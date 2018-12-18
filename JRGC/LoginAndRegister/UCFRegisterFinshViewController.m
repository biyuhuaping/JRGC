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
#import "AppDelegate.h"
#import "MongoliaLayerCenter.h"
#import "BaseNavigationViewController.h"
#import "UCFCouponPopup.h"
@interface UCFRegisterFinshViewController ()
@property (weak, nonatomic) IBOutlet UIButton *openButton;
@property (weak, nonatomic) IBOutlet NZLabel *customLabel;

@end

@implementation UCFRegisterFinshViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    baseTitleLabel.text = @"注册成功";
    [self addRightButtonWithName:@"关闭"];
    [_openButton setBackgroundImage:[[UIImage imageNamed:@"btn_red"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5] forState:UIControlStateNormal];
    [_openButton setBackgroundImage:[[UIImage imageNamed:@"btn_red_highlight"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5] forState:UIControlStateHighlighted];
    [self getRegistResultData];
}
- (void)addRightButtonWithName:(NSString *)rightButtonName
{
    UIButton *rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightbutton.frame = CGRectMake(0, 0, 65, 44);
    rightbutton.backgroundColor = [UIColor clearColor];
    [rightbutton setTitle:rightButtonName forState:UIControlStateNormal];
    [rightbutton addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    [rightbutton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [rightbutton setTitleColor:UIColorWithRGB(0x333333) forState:UIControlStateNormal];
    [rightbutton setTitleColor:[UIColor colorWithWhite:1 alpha:0.7] forState:UIControlStateHighlighted];
    [rightbutton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightbutton];
    self.navigationItem.rightBarButtonItem = rightItem;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickRightBtn
{
    [self backHome];
}
- (IBAction)openButton:(id)sender
{
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [delegate.tabBarController setSelectedIndex:0];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self backHome];
    });

    
//    VC.rootVc = delegate.tabBarController;
//    BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:VC];
//    NSInteger personInt = [[[NSUserDefaults standardUserDefaults] valueForKey:@"personCenterClick"] integerValue];
//    if (personInt == 1) {
//        [delegate.tabBarController setSelectedIndex:4];
//        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"personCenterClick"];
//    }

}
- (void)backHome
{
    if (self.isPresentViewController) {
        //视图是弹出来的，那么要
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    [UCFCouponPopup startQueryCouponPopup];//去调取首页优惠券弹框
}

#pragma mark - 请求网络及回调
//获取注册成功活动反的数据
- (void)getRegistResultData{
    NSString *userId = [UserInfoSingle sharedManager].userId;
//    NSString *strParameters = [NSString stringWithFormat:@"userId=%@",userId];//5644  931407
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"userId", nil];
    
    [[NetworkModule sharedNetworkModule] newPostReq:dic tag:kSXTagRegistResult owner:self signature:NO Type:SelectAccoutDefault];
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
    
    id ret = dic[@"ret"];
    if (tag.intValue == kSXTagRegistResult) {
        if ([ret boolValue]) {

            //restype：A 券 B公分 1:工豆
           
            NSDictionary *tempDic = @{@"A":@"返现券", @"B":@"返息券",@"C":@"公分",@"1":@"工豆",@"G":@"返金券"};
            NSArray *registResult =[[dic objectForKey:@"data"] objectForKey:@"registResult"];
            NSMutableAttributedString *rsultStr = [[NSMutableAttributedString alloc] init];
            
            for (int i = 0; i < registResult.count; i ++) {
                
                NSString *restype =  [[registResult objectAtIndex:i] objectForKey:@"restype"];
                NSString *resvalue = [NSString stringWithFormat:@"%@",[[registResult objectAtIndex:i] objectForKey:@"resvalue"] ];
                if ([restype isEqualToString:@"A"])
                {
//                    tempStr = [NSString stringWithFormat:@"%@元",resvalue];
//                    //设置字体颜色
//                    NSString *str1 = [NSString stringWithFormat:@"%@元%@",resvalue,[tempDic objectForKey:restype]];

                    [rsultStr appendAttributedString:[self setAttributedStringValue:resvalue andColor:[UIColor redColor] andFont:[UIFont systemFontOfSize:14]]];
                    [rsultStr appendAttributedString:[self setAttributedStringValue:[NSString stringWithFormat:@"元%@",[tempDic objectForKey:restype]] andColor:UIColorWithRGB(0xA9B1B5) andFont:[UIFont systemFontOfSize:14]]];
                    
                }
                else if ([restype isEqualToString:@"B"])
                {
//                    tempStr = [NSString stringWithFormat:@"%@个",resvalue];
//                    [tempStr appendFormat:@"%@%%%@",resvalue,[tempDic objectForKey:restype]];
                    
                    [rsultStr appendAttributedString:[self setAttributedStringValue:[NSString stringWithFormat:@"%@%%",resvalue] andColor:[UIColor redColor] andFont:[UIFont systemFontOfSize:14]]];
                    [rsultStr appendAttributedString:[self setAttributedStringValue:[tempDic objectForKey:restype] andColor:UIColorWithRGB(0xA9B1B5) andFont:[UIFont systemFontOfSize:14]]];
                }
                else if ([restype isEqualToString:@"C"])
                {
                    //                    tempStr = [NSString stringWithFormat:@"%@个",resvalue];
//                    [tempStr appendFormat:@"%@个%@",resvalue,[tempDic objectForKey:restype]];
                    [rsultStr appendAttributedString:[self setAttributedStringValue:resvalue andColor:[UIColor redColor] andFont:[UIFont systemFontOfSize:14]]];
                    [rsultStr appendAttributedString:[self setAttributedStringValue:[NSString stringWithFormat:@"个%@",[tempDic objectForKey:restype]] andColor:UIColorWithRGB(0xA9B1B5) andFont:[UIFont systemFontOfSize:14]]];
                }
                else if ([restype isEqualToString:@"1"])
                {
//                    tempStr = [NSString stringWithFormat:@"%@个",resvalue];
//                    [tempStr appendFormat:@"%@个%@",resvalue,[tempDic objectForKey:restype]];
                    [rsultStr appendAttributedString:[self setAttributedStringValue:resvalue andColor:[UIColor redColor] andFont:[UIFont systemFontOfSize:14]]];
                    [rsultStr appendAttributedString:[self setAttributedStringValue:[NSString stringWithFormat:@"个%@",[tempDic objectForKey:restype]] andColor:UIColorWithRGB(0xA9B1B5) andFont:[UIFont systemFontOfSize:14]]];
                }
                else if ([restype isEqualToString:@"G"])
                {
                    //                    tempStr = [NSString stringWithFormat:@"%@个",resvalue];
                    //                    [tempStr appendFormat:@"%@个%@",resvalue,[tempDic objectForKey:restype]];
                    [rsultStr appendAttributedString:[self setAttributedStringValue:resvalue andColor:[UIColor redColor] andFont:[UIFont systemFontOfSize:14]]];
                    [rsultStr appendAttributedString:[self setAttributedStringValue:[NSString stringWithFormat:@"克%@",[tempDic objectForKey:restype]] andColor:UIColorWithRGB(0xA9B1B5) andFont:[UIFont systemFontOfSize:14]]];
                }

                if (i +1 != registResult.count) {
                    [rsultStr appendAttributedString:[self setAttributedStringValue:[NSString stringWithFormat:@"、"] andColor:UIColorWithRGB(0xA9B1B5) andFont:[UIFont systemFontOfSize:14]]];
                }
            }
            [rsultStr appendAttributedString:[self setAttributedStringValue:[NSString stringWithFormat:@"已经转入您的账户中"] andColor:UIColorWithRGB(0xA9B1B5) andFont:[UIFont systemFontOfSize:14]]];
            _customLabel.attributedText = rsultStr;
            
        }
//        else {
//            _customLabel.text = @"恭喜您注册成功！";
//        }

    }
}

//请求失败
- (void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}


- (NSAttributedString *)setAttributedStringValue:(NSString *)str andColor:(UIColor *)color andFont:(UIFont *)font
{
    //设置字体格式和大小,设置字体颜色  A9B1B5
    NSString *str1 = str;
    NSDictionary *dictAttr1 = @{NSFontAttributeName:font,NSForegroundColorAttributeName:color};
    NSAttributedString *attr1 = [[NSAttributedString alloc]initWithString:str1 attributes:dictAttr1];
    return attr1;
}
- (void)dealloc
{
//    [[MongoliaLayerCenter sharedManager] showLogic];
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
