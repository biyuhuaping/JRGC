//
//  ToolSingleTon.m
//  JRGC
//
//  Created by 金融工场 on 15/7/17.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "ToolSingleTon.h"
#import "NetworkModule.h"
#import "JSONKit.h"
#import "NSDate+IsBelongToToday.h"
#import "AuxiliaryFunc.h"
#import "NZLabel.h"
#import "MjAlertView.h"
#import "FestivalActivitiesWebView.h"
#import "AppDelegate.h"
@interface ToolSingleTon () <NetworkModuleDelegate, UIAlertViewDelegate, MjAlertViewDelegate>
@property (strong, nonatomic) UIView *alertView;
@property (strong, nonatomic) UIView *background;
@property (strong, nonatomic) MjAlertView *alert;
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation ToolSingleTon
+ (ToolSingleTon *)sharedManager
{
    static ToolSingleTon *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}
- (instancetype)init {
    self = [super init];
    if(self) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(getGoldPrice) userInfo:nil repeats:YES];
        
        [_timer setFireDate:[NSDate distantPast]];
    }
    return self;
}
- (BOOL)checkHasCheckIn:(NSString *)uid
{
    NSDictionary *qiandaoDict =  [[NSUserDefaults standardUserDefaults] objectForKey:ISHASQIANDAOALERT];
    if (qiandaoDict == nil) {
        NSMutableArray  *arr = [NSMutableArray arrayWithCapacity:1];
        [arr addObject:uid];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        NSDictionary *dict = [NSDictionary dictionaryWithObject:arr forKey:dateString];
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:ISHASQIANDAOALERT];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    } else {
        NSString *preDateString = [[qiandaoDict allKeys] objectAtIndex:0];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *nowString = [formatter stringFromDate:[NSDate date]];
        if ([preDateString isEqualToString:nowString]) {
            NSArray *uidArr = [qiandaoDict objectForKey:preDateString];
            if ([uidArr containsObject:uid]) {
                return NO;
            } else {
                NSMutableArray *muUidArr = [NSMutableArray arrayWithArray:uidArr];
                [muUidArr addObject:uid];
                NSDictionary *dict = [NSDictionary dictionaryWithObject:muUidArr forKey:nowString];
                [[NSUserDefaults standardUserDefaults] setObject:dict forKey:ISHASQIANDAOALERT];
                [[NSUserDefaults standardUserDefaults] synchronize];
                return YES;
            }
        } else {
            NSArray *uidArr = [qiandaoDict objectForKey:preDateString];
            NSMutableArray *muUidArr = [NSMutableArray arrayWithArray:uidArr];
            [muUidArr removeAllObjects];
            [muUidArr addObject:uid];
            NSDictionary *dict = [NSDictionary dictionaryWithObject:muUidArr forKey:nowString];
            [[NSUserDefaults standardUserDefaults] setObject:dict forKey:ISHASQIANDAOALERT];
            [[NSUserDefaults standardUserDefaults] synchronize];
            return YES;
        }
    }
}
- (void)showFestivalActivitiesWebView:(NSString *)redBagUrl
{
    FestivalActivitiesWebView *festivalView = [[FestivalActivitiesWebView alloc] initWithNibName:@"FestivalActivitiesWebView" bundle:nil];
    festivalView.url = redBagUrl;
    festivalView.isHideNavigationBar = YES;
    festivalView.definesPresentationContext = YES;
    festivalView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    festivalView.view.backgroundColor = [UIColor clearColor];
    if (kIS_IOS8) {
        festivalView.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }

    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:festivalView];
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.tabBarController presentViewController:nav animated:YES completion:nil];

}

//获取当前黄金价格
- (void)getGoldPrice {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:BEHIN_GET_GOLD_PRICE object:nil];
    [[NetworkModule sharedNetworkModule] newPostReq:@{} tag:ksxTagGoldCurrentPrice owner:self signature:NO Type:SelectAccoutDefault];
}

- (void)beginPost:(kSXTag)tag
{
    
}

- (void)endPost:(id)result tag:(NSNumber *)tag
{
    NSString *data = (NSString *)result;
    NSMutableDictionary *dic = [data objectFromJSONString];
    if (tag.intValue == kSXTagSignDaysAndIsSign) {
        NSInteger flag = [dic[@"flag"] integerValue];
        self.apptzticket = dic[@"apptzticket"];
        if (flag == 1) {
            NSInteger signFlags = [dic[@"signflags"] integerValue];
            if (signFlags == 0) {
                    _alert = [[MjAlertView alloc] initSignAlertViewWithBlock:^(id blockContent) {
                    DLog(@"%@", blockContent);
                    
                    NZLabel *lab1 = [[NZLabel alloc]initWithFrame:CGRectMake(20, 60, 228, 25)];
                    lab1.font = [UIFont systemFontOfSize:15];
                    lab1.textColor = UIColorWithRGB(0x555555);
                    lab1.text = @"1.每日签到，立即领取10工豆奖励";
                    [lab1 setFontColor:UIColorWithRGB(0xfd4d4c) string:@"10工豆"];
                    
                    NZLabel *lab2 = [[NZLabel alloc]initWithFrame:CGRectMake(20, 60+25, 228, 25)];
                    lab2.font = [UIFont systemFontOfSize:15];
                    lab2.textColor = UIColorWithRGB(0x555555);
                    lab2.text = @"2.连续签到7天，额外领取50工豆";
                    [lab2 setFontColor:UIColorWithRGB(0xfd4d4c) string:@"7天"];
                    [lab2 setFontColor:UIColorWithRGB(0xfd4d4c) string:@"50工豆"];
                    
                    NZLabel *lab3 = [[NZLabel alloc]initWithFrame:CGRectMake(20, 60+50, 228, 25)];
                    lab3.font = [UIFont systemFontOfSize:15];
                    lab3.textColor = UIColorWithRGB(0x555555);
                    lab3.text = @"3.签到就有机会抽取红包奖励";
                    [lab3 setFontColor:UIColorWithRGB(0xfd4d4c) string:@"红包"];
                    
                    [blockContent addSubview:lab1];
                    [blockContent addSubview:lab2];
                    [blockContent addSubview:lab3];
                    //签到检测红点
                    [[NSNotificationCenter defaultCenter] postNotificationName:CHECK_RED_POINT object:nil];

                    
                } delegate:self cancelButtonTitle:@"给钱也不要" withOtherButtons:@[@"立即签到"]];
                [_alert show];
            }
        }
    }
    else if (tag.intValue == kSXTagSingMenthod){
        NSString *flag = dic[@"flag"];
        if ([flag isEqualToString:@"success"]) {
            NSString *returnAmount = dic[@"returnAmount"];//签到获得工豆数
            returnAmount = returnAmount?returnAmount:@"0";
            
            NSString *nextDayBeans = dic[@"nextDayBeans"];//明日签到获得工豆数
            nextDayBeans = nextDayBeans?nextDayBeans:@"0";
            
            NSString *signDays = dic[@"signDays"];//签到天数
            signDays = signDays?signDays:@"0";
            
            NSString *numDays = dic[@"numDays"];//活动规则的天数
            numDays = numDays?numDays:@"0";
            
            NSString *numBeans = dic[@"numBeans"];//活动规则的工豆数
            numBeans = numBeans?numBeans:@"0";
            
            BOOL win = NO;//是否获得红包 true/false
            if ([dic[@"win"] isEqualToString:@"true"]) {
                win = YES;
            }
            
            NSString *winAmount = dic[@"winAmount"];//获得红包金额
            winAmount = winAmount?winAmount:@"0";
            
            NSString *rewardAmt = dic[@"rewardAmt"];//抢光红包再奖励的钱数
            rewardAmt = rewardAmt?rewardAmt:@"0";
            [self showAlertViewWithQianDaoGongDouCount:returnAmount nextDayBeans:nextDayBeans signDays:signDays win:win winAmount:winAmount rewardAmt:rewardAmt];
            //签完到之后重新加载 用户数据
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getPersonalCenterNetData" object:nil];
        }
    } else if (tag.integerValue == kSXTagRedBagRainSwitch) {
        if ([dic[@"ret"] boolValue]) {
            if ([dic[@"data"][@"redBagRainOnOff"] boolValue] && [dic[@"data"][@"goInRedBagRainNum"] integerValue] == 0) {
                [self showFestivalActivitiesWebView:dic[@"data"][@"redBagRainAddress"]];
            }
        }
    } else if (tag.integerValue == ksxTagGoldCurrentPrice) {
        if ([dic[@"ret"] boolValue]) {
            self.readTimePrice = [dic[@"data"][@"readTimePrice"] doubleValue];
        } else {
//            [MBProgressHUD displayHudError:@"获取金价失败"];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:CURRENT_GOLD_PRICE object:nil];

    }
}
- (void)errorPost:(NSError *)err tag:(NSNumber *)tag
{
    if (tag.intValue == kSXTagSignDaysAndIsSign) {
        
    }
    else if (tag.intValue == kSXTagSingMenthod) {
        
    } else if (tag.integerValue == ksxTagGoldCurrentPrice) {
        [[NSNotificationCenter defaultCenter] postNotificationName:CURRENT_GOLD_PRICE object:nil];
    }
}



- (void)mjalertView:(MjAlertView *)alertview didClickedButton:(UIButton *)clickedButton andClickedIndex:(NSInteger)index
{
    DLog(@"%ld", (long)index);
    if (index == 1) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSString *strParameters = [NSString stringWithFormat:@"userId=%@&apptzticket=%@", [[NSUserDefaults standardUserDefaults] objectForKey:UUID],self.apptzticket];
            [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagSingMenthod owner:self Type:SelectAccoutDefault];
        });
    }
}

//展示视图
- (void)showAlertViewWithQianDaoGongDouCount:(NSString *)gongDouCount nextDayBeans:(NSString *)nextDayBeans signDays:(NSString *)signDays  win:(BOOL)isWin winAmount:(NSString *)winAmount rewardAmt:(NSString *)rewardAmt{
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    self.background = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _background.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    self.alertView = [[UIView alloc]initWithFrame:_background.bounds];
    
    UIImageView *ima = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    ima.image = [UIImage imageNamed:@"checkin_bg"];
    ima.center = _alertView.center;
    [_alertView addSubview:ima];
    
    NZLabel *lab1 = [[NZLabel alloc]initWithFrame:CGRectMake(0, ScreenHeight/2-100, ScreenWidth, 30)];
    lab1.font = [UIFont systemFontOfSize:25];
    lab1.textColor = UIColorWithRGB(0xffe65d);
    lab1.textAlignment = NSTextAlignmentCenter;
    lab1.text = [@"+" stringByAppendingString:gongDouCount];
    [lab1 setFont:[UIFont boldSystemFontOfSize:25] string:gongDouCount];
    
    
    NZLabel *lab2 = [[NZLabel alloc]initWithFrame:CGRectMake(0, ScreenHeight/2, ScreenWidth, 30)];
    lab2.font = [UIFont systemFontOfSize:17];
    lab2.textAlignment = NSTextAlignmentCenter;
    lab2.text = [NSString stringWithFormat:@"今日签到成功！已获得%@工豆",gongDouCount];
    [lab2 setFontColor:[UIColor redColor] string:gongDouCount];
    
    NZLabel *lab3 = [[NZLabel alloc]init];
    if (isWin) {//有红包时
        lab3.frame = CGRectMake(0, ScreenHeight/2+73, ScreenWidth, 30);
        
        NZLabel *lab = [[NZLabel alloc]initWithFrame:CGRectMake(0, ScreenHeight/2+32, ScreenWidth, 20)];
        lab.font = [UIFont systemFontOfSize:17];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.numberOfLines = 0;
        lab.lineBreakMode = NSLineBreakByWordWrapping;
        lab.text = [NSString stringWithFormat:@"人品爆表！抽到%@元红包",winAmount];
        [lab setFontColor:[UIColor redColor] string:winAmount];
        [_alertView addSubview:lab];
        
        if ([rewardAmt intValue] != 0) {
            NZLabel *lab11 = [[NZLabel alloc]initWithFrame:CGRectMake(0, ScreenHeight/2+50, ScreenWidth, 20)];
            lab11.font = [UIFont systemFontOfSize:17];
            lab11.textAlignment = NSTextAlignmentCenter;
            lab11.numberOfLines = 0;
            lab11.lineBreakMode = NSLineBreakByWordWrapping;
            lab11.text = [NSString stringWithFormat:@"抢光红包再奖励%@元",rewardAmt];
            [lab11 setFontColor:[UIColor redColor] string:rewardAmt];
            [_alertView addSubview:lab11];
        }
        
    }else{//没有红包时
        lab3.frame = CGRectMake(0, ScreenHeight/2+30, ScreenWidth, 30);
        
        UILabel *lab22 = [[UILabel alloc]initWithFrame:CGRectMake(0, ScreenHeight/2+50, ScreenWidth, 60)];
        lab22.font = [UIFont systemFontOfSize:13];
        lab22.textAlignment = NSTextAlignmentCenter;
        lab22.numberOfLines = 0;
        lab22.lineBreakMode = NSLineBreakByWordWrapping;
        lab22.textColor = [UIColor lightGrayColor];
        lab22.text = @"投资多多！好礼送不停\n签到就有机会抽到红包哟！";
        [_alertView addSubview:lab22];
    }
    lab3.font = [UIFont systemFontOfSize:13];
    lab3.textColor = [UIColor darkGrayColor];
    lab3.textAlignment = NSTextAlignmentCenter;
    lab3.text = [NSString stringWithFormat:@"明日签到奖励%@工豆，已连续签到%@天",nextDayBeans,signDays];
    [lab3 setFontColor:[UIColor redColor] string:nextDayBeans];
    
    [_alertView addSubview:lab1];
    [_alertView addSubview:lab2];
    [_alertView addSubview:lab3];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 192, 33);//ScreenWidth*0.6
    btn.center = CGPointMake(ScreenWidth/2, ScreenHeight/2+125);
    [btn setTitle:@"关闭" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:@selector(hideAlertAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[[UIImage imageNamed:@"btn_red"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5] forState:UIControlStateNormal];
    [btn setBackgroundImage:[[UIImage imageNamed:@"btn_red_highlight"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5] forState:UIControlStateHighlighted];
    [_alertView addSubview:btn];
    
    
    [window addSubview:_background];
    [window addSubview:_alertView];
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [_alertView.layer addAnimation:popAnimation forKey:nil];
}

//隐藏视图
- (void)hideAlertAction:(id)sender {
    [self.alert hide];
    self.alert = nil;
    [self.alertView removeFromSuperview];
    self.alertView = nil;
    [self.background removeFromSuperview];
    self.background = nil;
}

@end
