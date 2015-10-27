//
//  SKInputViewToolBar.m
//  TestXMPPDesktop
//
//  Created by LeouW on 15/10/26.
//  Copyright © 2015年 CC. All rights reserved.
//

#import "SKInputViewToolBar.h"

@implementation SKInputViewToolBar

@synthesize skFaceButton  = _skFaceButton;
@synthesize skInputTextView = _skInputTextView;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        skContentView = [[UIView alloc] initWithFrame:frame];
        [self addSubview:skContentView];
        
        _skFaceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_skFaceButton];
        
        _skInputTextView = [[UITextView alloc] init];
        _skInputTextView.layer.cornerRadius = 2.5f;
        _skInputTextView.font = [UIFont systemFontOfSize:16.0f];
        _skInputTextView.showsHorizontalScrollIndicator = NO;
        _skInputTextView.showsVerticalScrollIndicator = NO;
        _skInputTextView.delegate = self;
        _skInputTextView.returnKeyType = UIReturnKeySend;
        [self addSubview:_skInputTextView];
    }
    
    return self;
}

- (void)layoutSubviews {
    
    skContentView.backgroundColor = self.backgroundColor;
    skContentView.frame = self.bounds;
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        
        //点击return键 失去焦点
        [textView resignFirstResponder];
        
        return NO;
    }
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    
    return YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
