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
#import "RandomString.h"
#import "StringFormat.h"
#import "Translator.h"

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
    }else if ([identifier hasSuffix:idRandomString]) {
        [RandomString randomTheString:invocation];
    }else if ([identifier hasSuffix:idStringFormat2lowerCapitalize]) {
        [StringFormat stringFormat:invocation type:idStringFormat2lowerCapitalize];
    }else if ([identifier hasSuffix:idStringFormat2Capitalize]) {
        [StringFormat stringFormat:invocation type:idStringFormat2Capitalize];
    }else if ([identifier hasSuffix:idStringFormat2UpperCamel]) {
        [StringFormat stringFormat:invocation type:idStringFormat2UpperCamel];
    }else if ([identifier hasSuffix:idStringFormat2lowercamel]) {
        [StringFormat stringFormat:invocation type:idStringFormat2lowercamel];
    }else if ([identifier hasSuffix:idTranslatorToFirst]) {
        [Translator translate:invocation index:1];
    }else if ([identifier hasSuffix:idTranslatorToSecond]) {
        [Translator translate:invocation index:2];
    }
    
    
    completionHandler(nil);
}

@end
