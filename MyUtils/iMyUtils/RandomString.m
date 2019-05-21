//
//  RandomString.m
//  iMyUtils
//
//  Created by wintel on 3/21/19.
//  Copyright © 2019 wintelsui. All rights reserved.
//

#import "RandomString.h"

NSString * const idRandomString = @"RandomString";

@implementation RandomString

+ (void)randomTheString:(XCSourceEditorCommandInvocation *)invocation{
    
    NSString *symbolString = @"";
    NSMutableString *selectString = [[NSMutableString alloc] init];
    NSInteger endLine = 0;
    NSInteger startLine = 0;
    NSInteger startColumn = 0;
    NSInteger endColumn = 0;
    for (XCSourceTextRange *range in invocation.buffer.selections) {
        startLine = range.start.line;
        startColumn = range.start.column;
        endLine = range.end.line;
        endColumn = range.end.column;
        
        
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
    if (startLine == endLine) {
        symbolString = [selectString copy];
        
        NSInteger lenght = 0;
        if (symbolString.length > 0) {
            @try {
                lenght = [symbolString integerValue];
            } @catch (NSException *exception) {
                lenght = 0;
            } @finally {}
        }
        NSString *rs = @"";
        if (lenght == 0) {
            //插入
            lenght = [RandomString getANumber];
            rs = [RandomString getAString:lenght];
            
        }else{
            //替换
            rs = [RandomString getAString:lenght];
            
        }
        
        if (rs.length > 0) {
            
            NSString *startlineString = invocation.buffer.lines[startLine];
            
            NSString *frontStartlineString = [startlineString substringToIndex:startColumn];
            NSString *endlineString = invocation.buffer.lines[endLine];
            NSString *tailEndlineString = [endlineString substringFromIndex:endColumn];
            
            NSString *newString = [NSString stringWithFormat:@"%@%@%@",frontStartlineString,rs,tailEndlineString];
            
            [invocation.buffer.lines replaceObjectAtIndex:startLine withObject:newString];
        }
    }
}

+ (NSInteger)getANumber{
    int number = arc4random() % 199;
    while (number < 30) {
        number = arc4random() % 199;
    }
    return number;
}

+ (NSString *)getAString:(NSInteger)len{
    int key = arc4random() % 2;
    NSString *fullString = @"";
    if (key == 0){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"JaneEyre.txt" ofType:@""];
        fullString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    }else{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"theFurtherAdventuresOfRobinsonCrusoe.txt" ofType:@""];
        fullString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    }
    NSInteger fullLen = fullString.length;
    if (fullLen > len) {
        NSInteger index = fullLen - len;
        if (index < 1) {
            index = 1;
        }
        NSInteger start = arc4random() % index;
        NSRange range;
        range.location = start;
        range.length = len;
        if (start + len > fullLen) {
            range.length = fullLen - start;
        }
        NSString *sub = [fullString substringWithRange:range];
        return sub;
    }else{
        return fullString;
    }
    return @"";
}

@end
