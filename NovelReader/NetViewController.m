//
//  NetViewController.m
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/16.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import "NetViewController.h"
#import "HBNetManager.h"
#import "HBNetSearchBookListVC.h"

#import "HBNetBookDetailVC.h"

@interface NetViewController ()<UISearchControllerDelegate, HBNetSearchBookListVCDelegate>

@property (nonatomic, strong) UISearchController *searchVC;

@end

@implementation NetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    self.definesPresentationContext = true;
    
    if (@available(iOS 11.0, *)) {
        self.navigationItem.searchController = self.searchVC;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = _searchVC.active;
}

#pragma mark - UISearchControllerDelegate
- (void)willPresentSearchController:(UISearchController *)searchController {
    self.tabBarController.tabBar.hidden = true;
}

- (void)willDismissSearchController:(UISearchController *)searchController {
    self.tabBarController.tabBar.hidden = false;
}

#pragma mark - HBNetSearchBookListVCDelegate
- (void)didSelectNetBook:(HBNetSearchBook *)book {
    
    HBNetBookDetailVC *detail = [[HBNetBookDetailVC alloc] initWithNetBook:book];
    [self.navigationController pushViewController:detail animated:true];
}

#pragma mark - 属性
- (UISearchController *)searchVC {
    if (!_searchVC) {
        
        HBNetSearchBookListVC *list = HBNetSearchBookListVC.new;
        list.delegate = self;
        _searchVC = [[UISearchController alloc] initWithSearchResultsController:list];
        _searchVC.searchResultsUpdater = list;
        _searchVC.delegate = self;
        _searchVC.searchBar.tintColor = UIColor.whiteColor;
    }
    return _searchVC;
}

@end
