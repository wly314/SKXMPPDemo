//
//  SKXMPPViewController.m
//  TestXMPPDesktop
//
//  Created by LeouW on 15/10/20.
//  Copyright © 2015年 CC. All rights reserved.
//

#import "SKXMPPViewController.h"

#import "SKXMPPXmlManager.h"
#import "SKXmppDataModel.h"
#import "SKCoreDataManager.h"

#import "SKXmppContactCell.h"
#import "SKXmppMessageViewController.h"

@interface SKXmppViewController ()<UITableViewDataSource, UITableViewDelegate> {
    
    UITableView                 *skTableView;
    NSMutableArray              *skGroupListArray;//群组列表数组
    
    XMPPStream                  *skXMPPStream;   
    BOOL                        isXmppConnected;//记录Xmpp连接状态 YES－已经连接／连接成功 NO－未连接／连接失败
}

@end

@implementation SKXmppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    JID 51327@murp-ymm2003/iphone_teacher_1.0.8
    SKXMPPUser *loginUser = [[SKXMPPUser alloc] init];
    loginUser.usernameString = @"39038";
    loginUser.userPasswordString = @"admin";
    
    SKXMPPServer *loginServer = [[SKXMPPServer alloc] init];
    loginServer.serverDomainString = @"murp-ymm2003";
    loginServer.serverResourceString = @"iphone_teacher_1.0.8";
    loginServer.serverString = @"221.226.93.2";
    loginServer.serverPort = 5222;
    
    SKXMPPLoginInfo *xmppLoginInfo = [[SKXMPPLoginInfo alloc] init];
    xmppLoginInfo.loginUser = loginUser;
    xmppLoginInfo.loginServer = loginServer;
    
    isXmppConnected = [[SKXMPPXmlManager singletonInstance] skXMPPConnectWithXMPPLoginInfo:xmppLoginInfo];
    if (!isXmppConnected) {
        
        UIAlertView *skAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"聊天服务器未连接" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [skAlertView show];
    }else {
        
    }
    
    skTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    skTableView.delegate = self;
    skTableView.dataSource = self;
    [self.view addSubview:skTableView];
    skTableView.tableFooterView = [[UIView alloc] init];
    
    skGroupListArray = [[NSMutableArray alloc] initWithCapacity:0];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    //注册通知－上线
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(skXmppOnlineNow:) name:SKXmppStateOnline object:nil];
    //注册通知－收到群组列表
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(skXmppReviceGroupList:) name:SKXmppStateReciveGroupList object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    //注销通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SKXmppStateOnline object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SKXmppStateReciveGroupList object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NSNotification 
//XMPP已经上线
- (void)skXmppOnlineNow:(NSNotification *)aNotification {
    
    //获取群组列表
    [SKXMPPXmlManager getGroupList];
}

//XMPP收到群组信息
- (void)skXmppReviceGroupList:(NSNotification *)aNotification {
    
    NSLog(@"%@",aNotification.userInfo[SK_GroupList]);
    
    NSArray *listArray = [[NSArray alloc] initWithArray:aNotification.userInfo[SK_GroupList]];
    
    
    if (listArray.count > 0) {
        
        //删除原来数据，插入新数据
        [SKCoreDataManager deleteAllDataOfEntityName:@"SKGroupList"];
        //插入数据库CoreData
        for (NSDictionary *room in listArray) {

            SKXMPPGroupList *groupListModel = [[SKXMPPGroupList alloc] init];

            groupListModel.groupListRoomId = [[room valueForKey:@"roomId"] integerValue];//房间id
            groupListModel.groupListRoomNameString = [room valueForKey:@"roomName"];//房间的名字
            groupListModel.groupListUsernameString = [room valueForKey:@"username"];//成员在房间中的名字
            groupListModel.groupListBtype = [[room valueForKey:@"btype"] integerValue];//群组类型
            groupListModel.groupListName = [room valueForKey:@"name"];//群组类型
            [SKCoreDataManager insertSKGroupListWithSKXMPPGroupListModel:groupListModel];
            
            if ([[room valueForKey:@"roomName"] isEqualToString:@"公共账号"]) {
                
                [skGroupListArray insertObject:groupListModel atIndex:0];
            }else {
                [skGroupListArray addObject:groupListModel];
            }
        }
    }
    
    if (skGroupListArray && skGroupListArray.count > 0) {
        
        [skTableView reloadData];
    }
    
}


#pragma mark -  UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return skGroupListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = [NSString stringWithFormat:@"Cell%ld", indexPath.row];
    SKXmppContactCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        
        cell = [[SKXmppContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    SKXMPPGroupList *groupListModel = [skGroupListArray objectAtIndex:indexPath.row];
    cell.skCellType = SKContactCellTypeGroup | SKContactCellTypeMessage;
    cell.titleLabel.text = groupListModel.groupListRoomNameString;
    cell.content1Label.text = @"5分钟前";
    cell.content2Label.text = @"李章：你傻啊";
    cell.imageView.image = [UIImage imageNamed:@"sk_shishengjiaoliu_jxb.png"];
    
    if ([groupListModel.groupListRoomNameString isEqualToString:@"公共账号"]) {
        
        cell.imageView.image = [UIImage imageNamed:@"sk_shishengjiaoliu_xtz.png"];
        cell.skCellType = SKContactCellTypeNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SKXMPPGroupList *groupListModel = [skGroupListArray objectAtIndex:indexPath.row];
    
    SKXmppMessageViewController *messageViewController = [[SKXmppMessageViewController alloc] init];
    messageViewController.navigationItem.title = groupListModel.groupListRoomNameString;
    [self.navigationController pushViewController:messageViewController animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
