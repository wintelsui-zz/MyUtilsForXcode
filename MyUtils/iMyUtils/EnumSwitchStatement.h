//
//  EnumSwitchStatement.h
//  iMyUtils
//
//  Created by wintel on 3/21/19.
//  Copyright © 2019 wintelsui. All rights reserved.
//

#import <XcodeKit/XcodeKit.h>

extern NSString * const idEnum2Switch;

NS_ASSUME_NONNULL_BEGIN

@interface EnumSwitchStatement : NSObject

+ (void)enumToSwitch:(XCSourceEditorCommandInvocation *)invocation;

@end

NS_ASSUME_NONNULL_END
