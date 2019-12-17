//
//  HBTopView.m
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/12.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import "HBTopView.h"
#import "HBConfigManager.h"

@interface HBTopView ()

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *pageLbl;

@end

@implementation HBTopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = UIColor.redColor;
        
        [self addSubview:self.titleLbl];
        [self addSubview:self.pageLbl];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_titleLbl, _pageLbl);
        NSDictionary *metrics = @{@"b" : @3};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_titleLbl]-(>=0)-[_pageLbl]-|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_titleLbl]-(b)-|" options:0 metrics:metrics views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_pageLbl]-(b)-|" options:0 metrics:metrics views:views]];
        
    }
    return self;
}

- (void)configWithTitle:(NSString *)title pageStr:(NSString *)pageStr {
    
    NSMutableDictionary *att = HBConfigManager.sharedInstance.attributeDic.mutableCopy;
    att[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    att[NSForegroundColorAttributeName] = UIColor.darkTextColor;
    
    NSAttributedString *titleAttStr = [[NSAttributedString alloc] initWithString:title ?: @"" attributes:att];
    NSAttributedString *pageAttStr = [[NSAttributedString alloc] initWithString:pageStr ?: @"" attributes:att];

    _titleLbl.attributedText = titleAttStr;
    _pageLbl.attributedText = pageAttStr;
}

#pragma mark - getter
- (UILabel *)titleLbl {
    if (!_titleLbl) {
        _titleLbl = UILabel.new;
        _titleLbl.translatesAutoresizingMaskIntoConstraints = false;
        _titleLbl.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLbl;
}

- (UILabel *)pageLbl {
    if (!_pageLbl) {
        _pageLbl = UILabel.new;
        _pageLbl.translatesAutoresizingMaskIntoConstraints = false;
        _pageLbl.textAlignment = NSTextAlignmentRight;
    }
    return _pageLbl;
}

@end
