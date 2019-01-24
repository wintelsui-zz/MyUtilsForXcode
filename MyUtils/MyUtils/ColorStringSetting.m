//
//  ColorStringSetting.m
//  MyUtils
//
//  Created by wintel on 1/24/19.
//  Copyright © 2019 wintelsui. All rights reserved.
//

#import "ColorStringSetting.h"

@implementation ColorStringSetting

+ (BOOL)getHex2rgbDefaultNSColor{
    BOOL hex2rgbDefaultNSColor = [[NSUserDefaults standardUserDefaults] boolForKey:@"hex2rgbDefaultNSColor"];
    return hex2rgbDefaultNSColor;
}

+ (void)setHex2rgbDefaultNSColor:(BOOL)isNS{
    [[NSUserDefaults standardUserDefaults] setBool:isNS forKey:@"hex2rgbDefaultNSColor"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getCustomFormat1String{
    NSString *redPrefixCF1 = [[NSUserDefaults standardUserDefaults] stringForKey:@"CustomFormat1String"];
    if (redPrefixCF1 == nil || redPrefixCF1.length == 0) {
        NSString *format = @"RGBA((R),(G),(B),(A))";
        [ColorStringSetting setCustomFormat1String:format];
        return format;
    }
    return redPrefixCF1;
}

+ (void)setCustomFormat1String:(NSString *)formatString{
    if (formatString && formatString.length > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:formatString forKey:@"CustomFormat1String"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end
