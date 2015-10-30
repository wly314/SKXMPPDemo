//
//  SKXmppMessageCell.m
//  TestXMPPDesktop
//
//  Created by LeouW on 15/10/30.
//  Copyright © 2015年 CC. All rights reserved.
//

#import "SKXmppMessageCell.h"

@implementation SKXmppMessageCell

@synthesize skMessageType = _skMessageType;
@synthesize skAvatarImageView = _skAvatarImageView;
@synthesize skPaopaoImageView = _skPaopaoImageView;

@synthesize skContentLabel = _skContentLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        skContentBackgroundView = [[UIView alloc] init];
        skContentBackgroundView.backgroundColor = [UIColor clearColor];
        [self addSubview:skContentBackgroundView];
        
        _skAvatarImageView = [[UIImageView alloc] init];
        [_skAvatarImageView setImage:[UIImage imageNamed:@"sk_shishengjiaoliu_xzb.png"]];
        _skAvatarImageView.layer.cornerRadius = 20.0f;
        [skContentBackgroundView addSubview:_skAvatarImageView];
        
        //聊天气泡要放置聊天内容的下面
        _skPaopaoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 0, self.bounds.size.width - (40+10)*2, 40)];
        [skContentBackgroundView addSubview:_skPaopaoImageView];
        
        //聊天内容
        _skContentLabel = [[UILabel alloc] init];
        _skContentLabel.backgroundColor = [UIColor grayColor];
        _skContentLabel.numberOfLines = 0;
        [_skContentLabel setFont:[UIFont systemFontOfSize:CONTENT_LABEL_FONT_SIZE]];
        [skContentBackgroundView addSubview:_skContentLabel];
        
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    skContentBackgroundView.frame = self.bounds;
    
    if (_skMessageType == SKMessageTypeReviced) {
        
        //1.头像
        _skAvatarImageView.frame = CGRectMake(10, 0, 40, 40);
        
        //2.聊天气泡泡
        /*
         * 设置泡泡不变形拉伸处理
         */
        //首先获得图片 聊天气泡图片
        UIImage *paopaoImage = [UIImage imageNamed:@"shishengjiaoliu6.png"];
        //拉伸的边界根据图片来处理－上左下右 这里用中心点向外扩展10
        CGFloat capInsetsW = paopaoImage.size.width/2;//水平
        CGFloat capInsetsH = paopaoImage.size.height/2;//竖直
        UIEdgeInsets insets = UIEdgeInsetsMake(capInsetsH - 10, capInsetsW - 10, capInsetsH + 10, capInsetsW + 10);
        // 指定为拉伸模式，伸缩后重新赋值
        paopaoImage = [paopaoImage resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        
        //首先计算文本高度
        CGRect contentRect = [SKXmppMessageCell contentRectOfString:_skContentLabel.attributedText];
        
//         CGSize optimalSize = [_skContentLabel optimumSize:YES];
        
        //消息内容比起泡背景宽高各小20 起泡小箭头宽度为10
        CGFloat originX = 10;//左右各10
        CGFloat arrowW = 10;//小箭头宽度为10
        
        //气泡小箭头宽度为15 泡泡的宽度 ＝ cell的宽度- (头像的距离*2)
        //起泡的高度 ＝ 计算文本高度 ＋ 文本与气泡边界的距离
        _skPaopaoImageView.frame = CGRectMake(50, 0, self.bounds.size.width - (40+10)*2, contentRect.size.height);
        _skPaopaoImageView.image = paopaoImage;
        
        _skContentLabel.frame = CGRectMake(_skPaopaoImageView.frame.origin.x+originX+arrowW, _skPaopaoImageView.frame.origin.y+originX, _skPaopaoImageView.bounds.size.width-originX*2-arrowW, _skPaopaoImageView.bounds.size.height-originX*2);
        
    }else if (_skMessageType == SKMessageTypeSend) {
        
        //1.头像
        _skAvatarImageView.frame = CGRectMake(self.bounds.size.width - (40+10), 0, 40, 40);
        
        //2.聊天气泡泡
        /*
         * 设置泡泡不变形拉伸处理
         */
        //首先获得图片 聊天气泡图片
        UIImage *paopaoImage = [UIImage imageNamed:@"shishengjiaoliu5.png"];
        //拉伸的边界根据图片来处理－上左下右 这里用中心点向外扩展10
        CGFloat capInsetsW = paopaoImage.size.width/2;//水平
        CGFloat capInsetsH = paopaoImage.size.height/2;//竖直
        UIEdgeInsets insets = UIEdgeInsetsMake(capInsetsH - 10, capInsetsW - 10, capInsetsH + 10, capInsetsW + 10);
        // 指定为拉伸模式，伸缩后重新赋值
        paopaoImage = [paopaoImage resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        
        //首先计算文本高度
        CGRect contentRect = [SKXmppMessageCell contentRectOfString:_skContentLabel.attributedText];
        
        //消息内容比起泡背景宽高各小20(就是上下左右各10) 起泡小箭头宽度为10
        CGFloat originX = 10;//上下左右各10
        CGFloat arrowW = 10;//小箭头宽度为10
        
        //气泡小箭头宽度为15 泡泡的宽度 ＝ cell的宽度- (头像的距离*2)
        //起泡的高度 ＝ 计算文本高度 ＋ 文本与气泡边界的距离
        _skPaopaoImageView.frame = CGRectMake(50, 0, self.bounds.size.width - (40+10)*2, contentRect.size.height);
        _skPaopaoImageView.image = paopaoImage;
        
        //内容的宽度 ＝ 泡泡的宽度 － 小箭头宽度 － 文本与气泡边界距离＊2（左右）
        _skContentLabel.frame = CGRectMake(_skPaopaoImageView.frame.origin.x+originX, _skPaopaoImageView.frame.origin.y+originX, _skPaopaoImageView.bounds.size.width-originX*2-arrowW, _skPaopaoImageView.bounds.size.height-originX*2);
    }
}

+ (CGRect)contentRectOfString:(NSAttributedString *)aString {
    
    NSLog(@"---=== +++  %f", aString.size.height) ;
    
   
    
    //此方法仅适用于改聊天计算高度
    //消息内容比起泡背景宽高各小20(就是上下左右各10) 起泡小箭头宽度为10
    CGFloat originX = 10;//上下左右各10
    CGFloat arrowW = 10;//小箭头宽度为10
    
    //cell的宽度
    CGFloat cellW = [UIScreen mainScreen].bounds.size.width;
    //头像距离（*2 两端都要减去）
    CGFloat avatarWRange = (40+10)*2;
    
    //起泡的宽度 ＝ cell的宽度 - 头像距离
//    CGRect sizeRect = [aString boundingRectWithSize:CGSizeMake((cellW - avatarWRange)-originX*2-arrowW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[[NSDictionary alloc] initWithObjectsAndKeys:[UIFont systemFontOfSize:CONTENT_LABEL_FONT_SIZE], NSFontAttributeName, nil] context:nil];
    CGSize size = CGSizeMake((cellW - avatarWRange)-originX*2-arrowW, CGFLOAT_MAX);
    CGRect sizeRect = [aString boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil];
    
    sizeRect = CGRectMake(sizeRect.origin.x, sizeRect.origin.y, sizeRect.size.width, sizeRect.size.height+originX*2);
    
    
//    NSTextStorage *textStorage = [[NSTextStorage alloc] init];
//    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
//    [textStorage addLayoutManager:layoutManager];
//    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:CGSizeMake(size.width, FLT_MAX)];
//    [textContainer setLineFragmentPadding:0.0];
//    [layoutManager addTextContainer:textContainer];
//    [textStorage setAttributedString:aString];
//    [layoutManager glyphRangeForTextContainer:textContainer];
//    CGRect frame = [layoutManager usedRectForTextContainer:textContainer];
//    NSLog(@"3:%@", NSStringFromCGRect(frame));
    
    return sizeRect;
}

@end
