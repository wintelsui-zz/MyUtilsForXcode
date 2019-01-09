//
//  ViewController.m
//  MyUtils
//
//  Created by wintel on 1/9/19.
//  Copyright © 2019 wintelsui. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    NSArray *applicationSupports =  [[NSFileManager defaultManager] URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask];
    NSLog(@"applicationSupports:%@",applicationSupports);
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
