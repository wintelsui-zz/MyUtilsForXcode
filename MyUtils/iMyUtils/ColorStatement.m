//
//  ColorStatement.m
//  iMyUtils
//
//  Created by wintel on 1/9/19.
//  Copyright © 2019 wintelsui. All rights reserved.
//

#import "ColorStatement.h"
#import "ColorStringSetting.h"


NSString * const idColorConvert = @"ColorConvert";
NSString * const idColorConvertCustom1 = @"ColorConvertCustom1";

CGFloat colorComponentFrom(NSString *string, NSUInteger start, NSUInteger length) {
    NSString *substring = [string substringWithRange:NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent;
}

@implementation ColorStatement

+ (void)colorHexConvertRGBA:(XCSourceEditorCommandInvocation *)invocation type:(NSString *)idtype{
    for (XCSourceTextRange *range in invocation.buffer.selections) {
        NSInteger startLine = range.start.line;
        NSInteger startColumn = range.start.column;
        NSInteger endLine = range.end.line;
        NSInteger endColumn = range.end.column;
        
        NSMutableString *selectString = [[NSMutableString alloc] init];
        
        for (NSInteger index = startLine; index <= endLine ;index ++){
            NSString *line = invocation.buffer.lines[index];
            if (line == nil) {
                line = @"";
            }
            
            if (index == endLine && line.length >= endColumn) {
                NSRange lineRange = NSMakeRange(0, endColumn);
                line = [line substringWithRange:lineRange];
            }
            if (index == startLine && line.length > startColumn) {
                NSRange lineRange = NSMakeRange(startColumn, line.length - startColumn);
                line = [line substringWithRange:lineRange];
            }
            [selectString appendString:line];
            if (endLine > startLine && index != endLine) {
                [selectString appendString:@"\n"];
            }
        }
        
        NSLog(@"Selector(%@)",selectString);
        
        //做颜色转换
        if (selectString.length > 0) {
            
            //Hex -> RGB 必须大于等于6个字符小于等于8个字符,若带#号加1
            if (([selectString hasPrefix:@"#"] && (selectString.length == 7 || selectString.length == 9)) || ((![selectString hasPrefix:@"#"]) && (selectString.length == 6 || selectString.length == 8))) {
                NSString *colorString = [ColorStatement colorHex2RGB:selectString type:idtype];
                if (colorString.length > 0) {
                    NSString *startlineString = invocation.buffer.lines[startLine];
                    NSString *frontStartlineString = [startlineString substringToIndex:startColumn];
                    NSString *endlineString = invocation.buffer.lines[endLine];
                    NSString *tailEndlineString = [endlineString substringFromIndex:endColumn];
                    
                    NSString *newString = [NSString stringWithFormat:@"%@%@%@",frontStartlineString,colorString,tailEndlineString];
                    
                    //需要归到一行
                    for (NSInteger index = startLine; index <= endLine ;index ++){
                        if (index == startLine) {
                            [invocation.buffer.lines replaceObjectAtIndex:index withObject:newString];
                        }else{
                            [invocation.buffer.lines replaceObjectAtIndex:index withObject:@""];
                        }
                    }
                }
            }else if (([selectString hasPrefix:@"[UIColor"] || [selectString hasPrefix:@"[NSColor"]) && [selectString hasSuffix:@"]"]) {
//                [NSColor colorWithWhite:1 alpha:1]
//                [NSColor colorWithRed:1 green:1 blue:1 alpha:1]
//                [NSColor colorWithSRGBRed:1 green:1 blue:1 alpha:1]
                NSString *hexColor = [self colorRGB2Hex:selectString];
                
            }
        }
        
    }
}

+ (NSString *)colorHex2RGB:(NSString *)hexColor type:(NSString *)idtype{
    if (hexColor != nil && hexColor.length > 0) {
        NSString *colorString = [[hexColor stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
        colorString = [colorString uppercaseString];
        for (NSInteger i = 0; i < colorString.length; i++) {
            char ic = [colorString characterAtIndex:i];
            if (!((ic >= '0' && ic <= '9') || (ic >= 'A' && ic <= 'F'))) {
                return @"";
            }
        }
        if (colorString.length == 6 || colorString.length == 8) {
            CGFloat alpha = 1.0;
            CGFloat red   = colorComponentFrom(colorString, 0, 2);
            CGFloat green = colorComponentFrom(colorString, 2, 2);
            CGFloat blue  = colorComponentFrom(colorString, 4, 2);
            if (colorString.length == 8) {
                alpha = colorComponentFrom(colorString, 6, 2) / 255.0;
            }
            if (idtype != nil && [idtype isEqualToString:idColorConvertCustom1]) {
                NSString *redPrefixCF1 = [ColorStringSetting getCustomFormat1String];
                if (redPrefixCF1 != nil && redPrefixCF1.length > 0) {
                    redPrefixCF1 = [redPrefixCF1 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    if (redPrefixCF1 != nil && redPrefixCF1.length > 0) {
                        NSRange rangeRed = [redPrefixCF1 rangeOfString:@"(R)"];
                        NSRange rangeGreen = [redPrefixCF1 rangeOfString:@"(G)"];
                        NSRange rangeBlue = [redPrefixCF1 rangeOfString:@"(B)"];
                        NSRange rangeA = [redPrefixCF1 rangeOfString:@"(A)"];
                        if (rangeRed.length > 0 && rangeGreen.length > 0 && rangeBlue.length > 0) {
                            NSString *newString = [redPrefixCF1 stringByReplacingCharactersInRange:rangeRed withString:[NSString stringWithFormat:@"%.2f",red / 255.0]];
                            
                            rangeGreen = [newString rangeOfString:@"(G)"];
                            newString = [newString stringByReplacingCharactersInRange:rangeGreen withString:[NSString stringWithFormat:@"%.2f",green / 255.0]];
                            
                            rangeBlue = [newString rangeOfString:@"(B)"];
                            newString = [newString stringByReplacingCharactersInRange:rangeBlue withString:[NSString stringWithFormat:@"%.2f",blue / 255.0]];
                            
                            rangeA = [newString rangeOfString:@"(A)"];
                            if (rangeA.length > 0){
                                newString = [newString stringByReplacingCharactersInRange:rangeA withString:[NSString stringWithFormat:@"%.2f",alpha]];
                            }
                            return newString;
                        }
                    }
                }
            }
            BOOL hex2rgbDefaultNSColor = [ColorStringSetting getHex2rgbDefaultNSColor];
            if (hex2rgbDefaultNSColor) {
                NSString *colorStringFinal = [NSString stringWithFormat:@"[NSColor colorWithRed:%.2f green:%.2f blue:%.2f alpha:%.2f]",red / 255.0, green / 255.0, blue / 255.0, alpha];
                return colorStringFinal;
            }
            NSString *colorStringFinal = [NSString stringWithFormat:@"[UIColor colorWithRed:%.2f green:%.2f blue:%.2f alpha:%.2f]",red / 255.0, green / 255.0, blue / 255.0, alpha];
            return colorStringFinal;
        }
    }
    
    return @"";
}

+ (NSString *)colorRGB2Hex:(NSString *)rgbColor{
    NSRange range;
    range.location = @"[NSColor".length;
    range.length = rgbColor.length - range.location - 1;
    NSString *subStr = [rgbColor substringWithRange:range];
    if (subStr.length > 0) {
        subStr = [subStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSArray *em = [subStr componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@": "]];
        NSLog(@"em:%@",em);
        
        NSString *first = [em firstObject];
        if ([first hasPrefix:@"colorWithWhite"]) {
            //wa
            
        }else if ([first hasPrefix:@"colorWithRed"] || [first hasPrefix:@"colorWithSRGBRed"]) {
            //rgba
        }
    }
    return @"";
}

+ (NSString *)deleteFirstSpace:(NSString *)oldString{
    if (oldString == nil || oldString.length == 0) {
        return @"";
    }
    NSString *newString = oldString;
    while (newString.length > 0) {
        if ([newString hasPrefix:@" "]) {
            if (newString.length > 1) {
                newString = [newString substringFromIndex:1];
            }else{
                newString = @"";
            }
        }else{
            break;
        }
    }
    return newString;
}

+ (NSArray *)regularFinder:(NSString *)regular string:(NSString *)str{
    NSError *error_finder;
    //这是检测正则表达式
    NSRegularExpression *regex_finder = [NSRegularExpression regularExpressionWithPattern:regular options:0 error:&error_finder];
    if (regex_finder != nil) {
        NSArray *array_finder = [regex_finder matchesInString:str options:0 range:NSMakeRange(0, [str length])];
        return array_finder;
    }
    return nil;
}
@end
