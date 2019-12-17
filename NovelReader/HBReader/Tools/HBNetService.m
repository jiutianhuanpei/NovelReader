//
//  HBNetService.m
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/16.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import "HBNetService.h"



@implementation HBNetService


- (void)netType:(HBNetType)type url:(NSString *)url param:(NSDictionary *)param complete:(void (^)(NSError * _Nullable, NSDictionary * _Nullable))complete {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = type == HBNetType_GET ? @"GET" : @"POST";
    
    if (param.count > 0) {
        request.HTTPBody = [NSJSONSerialization dataWithJSONObject:param options:0 error:nil];
    }
    
    
    NSURLSessionDataTask *task = [NSURLSession.sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            !complete ?: complete(error, nil);
            return ;
        }
        
        NSError *er = nil;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&er];
        if (er) {
            !complete ?: complete(er, nil);
            return;
        }
        !complete ?: complete(nil, result);
        
    }];
    [task resume];
}

@end
