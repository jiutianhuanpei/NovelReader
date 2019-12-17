//
//  HBBottomView.h
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/12.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBToolViewDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface HBBottomToolView : UIView<HBToolViewDelegate>

@property (nonatomic, copy) dispatch_block_t catalogCallback;

@end

NS_ASSUME_NONNULL_END
