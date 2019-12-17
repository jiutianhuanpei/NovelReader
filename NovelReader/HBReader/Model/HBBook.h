//
//  HBBook.h
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/12.
//  Copyright © 2019 沈红榜. All rights reserved.
//

//  书

#import <Foundation/Foundation.h>
#import "HBChapter.h"

NS_ASSUME_NONNULL_BEGIN

@interface HBBook : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *coverUrlStr;

@property (nonatomic, copy) NSArray<HBChapter *> *chapterList;
@property (nonatomic, copy, readonly) NSArray<NSString *> *catalogList;

@end


NS_ASSUME_NONNULL_END
