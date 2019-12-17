//
//  HBNetReadVC.m
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/16.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import "HBNetReadVC.h"
#import "HBContentVC.h"
#import "HBNetBookManager.h"
#import "HBToolsView.h"
#import "HBBottomToolView.h"
#import "HBTopToolView.h"
#import "HBCatalogVC.h"
#import "HBConfigManager.h"

@interface HBNetReadVC ()<UIPageViewControllerDataSource, HBContentVCDelegate>

@property (nonatomic, strong) UIPageViewController *pageVC;

@property (nonatomic, assign) NSUInteger currentIndex;

@property (nonatomic, weak) HBContentVC *currentVC;

@property (nonatomic, strong) HBNetBookManager *manager;

@property (nonatomic, strong) HBToolsView *toolView;

@property (nonatomic, strong) HBTopToolView *topToolView;
@property (nonatomic, strong) HBBottomToolView *bottomView;

@end

@implementation HBNetReadVC

- (instancetype)initWithBookDetail:(HBNetBookDetail *)book chapterIndex:(NSUInteger)index {
    self = [super init];
    if (self) {
        _currentIndex = index;
        
        _manager = [[HBNetBookManager alloc] initWithBook:book];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    
    _pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    _pageVC.dataSource = self;
    [self addChildViewController:_pageVC];
    _pageVC.view.frame = self.view.bounds;
    [self.view addSubview:_pageVC.view];
    
    [self.pageVC setViewControllers:@[[self aNewContentVC]] direction:UIPageViewControllerNavigationDirectionForward animated:false completion:nil];
    
    __weak typeof(self) weakSelf = self;
    [_manager parsingShowDataAtChapterAtIndex:self.currentIndex complete:^{
        
        //加载书签
        HBShowData *data = [weakSelf.manager showDataInChapter:weakSelf.currentIndex page:0];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            weakSelf.currentVC.showData = data;
        });
    }];
    [self configCallback];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    HB_ShowStatusBar(false);
}

- (void)showCatalogVC {
    HBCatalogVC *vc = HBCatalogVC.new;
    __weak typeof(self) weakSelf = self;
    [vc configWithTotalRows:_manager.book.list.count selectRow:self.currentVC.showData.chapterIndex showTitle:^NSString * _Nonnull(NSIndexPath * _Nonnull indexPath) {
        HBNetBookChapter *chapter = weakSelf.manager.book.list[indexPath.row];
        return chapter.name;
    }];
    
    vc.didSelectCallback = ^(NSInteger chapterIndex) {
        if (chapterIndex < 0) {
            return ;
        }
        
        [weakSelf.manager parsingShowDataAtChapterAtIndex:chapterIndex complete:^{
            
            HBShowData *data = [weakSelf.manager showDataInChapter:chapterIndex page:0];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                HBContentVC *vc = [weakSelf aNewContentVC];
                vc.showData = data;
                [weakSelf.pageVC setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionForward animated:false completion:nil];
            });
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
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    
    return [self p_lastPage];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    
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
        weakSelf.currentVC = currentShowVC;
    };
    return vc;
}

- (HBContentVC *)p_lastPage {
    HBShowData *data = [self.manager showDataBefor:self.currentVC.showData];
    if (!data) {
        return nil;
    }
    
    HBContentVC *vc = [self aNewContentVC];
    vc.showData = data;
    
    return vc;
}

- (HBContentVC *)p_nextPage {

    HBShowData *data = [self.manager showDataAfter:self.currentVC.showData];
    if (!data) {
        return nil;
    }
    
    HBContentVC *vc = [self aNewContentVC];
    vc.showData = data;
    
    return vc;
}

#pragma mark - helps
- (HBContentVC *)p_aNewContentVC {
    HBContentVC *vc = HBContentVC.new;
    vc.delegate = self;

    __weak typeof(self) weakSelf = self;
    vc.didShowCallback = ^(HBContentVC * _Nonnull currentShowVC) {
        weakSelf.currentVC = currentShowVC;
    };
    return vc;
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
        _topToolView.title = self.manager.book.introduce.name;
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
