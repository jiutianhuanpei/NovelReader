//
//  RootViewController.m
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/16.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import "RootViewController.h"
#import "LocalViewController.h"
#import "NetViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    
    self.viewControllers = @[
        [self vcFromClass:NetViewController.class title:@"网络小说"],
        [self vcFromClass:LocalViewController.class title:@"本地小说"]
    ];
    
    
    
}


- (UIViewController *)vcFromClass:(Class)class title:(NSString *)title {
    
    UIViewController *vc = [[class alloc] init];
    vc.title = title;
    UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:vc];
    return na;
}

@end
