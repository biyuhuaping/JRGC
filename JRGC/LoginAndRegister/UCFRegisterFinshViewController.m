//
//  UCFRegisterFinshViewController.m
//  JRGC
//
//  Created by 狂战之巅 on 2017/3/24.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFRegisterFinshViewController.h"
#import "NZLabel.h"
#import "UCFToolsMehod.h"

@interface UCFRegisterFinshViewController ()
@property (weak, nonatomic) IBOutlet UIButton *openButton;
@property (weak, nonatomic) IBOutlet NZLabel *customLabel;

@end

@implementation UCFRegisterFinshViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_openButton setBackgroundImage:[[UIImage imageNamed:@"btn_red"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5] forState:UIControlStateNormal];
    [_openButton setBackgroundImage:[[UIImage imageNamed:@"btn_red_highlight"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5] forState:UIControlStateHighlighted];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)openButton:(id)sender {
}


#pragma mark - 请求网络及回调
//获取注册成功活动反的数据
- (void)getRegistResultData{
    NSString *userId = [UserInfoSingle sharedManager].userId;
    NSString *strParameters = [NSString stringWithFormat:@"userId=%@",userId];//5644
    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagRegistResult owner:self];
}

//开始请求
- (void)beginPost:(kSXTag)tag
{
    //    [GiFHUD show];
}

//请求成功及结果
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSMutableDictionary *dic = [result objectFromJSONString];
    
    id status = dic[@"status"];
    if (tag.intValue == kSXTagRegistResult) {
        if ([status boolValue]) {
            //restype:0:现金 1:工豆 A：优惠券 2：体验本金 3:抽奖机会 4:红包
            NSString *restype = dic[@"restype"];
            NSString *resvalue = [NSString stringWithFormat:@"%@",dic[@"resvalue"]];
            NSDictionary *tempDic = @{@"0":@"现金", @"1":@"工豆", @"A":@"优惠券", @"2":@"体验本金", @"3":@"抽奖机会", @"4":@"红包"};
            NSString *tempStr = @"";
            if ([restype isEqualToString:@"0"]) {
                tempStr = [NSString stringWithFormat:@"%@元",resvalue];
            } else if ([restype isEqualToString:@"1"]) {
                tempStr = [NSString stringWithFormat:@"%@个",resvalue];
            } else if ([restype isEqualToString:@"A"]) {
                tempStr = [NSString stringWithFormat:@"%@元",resvalue];
            } else if ([restype isEqualToString:@"2"]) {
                tempStr = [NSString stringWithFormat:@"%@元",resvalue];
            } else if ([restype isEqualToString:@"3"]) {
                tempStr = [NSString stringWithFormat:@"%@次",resvalue];
            } else if ([restype isEqualToString:@"4"]) {
                tempStr = [NSString stringWithFormat:@"%@元",resvalue];
            }
            _customLabel.text = [NSString stringWithFormat:@"%@%@已经转入您的账户中",tempStr,tempDic[restype]];
            [_customLabel setFontColor:[UIColor redColor] string:tempStr];
        }else {
            _customLabel.text = @"恭喜您注册成功！";
        }
    }
}

//请求失败
- (void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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
