//
//  SKInputViewToolBar.h
//  TestXMPPDesktop
//
//  Created by LeouW on 15/10/26.
//  Copyright © 2015年 CC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKInputViewToolBar : UIView <UITextViewDelegate> {
    
    UIView *skContentView;//内容容器View
}

@property (nonatomic, strong)UIButton   *skFaceButton;//表情按钮
@property (nonatomic, strong)UITextView *skInputTextView;//输入文本框

@end
