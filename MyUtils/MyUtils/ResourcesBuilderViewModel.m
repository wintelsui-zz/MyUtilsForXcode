//
//  ResourcesBuilderViewModel.m
//  testResourcs
//
//  Created by wintel on 2019/11/19.
//  Copyright © 2019 wintel. All rights reserved.
//

#import "ResourcesBuilderViewModel.h"
#import <CoreImage/CoreImage.h>
#import "NSImage+MGCropExtensions.h"

@interface ResourcesBuilderViewModel ()

@property (nonatomic, readwrite, strong) RACSignal *segmentedControlSignal;
@property (nonatomic, readwrite, strong) RACSignal *validStartSignal;

@end
@implementation ResourcesBuilderViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setData];
    }
    return self;
}

- (void)setData{
    _inputFolder = @"";
    _outputFolder = @"";
    
    _inputType = ResourcesSizeType3;
    _inputTypeTemp = ResourcesSizeTypeNone;
    
    _createImage1 = NO;
    _createImage2 = YES;
    _createImage3 = YES;
    
    self.validStartSignal = [[RACSignal
                              combineLatest:@[RACObserve(self, inputFolder), RACObserve(self, outputFolder)]
                              reduce:^(NSString *inputFolder, NSString *outputFolder) {
                                    return @(outputFolder.length > 0 && outputFolder.length > 0);
                            }]distinctUntilChanged];
    
    self.segmentedControlSignal = [[RACSignal
                              combineLatest:@[RACObserve(self, inputType)]
                                    reduce:^(NSNumber* inputType) {
                                    return @(self.inputType);
                            }]distinctUntilChanged];
}


- (void)startCompletion:(void (^)(BOOL))completion{
    if (_inputFolder != nil && _inputFolder.length > 0 && _outputFolder != nil && _outputFolder.length > 0) {
        BOOL isInputDir = NO;
        BOOL isInputExist = [[NSFileManager defaultManager] fileExistsAtPath:_inputFolder isDirectory:&isInputDir];
        if(isInputExist&&isInputDir)
        {
            if ([_outputFolder hasPrefix:@"/"] || [_outputFolder hasPrefix:@"~"]) {}{
                _outputFolder = [@"/" stringByAppendingString:_outputFolder];
            }
            
            BOOL isOutputDir = NO;
            BOOL isOutputExist = [[NSFileManager defaultManager] fileExistsAtPath:_outputFolder isDirectory:&isOutputDir];
            if (isOutputExist && !isOutputDir) {
                //地址存在,但是是个文件
                completion(NO);
            }else{
                if (!isOutputExist) {
                    //不存在,创建之
                    NSError *error;
                    [[NSFileManager defaultManager] createDirectoryAtPath:_outputFolder withIntermediateDirectories:YES attributes:@{NSFileAppendOnly:@(NO)} error:&error];
                    if (error != nil) {
                        completion(NO);
                        return;
                    }
                }
                
                __weak typeof(self)weakSelf = self;
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    NSArray *subs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.inputFolder error:nil];
                    NSLog(@"输入文件夹:%@",self.inputFolder);
                    for (NSString *fileName in subs) {
                        weakSelf.inputTypeTemp = ResourcesSizeTypeNone;
                        
                        NSString *fileFullPath = [self.inputFolder stringByAppendingPathComponent:fileName];
                        BOOL isDir = NO;
                        [[NSFileManager defaultManager] fileExistsAtPath:fileFullPath isDirectory:&isDir];
                        if(!isDir)
                        {
                            //该地址是一个文件
                            NSString *pathExtension = [[fileFullPath pathExtension] lowercaseString];
                            if (pathExtension != nil && [pathExtension isEqualToString:@"png"]) {
                                
                                NSString *tempPath = [fileFullPath stringByDeletingPathExtension];
                                NSString *fileNameSingle = [tempPath lastPathComponent];
                                if ([fileNameSingle hasSuffix:@"@3x"]){
                                    fileNameSingle = [fileNameSingle substringToIndex:(fileNameSingle.length - @"@3x".length)];
                                    weakSelf.inputTypeTemp = ResourcesSizeType3;
                                }else if ([fileNameSingle hasSuffix:@"@2x"]){
                                    fileNameSingle = [fileNameSingle substringToIndex:(fileNameSingle.length - @"@3x".length)];
                                    weakSelf.inputTypeTemp = ResourcesSizeType2;
                                }
                                NSLog(@"deal:%@ --> %@",fileName, fileNameSingle);
                                
                                NSString *filePathOld1 = [self.inputFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",fileNameSingle]];
                                NSString *filePathOld2 = [self.inputFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"%@@2x.png",fileNameSingle]];
                                NSString *filePathOld3 = [self.inputFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"%@@3x.png",fileNameSingle]];
                                
                                NSString *filePathNew1 = [self.outputFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",fileNameSingle]];
                                NSString *filePathNew2 = [self.outputFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"%@@2x.png",fileNameSingle]];
                                NSString *filePathNew3 = [self.outputFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"%@@3x.png",fileNameSingle]];
                                
                                BOOL create1 = NO;
                                BOOL create2 = NO;
                                BOOL create3 = NO;
                                
                                if (self.createImage1) {
                                    //生成一倍图片
                                    if (self.inputType == ResourcesSizeType1) {
                                        create1 = [self needCreateImageNewPath:filePathNew1 oldPath:filePathOld1 contrast:ResourcesSizeType1 originalPath:fileFullPath];
                                    }else{
                                        create1 = YES;
                                    }
                                }
                                
                                if (self.createImage2) {
                                    //生成二倍图片
                                    create2 = [self needCreateImageNewPath:filePathNew2 oldPath:filePathOld2 contrast:ResourcesSizeType2 originalPath:fileFullPath];
                                }
                                
                                if (self.createImage3) {
                                    //生成二倍图片
                                    create3 = [self needCreateImageNewPath:filePathNew3 oldPath:filePathOld3 contrast:ResourcesSizeType3 originalPath:fileFullPath];
                                }
                                if (create1 || create2 || create3) {
                                    //有需要生成的图片
                                    NSImage *imageOriginal = [[NSImage alloc] initWithContentsOfFile:fileFullPath];
                                    if (imageOriginal) {
                                        CIImage *ci_imageOriginal = [ResourcesBuilderViewModel getCIImageWithNSImage:imageOriginal];
                                        if (ci_imageOriginal) {
                                            CGSize sizeOriginal = ci_imageOriginal.extent.size;
                                            
                                            NSLog(@"size:%.2f * %.2f",ci_imageOriginal.extent.size.width,ci_imageOriginal.extent.size.height);
                                            
                                            if (create1) {
                                                [self saveZoomNSImage:imageOriginal sizeOriginal:sizeOriginal outputType:ResourcesSizeType1 toPath:filePathNew1];
                                            }
                                            if (create2) {
                                                [self saveZoomNSImage:imageOriginal sizeOriginal:sizeOriginal outputType:ResourcesSizeType2 toPath:filePathNew2];

                                            }
                                            if (create3) {
                                                [self saveZoomNSImage:imageOriginal sizeOriginal:sizeOriginal outputType:ResourcesSizeType3 toPath:filePathNew3];

                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            completion(YES);
                        });
                    });
                });
            }
        }else{
            completion(NO);
        }
    }else{
        completion(NO);
    }
}

- (BOOL)needCreateImageNewPath:(NSString *)newPath oldPath:(NSString *)oldPath contrast:(ResourcesSizeType)type originalPath:(NSString *)originalPath{
    BOOL isOutput1Dir = NO;
    BOOL isOutput1Exist = [[NSFileManager defaultManager] fileExistsAtPath:newPath isDirectory:&isOutput1Dir];
    if(!isOutput1Exist){
            //文件不存在
        BOOL isInput1Dir = NO;
        BOOL isInput1Exist = [[NSFileManager defaultManager] fileExistsAtPath:oldPath isDirectory:&isInput1Dir];
        if(isInput1Exist && (!isInput1Dir)){
                //存在需要新生成的文件，可以直接使用
            if (![newPath isEqualToString:oldPath]) {
                [[NSFileManager defaultManager] copyItemAtPath:oldPath toPath:newPath error:nil];
            }
        }else{
            if (self.inputType == type) {
                    //原图是1倍图
                [[NSFileManager defaultManager] copyItemAtPath:originalPath toPath:newPath error:nil];
            }else{
                return YES;
            }
        }
    }else{
            //需要生成的文件已经存在，去处理下一个
    }
    return NO;
}

- (void)saveZoomNSImage:(NSImage *)originalImage sizeOriginal:(CGSize)sizeOriginal outputType:(ResourcesSizeType)outputType toPath:(NSString *)filePath{
    if (originalImage && filePath) {
        
        if (NO) {
            CGSize sizeNew = CGSizeMake(sizeOriginal.width * (outputType + 1.0) / (self.inputType + 1.0), sizeOriginal.height * (outputType + 1.0) / (self.inputType + 1.0));
            
                //        [ResourcesBuilderViewModel resizeImage:originalImage toSize:sizeNew saveTo:filePath];
            NSImage *imageNew = [ResourcesBuilderViewModel resizeImage:originalImage toSize:sizeNew isPixels:YES];
            NSData *imageData = [imageNew TIFFRepresentation];
            if (imageData) {
                [imageData writeToFile:filePath atomically:YES];
            }
        }else{
            NSSize targetSize = NSMakeSize(sizeOriginal.width * (outputType) / (self.inputType), sizeOriginal.height * (outputType) / (self.inputType));
            NSImage* resultImg = [originalImage imageToFitSize:targetSize method:MGImageResizeScale];
            
            CGImageRef cgRef = [resultImg CGImageForProposedRect:NULL  context:nil  hints:nil];
            NSBitmapImageRep *newRep = [[NSBitmapImageRep alloc] initWithCGImage:cgRef];
            [newRep setSize:targetSize];
            NSData *pngData = [newRep representationUsingType:NSPNGFileType properties:nil];
            [pngData writeToFile:filePath atomically:YES];
        }
        

        
    }
}

+ (NSImage *)resizeNSImage:(NSImage *)sourceImage sizeOriginal:(CGSize)sizeOriginal forSize:(CGSize)newSize{
    
    newSize = CGSizeMake(newSize.width / [NSScreen mainScreen].backingScaleFactor, newSize.height / [NSScreen mainScreen].backingScaleFactor);
    
    CGSize imageSize = sourceImage.size;

    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;

    CGFloat targetWidth = newSize.width;
    CGFloat targetHeight = newSize.height;

    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;

    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);

    if (CGSizeEqualToSize(imageSize, newSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;

            // scale to fit the longer
        scaleFactor = (widthFactor>heightFactor)?widthFactor:heightFactor;
        scaledWidth  = ceil(width * scaleFactor);
        scaledHeight = ceil(height * scaleFactor);

            // center the image
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }

    NSImage *newImage = [[NSImage alloc] initWithSize:NSMakeSize(scaledWidth, scaledHeight)];
    CGRect thumbnailRect = {thumbnailPoint, {scaledWidth, scaledHeight}};
    NSImageRep *sourceImageRep = [sourceImage bestRepresentationForRect:thumbnailRect context:nil hints:nil];

    [newImage lockFocus];
    [sourceImageRep drawInRect:thumbnailRect];
    [newImage unlockFocus];

    return newImage;
}

#pragma mark -  NSImage转CIImage
+ (CIImage *)getCIImageWithNSImage:(NSImage *)myImage {

    // convert NSImage to bitmap
    NSData  *tiffData = [myImage TIFFRepresentation];
    NSBitmapImageRep *bitmap = [NSBitmapImageRep imageRepWithData:tiffData];

    // create CIImage from bitmap
    CIImage * ciImage = [[CIImage alloc] initWithBitmapImageRep:bitmap];

    // create affine transform to flip CIImage
    NSAffineTransform *affineTransform = [NSAffineTransform transform];
    [affineTransform translateXBy:0 yBy:128];
    [affineTransform scaleXBy:1 yBy:-1];

    // create CIFilter with embedded affine transform
    CIFilter *transform = [CIFilter filterWithName:@"CIAffineTransform"];
    [transform setValue:ciImage forKey:@"inputImage"];
    [transform setValue:affineTransform forKey:@"inputTransform"];

    // get the new CIImage, flipped and ready to serve
    CIImage * result = [transform valueForKey:@"outputImage"];
    return result;
}

+ (CGImageRef)nsImageToCGImageRef:(NSImage*)image;
{
    NSData * imageData = [image TIFFRepresentation];
    CGImageRef imageRef = nil;
    if(imageData != nil)
    {
        CGImageSourceRef imageSource = CGImageSourceCreateWithData((CFDataRef)imageData,  NULL);
        imageRef = CGImageSourceCreateImageAtIndex(imageSource, 0, NULL);
    }
    return imageRef;
}

+ (NSImage *)resizeImage:(NSImage *)sourceImage toSize:(CGSize)toSize isPixels:(BOOL)isPixels{
    float screenScale = [NSScreen mainScreen].backingScaleFactor;
    CGSize newSize = toSize;
    if (isPixels) {
        newSize = CGSizeMake(newSize.width / screenScale, newSize.height / screenScale);
    }
     
    CGRect toRect =  CGRectMake(0, 0, newSize.width, newSize.height);
    CGRect fromRect =  CGRectMake(0, 0, sourceImage.size.width, sourceImage.size.height);
    
    NSImage *newImage = [[NSImage alloc] initWithSize:toRect.size];
    [newImage lockFocus];
    [sourceImage drawInRect:toRect fromRect:fromRect operation:NSCompositingOperationCopy fraction:1.0];
    [newImage unlockFocus];

    return newImage;
}

+ (BOOL)resizeImage:(NSImage *)sourceImage toSize:(CGSize)toSize saveTo:(NSString *)path{
    
    CGImageRef sourceImage_cg = [ResourcesBuilderViewModel nsImageToCGImageRef:sourceImage];
    CGContextRef ctx = CGBitmapContextCreate(NULL, sourceImage.size.width, sourceImage.size.height, CGImageGetBitsPerComponent(sourceImage_cg), 0, CGImageGetColorSpace(sourceImage_cg), CGImageGetBitmapInfo(sourceImage_cg));
//    CGContextConcatCTM(ctx, CGAffineTransform);
    if (ctx == nil) {
        ctx = NSGraphicsContext.currentContext.CGContext;
    }
    CGContextScaleCTM(ctx, 1, 1);
    CGContextDrawImage(ctx, CGRectMake(0, 0, toSize.width, toSize.height), sourceImage_cg);
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    CGContextRelease(ctx);
    
    BOOL s = CGImageWriteToFile(cgimg, path);
    CGImageRelease(cgimg);
    return s;
    
    
//    [NSGraphicsContext saveGraphicsState];
//    CGContextScaleCTM(ctx, 0.5, 0.5);
//    CGContextDrawImage(ctx, NSMakeRect(0, 0, sourceImage.size.width, sourceImage.size.height), sourceImage_cg);
//    [NSGraphicsContext restoreGraphicsState];
    
}

BOOL CGImageWriteToFile(CGImageRef image, NSString *path) {
    CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath:path];
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL(url, kUTTypePNG, 1, NULL);
    if (!destination) {
        NSLog(@"Failed to create CGImageDestination for %@", path);
        return NO;
    }
    CGImageDestinationAddImage(destination, image, nil);
    if (!CGImageDestinationFinalize(destination)) {
        NSLog(@"Failed to write image to %@", path);
        CFRelease(destination);
        return NO;
    }
    CFRelease(destination);
    return YES;
}

- (ResourcesSizeType)inputType{
    if (_inputTypeTemp != ResourcesSizeTypeNone) {
        return _inputTypeTemp;
    }
    return _inputType;
}
@end
