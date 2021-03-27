//
//  Translator.m
//  MyUtils
//
//  Created by smalltalk on 16/3/2021.
//  Copyright © 2021 wintelsui. All rights reserved.
//

#import "Translator.h"
#import "XTranslationEngine.h"

NSString * const idTranslatorToFirst = @"TranslatorToFirst";
NSString * const idTranslatorToSecond = @"TranslatorToSecond";

@implementation Translator

+ (void)translate:(XCSourceEditorCommandInvocation *)invocation index:(NSInteger)index{
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
        
        NSString *engine = [XTranslationEngine chooseEngineName];
        NSString *second = @"";
        if (index == 1) {
            second = [XTranslationEngine chooseFirstLangName];
        }else{
            second = [XTranslationEngine chooseSecondLangName];
        }
        NSString *toLang = [[XTranslationEngine langMaps] objectForKey:second];
        
        NSString *rs = [[NSClassFromString(engine) shared] translate:selectString toLang:toLang];
        
        NSString *startlineString = invocation.buffer.lines[startLine];
        
        NSString *frontStartlineString = [startlineString substringToIndex:startColumn];
        NSString *endlineString = invocation.buffer.lines[endLine];
        NSString *tailEndlineString = [endlineString substringFromIndex:endColumn];
        
        NSString *newString = [NSString stringWithFormat:@"%@%@%@",frontStartlineString,rs,tailEndlineString];
        
        [invocation.buffer.lines replaceObjectAtIndex:startLine withObject:newString];
    }
}

@end
