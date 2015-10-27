//
//  SKXmppContactCell.h
//  TestXMPPDesktop
//
//  Created by LeouW on 15/10/22.
//  Copyright © 2015年 CC. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 *SKCellType  Cell 样式
 */
//联系人和群组Cell样式
typedef NS_OPTIONS(NSInteger, SKContactCellType) {
    
    SKContactCellTypeNone,  //普通样式 default
    SKContactCellTypeGroup, //群组样式
    SKContactCellTypeContact,//联系人样式－点对点
    SKContactCellTypeMessage //带消息样式
} NS_ENUM_AVAILABLE(10_0, 7_0);


@interface SKXmppContactCell : UITableViewCell {
    
    @private
    UIView  *skContentBackgroundView;//内容区域的背景
}

/*
 *属性值
 */
@property (nonatomic, assign)SKContactCellType skCellType;//Cell类型 -- enum SKCellType

/*
 *自定义控件
 */
@property (nonatomic, strong)UILabel *titleLabel;//联系人名标签
@property (nonatomic, strong)UILabel *content1Label;//时间标签 在titleLabel右侧
@property (nonatomic, strong)UILabel *content2Label;//消息内容标签 最新消息

@end
