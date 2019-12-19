//
//  HBDBManager.h
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/17.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBNetBook.h"
#import "HBShowData.h"

NS_ASSUME_NONNULL_BEGIN

@interface HBDBManager : NSObject

+ (instancetype)sharedInstance;

- (BOOL)addToBookcaseWithNetBook:(HBNetBook *)book;

- (NSArray<HBNetBook *> *)getBooksWithName:(NSString *)bookName;
- (NSArray<HBNetBook *> *)getBooksWithUrl:(NSString *)bookUrl;
- (NSArray<HBNetBook *> *)getAllBooks;

- (BOOL)updateNetBook:(HBNetBook *)book;
- (BOOL)deleteNetBook:(HBNetBook *)book;


- (void)saveBookmark:(HBShowData *)showData;
- (void)getBookmarkFromBookId:(NSString *)bookId complete:(void(^)(NSString *bookId, NSString *chapterId, NSInteger index, NSString *bookName))complete;

- (void)getBookmarkFromLocalBook:(HBLocalBook *)book
                        complete:(void(^)(NSInteger chapterIndex, NSInteger progress))complete;

@end

NS_ASSUME_NONNULL_END
