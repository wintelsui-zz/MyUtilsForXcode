//
//  TranslatorViewController.m
//  MyUtils
//
//  Created by smalltalk on 16/3/2021.
//  Copyright © 2021 wintelsui. All rights reserved.
//

#import "TranslatorViewController.h"
#import "GoogleCNTranslationEngine.h"

@interface TranslatorViewController ()
{
    NSArray *_langs;
    NSArray *_engines;
    
}
@property (weak) IBOutlet NSTextField *wordInputFiled;
@property (weak) IBOutlet NSTextField *wordResultLabel;

@property (weak) IBOutlet NSPopUpButton *translationEngineSelector;
@property (weak) IBOutlet NSPopUpButton *translationLanguageFirstSelector;
@property (weak) IBOutlet NSPopUpButton *translationLanguageSecondSelector;
@end

@implementation TranslatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupData];
    [self setupUI];
}

- (void)setupData{
    _engines = [[XTranslationEngine translationEngineMap] allKeys];
    _langs = [[XTranslationEngine langMaps] allKeys];
}

- (void)setupUI{
    [_translationEngineSelector removeAllItems];
    [_translationLanguageFirstSelector removeAllItems];
    [_translationLanguageSecondSelector removeAllItems];
    
    [_translationEngineSelector addItemsWithTitles:_engines];
    [_translationLanguageFirstSelector addItemsWithTitles:_langs];
    [_translationLanguageSecondSelector addItemsWithTitles:_langs];
    
    NSString *engine = [XTranslationEngine chooseEngineName];
    if ([_engines containsObject:engine]) {
        NSUInteger i = [_engines indexOfObject:engine];
        [_translationEngineSelector selectItemAtIndex:i];
    }else{
        [XTranslationEngine setChooseEngineName:[_engines firstObject]];
        [_translationEngineSelector selectItemAtIndex:0];
    }
    
    NSString *first = [XTranslationEngine chooseFirstLangName];
    if ([_langs containsObject:first]) {
        NSUInteger i = [_langs indexOfObject:first];
        [_translationLanguageFirstSelector selectItemAtIndex:i];
    }else{
        [XTranslationEngine setChooseFirstLangName:[_langs firstObject]];
        [_translationLanguageFirstSelector selectItemAtIndex:0];
    }
    
    NSString *second = [XTranslationEngine chooseSecondLangName];
    if ([_langs containsObject:second]) {
        NSUInteger i = [_langs indexOfObject:second];
        [_translationLanguageSecondSelector selectItemAtIndex:i];
    }else{
        [XTranslationEngine setChooseSecondLangName:[_langs firstObject]];
        [_translationLanguageSecondSelector selectItemAtIndex:0];
    }
}

- (IBAction)firstLangTranslaterPressed:(id)sender {
    
    NSString *word = self.wordInputFiled.stringValue;
    if (word) {
        NSString *first = [XTranslationEngine chooseFirstLangName];
        NSString *toLang = [[XTranslationEngine langMaps] objectForKey:first];
        
        __weak typeof(self)weakSelf = self;
        
        
        [[GoogleCNTranslationEngine shared] translate:word toLang:toLang completion:^(NSString * _Nonnull result) {
            weakSelf.wordResultLabel.stringValue = result;
        }];
    }
}
- (IBAction)secondLangTranslaterPressed:(id)sender {
    NSString *word = self.wordInputFiled.stringValue;
    if (word) {
        NSString *engine = [XTranslationEngine chooseEngineName];
        NSString *second = [XTranslationEngine chooseSecondLangName];
        NSString *toLang = [[XTranslationEngine langMaps] objectForKey:second];
        
        __weak typeof(self)weakSelf = self;
        [[NSClassFromString(engine) shared] translate:word toLang:toLang completion:^(NSString * _Nonnull result) {
            weakSelf.wordResultLabel.stringValue = result;
        }];
    }
}

- (IBAction)translationEngineSelectorChanged:(NSPopUpButton *)sender {
    NSString *selectLang = [_engines objectAtIndex:sender.indexOfSelectedItem];
    [XTranslationEngine setChooseEngineName:selectLang];
}
- (IBAction)translationLanguageFirstSelectorChanged:(NSPopUpButton *)sender {
    
    NSString *selectLang = [_langs objectAtIndex:sender.indexOfSelectedItem];
    [XTranslationEngine setChooseFirstLangName:selectLang];
}

- (IBAction)translationLanguageSecondSelectorChanged:(NSPopUpButton *)sender {
    NSString *selectLang = [_langs objectAtIndex:sender.indexOfSelectedItem];
    [XTranslationEngine setChooseSecondLangName:selectLang];
}

@end
