//
//  RandomString.h
//  iMyUtils
//
//  Created by wintel on 3/21/19.
//  Copyright © 2019 wintelsui. All rights reserved.
//

#import <XcodeKit/XcodeKit.h>

extern NSString * _Nonnull const idRandomString;

NS_ASSUME_NONNULL_BEGIN

@interface RandomString : NSObject

+ (void)randomTheString:(XCSourceEditorCommandInvocation *)invocation;

@end

NS_ASSUME_NONNULL_END
