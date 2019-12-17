//
//  AppDelegate.m
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/11.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.backgroundColor = UIColor.whiteColor;
    [self.window makeKeyAndVisible];
    
    RootViewController *na = [[RootViewController alloc] init];
    self.window.rootViewController = na;
    
    
    UINavigationBar.appearance.barTintColor = UIColor.redColor;
    UINavigationBar.appearance.titleTextAttributes = @{NSForegroundColorAttributeName : UIColor.whiteColor};
    
    return YES;
}




@end
