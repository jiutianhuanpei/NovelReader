//
//  HBNetService.h
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/16.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, HBNetType) {
    HBNetType_GET,
    HBNetType_POST,
};

@interface HBNetService : NSObject

- (void)netType:(HBNetType)type url:(NSString *)url param:(NSDictionary * _Nullable)param complete:(void(^)(NSError * _Nullable error, NSDictionary * _Nullable result))complete;

@end

NS_ASSUME_NONNULL_END
