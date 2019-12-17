//
//  HBReadView.m
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/11.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import "HBReadView.h"

@interface HBReadView ()

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGes;

@end

@implementation HBReadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.textView];
        
        _textView.translatesAutoresizingMaskIntoConstraints = false;
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_textView);
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_textView]|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_textView]|" options:0 metrics:nil views:views]];
    }
    return self;
}

- (void)setText:(NSAttributedString *)text {
    _text = text;
    _textView.attributedText = text;
}

- (void)didTap:(UITapGestureRecognizer *)tap {
    
    if ([_delegate respondsToSelector:@selector(didTapReadView:atPoint:)]) {
        CGPoint point = [tap locationInView:self];
        [_delegate didTapReadView:self atPoint:point];
    }
}

#pragma mark - setter
- (void)setGestureEnable:(BOOL)gestureEnable {
    _gestureEnable = gestureEnable;
    _tapGes.enabled = gestureEnable;
}

#pragma mark - getter
- (UITextView *)textView {
    if (!_textView) {
        _textView = UITextView.new;
        _textView.backgroundColor = UIColor.clearColor;
        _textView.editable = false;
        if (@available(iOS 11.0, *)) {
            _textView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
//        _textView.scrollEnabled = false;

        //禁用 UIMenu
        for (UIGestureRecognizer *ges in _textView.gestureRecognizers) {
            
            if ([ges isKindOfClass:NSClassFromString(@"UILongPressGestureRecognizer")] ||
                [ges isKindOfClass:NSClassFromString(@"_UITextSelectionForceGesture")] ||
                [ges isKindOfClass:NSClassFromString(@"UITapAndAHalfRecognizer")]) {
                ges.enabled = false;
            } else if ([ges isKindOfClass:NSClassFromString(@"UITapGestureRecognizer")]) {
                UITapGestureRecognizer *tap = (UITapGestureRecognizer *)ges;
                if (tap.numberOfTapsRequired > 1) {
                    ges.enabled = false;
                }
            }            
        }

        _tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
        _gestureEnable = true;
        [_textView addGestureRecognizer:_tapGes];
    }
    return _textView;
}

@end
