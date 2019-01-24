//
//  ViewController.m
//  MyUtils
//
//  Created by wintel on 1/9/19.
//  Copyright © 2019 wintelsui. All rights reserved.
//

#import "ViewController.h"
#import "ColorStringSetting.h"

@interface ViewController ()
<NSTextFieldDelegate>

@property (weak) IBOutlet NSSegmentedControl *segmentedColor;
@property (weak) IBOutlet NSTextField *previewShowLabel;
@property (weak) IBOutlet NSTextField *redPrefixInput;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@",[NSColor colorWithWhite:1 alpha:1]);
    NSLog(@"%@",[NSColor colorWithRed:1 green:1 blue:1 alpha:0]);
    
    // Do any additional setup after loading the view.
    NSArray *applicationSupports =  [[NSFileManager defaultManager] URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask];
    NSLog(@"applicationSupports:%@",applicationSupports);
    
    [self updateSegmentedColor];
    [_segmentedColor setAction:@selector(segmentControlChange:)];
    
    [self updateCustomFormat1];
    [self updateCustomFormat1Preview];
}

- (void)updateSegmentedColor{
    BOOL hex2rgbDefaultNSColor = [ColorStringSetting getHex2rgbDefaultNSColor];
    if (hex2rgbDefaultNSColor) {
        _segmentedColor.selectedSegment = 1;
    }else{
        _segmentedColor.selectedSegment = 0;
    }
}

- (void)segmentControlChange:(NSSegmentedControl *)segControl{
    NSInteger index = segControl.selectedSegment;
    [ColorStringSetting setHex2rgbDefaultNSColor:((index == 1) ? YES : NO)];
}

- (void)updateCustomFormat1{
    NSString *redPrefixCF1 = [ColorStringSetting getCustomFormat1String];
    _redPrefixInput.stringValue = redPrefixCF1;
}

- (void)updateCustomFormat1Preview{
    NSString *redPrefixCF1 = _redPrefixInput.stringValue;
    if (redPrefixCF1 != nil && redPrefixCF1.length > 0) {
        redPrefixCF1 = [redPrefixCF1 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        NSRange rangeRed = [redPrefixCF1 rangeOfString:@"(R)"];
        NSRange rangeGreen = [redPrefixCF1 rangeOfString:@"(G)"];
        NSRange rangeBlue = [redPrefixCF1 rangeOfString:@"(B)"];
        NSRange rangeA = [redPrefixCF1 rangeOfString:@"(A)"];
        if (rangeRed.length > 0 && rangeGreen.length > 0 && rangeBlue.length > 0) {
            NSString *newString = [redPrefixCF1 stringByReplacingCharactersInRange:rangeRed withString:@"1.0"];
            newString = [newString stringByReplacingCharactersInRange:rangeGreen withString:@"1.0"];
            newString = [newString stringByReplacingCharactersInRange:rangeBlue withString:@"1.0"];
            if (rangeA.length > 0){
                newString = [newString stringByReplacingCharactersInRange:rangeA withString:@"1.0"];
            }
            _previewShowLabel.stringValue = newString;
        }else{
            _previewShowLabel.stringValue = @"";
        }
    }else{
        _previewShowLabel.stringValue = @"";
    }
    
}

- (IBAction)applyCustomF1Pressed:(id)sender {
    
    NSString *redPrefixCF1 = _redPrefixInput.stringValue;
    if (redPrefixCF1 != nil && redPrefixCF1.length > 0) {
        redPrefixCF1 = [redPrefixCF1 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        NSRange rangeRed = [redPrefixCF1 rangeOfString:@"(R)"];
        NSRange rangeGreen = [redPrefixCF1 rangeOfString:@"(G)"];
        NSRange rangeBlue = [redPrefixCF1 rangeOfString:@"(B)"];
        if (rangeRed.length > 0 && rangeGreen.length > 0 && rangeBlue.length > 0) {
            [ColorStringSetting setCustomFormat1String:redPrefixCF1];
            
            //Color Converter Custom1
            
            NSAlert * alert = [[NSAlert alloc]init];
            alert.messageText = @"Successfully Set";
            alert.alertStyle = NSAlertStyleInformational;
            [alert addButtonWithTitle:@"OK"];
            [alert setInformativeText:@"You can use the key \"Color Converter Custom1\"."];
            [alert beginSheetModalForWindow:[self.view window] completionHandler:^(NSModalResponse returnCode) {
                
//                if (returnCode == NSModalResponseOK){
//                    NSLog(@"(returnCode == NSOKButton)");
//                }else if (returnCode == NSModalResponseCancel){
//                    NSLog(@"(returnCode == NSCancelButton)");
//                }else if(returnCode == NSAlertFirstButtonReturn){
//                    NSLog(@"if (returnCode == NSAlertFirstButtonReturn)");
//                }
            }];
        }
    }
}

- (void)textDidChange:(NSNotification *)notification{
    NSLog(@"notification:%@",notification);
    if (notification.object == _redPrefixInput) {
        [self updateCustomFormat1Preview];
    }
}
-(BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector {
    if (commandSelector == @selector(insertNewline:)) {// 监听键盘的回车事件.
        
    }
    return NO;
}
// 控制文本输入框的内容长度.
-(void)controlTextDidChange:(NSNotification *)obj{
//    NSLog(@"controlTextDidChange:%@",obj);
    if (obj.object == _redPrefixInput) {
        [self updateCustomFormat1Preview];
    }
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
