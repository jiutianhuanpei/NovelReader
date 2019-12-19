//
//  HBNetBookManager.h
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/16.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBNetBook.h"


NS_ASSUME_NONNULL_BEGIN

@interface HBNetManager : NSObject

+ (instancetype)sharedInstance;

- (void)searchBookWithName:(NSString *)bookName complete:(void(^)(NSError *_Nullable error, NSArray<HBNetBook *> * _Nullable bookList))complete;

- (void)updateNetBookChapterList:(HBNetBook *)book
                       complete:(void(^)(NSError * _Nullable error, HBNetBook * _Nullable bookDetail))complete;

- (void)fetchNetBookContentWithUrl:(NSString *)url complete:(void(^)(NSError * _Nullable error, HBChapter * _Nullable chapter))complete;

@end

NS_ASSUME_NONNULL_END
