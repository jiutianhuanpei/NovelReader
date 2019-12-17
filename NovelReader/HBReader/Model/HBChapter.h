//
//  HBChapter.h
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/12.
//  Copyright © 2019 沈红榜. All rights reserved.
//

// 章节

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBChapter : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *text;

@end

NS_ASSUME_NONNULL_END
