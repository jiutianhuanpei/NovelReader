//
//  HBShowPage.m
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/12.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import "HBShowData.h"

@implementation HBShowData

- (void)setBook:(HBLocalBook *)book {
    _book = book;
    _localBook = true;
}

- (void)setNetBook:(HBNetBook *)netBook {
    _netBook = netBook;
    _localBook = false;
}

@end
