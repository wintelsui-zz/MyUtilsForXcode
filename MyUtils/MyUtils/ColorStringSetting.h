//
//  ColorStringSetting.h
//  MyUtils
//
//  Created by wintel on 1/24/19.
//  Copyright © 2019 wintelsui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ColorStringSetting : NSObject

+ (BOOL)getHex2rgbDefaultNSColor;
+ (void)setHex2rgbDefaultNSColor:(BOOL)isNS;


+ (NSString *)getCustomFormat1String;
+ (void)setCustomFormat1String:(NSString *)formatString;

@end

NS_ASSUME_NONNULL_END
