//
//  UCFSignView.m
//  JRGC
//
//  Created by njw on 2017/4/7.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFSignView.h"
#import "UCFSignModel.h"
#import "NZLabel.h"

@interface UCFSignView ()

@property (nonatomic, weak) NZLabel *lab1;
@property (nonatomic, weak) NZLabel *lab2;
@property (nonatomic, weak) NZLabel *lab3;
@property (nonatomic, weak) NZLabel *lab;
@property (nonatomic, weak) NZLabel *lab11;
@property (nonatomic, weak) NZLabel *lab22;
@end

@implementation UCFSignView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NZLabel *lab1 = [[NZLabel alloc] initWithFrame:CGRectZero];
//        NZLabel *lab1 = [[NZLabel alloc] initWithFrame:CGRectMake(0, 70, view.frame.size.width, 30)];
        lab1.font = [UIFont systemFontOfSize:25];
        lab1.textColor = UIColorWithRGB(0xffe65d);
        lab1.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lab1];
        self.lab1 = lab1;
//        lab1.text = [@"+" stringByAppendingString:returnAmount];
//        [lab1 setFont:[UIFont boldSystemFontOfSize:25] string:returnAmount];
        NZLabel *lab2 = [[NZLabel alloc]initWithFrame:CGRectZero];
        
//        NZLabel *lab2 = [[NZLabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(view.frame)/2.0+10, CGRectGetWidth(view.frame), 30)];
        lab2.font = [UIFont systemFontOfSize:17];
        lab2.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lab2];
        self.lab2 = lab2;
        //        lab2.text = [NSString stringWithFormat:@"今日签到成功！已获得%@工豆",returnAmount];
//        if ([isOpen isEqualToString:@"1"]) {
//            lab2.text = [NSString stringWithFormat:@"今日签到成功！已获得%@工分",returnAmount];
//        }
//        else if ([isOpen isEqualToString:@"0"]) {
//            lab2.text = [NSString stringWithFormat:@"今日签到成功！已获得%@工豆",returnAmount];
//        }
//        [lab2 setFontColor:[UIColor redColor] string:returnAmount];
        
        NZLabel *lab3 = [[NZLabel alloc]init];
        lab3.font = [UIFont systemFontOfSize:13];
        lab3.textColor = [UIColor darkGrayColor];
        lab3.textAlignment = NSTextAlignmentCenter;
//        if ([isOpen isEqualToString:@"1"]) {
//            lab3.text = [NSString stringWithFormat:@"明日奖励%@工分，已连续签到%@天",@"10",@"20"];
//        }
//        else if ([isOpen isEqualToString:@"0"]) {
//            lab3.text = [NSString stringWithFormat:@"明日奖励%@工豆，已连续签到%@天",@"10",@"20"];
//        }
        [self addSubview:lab3];
        self.lab3 = lab3;
        
        NZLabel *lab = [[NZLabel alloc]initWithFrame:CGRectZero];
        lab.font = [UIFont systemFontOfSize:17];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.numberOfLines = 0;
        lab.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:lab];
        self.lab = lab;
        
        NZLabel *lab11 = [[NZLabel alloc]initWithFrame:CGRectZero];
        lab11.font = [UIFont systemFontOfSize:17];
        lab11.textAlignment = NSTextAlignmentCenter;
        lab11.numberOfLines = 0;
        lab11.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:lab11];
        self.lab11 = lab11;
        
        UILabel *lab22 = [[UILabel alloc]initWithFrame:CGRectZero];
        lab22.font = [UIFont systemFontOfSize:13];
        lab22.textAlignment = NSTextAlignmentCenter;
        lab22.numberOfLines = 0;
        lab22.lineBreakMode = NSLineBreakByWordWrapping;
        lab22.textColor = [UIColor lightGrayColor];
        lab22.text = @"投资多多！好礼送不停\n签到就有机会抽到红包哟！";
        [self addSubview:lab22];
        self.lab22 = lab22;
        
        if (YES) {//有红包时
//            lab3.frame = CGRectMake(0, CGRectGetHeight(view.frame)/2+73, CGRectGetWidth(view.frame), 30);
            
//            NZLabel *lab = [[NZLabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(view.frame)/2+32, CGRectGetWidth(view.frame), 20)];
//            lab.font = [UIFont systemFontOfSize:17];
//            lab.textAlignment = NSTextAlignmentCenter;
//            lab.numberOfLines = 0;
//            lab.lineBreakMode = NSLineBreakByWordWrapping;
//            lab.text = [NSString stringWithFormat:@"人品爆表！抽到%@元红包",winAmount];
//            [lab setFontColor:[UIColor redColor] string:winAmount];
//            [view addSubview:lab];
            
//            if ([rewardAmt intValue] != 0) {
//                NZLabel *lab11 = [[NZLabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(view.frame)/2+50, CGRectGetWidth(view.frame), 20)];
//                lab11.font = [UIFont systemFontOfSize:17];
//                lab11.textAlignment = NSTextAlignmentCenter;
//                lab11.numberOfLines = 0;
//                lab11.lineBreakMode = NSLineBreakByWordWrapping;
//                lab11.text = [NSString stringWithFormat:@"抢光红包再奖励%@元",rewardAmt];
//                [lab11 setFontColor:[UIColor redColor] string:rewardAmt];
//                [view addSubview:lab11];
//            }
            
        }
        else{//没有红包时
//            lab3.frame = CGRectMake(0, CGRectGetHeight(view.frame)/2+30, CGRectGetWidth(view.frame), 30);
//            
//            UILabel *lab22 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(view.frame)/2+50, CGRectGetWidth(view.frame), 60)];
//            lab22.font = [UIFont systemFontOfSize:13];
//            lab22.textAlignment = NSTextAlignmentCenter;
//            lab22.numberOfLines = 0;
//            lab22.lineBreakMode = NSLineBreakByWordWrapping;
//            lab22.textColor = [UIColor lightGrayColor];
//            lab22.text = @"投资多多！好礼送不停\n签到就有机会抽到红包哟！";
//            [view addSubview:lab22];
        }
//        lab3.font = [UIFont systemFontOfSize:13];
//        lab3.textColor = [UIColor darkGrayColor];
//        lab3.textAlignment = NSTextAlignmentCenter;
//        if ([isOpen isEqualToString:@"1"]) {
//            lab3.text = [NSString stringWithFormat:@"明日签到奖励%@工分，已连续签到%@天",nextDayBeans,signDays];
//        }
//        else if ([isOpen isEqualToString:@"0"]) {
//            lab3.text = [NSString stringWithFormat:@"明日签到奖励%@工豆，已连续签到%@天",nextDayBeans,signDays];
//        }
//        [lab3 setFontColor:[UIColor redColor] string:nextDayBeans];
//        
//        [view addSubview:lab1];
//        [view addSubview:lab2];
//        [view addSubview:lab3];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
