//
//  HBCatalogVCTableViewController.m
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/13.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import "HBCatalogVC.h"

@interface HBCatalogVC ()

//@property (nonatomic, strong) HBBook *book;
@property (nonatomic, assign) NSUInteger totalRows;
@property (nonatomic, assign) NSUInteger chapterIndex;
@property (nonatomic, copy) NSString *(^showTitle)(NSIndexPath *);


@end

@implementation HBCatalogVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.title = @"目录";
    self.tableView.tableFooterView = UIView.new;
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"reuseIdentifier"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_chapterIndex inSection:0] animated:false scrollPosition:UITableViewScrollPositionMiddle];
}

- (void)configWithTotalRows:(NSUInteger)totalNum selectRow:(NSUInteger)selectRow showTitle:(NSString * _Nonnull (^)(NSIndexPath * _Nonnull))showTitle {
    _totalRows = totalNum;
    _chapterIndex = selectRow;
    _showTitle = showTitle;
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _totalRows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
    cell.textLabel.text = _showTitle(indexPath);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    !_didSelectCallback ?: _didSelectCallback(indexPath.row);
    [self dismissViewControllerAnimated:true completion:nil];
}


@end
