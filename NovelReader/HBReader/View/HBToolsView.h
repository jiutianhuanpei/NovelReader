//
//  HBToolsView.h
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/13.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBToolViewDelegate.h"
NS_ASSUME_NONNULL_BEGIN

@interface HBToolsView : UIView

+ (instancetype)viewForVC:(UIViewController *)vc;

@property (nonatomic, assign) NSTimeInterval animtionDurtionTime;
@property (nonatomic, strong) NSArray<id<HBToolViewDelegate>> *toolViews;

- (void)show;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
