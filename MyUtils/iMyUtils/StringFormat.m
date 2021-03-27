//
//  StringFormat.m
//  iMyUtils
//
//  Created by wintel on 3/21/19.
//  Copyright © 2019 wintelsui. All rights reserved.
//

#import "StringFormat.h"

NSString * const idStringFormat2lowerCapitalize = @"StringFormat2lowerCapitalize";
NSString * const idStringFormat2Capitalize = @"StringFormat2Capitalize";
NSString * const idStringFormat2UpperCamel = @"StringFormat2UpperCamel";
NSString * const idStringFormat2lowercamel = @"StringFormat2lowercamel";


@implementation StringFormat

+ (void)stringFormat:(XCSourceEditorCommandInvocation *)invocation type:(NSString *)idtype{
    
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
        NSString *rs = [self combination:[self splitString:selectString] type:idtype];
        
        NSString *startlineString = invocation.buffer.lines[startLine];
        
        NSString *frontStartlineString = [startlineString substringToIndex:startColumn];
        NSString *endlineString = invocation.buffer.lines[endLine];
        NSString *tailEndlineString = [endlineString substringFromIndex:endColumn];
        
        NSString *newString = [NSString stringWithFormat:@"%@%@%@",frontStartlineString,rs,tailEndlineString];
        
        [invocation.buffer.lines replaceObjectAtIndex:startLine withObject:newString];
    }
}

//仅仅处理大写和空格和\n
+ (NSArray *)splitString:(NSString *)string{
    
    NSMutableArray *words = [NSMutableArray new];
    NSArray *wordsBySpace = [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" \n"]];
    
    for (int index = 0; index < [wordsBySpace count]; index++) {
        NSString *wordBySpace = [wordsBySpace objectAtIndex:index];
        NSUInteger len = wordBySpace.length;
        if (len > 0) {
            //这里就只大写字母分词
            int start = 0;
            int end = -1;
            
            for (int i = 0; i < len; i++) {
                char sub = [wordBySpace characterAtIndex:i];
                
                if (sub >= 'A' && sub <= 'Z') {
                    //新的开始
                    end = i - 1;
                    if (end >= start){
                        NSRange range = NSMakeRange(start, (end - start + 1));
                        NSString *subStr = [wordBySpace substringWithRange:range];
                        [words addObject:subStr];
                    }
                    start = i;
                }
                if (i == len - 1){
                    end = i;
                    if (end >= start){
                        NSRange range = NSMakeRange(start, (end - start + 1));
                        NSString *subStr = [wordBySpace substringWithRange:range];
                        [words addObject:subStr];
                    }
                }
            }
        }
    }
    return [words copy];
}

+ (NSString *)combination:(NSArray *)words type:(NSString *)idtype{
    NSMutableArray *wordsNew = [NSMutableArray new];
    for (int index = 0; index < [words count]; index++) {
        NSString *word = [words objectAtIndex:index];
        
        if ([idtype hasSuffix:idStringFormat2lowerCapitalize]) {
            if (index == 0) {
                [wordsNew addObject:[word lowercaseString]];
            }else{
                [wordsNew addObject:[word capitalizedString]];
            }
        }else if ([idtype hasSuffix:idStringFormat2Capitalize]) {
            [wordsNew addObject:[word capitalizedString]];
        }else if ([idtype hasSuffix:idStringFormat2UpperCamel]) {
            [wordsNew addObject:[word capitalizedString]];
        }else if ([idtype hasSuffix:idStringFormat2lowercamel]) {
            [wordsNew addObject:[word lowercaseString]];
        }
    }
    if ([idtype hasSuffix:idStringFormat2lowerCapitalize]) {
        return [wordsNew componentsJoinedByString:@""];
    }else if ([idtype hasSuffix:idStringFormat2Capitalize]) {
        return [wordsNew componentsJoinedByString:@""];
    }else if ([idtype hasSuffix:idStringFormat2UpperCamel]) {
        return [wordsNew componentsJoinedByString:@" "];
    }else if ([idtype hasSuffix:idStringFormat2lowercamel]) {
        return [wordsNew componentsJoinedByString:@" "];
    }
    return @"";
}


@end
