//
//  SourceEditorCommand.m
//  iMyUtils
//
//  Created by wintel on 1/9/19.
//  Copyright © 2019 wintelsui. All rights reserved.
//

#import "SourceEditorCommand.h"
#import "ColorStatement.h"
#import "EnumSwitchStatement.h"

@implementation SourceEditorCommand

- (void)performCommandWithInvocation:(XCSourceEditorCommandInvocation *)invocation completionHandler:(void (^)(NSError * _Nullable nilOrError))completionHandler
{
    // Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.
    NSString *identifier = invocation.commandIdentifier;
    
    if ([identifier hasSuffix:idColorConvert]) {
        [ColorStatement colorHexConvertRGBA:invocation type:idColorConvert];
    }else if ([identifier hasSuffix:idColorConvertCustom1]) {
        [ColorStatement colorHexConvertRGBA:invocation type:idColorConvertCustom1];
    }else if ([identifier hasSuffix:idEnum2Switch]) {
        [EnumSwitchStatement enumToSwitch:invocation];
    }
    completionHandler(nil);
}

@end
