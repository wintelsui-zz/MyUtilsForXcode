//
//  AppDelegate.m
//  MyUtils
//
//  Created by wintel on 1/9/19.
//  Copyright © 2019 wintelsui. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender{
    //当关闭最后一个窗口时，退出app
//    NSLog(@"codes:%@",@"applicationShouldTerminateAfterLastWindowClosed");
    return YES;
}


@end
