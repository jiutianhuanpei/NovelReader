//
//  HBNetBookManager.h
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/16.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBNetSearchBook.h"
#import "HBNetBookDetail.h"
#import "HBNetChapter.h"

NS_ASSUME_NONNULL_BEGIN

@interface HBNetManager : NSObject

+ (instancetype)sharedInstance;

- (void)searchBookWithName:(NSString *)bookName complete:(void(^)(NSError *_Nullable error, NSArray<HBNetSearchBook *> * _Nullable bookList))complete;

- (void)fetchNetBookDetailWithUrl:(NSString *)url complete:(void(^)(NSError * _Nullable error, HBNetBookDetail * _Nullable bookDetail))complete;

- (void)fetchNetBookContentWithUrl:(NSString *)url complete:(void(^)(NSError * _Nullable error, HBNetChapter * _Nullable chapter))complete;

@end

NS_ASSUME_NONNULL_END
