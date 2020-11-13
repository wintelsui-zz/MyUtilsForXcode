//
//  StringFormat.h
//  iMyUtils
//
//  Created by wintel on 3/21/19.
//  Copyright © 2019 wintelsui. All rights reserved.
//

#import <XcodeKit/XcodeKit.h>

extern NSString * _Nonnull const idStringFormat2lowerCapitalize;
extern NSString * _Nonnull const idStringFormat2Capitalize;
extern NSString * _Nonnull const idStringFormat2UpperCamel;
extern NSString * _Nonnull const idStringFormat2lowercamel;

NS_ASSUME_NONNULL_BEGIN

@interface StringFormat : NSObject

+ (void)stringFormat:(XCSourceEditorCommandInvocation *)invocation type:(NSString *)idtype;

@end

NS_ASSUME_NONNULL_END
