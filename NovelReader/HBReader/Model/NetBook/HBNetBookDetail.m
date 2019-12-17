//
//  HBNetBookDetail.m
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/16.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import "HBNetBookDetail.h"

@implementation HBNetBookIntroduce

@end

@implementation HBNetBookChapter

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{
        @"name" : @"num"
    };
}

@end

@implementation HBNetBookDetail

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{
        @"introduce" : @"data"
    };
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
        @"list" : HBNetBookChapter.class
    };
}

@end
