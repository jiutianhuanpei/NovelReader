//
//  HBNetBookItem.m
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/17.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import "HBNetBookItem.h"

@interface HBNetBookItem ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *nameLbl;

@end

@implementation HBNetBookItem

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self hb_addSubviews:@[self.imgView, self.nameLbl]];
        
        __weak typeof(self) weakSelf = self;
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
        }];
        
        [_nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.imgView.mas_bottom).offset(5);
            make.left.bottom.right.mas_equalTo(0);
            make.height.mas_equalTo(15);
        }];
        
    }
    return self;
}

- (void)setBook:(HBNetBook *)book {
    _book = book;
    
    [_imgView sd_setImageWithURL:[NSURL URLWithString:book.cover ?: @""]];
    _nameLbl.text = book.name;
}

#pragma mark - getter
- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = UIImageView.new;
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.clipsToBounds = true;
    }
    return _imgView;
}

- (UILabel *)nameLbl {
    if (!_nameLbl) {
        _nameLbl = UILabel.new;
        _nameLbl.font = [UIFont systemFontOfSize:13];
        _nameLbl.adjustsFontSizeToFitWidth = true;
        _nameLbl.textColor = [UIColor colorWithHex:0x333333];
        _nameLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLbl;
}


@end
