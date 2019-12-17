//
//  HBBookProtocol.h
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/16.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBShowData.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HBBookProtocol <NSObject>

- (NSUInteger)pageNumAtChapter:(NSUInteger)chapterIndex;

- (HBShowData *)showDataInChapter:(NSUInteger)chapterIndex page:(NSUInteger)pageIndex;
- (HBShowData *)showDataBefor:(HBShowData *)showData;
- (HBShowData *)showDataAfter:(HBShowData *)showData;


/// 解析显示数据
/// @param chapterIndex 第几章节
/// @param complete 本章解析完毕
- (void)parsingShowDataAtChapterAtIndex:(NSUInteger)chapterIndex
                               complete:(dispatch_block_t _Nullable)complete;


@end

NS_ASSUME_NONNULL_END
