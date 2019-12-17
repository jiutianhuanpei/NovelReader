//
//  HBNetBookDetail.h
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/16.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBNetBookIntroduce : NSObject

@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *cover;
@property (nonatomic, copy) NSString *introduce;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *time;

@end

@interface HBNetBookChapter : NSObject<YYModel>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *url;

@end

@interface HBNetBookDetail : NSObject<YYModel>

@property (nonatomic, strong) HBNetBookIntroduce *introduce;
@property (nonatomic, strong) NSArray<HBNetBookChapter *> *list;

@end

NS_ASSUME_NONNULL_END
