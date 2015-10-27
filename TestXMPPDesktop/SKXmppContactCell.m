//
//  SKXmppContactCell.m
//  TestXMPPDesktop
//
//  Created by LeouW on 15/10/22.
//  Copyright © 2015年 CC. All rights reserved.
//

#import "SKXmppContactCell.h"

@implementation SKXmppContactCell

@synthesize skCellType = _skCellType;

@synthesize titleLabel    = _titleLabel;
@synthesize content1Label = _content1Label;
@synthesize content2Label = _content2Label;

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        skContentBackgroundView = [[UIView alloc] init];
        skContentBackgroundView.backgroundColor = [UIColor whiteColor];
        [self addSubview:skContentBackgroundView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [skContentBackgroundView addSubview:_titleLabel];
        
        _content1Label = [[UILabel alloc] init];
        _content1Label.backgroundColor = [UIColor clearColor];
        _content1Label.font = [UIFont systemFontOfSize:12.0f];
        _content1Label.textAlignment = NSTextAlignmentCenter;
        [skContentBackgroundView addSubview:_content1Label];
        
        _content2Label = [[UILabel alloc] init];
        _content2Label.backgroundColor = [UIColor clearColor];
        _content2Label.font = [UIFont systemFontOfSize:14.0f];
        [skContentBackgroundView addSubview:_content2Label];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    skContentBackgroundView.frame = CGRectMake(self.imageView.bounds.size.width+self.imageView.frame.origin.x+15, 0, self.bounds.size.width-(self.imageView.bounds.size.width+self.imageView.frame.origin.x+15), self.bounds.size.height);
    
    if (_skCellType == SKContactCellTypeNone) {
        
        _titleLabel.frame = CGRectMake(0, 0, skContentBackgroundView.bounds.size.width, skContentBackgroundView.bounds.size.height);
        
    }else if (_skCellType == SKContactCellTypeContact) {
        
        _titleLabel.frame = CGRectMake(0, 0, skContentBackgroundView.bounds.size.width, skContentBackgroundView.bounds.size.height);
        
    }else if (_skCellType == SKContactCellTypeGroup) {
        
        _titleLabel.frame = CGRectMake(0, 0, skContentBackgroundView.bounds.size.width, skContentBackgroundView.bounds.size.height);
        
    }else if (_skCellType == (SKContactCellTypeContact | SKContactCellTypeMessage)) {
        
        _titleLabel.frame = CGRectMake(0, 0, skContentBackgroundView.bounds.size.width/4*3, skContentBackgroundView.bounds.size.height/2);
        _content1Label.frame = CGRectMake(skContentBackgroundView.bounds.size.width/4*3, 0, skContentBackgroundView.bounds.size.width/4*1, skContentBackgroundView.bounds.size.height/2);
        _content2Label.frame = CGRectMake(0, skContentBackgroundView.bounds.size.height/2, skContentBackgroundView.bounds.size.width, skContentBackgroundView.bounds.size.height/2);
        
    }else if (_skCellType == (SKContactCellTypeGroup | SKContactCellTypeMessage)) {
        _titleLabel.frame = CGRectMake(0, 0, skContentBackgroundView.bounds.size.width/4*3, skContentBackgroundView.bounds.size.height);
        _content1Label.frame = CGRectMake(skContentBackgroundView.bounds.size.width/4*3, 0, skContentBackgroundView.bounds.size.width/4*1, skContentBackgroundView.bounds.size.height/2);
        _content2Label.frame = CGRectMake(0, skContentBackgroundView.bounds.size.height/2, skContentBackgroundView.bounds.size.width, skContentBackgroundView.bounds.size.height/2);
        
    }else if (_skCellType == SKContactCellTypeMessage) {
        
        _titleLabel.frame = CGRectMake(0, 0, skContentBackgroundView.bounds.size.width/4*3, skContentBackgroundView.bounds.size.height);
        _content1Label.frame = CGRectMake(skContentBackgroundView.bounds.size.width/4*3, 0, skContentBackgroundView.bounds.size.width/4*1, skContentBackgroundView.bounds.size.height/2);
        _content2Label.frame = CGRectMake(0, skContentBackgroundView.bounds.size.height/2, skContentBackgroundView.bounds.size.width, skContentBackgroundView.bounds.size.height/2);
    }
}

@end
