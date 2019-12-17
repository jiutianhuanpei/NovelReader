//
//  HBReadView.h
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/11.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HBReadView;

NS_ASSUME_NONNULL_BEGIN

@protocol HBReadViewDelegate <NSObject>

@optional
- (void)didTapReadView:(HBReadView *)readView atPoint:(CGPoint)point;

@end

@interface HBReadView : UIView

@property (nonatomic, weak) id<HBReadViewDelegate> delegate;

@property (nonatomic, strong) NSAttributedString *text;
@property (nonatomic, assign) BOOL gestureEnable;

@end

NS_ASSUME_NONNULL_END
