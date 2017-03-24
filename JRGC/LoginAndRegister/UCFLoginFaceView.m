//
//  UCFLoginFaceView.m
//  JRGC
//
//  Created by 秦 on 16/7/21.
//  Copyright © 2016年 qinwei. All rights reserved.
//
#import <UIKit/UIKit.h>
//与网络请求有关
#import "MBProgressHUD.h"
#import "NetworkModule.h"
#import "AuxiliaryFunc.h"
#import "MJRefresh.h"
//数据解析
#import "JSONKit.h"

// 图片加载
#import "UIImageView+WebCache.h"

//安全取值
#import "YcArray.h"
#import "YcMutableArray.h"
#import "UIDic+Safe.h"

#define PAGESIZE @"20"

// 资金的千位格式化
#import "NSString+FormatForThousand.h"

#import "GiFHUD.h"


#import "UCFLoginFaceView.h"
#import "ASIFormDataRequest.h"
@implementation UCFLoginFaceView


- (void)drawRect:(CGRect)rect {
   NSString *sexStr = [[NSUserDefaults standardUserDefaults] objectForKey:SEX];
    if ([sexStr isEqualToString:@"0"]) {
        self.imageHead.image = [UIImage imageNamed:@"user_icon_head_female"];
    }
    else if ([sexStr isEqualToString:@"1"]) {
        self.imageHead.image = [UIImage imageNamed:@"user_icon_head_male"];
    }
    else {
        self.imageHead.image = [UIImage imageNamed:@"password_icon_head"];
    }
    self.lable_username.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastLoginName"];
}
- (IBAction)buttonPressLogin:(id)sender {
    [self getFaceSwitchStatusNetData];//***查询人脸开关状态
}
- (IBAction)buttonPressChangeToPassword:(id)sender {
    self.hidden = YES;
    [self.delegate keyBoardPushOut];//***弹出键盘
}

//获取 人脸识别开关状态查询网络请求
-(void)getFaceSwitchStatusNetData
{
    NSString *strParameters = [NSString stringWithFormat:@"loginName=%@", self.lable_username.text];
    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagFaceInfoStore owner:self Type:SelectAccoutDefault];
    [MBProgressHUD showHUDAddedTo:self animated:YES];
}
- (void)beginPost:(kSXTag)tag
{
    
}
//请求成功及结果
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self animated:YES];
    NSString *data = (NSString *)result;
    NSDictionary *dic = [data objectFromJSONString];
    if (tag.intValue == kSXTagFaceInfoStore) {
        BOOL faceIsOpen = ![[dic objectSafeForKey:@"isOpen"] boolValue];// 1：关闭 0：开启
        [[NSUserDefaults standardUserDefaults] setBool:faceIsOpen forKey:FACESWITCHSTATUS];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if(faceIsOpen == YES)
        {
             [self.delegate goToFaceCheaking];
        }else{
            UIAlertView*aler = [[UIAlertView alloc]initWithTitle:@"" message:@"您已关闭刷脸登录，请使用密码进行登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [aler show];
        }
    }
}
//请求失败
- (void)errorPost:(NSError*)err tag:(NSNumber*)tag{
   
    if (tag.intValue == kSXTagFaceInfoStore) {
        [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
    }
    [MBProgressHUD hideAllHUDsForView:self animated:YES];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.hidden = YES;
    [self.delegate keyBoardPushOut];//***弹出键盘
}
@end
