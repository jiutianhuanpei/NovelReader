//
//  ViewController.m
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/11.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import "LocalViewController.h"
#import "HBTools.h"
#import "HBLocalReadVC.h"
#import "HBLocalBook.h"

@interface LocalViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *bookList;

@end

@implementation LocalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
//    self.navigationController.navigationBar.barTintColor = UIColor.redColor;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"sync"] style:UIBarButtonItemStylePlain target:self action:@selector(syncLocalBooks)];
    right.tintColor = UIColor.whiteColor;
    
    self.navigationItem.rightBarButtonItem = right;
    
    
    
    [self.view addSubview:self.tableView];
    
    [self reloadData];
}

- (void)reloadData {
    NSArray *pathList = [HBTools localBookPathList];
    
    _bookList = @[].mutableCopy;
    
    for (NSString *path in pathList) {
        
        HBLocalBook *book = [[HBLocalBook alloc] initWithLocalUrl:[NSURL fileURLWithPath:path] regex:@"\r\n第.{1,}章.*\r\n"];
        
        [_bookList addObject:book];
    }
    [self.tableView reloadData];
}

- (void)syncLocalBooks {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"同步本地图书" message:@"手机连接Mac，打开Finder，在iPhone里选中文件，把小说文件拖到“本地图书”之下，再点击手机上的确定按钮" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [HBTools moveBookToLocalBookPath];
        
        [self reloadData];
    }]];
    [self presentViewController:alert animated:true completion:nil];
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _bookList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class) forIndexPath:indexPath];
    
    HBLocalBook *book = _bookList[indexPath.row];
    cell.textLabel.text = book.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HBLocalBook *book = _bookList[indexPath.row];
    
    HBLocalReadVC *vc = [[HBLocalReadVC alloc] initWithLocalBook:book];
    [self presentViewController:vc animated:true completion:nil];
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self) weakSelf = self;
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        HBLocalBook *book = weakSelf.bookList[indexPath.row];
        
        [NSFileManager.defaultManager removeItemAtURL:book.localUrl error:nil];
        [weakSelf.bookList removeObject:book];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }];
    
    return @[action];
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = UIView.new;
    }
    return _tableView;
}


@end
