//
//  HBTools.h
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/11.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBChapter.h"

NS_ASSUME_NONNULL_BEGIN

#define dispatch_at_main_queue(callback) if (NSThread.currentThread.isMainThread) { callback; } else { dispatch_async(dispatch_get_main_queue(), callback);}

void HB_ShowStatusBarAnimated(BOOL show, BOOL animated);
void HB_ShowStatusBar(BOOL show);


@interface HBTools : NSObject

+ (NSString *)documentPath;
+ (NSString *)localBookPath;
+ (NSArray<NSString *> *)localBookPathList;

+ (void)moveBookToLocalBookPath;

+ (NSString *)novelTextFromLocalUrl:(NSURL *)url;

+ (NSArray<HBChapter *> *)chapterListFrom:(NSString *)novelText spaceRegex:(NSString *)regex;


@end

NS_ASSUME_NONNULL_END
