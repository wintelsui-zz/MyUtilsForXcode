//
//  ColorStatement.h
//  iMyUtils
//
//  Created by wintel on 1/9/19.
//  Copyright © 2019 wintelsui. All rights reserved.
//

#import <XcodeKit/XcodeKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const idColorConvert;
extern NSString * const idColorConvertCustom1;

@interface ColorStatement : NSObject

+ (void)colorHexConvertRGBA:(XCSourceEditorCommandInvocation *)invocation type:(NSString *)idtype;

@end

NS_ASSUME_NONNULL_END
