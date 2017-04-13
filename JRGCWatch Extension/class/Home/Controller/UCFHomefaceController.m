//
//  UCFHomefaceController.m
//  Test01
//
//  Created by NJW on 16/10/20.
//  Copyright © 2016年 NJW. All rights reserved.
//

#import "UCFHomefaceController.h"
#import "UCFNetwork.h"
#import "UCFAccountTool.h"
#import "UCFAccount.h"
#import "UCFTool.h"

@interface UCFHomefaceController ()
{
    NSDictionary *_dataDic;
}
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *interestsMoneyLabel; //累计收益
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *totalMoneyLabel;//总资产
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *cashBalanceMoneyLabel;//可用余额

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *tipGroup;
 @property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *loadingGroup;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *viewGroup;
- (IBAction)gotoBackMoneyController;
- (IBAction)gotoAssetListController;

@end

@implementation UCFHomefaceController


- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    //默认显示
    
    [self setTitle:@"金融工场"];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadPersonData) name:@"reloadPersonData" object:nil];
    [self addMenuItemWithImageNamed:@"qr_code_icon" title:@"工场码" action:@selector(gotoGongChangma)];
//    [self addMenuItemWithImageNamed:@"sign_icon" title:@"签到" action:@selector(gotoQiandao)];
    [self.tipGroup setHidden:NO];
    [self.viewGroup setHidden:YES];
    [self.loadingGroup startAnimating];
    [self.loadingGroup setBackgroundImageNamed:@"loading"];
    [self.loadingGroup startAnimatingWithImagesInRange:NSMakeRange(0, 10) duration:1 repeatCount:0];
    [self getPersonDataHttpRequest];
}
-(void)reloadPersonData{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getPersonDataHttpRequest];
    });

}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];

//    NSString *iOSPath = [[UCFTool getDocumentsPath] stringByAppendingPathComponent:@"factory.png"];
//    NSData *data = [NSData dataWithContentsOfFile:iOSPath];
}
#pragma mark -获取个人中心的数据网络请求
-(void)getPersonDataHttpRequest{
    
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_IP, PERSONCEMTRER];
    UCFAccount *account = [UCFAccountTool account];
    if (!account.userId) {
        return;
    }
    [UCFNetwork POSTWithUrl:url parameters:@{@"userId":account.userId} isNew:YES success:^(id json) {
        
        [self.loadingGroup stopAnimating];
        [self.loadingGroup setHidden:YES];
        [self.tipGroup setHidden:YES];
        [self.viewGroup setHidden:NO];
        _dataDic = (NSDictionary *)json;
        NSDictionary * dataDic = [(NSDictionary *)json objectForKey:@"data"];
//        NSLog(@"dataDic -----首页返回数据--->>>>%@",dataDic);
        if(dataDic){
            NSString *interests = [NSString stringWithFormat:@"%@", [dataDic objectForKey:@"interests"]];
            NSString *total = [NSString stringWithFormat:@"%@", [dataDic objectForKey:@"total"]];
             total = [self moneyChangeFromValue:total];
            NSString *cashBalance = [NSString stringWithFormat:@"%@", [dataDic objectForKey:@"cashBalance"]];
             cashBalance = [self moneyChangeFromValue:cashBalance];
            [self.interestsMoneyLabel setText: interests] ;//累计收益
            [self.totalMoneyLabel setText:total];//总计资产
            [self.cashBalanceMoneyLabel setText:cashBalance];//可用余额
        }
//        [[NSUserDefaults standardUserDefaults] setObject:[json objectForKey:@"apptzticket"] forKey:@"apptzticket"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        NSLog(@"succ: %@", json);
    } fail:^(id json){
        
//        NSDictionary *ditc = (NSDictionary *)json;
        
        [self.loadingGroup stopAnimating];
        [self.loadingGroup setHidden:YES];
        [self.tipGroup setHidden:YES];
        [self.viewGroup setHidden:NO];
//        NSLog(@"failed: %@", ditc);
    }];
}

- (NSString *)moneyChangeFromValue:(NSString *)originValue
{
    BOOL isChange = NO; //判断金额是否有变化
    NSString *temp = [originValue stringByReplacingOccurrencesOfString:@"," withString:@""];
    double temp01 = [temp doubleValue];
    if (temp01 >= 1000000.0)//不小于100万
    {
        isChange = YES;
        temp01 /= 1000000.0;
        temp = [NSString stringWithFormat:@"%.2fm", temp01];
        if ([temp hasSuffix:@"00"]) {
            temp = [NSString stringWithFormat:@"%dm", (int)temp01];
        }
        else if ([temp hasSuffix:@"0"])
        {
            temp = [NSString stringWithFormat:@"%.1fm", temp01];
        }
    }
    else if (temp01 >= 10000.0)//不小于1万
    {
        isChange = YES;
        temp01 /= 10000.0;
        temp = [NSString stringWithFormat:@"%.2fw", temp01];
        if ([temp hasSuffix:@"00"]) {
            temp = [NSString stringWithFormat:@"%dw", (int)temp01];
        }
        else if ([temp hasSuffix:@"0"])
        {
            temp = [NSString stringWithFormat:@"%.1fw", temp01];
        }
    }
    if (isChange) {
        return temp;
    }
    return originValue;
}
#pragma mark -跳转至回款页面
- (IBAction)gotoBackMoneyController {
    [self pushControllerWithName:@"BackMoney" context:@{}];
}
#pragma mark -跳转至资金页面
- (IBAction)gotoAssetListController {
    [self pushControllerWithName:@"AssetList" context:@{}];
}
- (void)networkDistconnect
{
    [self.tipGroup setHidden:NO];
    [self.viewGroup setHidden:YES];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}
#pragma mark -跳转工场码页面
-(void)gotoGongChangma{
    [self pushControllerWithName:@"gongChangMa" context:nil];
//    [self presentControllerWithName:@"gongChangMa" context:nil];
}
#pragma mark -跳转签到页面
-(void)gotoQiandao{
    [self pushControllerWithName:@"qianDao" context:_dataDic];
//    [self presentControllerWithName:@"qianDao" context:nil];
}

@end



