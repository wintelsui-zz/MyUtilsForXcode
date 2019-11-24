//
//  ResourcesBuilderViewController.m
//  testResourcs
//
//  Created by wintel on 2019/11/19.
//  Copyright © 2019 wintel. All rights reserved.
//

#import "ResourcesBuilderViewController.h"
#import "ResourcesBuilderViewModel.h"

@interface ResourcesBuilderViewController ()

@property (weak) IBOutlet NSTextField *InputFolderField;
@property (weak) IBOutlet NSTextField *outputFolderField;
@property (weak) IBOutlet NSButton *inputFolderClearButton;
@property (weak) IBOutlet NSButton *outputFolderSettingButton;



@property (weak) IBOutlet NSProgressIndicator *progressIndicator;
@property (weak) IBOutlet NSButton *startButton;

@property (weak) IBOutlet NSSegmentedControl *segmentedControl;

@property (weak) IBOutlet NSButton *checkBox1;
@property (weak) IBOutlet NSButton *checkBox2;
@property (weak) IBOutlet NSButton *checkBox3;

@property (nonatomic, strong) ResourcesBuilderViewModel *viewModel;

@end

@implementation ResourcesBuilderViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupData];
    [self setupUI];
}

- (void)setupData{
    _viewModel = [ResourcesBuilderViewModel new];
}
- (void)setupUI{
    [_progressIndicator setHidden:YES];
    
    CGRect rect = self.view.frame;
    rect.size.width = 650;
    rect.size.height = 400;
    self.view.frame = rect;
    
    self.segmentedControl.selectedSegment = self.viewModel.inputType;
    
    RAC(self.viewModel , inputFolder) = [RACSignal merge:@[RACObserve(self.InputFolderField, stringValue),self.InputFolderField.rac_textSignal]];
    RAC(self.viewModel , outputFolder) = [RACSignal merge:@[RACObserve(self.outputFolderField, stringValue),self.outputFolderField.rac_textSignal]];
    
    self.checkBox1.state = self.viewModel.createImage1 ? NSControlStateValueOn : NSControlStateValueOff;
    self.checkBox2.state = self.viewModel.createImage2 ? NSControlStateValueOn : NSControlStateValueOff;
    self.checkBox3.state = self.viewModel.createImage3 ? NSControlStateValueOn : NSControlStateValueOff;
    
    RAC(self.startButton , enabled) = self.viewModel.validStartSignal;
}



- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)InputFolderSettingButtonPressed:(id)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseFiles:NO];
    [panel setCanChooseDirectories:YES];
    [panel setAllowsMultipleSelection:NO];
    NSInteger finded = [panel runModal];
    if (finded == NSModalResponseOK) {
        for (NSURL *url in [panel URLs])
        {NSLog(@"--->%@",url);
            NSString *folderUrlAbsoluteString = [url.absoluteString stringByRemovingPercentEncoding];
            if ([folderUrlAbsoluteString hasPrefix:@"file://"]) {
                folderUrlAbsoluteString = [folderUrlAbsoluteString substringFromIndex:@"file://".length];
            }
            _InputFolderField.stringValue = folderUrlAbsoluteString;
        }
    }
}
- (IBAction)InputFolderClearButtonPressed:(id)sender {
    _InputFolderField.stringValue = @"";
}

- (IBAction)outputFolderSettingButtonPressed:(id)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseFiles:NO];
    [panel setCanChooseDirectories:YES];
    [panel setAllowsMultipleSelection:NO];
    NSInteger finded = [panel runModal];
    if (finded == NSModalResponseOK) {
        for (NSURL *url in [panel URLs])
        {NSLog(@"--->%@",url);
            NSString *folderUrlAbsoluteString = [url.absoluteString stringByRemovingPercentEncoding];
            if ([folderUrlAbsoluteString hasPrefix:@"file://"]) {
                folderUrlAbsoluteString = [folderUrlAbsoluteString substringFromIndex:@"file://".length];
            }
            _outputFolderField.stringValue = folderUrlAbsoluteString;
        }
    }
}
- (IBAction)outputFolderClearButtonPressed:(id)sender {
    _outputFolderField.stringValue = @"";
}

- (IBAction)startButtonPressed:(id)sender {
    [_startButton setEnabled:NO];
    [_progressIndicator setHidden:NO];
    [_progressIndicator startAnimation:nil];
    
    __weak typeof(self)weakSelf = self;
    [self.viewModel startCompletion:^(BOOL succeed) {
        
        if (succeed) {
            NSString *message = [NSString stringWithFormat:@"图片已经保存到文件夹\n%@",weakSelf.viewModel.outputFolder];
            [weakSelf showSingleAlertMessage:@"完成" informative:message];
        }else{
            [weakSelf showSingleAlertMessage:@"错误" informative:@"请确定填写正确输入/输出文件夹"];
        }
        [weakSelf.progressIndicator stopAnimation:nil];
        [weakSelf.progressIndicator setHidden:YES];
        [weakSelf.startButton setEnabled:YES];
    }];
    
}

- (IBAction)segmentedControlChanged:(NSSegmentedControl *)sender {
    NSLog(@"sender:%ld",sender.selectedSegment);
    self.viewModel.inputType = sender.selectedSegment;
}

- (IBAction)checkBoxPressed:(NSButton *)sender {
    if (sender == self.checkBox1) {
        self.viewModel.createImage1 = self.checkBox1.state == NSControlStateValueOn ? YES : NO;
    }else if (sender == self.checkBox2) {
        self.viewModel.createImage2 = self.checkBox2.state == NSControlStateValueOn ? YES : NO;
    }else if (sender == self.checkBox3) {
        self.viewModel.createImage3 = self.checkBox3.state == NSControlStateValueOn ? YES : NO;
    }
}


- (void)showSingleAlertMessage:(NSString *)message informative:(NSString *)informative{
    
    NSAlert *alert = [[NSAlert alloc] init];
        alert.icon = [NSImage imageNamed:@"icon_image_icon"];
    
    //提示的标题
    [alert setMessageText:message];
    
    //提示的详细内容
    [alert setInformativeText:informative];
    
    [alert addButtonWithTitle:@"OK"];//1000
    
    [alert setAlertStyle:NSAlertStyleInformational];
    [alert beginSheetModalForWindow:self.view.window
                  completionHandler:^(NSModalResponse returnCode){
        NSLog(@"returnCode:%ld",(long)returnCode);
    }];
}

@end
