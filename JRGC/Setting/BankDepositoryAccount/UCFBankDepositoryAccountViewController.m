//
//  UCFBankDepositoryAccountViewController.m
//  JRGC
//
//  Created by admin on 16/8/9.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFBankDepositoryAccountViewController.h"
#import "NZLabel.h"
#import "FullWebViewController.h"
#import "UCFOldUserGuideViewController.h"
@interface UCFBankDepositoryAccountViewController ()
@property (weak, nonatomic) IBOutlet UIView *whiteBaseView;
@property (weak, nonatomic) IBOutlet UILabel *bottomLab;
@property (weak, nonatomic) IBOutlet NZLabel *registLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *whiteBaseHeight;
@end

@implementation UCFBankDepositoryAccountViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _whiteBaseHeight.constant = CGRectGetMaxY(_bottomLab.frame) + 15;
}

- (void)viewDidAppear:(BOOL)animated
{
    [Common addLineViewColor:UIColorWithRGB(0xd8d8d8) With:_whiteBaseView isTop:YES];
    [Common addLineViewColor:UIColorWithRGB(0xd8d8d8) With:_whiteBaseView isTop:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
        //请求数据
}
- (void)initUI
{
    [self addLeftButton];
    baseTitleLabel.text = @"确认授权";
    __weak typeof(self) weakSelf = self;
    _registLabel.userInteractionEnabled = YES;
    [_registLabel addLinkString:@"《注册协议》" block:^(ZBLinkLabelModel *linkModel) {
        [weakSelf showHeTong:linkModel];
    }];
    [_registLabel setFontColor:UIColorWithRGB(0x4aa1f9) string:@"《注册协议》"];
}
- (void)showHeTong:(ZBLinkLabelModel *)model
{
    FullWebViewController *webController = [[FullWebViewController alloc] initWithWebUrl:ZXREGISTURL title:@"注册协议"];
    webController.baseTitleType = @"specialUser";
    [self.navigationController pushViewController:webController animated:YES];
}
- (IBAction)goToEnjoyOpenHSAccount:(id)sender {
    UCFOldUserGuideViewController *vc = [UCFOldUserGuideViewController createGuideHeadSetp:2];
    vc.site = @"2";
    [self.navigationController pushViewController:vc animated:YES];
    NSMutableArray *navVCArray = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    [navVCArray removeObjectAtIndex:navVCArray.count-2];
    [self.navigationController setViewControllers:navVCArray animated:NO];
}
- (void)dealloc
{
    
}
@end
