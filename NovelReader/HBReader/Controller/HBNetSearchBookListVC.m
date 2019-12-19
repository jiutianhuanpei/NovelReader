//
//  HBNetSearchBookListVC.m
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/16.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import "HBNetSearchBookListVC.h"
#import "HBNetManager.h"
#import "HBNetSearchCell.h"

@interface HBNetSearchBookListVC ()

@property (nonatomic, strong) NSMutableArray<HBNetBook *> *dataArray;
@property (nonatomic, weak) UISearchController *searchVC;


@end

@implementation HBNetSearchBookListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self.tableView registerClass:HBNetSearchCell.class forCellReuseIdentifier:NSStringFromClass(HBNetSearchCell.class)];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    _dataArray = @[].mutableCopy;    
    // Do any additional setup after loading the view.
}

- (void)dealloc {
    NSLog(@"");
}



#pragma mark - DataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HBNetSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(HBNetSearchCell.class) forIndexPath:indexPath];
    
    HBNetBook *book = _dataArray[indexPath.row];
    cell.book = book;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

#pragma mark - Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HBNetBook *book = _dataArray[indexPath.row];
    if ([_delegate respondsToSelector:@selector(didSelectNetBook:)]) {
        [_delegate didSelectNetBook:book];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_searchVC.searchBar resignFirstResponder];
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    _searchVC = searchController;
    
    if (searchController.searchBar.text.length == 0) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [HBNetManager.sharedInstance searchBookWithName:searchController.searchBar.text complete:^(NSError * _Nullable error, NSArray<HBNetBook *> * _Nullable bookList) {
       
        [weakSelf.dataArray removeAllObjects];
        [weakSelf.dataArray addObjectsFromArray:bookList];
        
        dispatch_at_main_queue(^{
            [weakSelf.tableView reloadData];
        })
    }];
    
}



@end
