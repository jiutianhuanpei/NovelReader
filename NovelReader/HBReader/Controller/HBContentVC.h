//
//  HBReadVC.h
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/11.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBShowData.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HBContentVCDelegate <NSObject>

- (NSUInteger)showPageTotalNumberWith:(HBShowData *)showData;

@optional
- (void)wannaGotoLastPage;
- (void)wannaGotoNextPage;
- (void)didTapMenuRegion;

@end

@interface HBContentVC : UIViewController

@property (nonatomic, weak) id<HBContentVCDelegate> delegate;

@property (nonatomic, strong) HBShowData *showData;

@property (nonatomic, copy) void(^didShowCallback)(HBContentVC *currentShowVC);

- (void)configBackgroundImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
