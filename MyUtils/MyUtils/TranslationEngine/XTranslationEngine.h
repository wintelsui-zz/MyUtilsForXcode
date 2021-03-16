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

+ (instancetype)shared;



+ (NSString *)hostUrl;
+ (NSDictionary *)langMaps; //当前引擎支持的语言




- (NSString *)translate:(NSString *)words fromLang:(NSString *)from toLang:(NSString *)to;

- (NSString *)translate:(NSString *)words toLang:(NSString *)to;

- (void)translate:(NSString *)words fromLang:(NSString *)from toLang:(NSString *)to completion:(void (^)(NSString *result))completion;

- (void)translate:(NSString *)words toLang:(NSString *)to completion:(void (^)(NSString *result))completion;


+ (NSString *)urlUtf8:(NSString *)content;



#pragma mark - -- 当前选择配置 --

+ (NSDictionary *)translationEngineMap;

+ (NSString *)chooseEngineName;
+ (NSString *)chooseFirstLangName;
+ (NSString *)chooseSecondLangName;

+ (void)setChooseEngineName:(NSString *)engineName;
+ (void)setChooseFirstLangName:(NSString *)firstLangName;
+ (void)setChooseSecondLangName:(NSString *)secondLangName;


@end

NS_ASSUME_NONNULL_END
