//
//  HBTableString.h
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/17.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#ifndef HBTableString_h
#define HBTableString_h
#import <Foundation/Foundation.h>

#pragma mark - 网络表
NSString *NetBookListTable = @"NetBook";

NSString *HBBookName = @"name";
NSString *HBBookId = @"bookId";
NSString *HBBookAuthor = @"author";
NSString *HBBookCover = @"cover";

NSString *HBBookIntroduce = @"introduce";
NSString *HBBookStatus = @"status";
NSString *HBBookTime = @"time";
NSString *HBBookTag = @"tag";
NSString *HBBookUpdateTitle = @"updateTitle";


NSString *NetBookSaveTable = @"NetBookSaveTable";
NSString *HBChapterId = @"chapterId";
NSString *HBProgress = @"progress";

NSString *LocalBookSaveTable = @"LocalBookSaveTable";
NSString *HBChapterIndex = @"chapterIndex";



#pragma mark - 章节
NSString *HBChapterTitle = @"title";
//NSString *HBChapterText = @"text";


#endif /* HBTableString_h */
