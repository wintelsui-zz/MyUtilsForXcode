//
//  Translator.h
//  MyUtils
//
//  Created by smalltalk on 16/3/2021.
//  Copyright © 2021 wintelsui. All rights reserved.
//

#import <XcodeKit/XcodeKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * _Nonnull const idTranslatorToFirst;
extern NSString * _Nonnull const idTranslatorToSecond;

@interface Translator : NSObject

+ (void)translate:(XCSourceEditorCommandInvocation *)invocation index:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
