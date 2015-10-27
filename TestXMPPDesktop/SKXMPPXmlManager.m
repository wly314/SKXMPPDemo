//
//  SKXMPPXmlManager.m
//  TestXMPPDesktop
//
//  Created by LeouW on 15/10/20.
//  Copyright © 2015年 CC. All rights reserved.
//

#import "SKXMPPXmlManager.h"

#import "XMPPFramework.h"
#import "SKXmppDataModel.h"
#import "SKCoreDataManager.h"

static SKXMPPXmlManager * _singletonInstance = nil;

@implementation SKXMPPXmlManager

@synthesize skXmppStream = _skXmppStream;

@synthesize skXmppLoginInfo = _skXmppLoginInfo;

+ (SKXMPPXmlManager *)singletonInstance {
    
    @synchronized([SKXMPPXmlManager class]) {
        
        if (_singletonInstance == nil) {
            //单例
            _singletonInstance = [[self alloc] init];
        }
        
        return _singletonInstance;
    }
    return nil;
}

+ (id)alloc {
    
    @synchronized([SKXMPPXmlManager class]) {
        
        NSAssert(_singletonInstance == nil, @"Attempted to allocate a second instance of a singleton.");
        _singletonInstance = [super alloc];
        
        return _singletonInstance;
    }
    
    return nil;
}

- (id)init {
    
    if((self = [super init])) {
        
        
    }
    
    return self;
}

#pragma mark - XMPPXML

#pragma mark XMPP Connect/disconnect
- (BOOL)skXMPPConnectWithXMPPLoginInfo:(SKXMPPLoginInfo *)skXmppLoginInfo {
    
    _skXmppLoginInfo = skXmppLoginInfo;
    
    //Setup the XMPP stream
    if(![self skSetupStreamWithXMPPLoginInfo:skXmppLoginInfo]) {
        
        return NO;
    }
    
    //判断Stream状态
    if (![_skXmppStream isDisconnected]) {
        
        return YES;
    }
    
    //XMPP的地址叫做JabberID（简写为JID），它用来标示XMPP网络中的各个XMPP实体。JID由三部分组成：domain，node identifier和resource。JID中domain是必不可少的部分。注意：domain和user部分是不分大小写的，但是resource区分大小写。
    //JID 通过umicd拼接XMPP主机名和resource信息 -如："51327@murp-ymm2003/iphone_teacher_1.0.8"
    
    NSError *error = nil;
    //连接XMPP服务器,并设置设置10S的超时时间
    if (![_skXmppStream connectWithTimeout:10.0 error:&error]) {
        
        return NO;
    }
    
    return YES;
}

- (void)skXMPPDisconnect {
    
    [self goOffline];
    [_skXmppStream disconnect];
}

//发送在线状态
-(void)goOnline{
    
    XMPPPresence *presence = [XMPPPresence presence];
    [_skXmppStream sendElement:presence];
    
}

//发送下线状态
-(void)goOffline{
    
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [_skXmppStream sendElement:presence];
    
}

#pragma mark XMPP Private Method
- (BOOL)skSetupStreamWithXMPPLoginInfo:(SKXMPPLoginInfo *)skXmppLoginInfo {
    
    if(_skXmppStream != nil) {
        
        _skXmppStream = nil;
    }
    NSAssert(_skXmppStream == nil, @"Method setupStream invoked multiple times");
    
    //初始化XMPPStream
    _skXmppStream = [[XMPPStream alloc] init];
    [_skXmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    SKXMPPUser   *xmppUser   = skXmppLoginInfo.loginUser;
    NSString *userStr = xmppUser.usernameString;//用户
    
    SKXMPPServer *xmppServer = skXmppLoginInfo.loginServer;
    NSString *domainStr = xmppServer.serverDomainString;//XMPP主机
    NSString *resourceStr = xmppServer.serverResourceString;//resource
    NSString *serverStr = xmppServer.serverString;//服务器地址
    NSInteger serverPortStr = xmppServer.serverPort;//服务器端口
    
    //当userStr和passStr任何一个不存在时候，将无法连接XMPP服务器
    if (!userStr || [userStr isEqualToString:@""]) {
        
        return NO;
    }
    //XMPP的地址叫做JabberID（简写为JID），它用来标示XMPP网络中的各个XMPP实体。JID由三部分组成：domain，node identifier和resource。JID中domain是必不可少的部分。注意：domain和user部分是不分大小写的，但是resource区分大小写。
    
    //JID 通过umicd拼接XMPP主机名和resource信息 -如："51327@murp-ymm2003/iphone_teacher_1.0.8"
    XMPPJID *jid = [XMPPJID jidWithUser:userStr domain:domainStr resource:resourceStr];
    //设置用户
    [_skXmppStream setMyJID:jid];
    //设置服务器
    [_skXmppStream setHostName:serverStr];
    //设置服务器端口
    [_skXmppStream setHostPort:serverPortStr];
    
    return YES;
}

- (void)teardownStream {
    
    
}

#pragma mark XMPP XMPPStreamDelegate
//连接服务器
- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    
    NSError *error = nil;
    
    SKXMPPUser *xmppUser   = _skXmppLoginInfo.loginUser;
    NSString   *passwordString = xmppUser.userPasswordString;//密码 密码将会在连接服务器之后在代理方法中验证
    //验证密码
    [_skXmppStream authenticateWithPassword:passwordString error:&error];
}

//验证通过 发送上线
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    
    //设置已经上线 告诉服务器上线
    [self goOnline];
    //发送上线通知，可以继续其他操作，如获取群组／联系人
    [[NSNotificationCenter defaultCenter] postNotificationName:SKXmppStateOnline object:nil];
}

//收到消息
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
    //收到群组消息
    [SKXMPPXmlManager receiveGroupList:message];
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
//    [XMPPXmlManager receiveGroupMember:iq];
    return NO;
}

//收到好友状态
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence {
    
    //取得好友状态
    NSString *presenceType = [presence type]; //online/offline
    //当前用户
    NSString *userStr = [[sender myJID] user];
    //在线用户
    NSString *presenceFromUser = [[presence from] user];
    
    if (![presenceFromUser isEqualToString:userStr]) {
        
        //在线状态
        if ([presenceType isEqualToString:@"available"]) {
            
            
        }else if ([presenceType isEqualToString:@"unavailable"]) {
            
            
        }
    }
}

#pragma mark - XMPPMessage - Send
//获取群组列表
+ (void)getGroupList {
    
    XMPPMessage *message = [XMPPMessage messageWithType:@"expansion6"];
    
    [[[self singletonInstance] skXmppStream] sendElement:message];
}

#pragma mark - XMPPMessage - Receive
//收到群组列表
+ (void)receiveGroupList:(XMPPMessage*)msg {
    
    NSString *bodyStr = [[msg elementForName:@"body"]stringValue];
    NSArray *rooms = [NSJSONSerialization JSONObjectWithData:[bodyStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
    NSDictionary *dicts = [[NSDictionary alloc] initWithObjectsAndKeys:rooms, SK_GroupList, nil];
    
    //接收到消息发送通知，将获得数据传过去，可以继续其他操作，
    [[NSNotificationCenter defaultCenter] postNotificationName:SKXmppStateReciveGroupList object:nil userInfo:dicts];

}

@end
