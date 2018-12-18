//
//  UCFCouponPopup.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2018/12/13.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import "UCFCouponPopup.h"
#import "NetworkModule.h"
#import "UCFCouponPopupModel.h"
#import "JSONKit.h"
#import "AppDelegate.h"
#import "UIView+TYAlertView.h"
// if you want blur efffect contain this
#import "TYAlertController+BlurEffects.h"
#import "UCFCouponPopupHomeView.h"
#import "ASIHTTPRequest.h"
#import "AppDelegate.h"
#import "UCFHomeViewController.h"
#import "BaseNavigationViewController.h"
@implementation UCFCouponPopup

+ (void)startQueryCouponPopup
{
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    BaseNavigationViewController *nav = [delegate.tabBarController.viewControllers objectAtIndex:0];
    UCFHomeViewController *hc = [nav.viewControllers firstObject];
    [hc homeCouponPopup];
//    BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:VC];
//    [delegate.tabBarController presentViewController:nav animated:YES completion:^{
//
//    }];
}
- (void)request
{
    [self startRequest];
    return;
    @synchronized(self) {
        NSString *userId = [[NSUserDefaults standardUserDefaults] valueForKey:UUID];
        if (![userId isEqualToString:@""] && userId != nil) {
            //当前是否有用户登录
            if ([[NSUserDefaults standardUserDefaults] valueForKey:TIMESTAMP]!=nil && ![[[NSUserDefaults standardUserDefaults] valueForKey:TIMESTAMP] isEqualToString:@""]) //判断是否有时间戳,如果没有,说明是新登录的用户,如果有,说明是已登录的用户
            {
                if ([self getTimestamp]) {
                    //已登录的用户,需要计算两次间隔是否够24小时,大于24小时才重新进行请求
                    [self startRequest];
                }else
                {
                    //不够24小时不做处理
                    DBLOG(@"不够24小时");
                }
            }
            else
            {
                //新登录的用户直接请求
                [self startRequest];
            }
        }
    }    
}
- (void)startRequest
{
    NSString *userId = [[NSUserDefaults standardUserDefaults] valueForKey:UUID];
    [[NetworkModule sharedNetworkModule] newPostReq:@{@"userId":userId} tag:kSXTagShowCouponTips owner:self signature:YES Type:SelectAccoutDefault];
    
//    NSURL *url = [NSURL URLWithString:@"http://10.105.101.64:3000/mock/11/api/discountCoupon/v2/showCouponTips.json"];
//    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
//    request.requestMethod = @"POST";
//    request.timeOutSeconds = 30;
//    [request setCompletionBlock:^{
//        DBLOG(@"%@",request.responseString);
//        NSMutableDictionary *dic = [request.responseString objectFromJSONString];
//        [self starCouponPopup:dic];
//    }];
//    [request startAsynchronous];
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    
}
-(void)beginPost:(kSXTag)tag
{
    
}

- (void)endPost:(id)result tag:(NSNumber *)tag
{
    if ([tag intValue] == kSXTagShowCouponTips)
    {
        NSMutableDictionary *dic = [result objectFromJSONString];
        [self starCouponPopup:dic];
    }
}

-(void)starCouponPopup:(NSDictionary *)dic
{
    UCFCouponPopupModel *model = [ModelTransition TransitionModelClassName:[UCFCouponPopupModel class] dataGenre:dic];
    if (model.ret)//&& [dic[@"data"][@"bankList"]count] > 0 && [dic[@"data"][@"quickBankList"]count] > 0
    {
        if (model.data.couponList.count > 0) {
            
            
            
            UCFCouponPopupHomeView *fir = [[UCFCouponPopupHomeView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) withModel:model];
            // use UIView Category
            
            [fir showInWindow];
            [[NSUserDefaults standardUserDefaults] setObject:[self getNowTimeTimestamp] forKey:TIMESTAMP];
            [[NSUserDefaults standardUserDefaults] synchronize];
//            AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//            [delegate.tabBarController dismissViewControllerAnimated:NO completion:^{
//
//                UCFCouponPopupHomeView *fir = [[UCFCouponPopupHomeView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
//                // use UIView Category
//                [fir showInWindow];
//                [[NSUserDefaults standardUserDefaults] setObject:[self getNowTimeTimestamp] forKey:TIMESTAMP];
//
//                NSUInteger selectedIndex = delegate.tabBarController.selectedIndex;
//                UINavigationController *nav = [delegate.tabBarController.viewControllers objectAtIndex:selectedIndex];
//                [nav popToRootViewControllerAnimated:NO];
//            }];
        }
    }
    else
    {
        //失败
        
    }
}
- (void)errorPost:(NSError *)err tag:(NSNumber *)tag
{
    
}

- (BOOL)getTimestamp
{
    NSString *timestamp = [[NSUserDefaults standardUserDefaults] valueForKey:TIMESTAMP];
   return  [self dateTimeDifferenceWithStartTime:timestamp endTime:[self getNowTimeTimestamp]];
}

//获取当前时间戳
- (NSString *)getNowTimeTimestamp{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    
    return timeSp;
    
}
//计算两个时间戳的时间差
- (BOOL)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *startD =[date dateFromString:startTime];
    
    NSDate *endD = [date dateFromString:endTime];
    
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    
    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    
    NSTimeInterval value = end - start;
    
    int second = (int)value %60;//秒
    
    int minute = (int)value /60%60;
    
    int house = (int)value / (24 *3600)%3600;
    
    int day = (int)value / (24 *3600);
    
    NSString *str;
    
    if (day != 0) {
        
        str = [NSString stringWithFormat:@"耗时%d天%d小时%d分%d秒",day,house,minute,second];
        
    }else if (day==0 && house !=0) {
            
            str = [NSString stringWithFormat:@"耗时%d小时%d分%d秒",house,minute,second];
            
        }else if (day==0 && house==0 && minute!=0) {
                
                str = [NSString stringWithFormat:@"耗时%d分%d秒",minute,second];
                
            }else{
                    
                    str = [NSString stringWithFormat:@"耗时%d秒",second];
                    
                }
    
//    return str;

    return house >= 24? YES:NO;
}



@end
