//
//  XTranslationEngine.m
//  MyUtils
//
//  Created by smalltalk on 2021/3/15.
//  Copyright © 2021 wintelsui. All rights reserved.
//

#import "XTranslationEngine.h"

#define kChooseEngineName @"kChooseEngineName"
#define kChooseFirstLangName @"kChooseFirstLangName"
#define kChooseSecondLangName @"kChooseSecondLangName"

static XTranslationEngine * _instance;

@implementation XTranslationEngine

+ (instancetype)shared{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _instance = [[[self class] alloc] init];
        
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}


+ (NSString *)hostUrl{
    return @"";
}

+ (NSDictionary *)langMaps{
    return @{@"arabic":@"ar",
             @"bulgarian":@"bg",
             @"catalan":@"ca",
             @"chinese":@"zh-CN",
             @"chinese simplified":@"zh-CHS",
             @"chinese traditional":@"zh-CHT",
             @"czech":@"cs",
             @"danish":@"da",
             @"dutch":@"nl",
             @"english":@"en",
             @"estonian":@"et",
             @"finnish":@"fi",
             @"french":@"fr",
             @"german":@"de",
             @"greek":@"el",
             @"haitian creole":@"ht",
             @"hebrew":@"he",
             @"hindi":@"hi",
             @"hmong daw":@"mww",
             @"hungarian":@"hu",
             @"indonesian":@"id",
             @"italian":@"it",
             @"japanese":@"ja",
             @"klingon":@"tlh",
             @"klingon (piqad)":@"tlh-Qaak",
             @"korean":@"ko",
             @"latvian":@"lv",
             @"lithuanian":@"lt",
             @"malay":@"ms",
             @"maltese":@"mt",
             @"norwegian":@"no",
             @"persian":@"fa",
             @"polish":@"pl",
             @"portuguese":@"pt",
             @"romanian":@"ro",
             @"russian":@"ru",
             @"slovak":@"sk",
             @"slovenian":@"sl",
             @"spanish":@"es",
             @"swedish":@"sv",
             @"thai":@"th",
             @"turkish":@"tr",
             @"ukrainian":@"uk",
             @"urdu":@"ur",
             @"vietnamese":@"vi",
             @"welsh":@"cy"};
}

- (NSString *)translate:(NSString *)words fromLang:(NSString *)from toLang:(NSString *)to{
    NSLog(@"translate: fromLang: toLang: 需要被重写");
    return words;
}


- (NSString *)translate:(NSString *)words toLang:(NSString *)to{
    
    return [self translate:words fromLang:@"auto" toLang:to];
}

- (void)translate:(NSString *)words fromLang:(NSString *)from toLang:(NSString *)to completion:(nonnull void (^)(NSString * _Nonnull))completion{
    __weak typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *result = [weakSelf translate:words fromLang:from toLang:to];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (completion) {
                completion(result);
            }
        });
    });
}


- (void)translate:(NSString *)words toLang:(NSString *)to completion:(void (^)(NSString * _Nonnull))completion{
    [self translate:words fromLang:@"auto" toLang:to completion:completion];
}


+ (NSString *)urlUtf8:(NSString *)content
{
    if (content == nil || content.length == 0) {
        return @"";
    }
    NSString *encodedString = (__bridge_transfer NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)content, nil,(CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]\"", kCFStringEncodingUTF8);
    return encodedString;
}

#pragma mark - -- 当前选择配置 --
+ (NSDictionary *)translationEngineMap{
    return @{@"GoogleTranslationEngine": @"Google Int",
             @"GoogleCNTranslationEngine": @"Google CN"
    };
}

+ (NSString *)chooseEngineName{
    NSString *config = [[[NSUserDefaults alloc] initWithSuiteName:@"group.com.sfs.MyUtils"] stringForKey:kChooseEngineName];
    if (config == nil || config.length == 0) {
        config = @"GoogleTranslationEngine";
    }
    return config;
}

+ (NSString *)chooseFirstLangName{
    NSString *config = [[[NSUserDefaults alloc] initWithSuiteName:@"group.com.sfs.MyUtils"] stringForKey:kChooseFirstLangName];
    if (config == nil || config.length == 0) {
        config = @"english";
    }
    return config;
}

+ (NSString *)chooseSecondLangName{
    NSString *config = [[[NSUserDefaults alloc] initWithSuiteName:@"group.com.sfs.MyUtils"] stringForKey:kChooseSecondLangName];
    if (config == nil || config.length == 0) {
        config = @"chinese";
    }
    return config;
}

+ (void)setChooseEngineName:(NSString *)engineName{
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.sfs.MyUtils"];
    [userDefaults setObject:engineName forKey:kChooseEngineName];
    [userDefaults synchronize];
}
+ (void)setChooseFirstLangName:(NSString *)firstLangName{
    
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.sfs.MyUtils"];
    [userDefaults  setObject:firstLangName forKey:kChooseFirstLangName];
    [userDefaults synchronize];
}
+ (void)setChooseSecondLangName:(NSString *)secondLangName{
    
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.sfs.MyUtils"];
    [userDefaults  setObject:secondLangName forKey:kChooseSecondLangName];
    [userDefaults synchronize];
}
@end
