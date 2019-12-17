//
//  HBToolViewDelegate.h
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/13.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HBToolViewDelegate <NSObject>


/// 可以工具控件布局了，布局为隐藏的状态 
- (void)containerViewIsReadied;

- (void)hide:(BOOL)isHide;

@optional
@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, copy) dispatch_block_t dismissToolView;

@end

NS_ASSUME_NONNULL_END
