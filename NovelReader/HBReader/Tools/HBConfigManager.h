//
//  HBConfigManager.h
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/12.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBConfigManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, strong) UIImage *bgImage;
@property (nonatomic, copy) void(^bgImageChangedCallback)(UIImage *image);

@property (nonatomic, copy) NSDictionary *attributeDic;
@property (nonatomic, copy) void(^attributeDicChangedCallback)(NSDictionary *dic);

@property (nonatomic, assign, readonly) CGFloat safeTop;
@property (nonatomic, assign, readonly) CGSize showSize;




@end

NS_ASSUME_NONNULL_END
