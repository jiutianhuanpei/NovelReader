//
//  HBNetSearchCell.m
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/16.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import "HBNetSearchCell.h"

@interface HBNetSearchCell ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *authorLbl;
@property (nonatomic, strong) UILabel *introduceLbl;
@property (nonatomic, strong) UILabel *updateLbl;

@end

@implementation HBNetSearchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self hb_addSubviews:@[self.imgView, self.nameLbl, self.authorLbl, self.introduceLbl, self.updateLbl]];
        
        __weak typeof(self) weakSelf = self;
        
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.centerY.mas_equalTo(weakSelf.mas_centerY);
            make.width.mas_equalTo(40);
            make.width.mas_equalTo(weakSelf.imgView.mas_height).multipliedBy(37. / 52.);
        }];
        
        [_nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.imgView.mas_right).offset(10);
            make.top.mas_equalTo(5);
            make.right.mas_equalTo(weakSelf.mas_right).offset(-10);
        }];
        
        [_authorLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.nameLbl.mas_bottom);
            make.left.mas_equalTo(weakSelf.imgView.mas_right).offset(10);
            make.right.mas_equalTo(weakSelf.mas_right).offset(-10);
        }];
        
        [_introduceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.imgView.mas_right).offset(10);
            make.top.mas_equalTo(weakSelf.authorLbl.mas_bottom);
            make.right.mas_equalTo(weakSelf.mas_right).offset(-10);
        }];
        [_updateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.imgView.mas_right).offset(10);
            make.top.mas_equalTo(weakSelf.introduceLbl.mas_bottom).offset(5);
            make.right.mas_equalTo(weakSelf.mas_right).offset(-10);
            make.bottom.mas_equalTo(weakSelf.mas_bottom).offset(-5);
        }];
    }
    return self;
}

- (void)setBook:(HBNetSearchBook *)book {
    _book = book;
    
    _introduceLbl.numberOfLines = _introduceMaxLines == 0 ? 2 : _introduceMaxLines;
    
    [_imgView sd_setImageWithURL:[NSURL URLWithString:book.cover]];
    _nameLbl.text = book.name;
    
    NSString *authStr = nil;
    if (book.author.length == 0 ) {
        authStr = book.tag;
    } else if (book.tag.length == 0) {
        authStr = book.author;
    } else {
        authStr = [NSString stringWithFormat:@"%@ | %@", book.author, book.tag];
    }
    
    _authorLbl.text = authStr;
    _introduceLbl.text = book.introduce;
    _updateLbl.text = book.updateChapterTitle;
}

#pragma mark - 属性
- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = UIImageView.new;
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.layer.borderWidth = 1/UIScreen.mainScreen.scale;
        _imgView.layer.borderColor = UIColor.grayColor.CGColor;
        _imgView.clipsToBounds = true;
    }
    return _imgView;
}

- (UILabel *)nameLbl {
    if (!_nameLbl) {
        _nameLbl = UILabel.new;
        _nameLbl.font = [UIFont boldSystemFontOfSize:17];
        _nameLbl.textColor = [UIColor colorWithHex:0x333333];
    }
    return _nameLbl;
}

- (UILabel *)authorLbl {
    if (!_authorLbl) {
        _authorLbl = UILabel.new;
        _authorLbl.font = [UIFont systemFontOfSize:11];
        _authorLbl.textColor = [UIColor colorWithHex:0x222222];
    }
    return _authorLbl;
}

- (UILabel *)introduceLbl {
    if (!_introduceLbl) {
        _introduceLbl = UILabel.new;
        _introduceLbl.font = [UIFont systemFontOfSize:11];
        _introduceLbl.textColor = [UIColor colorWithHex:0x222222];
        _introduceLbl.numberOfLines = 2;
    }
    return _introduceLbl;
}

- (UILabel *)updateLbl {
    if (!_updateLbl) {
        _updateLbl = UILabel.new;
        _updateLbl.font = [UIFont systemFontOfSize:11];
        _updateLbl.textColor = [UIColor colorWithHex:0x222333];
    }
    return _updateLbl;
}

@end
