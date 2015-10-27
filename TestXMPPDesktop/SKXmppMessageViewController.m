//
//  SKXmppMessageViewController.m
//  TestXMPPDesktop
//
//  Created by LeouW on 15/10/23.
//  Copyright © 2015年 CC. All rights reserved.
//

#import "SKXmppMessageViewController.h"

#import "SKInputViewToolBar.h"

@interface MMTextAttachment : NSTextAttachment {
    
}

@end

@implementation MMTextAttachment

//图片大小与文字保持一致
- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex NS_AVAILABLE_IOS(7_0) {
    
    return CGRectMake( 0 , 0 , lineFrag.size.height , lineFrag.size.height );
}

@end

@interface SKXmppMessageViewController ()<UITextViewDelegate, UITableViewDataSource, UITableViewDelegate> {
    
    UITextView          *skTextView;//输入文本框 《＝ skToolBar.skInputToolBar
    SKInputViewToolBar  *skToolBar;//键盘ToolBar
}

@end

@implementation SKXmppMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    //自定义navigationItem title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.font = [UIFont systemFontOfSize:13.0f];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = self.navigationItem.title;
    self.navigationItem.titleView = titleLabel;
    
    [self initToolBarItem2];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    //显示Toolbar
//    [self.navigationController setToolbarHidden:NO animated:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    //隐藏Toolbar
//    [self.navigationController setToolbarHidden:YES animated:NO];
    
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillShowNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillHideNotification];
}

- (void)initToolBarItem2 {
    
    SKInputViewToolBar *skInputToolBar = [[SKInputViewToolBar alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-45, [UIScreen mainScreen].bounds.size.width, 45)];
    skInputToolBar.backgroundColor = [UIColor grayColor];
    [self.view addSubview:skInputToolBar];
    
    skToolBar = skInputToolBar;
    
    skInputToolBar.skFaceButton.frame = CGRectMake(5, 10, 25, 25);
    [skInputToolBar.skFaceButton setImage:[UIImage imageNamed:@"emotion_face_128px_1179571_easyicon.net.png"] forState:UIControlStateNormal];
    
    skInputToolBar.skInputTextView.frame = CGRectMake(35, 5, [UIScreen mainScreen].bounds.size.width - 35 - 10, 35);
    skTextView = skInputToolBar.skInputTextView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSMutableAttributedString * string = [[ NSMutableAttributedString alloc ] initWithString:@"123456789101112计算"  attributes:nil ] ;
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0] range:NSMakeRange(0,string.length-1)];
    
    MMTextAttachment * textAttachment = [[ MMTextAttachment alloc ] initWithData:nil ofType:nil ] ;
    UIImage * smileImage = [ UIImage imageNamed:@"a.jpg" ]  ;  //my emoticon image named a.jpg
    textAttachment.image = smileImage ;
    
    NSAttributedString * textAttachmentString = [ NSAttributedString attributedStringWithAttachment:textAttachment ] ;
    [ string insertAttributedString:textAttachmentString atIndex:6 ] ;
    
    cell.textLabel.attributedText = string ;
    
    return cell;
}

#pragma mark - UIKeyboardNotification
- (void)keyboardWillShow:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    //获取键盘大小
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    //获取动画路径
    UIViewAnimationCurve animationCurve;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    //获取动画持续时间
    NSTimeInterval animationDuration;
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    //获取键盘大小
    CGRect keyboardFrame;
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    
    [UIView animateWithDuration:animationDuration animations:^{
        
        skToolBar.center = CGPointMake(skToolBar.bounds.size.width/2, [UIScreen mainScreen].bounds.size.height - (keyboardFrame.size.height + skToolBar.bounds.size.height/2));
        
    } completion:^(BOOL finished) {
        
        
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    
    //获取动画持续时间
    NSTimeInterval animationDuration;
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    
    //执行动画
    [UIView animateWithDuration:animationDuration animations:^{
        
        skToolBar.center = CGPointMake(skToolBar.bounds.size.width/2, [UIScreen mainScreen].bounds.size.height - (skToolBar.bounds.size.height/2));
        
    } completion:^(BOOL finished) {
        
        
    }];
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
