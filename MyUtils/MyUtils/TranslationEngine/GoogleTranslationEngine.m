//
//  GoogleTranslationEngine.m
//  MyUtils
//
//  Created by smalltalk on 2021/3/15.
//  Copyright © 2021 wintelsui. All rights reserved.
//

#import "GoogleTranslationEngine.h"
#import "JSONFighting.h"

@implementation GoogleTranslationEngine

+ (NSString *)hostUrl{
    return @"https://translate.googleapis.com";
}

- (NSString *)translate:(NSString *)words fromLang:(NSString *)from toLang:(NSString *)to{
    if (from == nil) {
        from = @"auto";
    }
    NSString *userAgent = @"Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:59.0) Gecko/20100101 Firefox/59.0";
    
    
    NSString *wordsutf = [[self class] urlUtf8:words];
    NSString *urlString = [NSString stringWithFormat:@"%@/translate_a/single?client=gtx&sl=%@&tl=%@&dt=at&dt=bd&dt=ex&dt=ld&dt=md&dt=qca&dt=rw&dt=rm&dt=ss&dt=t&q=%@", [[self class] hostUrl], from, to, wordsutf];
    
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [theRequest setHTTPMethod:@"GET"];
    [theRequest setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    
    NSURLResponse *reponse = nil;
    NSError *erro = nil;
    NSData *resultData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&reponse error:&erro];
    NSString *resultJSON = [[NSString alloc] initWithData:resultData  encoding:NSUTF8StringEncoding];
    
    NSArray *resultArray = [resultJSON objectFromJSONString];
    if (resultArray != nil && [resultArray isKindOfClass:[NSArray class]]) {
        
        NSArray *resultArrayFirst = [resultArray firstObject];
        if (resultArrayFirst != nil && [resultArrayFirst isKindOfClass:[NSArray class]]) {
            NSArray *resultArrayData = [resultArrayFirst firstObject];
            
            if (resultArrayData != nil && [resultArrayData isKindOfClass:[NSArray class]]) {
                
                for (NSInteger i = 0; i < [resultArrayData count]; i++) {
                    
                    NSString *res = [resultArrayData objectAtIndex:i];
                    if (res != nil && res.length > 0) {
                        return res;
                    }
                }
            }
        }
    }
    
    return words;
}

@end
