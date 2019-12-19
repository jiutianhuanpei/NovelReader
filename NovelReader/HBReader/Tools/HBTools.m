//
//  HBTools.m
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/11.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import "HBTools.h"

void HB_ShowStatusBarAnimated(BOOL show, BOOL animated) {
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations" // 这部分是用到的过期api
    [UIApplication.sharedApplication setStatusBarHidden:!show withAnimation:animated ? UIStatusBarAnimationFade : UIStatusBarAnimationNone];
#pragma clang diagnostic pop
}

void HB_ShowStatusBar(BOOL show) {
    HB_ShowStatusBarAnimated(show, true);
}

@implementation HBTools

+ (NSString *)documentPath {
    NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).firstObject;
    return document;
}

+ (NSString *)localBookPath {
    
    NSString *document = [self documentPath];
    
    NSString *path = [document stringByAppendingPathComponent:@"本地图书"];
    
    BOOL isDir = false;
    BOOL hadFile = [NSFileManager.defaultManager fileExistsAtPath:path isDirectory:&isDir];
        
    if (hadFile) {
        if (!isDir) {
            [NSFileManager.defaultManager removeItemAtPath:path error:nil];
            [NSFileManager.defaultManager createDirectoryAtPath:path withIntermediateDirectories:true attributes:nil error:nil];
        }
    } else {
        [NSFileManager.defaultManager createDirectoryAtPath:path withIntermediateDirectories:true attributes:nil error:nil];
    }
    return path;
}

+ (NSArray<NSString *> *)localBookPathList {
    
    [self moveBookToLocalBookPath];
    NSString *dirPath = [self localBookPath];
    
    NSArray *names = [NSFileManager.defaultManager contentsOfDirectoryAtPath:dirPath error:nil];
    
    NSMutableArray *array = @[].mutableCopy;
    
    for (NSString *name in names) {
        
        if ([name hasPrefix:@"."]) {
            continue;
        }
        
        NSString *path = [dirPath stringByAppendingPathComponent:name];
        [array addObject:path];
    }
    return array;
}

+ (void)moveBookToLocalBookPath {
    
    NSArray *files = [NSFileManager.defaultManager contentsOfDirectoryAtPath:HBTools.documentPath error:nil];
    
    for (NSString *name in files) {
        
        NSString *path = [HBTools.documentPath stringByAppendingPathComponent:name];
        
        BOOL isDir = false;
        [NSFileManager.defaultManager fileExistsAtPath:path isDirectory:&isDir];
        
        if (!isDir) {
            //文件
            NSString *toPath = [HBTools.localBookPath stringByAppendingPathComponent:name];
            [NSFileManager.defaultManager moveItemAtPath:path toPath:toPath error:nil];
        }
        
    }
    
}


+ (NSString *)novelTextFromLocalUrl:(NSURL *)url {
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    //取一段数据就好，否则解析 Encoding 时太慢
    data = [data subdataWithRange:NSMakeRange(0, MIN(100, data.length))];
    
    NSStringEncoding coding = [NSString stringEncodingForData:data encodingOptions:nil convertedString:nil usedLossyConversion:nil];
    
    NSString *text = [NSString stringWithContentsOfURL:url encoding:coding error:nil];
    return text;
}

+ (NSArray<HBChapter *> *)chapterListFrom:(NSString *)novelText spaceRegex:(NSString *)regex {
    
    if (novelText.length == 0 || regex.length == 0) {
        return nil;
    }
    
    NSRange range = [novelText rangeOfString:regex options:NSRegularExpressionSearch];
    
    if (range.location == NSNotFound) {
        //没找到
        HBChapter *chapter = HBChapter.new;
        
        NSString *title = [novelText componentsSeparatedByString:@"\n"].firstObject;
        
        if (title.length == 0) {
            title = [novelText substringToIndex:MIN(10, novelText.length)];
        }
        
        title = [title stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
        
        chapter.title = title;
        chapter.chapterId = title;
        chapter.text = novelText;
        
        return @[chapter];
    }
    
    
    NSMutableArray *resultArray = @[].mutableCopy;
    
    
    NSRegularExpression *expression = [[NSRegularExpression alloc] initWithPattern:regex options:NSRegularExpressionCaseInsensitive error:nil];
    
    __block NSTextCheckingResult *lastResult = nil;
    
    [expression enumerateMatchesInString:novelText options:0 range:NSMakeRange(0, novelText.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
       
        
        if (lastResult != nil) {

            NSRange chapterRange = NSMakeRange(lastResult.range.location, result.range.location - lastResult.range.location);
            NSString *chapterText = [novelText substringWithRange:chapterRange];
            
            if (chapterText.length > 0) {
                NSString *title = [novelText substringWithRange:lastResult.range];
                title = [title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                HBChapter *chapter = HBChapter.new;
                chapter.title = title;
                chapter.text = chapterText;
                
                [resultArray addObject:chapter];
            }
        }
        lastResult = result;
    }];
    
    //最后一章
    NSRange chapterRange = NSMakeRange(lastResult.range.location, novelText.length - lastResult.range.location);
    NSString *chapterText = [novelText substringWithRange:chapterRange];
    
    if (chapterText.length > 0) {
        NSString *title = [novelText substringWithRange:lastResult.range];
        HBChapter *chapter = HBChapter.new;
        chapter.title = title;
        chapter.text = chapterText;
        
        [resultArray addObject:chapter];
    }
    
    return resultArray;
}


@end
