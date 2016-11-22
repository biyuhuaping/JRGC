//
//  UCFSignfaceController.m
//  Test01
//
//  Created by NJW on 2016/10/26.
//  Copyright © 2016年 NJW. All rights reserved.
//

#import "UCFSignfaceController.h"
#import "UCFNetwork.h"
#import "UCFAccount.h"
#import "UCFAccountTool.h"
@interface UCFSignfaceController ()
{
    NSString *_apptzticket;
}
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *returnAmountLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *signStatusLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *todaySignedGroup;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *signDaysLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *nextDayBeansLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *returnAmountGroup;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *jiaHaoLabel;

@end

@implementation UCFSignfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

      [self getSignApptzticketHttpRequest];
}

-(void)getSignApptzticketHttpRequest{
    
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_IP, SignDaysAndIsSign];
//    NSString*apptzticketStr =
//    [[NSUserDefaults standardUserDefaults]  objectForKey: @"apptzticket"];
//    if (apptzticketStr == nil) {
//        return;
//    }
    UCFAccount *account = [UCFAccountTool account];
    [UCFNetwork POSTWithUrl:url parameters:@{@"userId":account.userId} isNew:NO success:^(id json) {
         _apptzticket = json[@"apptzticket"];
        if (_apptzticket == nil) {
            _apptzticket = @"";
        }
       [self getSignDataHttpRequest:_apptzticket];
        
    } fail:^(id json){
    
    }];

    
}
#pragma mark -获取签到的数据网络请求
-(void)getSignDataHttpRequest:(NSString *)apptzticketStr{

    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_IP, SingMenthod];
    UCFAccount *account = [UCFAccountTool account];
    [UCFNetwork POSTWithUrl:url parameters:@{@"userId":account.userId,@"apptzticket":apptzticketStr} isNew:NO success:^(id json) {
        
        [self refreshSignData:json];
        
    } fail:^(id json){
        NSDictionary *ditc = (NSDictionary *)json;
//        NSLog(@"failed: %@", ditc);
    }];
}
-(void)refreshSignData:(NSDictionary *)dataDict{
    NSString *flag = [dataDict objectForKey: @"flag"];
    
    if ([flag isEqualToString:@"success"]) {//签到成功
        [self.returnAmountGroup setHidden:NO];
        [self.returnAmountLabel setHidden:NO];
        [self.jiaHaoLabel setHidden:NO];
        [self.todaySignedGroup setHidden:YES];
        NSString *returnAmount = [dataDict objectForKey: @"returnAmount"];//签到获得工豆数
        returnAmount = returnAmount?returnAmount:@"0";
        NSString *nextDayBeans = [dataDict objectForKey:@"nextDayBeans"];//明日签到获得工豆数
        NSString *signDays = [dataDict objectForKey:@"signDays"];//签到天数
        [self.returnAmountLabel setText:[NSString stringWithFormat:@"%@",returnAmount]];
//        [self.signDaysLabel setText:[NSString stringWithFormat:@"您已连续签到%@天",signDays]];
        [self.signDaysLabel setText:[NSString stringWithFormat:@"%@",signDays]];
        [self.nextDayBeansLabel setText:[NSString stringWithFormat:@"明日签到奖励%@工分",nextDayBeans]];
        [self.signStatusLabel setText:@"签到成功"];
    } else if ([flag isEqualToString:@"already"]) {//已签到
        [self.returnAmountGroup setHidden:YES];
        [self.returnAmountLabel setHidden:YES];
        [self.jiaHaoLabel setHidden:YES];
        [self.todaySignedGroup setHidden:NO];
        [self.todaySignedGroup setBackgroundImageNamed:@"already_sign_in"];
        NSString *nextDayBeans = [dataDict objectForKey:@"nextDayBeans"];//明日签到获得工豆数
        NSString *signDays = dataDict[@"signDays"];//签到天数
        [self.signDaysLabel setText:[NSString stringWithFormat:@"%@",signDays]];
        [self.nextDayBeansLabel setText:[NSString stringWithFormat:@"明日签到奖励%@工分",nextDayBeans]];
        [self.signStatusLabel setText:@"今日已签到"];
    }
    
}
- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



