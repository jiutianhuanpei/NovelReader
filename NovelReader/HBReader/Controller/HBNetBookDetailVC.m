//
//  HBNetBookDetailVC.m
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/16.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import "HBNetBookDetailVC.h"
#import "HBNetSearchCell.h"
#import "HBNetBookDetail.h"
#import "HBNetManager.h"
#import "HBNetReadVC.h"

@interface HBNetBookDetailVC ()

@property (nonatomic, strong) HBNetSearchBook *searchBook;
@property (nonatomic, strong) HBNetBookDetail *book;

@end

@implementation HBNetBookDetailVC

- (instancetype)initWithNetBook:(HBNetSearchBook *)book{
    self = [super init];
    if (self) {
        _searchBook = book;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = UIView.new;
    
    [self.tableView registerClass:HBNetSearchCell.class forCellReuseIdentifier:NSStringFromClass(HBNetSearchCell.class)];
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
    
    [self fetchData];
}

- (void)fetchData {
    __weak typeof(self) weakSelf = self;
    [HBNetManager.sharedInstance fetchNetBookDetailWithUrl:_searchBook.url complete:^(NSError * _Nullable error, HBNetBookDetail * _Nullable bookDetail) {
        weakSelf.book = bookDetail;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_book.introduce) {
        return 2;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    }
    
    return _book.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        HBNetSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(HBNetSearchCell.class) forIndexPath:indexPath];
        cell.introduceMaxLines = NSIntegerMax;
        cell.book = _searchBook;
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class) forIndexPath:indexPath];
    
    HBNetBookChapter *chapter = _book.list[indexPath.row];
    cell.textLabel.text = chapter.name;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return;
    }
    HBNetReadVC *vc = [[HBNetReadVC alloc] initWithBookDetail:_book chapterIndex:indexPath.row];
    [self presentViewController:vc animated:true completion:nil];
}

#pragma mark - override
- (BOOL)hidesBottomBarWhenPushed {
    return true;
}


@end
