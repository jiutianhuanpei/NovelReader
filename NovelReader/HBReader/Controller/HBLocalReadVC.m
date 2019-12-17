//
//  HBReadVC.m
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/11.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import "HBLocalReadVC.h"
#import "HBContentVC.h"
#import "HBLocalBookManager.h"
#import "HBToolsView.h"
#import "HBBottomToolView.h"
#import "HBTopToolView.h"
#import "HBCatalogVC.h"
#import "HBConfigManager.h"

@interface HBLocalReadVC ()<UIPageViewControllerDataSource, HBContentVCDelegate>

@property (nonatomic, weak) HBContentVC *currentVC;

@property (nonatomic, strong) HBLocalBookManager *manager;

@property (nonatomic, strong) UIPageViewController *pageVC;

@property (nonatomic, strong) HBToolsView *toolView;

@property (nonatomic, strong) HBTopToolView *topToolView;
@property (nonatomic, strong) HBBottomToolView *bottomView;

@property (nonatomic, strong) HBShowData *currentShowData;




@end

@implementation HBLocalReadVC

- (instancetype)initWithLocalBook:(HBLocalBook *)book {
    self = [super init];
    if (self) {
        _manager = [[HBLocalBookManager alloc] initWithLocalBook:book];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
        
    [self addChildViewController:self.pageVC];
    [self.view addSubview:self.pageVC.view];
    self.pageVC.view.frame = self.view.bounds;
    
    [self.pageVC setViewControllers:@[[self aNewContentVC]] direction:UIPageViewControllerNavigationDirectionForward animated:false completion:nil];
    
    __weak typeof(self) weakSelf = self;
    [_manager parsingShowDataAtChapterAtIndex:self.chapterIndex complete:^{
        
        //加载书签
        HBShowData *data = [weakSelf.manager showDataInChapter:weakSelf.chapterIndex page:0];
        weakSelf.currentVC.showData = data;
    }];
    [self configCallback];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    HB_ShowStatusBar(false);
}

- (void)showCatalogVC {
//    HBCatalogVC *vc = [[HBCatalogVC alloc] initWithBook:_manager.book currentChapterIndex:self.currentVC.showData.chapterIndex];
    HBCatalogVC *vc = HBCatalogVC.new;
    __weak typeof(self) weakSelf = self;
    [vc configWithTotalRows:_manager.book.chapterList.count selectRow:self.currentVC.showData.chapterIndex showTitle:^NSString * _Nonnull(NSIndexPath * _Nonnull indexPath) {
        HBChapter *chapter = weakSelf.manager.book.chapterList[indexPath.row];
        return chapter.title;
    }];
    
    vc.didSelectCallback = ^(NSInteger chapterIndex) {
        if (chapterIndex < 0) {
            return ;
        }
        
        [self.manager parsingShowDataAtChapterAtIndex:chapterIndex complete:^{
            
            HBContentVC *vc = [self aNewContentVC];
            
            HBShowData *data = [self.manager showDataInChapter:chapterIndex page:0];
            vc.showData = data;
            [self.pageVC setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionForward animated:false completion:nil];
        }];
        
    };
    
    UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:na animated:true completion:nil];
}

- (void)configCallback {
    
    __weak typeof(self) weakSelf = self;
    HBConfigManager.sharedInstance.bgImageChangedCallback = ^(UIImage * _Nonnull image) {
        [weakSelf.currentVC configBackgroundImage:image];
    };
}

#pragma mark - UIPageViewControllerDataSource
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(HBContentVC *)viewController {

    return [self p_lastPage];
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(HBContentVC *)viewController {

    return [self p_nextPage];
}

#pragma mark - HBContentVCDelegate
- (NSUInteger)showPageTotalNumberWith:(HBShowData *)showData {
    NSUInteger num = [_manager pageNumAtChapter:showData.chapterIndex];
    return num;
}

- (void)wannaGotoLastPage {
    HBContentVC *vc = [self p_lastPage];
    if (vc) {
        [self.pageVC setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionReverse animated:true completion:nil];
    }
}

- (void)wannaGotoNextPage {
    HBContentVC *vc = [self p_nextPage];
    if (vc) {
        [self.pageVC setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionForward animated:true completion:nil];
    }
}

- (void)didTapMenuRegion {
    [self.navigationController setNavigationBarHidden:!self.navigationController.isNavigationBarHidden animated:true];
    
    if (!self.navigationController.isNavigationBarHidden) {
        [self.toolView show];
    }
}

#pragma mark - private
- (HBContentVC * _Nonnull)aNewContentVC {
    HBContentVC *vc = HBContentVC.new;
    vc.delegate = self;

    __weak typeof(self) weakSelf = self;
    vc.didShowCallback = ^(HBContentVC * _Nonnull currentShowVC) {
        weakSelf.currentShowData = currentShowVC.showData;
        weakSelf.currentVC = currentShowVC;
    };
    return vc;
}

- (HBContentVC *)p_lastPage {
    HBShowData *data = [self.manager showDataBefor:self.currentShowData];
    if (!data) {
        return nil;
    }
    
    HBContentVC *vc = [self aNewContentVC];
    vc.showData = data;
    
    return vc;
}

- (HBContentVC *)p_nextPage {

    HBShowData *data = [self.manager showDataAfter:self.currentShowData];
    if (!data) {
        return nil;
    }
    
    HBContentVC *vc = [self aNewContentVC];
    vc.showData = data;
    
    return vc;
}

#pragma mark - getter
- (UIPageViewController *)pageVC {
    if (!_pageVC) {
        _pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageVC.dataSource = self;
    }
    return _pageVC;
}



- (HBToolsView *)toolView {
    if (!_toolView) {
        _toolView = [HBToolsView viewForVC:self];
        _toolView.toolViews = @[self.topToolView, self.bottomView];
    }
    return _toolView;
}

- (HBTopToolView *)topToolView {
    if (!_topToolView) {
        _topToolView = HBTopToolView.new;
        _topToolView.title = self.manager.book.name;
        __weak typeof(self) weakSelf = self;
        _topToolView.closeCallback = ^{
            HB_ShowStatusBar(true);
            [weakSelf dismissViewControllerAnimated:true completion:nil];
        };
    }
    return _topToolView;
}

- (HBBottomToolView *)bottomView {
    if (!_bottomView) {
        _bottomView = HBBottomToolView.new;
        __weak typeof(self) weakSelf = self;
        _bottomView.catalogCallback = ^{
            [weakSelf showCatalogVC];
        };
    }
    return _bottomView;
}

#pragma mark - over
- (UIModalPresentationStyle)modalPresentationStyle {
    return UIModalPresentationOverFullScreen;
}

@end
