//
//  XTranslationEngine.h
//  MyUtils
//
//  Created by smalltalk on 2021/3/15.
//  Copyright © 2021 wintelsui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XTranslationEngine : NSObject

- (NSArray *)apis; //当前引擎可用的 API
- (NSArray *)langKeys; //当前引擎支持的语言


- (NSString *)translate:(NSString *)words fromLang:(NSString *)from toLang:(NSString *)to;

- (NSString *)translate:(NSString *)words toLang:(NSString *)to;


@end

NS_ASSUME_NONNULL_END
