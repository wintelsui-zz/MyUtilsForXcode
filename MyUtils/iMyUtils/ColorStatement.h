//
//  ColorStatement.h
//  iMyUtils
//
//  Created by wintel on 1/9/19.
//  Copyright © 2019 wintelsui. All rights reserved.
//

#import <XcodeKit/XcodeKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ColorStatement : NSObject

+ (void)colorHexConvertRGBA:(XCSourceEditorCommandInvocation *)invocation;

@end

NS_ASSUME_NONNULL_END
