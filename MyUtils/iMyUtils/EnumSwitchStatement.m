//
//  EnumSwitchStatement.m
//  iMyUtils
//
//  Created by wintel on 3/21/19.
//  Copyright © 2019 wintelsui. All rights reserved.
//

#import "EnumSwitchStatement.h"

NSString * const idEnum2Switch = @"Enum2Switch";

@implementation EnumSwitchStatement

+ (void)enumToSwitch:(XCSourceEditorCommandInvocation *)invocation{
    
    NSString *symbolString = @"";
    NSMutableString *selectString = [[NSMutableString alloc] init];
    
    for (XCSourceTextRange *range in invocation.buffer.selections) {
        NSInteger startLine = range.start.line;
        NSInteger startColumn = range.start.column;
        NSInteger endLine = range.end.line;
        NSInteger endColumn = range.end.column;
        
        
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
    }
    symbolString = [selectString copy];
    
    symbolString = [[symbolString componentsSeparatedByString:@"::"] lastObject];
    
    symbolString = [symbolString stringByReplacingOccurrencesOfString:@"^enum\\s+" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, symbolString.length)];
    
    symbolString = [symbolString stringByReplacingOccurrencesOfString:@"^\\((.*)\\)$" withString:@"$1" options:NSRegularExpressionSearch range: NSMakeRange(0, symbolString.length)];
    
    symbolString = [symbolString stringByReplacingOccurrencesOfString:@"=.*?," withString:@"," options:NSRegularExpressionSearch range:NSMakeRange(0, symbolString.length)];
    
    symbolString = [symbolString stringByReplacingOccurrencesOfString:@"=.*?\n" withString:@",\n" options:NSRegularExpressionSearch range:NSMakeRange(0, symbolString.length)];
    
    NSLog(@"symbol\n%@\n",symbolString);
    
    
}

@end
