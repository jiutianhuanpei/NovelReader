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
#import "HBNetBookItem.h"
#import "HBDBManager.h"

#import "HBNetReadVC.h"

@interface NetViewController ()
<UISearchControllerDelegate,
HBNetSearchBookListVCDelegate,
UICollectionViewDataSource, UICollectionViewDelegate
>

@property (nonatomic, strong) UISearchController *searchVC;

@property (nonatomic, strong) UICollectionView *colView;

@property (nonatomic, strong) NSMutableArray *bookList;

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
    
    [self.view addSubview:self.colView];
    
    [_colView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = _searchVC.active;
    
    NSArray *array = HBDBManager.sharedInstance.getAllBooks;
    _bookList = array.mutableCopy;
    [_colView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _bookList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HBNetBookItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(HBNetBookItem.class) forIndexPath:indexPath];
    
    HBNetBook *book = _bookList[indexPath.item];
    item.book = book;
    
    return item;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HBNetBook *book = _bookList[indexPath.item];
        
        __weak typeof(self) weakSelf = self;
    [HBDBManager.sharedInstance getBookmarkFromBookId:book.bookId complete:^(NSString * _Nonnull bookId, NSString * _Nonnull chapterId, NSInteger index, NSString * _Nonnull bookName) {
        
        
        HBNetReadVC *vc = [[HBNetReadVC alloc] initWithBookId:bookId chapterId:chapterId index:index];
        [weakSelf presentViewController:vc animated:true completion:nil];
        
    }];
}

#pragma mark - UISearchControllerDelegate
- (void)willPresentSearchController:(UISearchController *)searchController {
    self.tabBarController.tabBar.hidden = true;
}

- (void)willDismissSearchController:(UISearchController *)searchController {
    self.tabBarController.tabBar.hidden = false;
    NSArray *array = HBDBManager.sharedInstance.getAllBooks;
    _bookList = array.mutableCopy;
    [_colView reloadData];
}

#pragma mark - HBNetSearchBookListVCDelegate
- (void)didSelectNetBook:(HBNetBook *)book {
    
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

- (UICollectionView *)colView {
    if (!_colView) {
        UICollectionViewFlowLayout *layout = UICollectionViewFlowLayout.new;
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        
        CGFloat itemW = floor((CGRectGetWidth(UIScreen.mainScreen.bounds) - 50) / 4.0);
        CGFloat itemH = ceil(1.25 * itemW);
        
        layout.itemSize = CGSizeMake(itemW, itemH);
        
        _colView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _colView.backgroundColor = UIColor.whiteColor;
        [_colView registerClass:HBNetBookItem.class forCellWithReuseIdentifier:NSStringFromClass(HBNetBookItem.class)];
        _colView.alwaysBounceVertical = true;
        
        _colView.delegate = self;
        _colView.dataSource = self;
    }
    return _colView;
}

@end
