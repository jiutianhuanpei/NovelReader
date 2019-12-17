//
//  HBTopToolView.h
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/13.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBToolViewDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface HBTopToolView : UIView<HBToolViewDelegate>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) dispatch_block_t closeCallback;

@end

NS_ASSUME_NONNULL_END
