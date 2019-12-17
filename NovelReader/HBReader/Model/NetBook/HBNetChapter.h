//
//  HBNetChapter.h
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/16.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBNetChapter : NSObject<YYModel>

@property (nonatomic, copy) NSArray<NSString *> *content;
@property (nonatomic, copy) NSString *title;

@end

NS_ASSUME_NONNULL_END
