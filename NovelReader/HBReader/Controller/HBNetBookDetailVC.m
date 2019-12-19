//
//  HBNetBookDetailVC.m
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/16.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import "HBNetBookDetailVC.h"
#import "HBNetSearchCell.h"
#import "HBNetBook.h"
#import "HBNetManager.h"
#import "HBNetReadVC.h"
#import "UIButton+HB.h"
#import "HBDBManager.h"

@interface HBNetBookDetailVC ()

@property (nonatomic, strong) HBNetBook *searchBook;
@property (nonatomic, strong) HBNetBook *book;

@property (nonatomic, strong) UIButton *addBtn;


@end

@implementation HBNetBookDetailVC

- (instancetype)initWithNetBook:(HBNetBook *)book{
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
    
    NSArray *books = [HBDBManager.sharedInstance getBooksWithUrl:_searchBook.bookId];
    
    NSString *title = books.count > 0 ? @"移出书架" : @"加入书架";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(didClickedRightItem:)];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = UIView.new;
    
    [self.tableView registerClass:HBNetSearchCell.class forCellReuseIdentifier:NSStringFromClass(HBNetSearchCell.class)];
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
    
    [self fetchData];
}

- (void)fetchData {
    __weak typeof(self) weakSelf = self;    
    [HBNetManager.sharedInstance updateNetBookChapterList:_searchBook complete:^(NSError * _Nullable error, HBNetBook * _Nullable bookDetail) {
        weakSelf.book = bookDetail;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    }];
}

- (void)didClickedRightItem:(UIBarButtonItem *)item {
    
    if ([item.title isEqualToString:@"移出书架"]) {
        BOOL ret = [HBDBManager.sharedInstance deleteNetBook:_searchBook];
        if (ret) {
            item.title = @"加入书架";
        }
    } else {
        bool ret = [HBDBManager.sharedInstance addToBookcaseWithNetBook:_searchBook];
        if (ret) {
            item.title = @"移出书架";
        }
    }
    
}

#pragma mark - UITableViewDataSource
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
    
    return _book.chapterList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        HBNetSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(HBNetSearchCell.class) forIndexPath:indexPath];
        cell.introduceMaxLines = NSIntegerMax;
        cell.book = _searchBook;
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class) forIndexPath:indexPath];
    
    HBChapter *chapter = _book.chapterList[indexPath.row];
    cell.textLabel.text = chapter.title;
    
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
