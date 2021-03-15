//
//  XTranslationEngine.m
//  MyUtils
//
//  Created by smalltalk on 2021/3/15.
//  Copyright © 2021 wintelsui. All rights reserved.
//

#import "XTranslationEngine.h"

@implementation XTranslationEngine

- (NSString *)translate:(NSString *)words fromLang:(NSString *)from toLang:(NSString *)to{
    
    return words;
}

- (NSString *)translate:(NSString *)words toLang:(NSString *)to{
    
    return [self translate:words fromLang:@"auto" toLang:to];
}

@end
