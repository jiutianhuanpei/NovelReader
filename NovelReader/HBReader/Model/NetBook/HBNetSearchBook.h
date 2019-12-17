//
//  HBNetSearchBook.h
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/16.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBNetSearchBook : NSObject

@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *cover;
@property (nonatomic, copy) NSString *introduce;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *updateChapterTitle;
@property (nonatomic, copy) NSString *tag;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *url;


@end

NS_ASSUME_NONNULL_END
