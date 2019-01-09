//
//  ColorStatement.m
//  iMyUtils
//
//  Created by wintel on 1/9/19.
//  Copyright © 2019 wintelsui. All rights reserved.
//

#import "ColorStatement.h"

CGFloat colorComponentFrom(NSString *string, NSUInteger start, NSUInteger length) {
    NSString *substring = [string substringWithRange:NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent;
}

@implementation ColorStatement

+ (void)colorHexConvertRGBA:(XCSourceEditorCommandInvocation *)invocation{
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
                NSString *colorString = [ColorStatement colorHex2RGB:selectString];
                if (colorString.length > 0) {
                    for (NSInteger index = startLine; index <= endLine ;index ++){
                        if (index == startLine) {
                            NSString *line = invocation.buffer.lines[index];
                            NSString *frontString = [line substringToIndex:startColumn];
                            NSString *newLine = [frontString stringByAppendingString:colorString];
                            
                            [invocation.buffer.lines replaceObjectAtIndex:index withObject:newLine];
                        }else{
                            [invocation.buffer.lines replaceObjectAtIndex:index withObject:@""];
                        }
                    }
                }
            }else{
                
            }
        }
        
    }
}

+ (NSString *)colorHex2RGB:(NSString *)hexColor{
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
            NSString *colorStringFinal = [NSString stringWithFormat:@"[UIColor colorWithRed:%.2f green:%.2f blue:%.2f alpha:%.2f]",red / 255.0, green / 255.0, blue / 255.0, alpha];
            return colorStringFinal;
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
