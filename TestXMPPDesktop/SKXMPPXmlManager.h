//
//  SKXMPPXmlManager.h
//  TestXMPPDesktop
//
//  Created by LeouW on 15/10/20.
//  Copyright © 2015年 CC. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XMPPFramework.h"

@class SKXMPPLoginInfo;

//XMPP相关的通知操作，如：SKXmppStateOnline xmpp验证成功上线之后会post该通知，需要获取上线状态的可以注册该通知
#define SKXmppStateOnline               @"SKXmppStateOnline"//Xmpp用户上线
#define SKXmppStateOffline              @"SKXmppStateOffline"//Xmpp用户下线
/*
 *发送SKXmppStateReciveGroupList 通知的时候，会将获取的列表值解析成数组并以字典的形式传过去，字典的key是@"SK_GroupList"
 */
#define SKXmppStateReciveContactList    @"SKXmppStateReciveContactList"//Xmpp用户收到联系人列表
/*
 *发送SKXmppStateReciveGroupList 通知的时候，会将获取的列表值解析成数组并以字典的形式传过去，字典的key是@"SK_GroupList"
 */
#define SKXmppStateReciveGroupList      @"SKXmppStateReciveGroupList"//Xmpp用户收到群组列表

//发送SKXmppStateReciveGroupList 通知的时候，会将获取的列表值解析成数组并以字典的形式传过去，字典的key是@"SK_GroupList"
#define SK_GroupList   @"SK_GroupList" 

@interface SKXMPPXmlManager : NSObject

+ (SKXMPPXmlManager *)singletonInstance;


#pragma mark - XMPP
/*
 *
 */

/*
expansion1  平台回执信息
expansion2  注销请求
expansion3  个人消息回执
expansion4  群组消息
expansion5  离线消息
expansion6  群组列表
expansion7  按照房间号和消息Id获取消息
expansion8  在房间，不在聊天室获取的消息
expansion9  ID不存在的消息
 */

//xmppStream所有XMPP活动的基础
@property (nonatomic, readonly, strong)XMPPStream *skXmppStream;

//xmpp登录的相关信息－ 包含地址 端口 登录名 密码等
@property (nonatomic, readonly, strong)SKXMPPLoginInfo *skXmppLoginInfo;


//连接XMPP
- (BOOL)skXMPPConnectWithXMPPLoginInfo:(SKXMPPLoginInfo *)skXmppLoginInfo;
//去获取群组列表
+ (void)getGroupList;
//收到群组列表
+ (void)receiveGroupList:(XMPPMessage*)msg;
@end
