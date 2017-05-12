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
@property (nonatomic, weak) UILabel *lab22;
@end

@implementation UCFSignView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NZLabel *lab1 = [[NZLabel alloc] initWithFrame:CGRectZero];
        lab1.font = [UIFont systemFontOfSize:25];
        lab1.textColor = UIColorWithRGB(0xffe65d);
        lab1.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lab1];
        self.lab1 = lab1;
        
        
        NZLabel *lab2 = [[NZLabel alloc]initWithFrame:CGRectZero];
        lab2.font = [UIFont systemFontOfSize:17];
        lab2.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lab2];
        self.lab2 = lab2;
        
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
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.lab1.frame = CGRectMake(0, 70, self.width, 30);
    self.lab1.text = [@"+" stringByAppendingString:[NSString stringWithFormat:@"%@", self.signModel.returnAmount]];
    [self.lab1 setFont:[UIFont boldSystemFontOfSize:25] string:[NSString stringWithFormat:@"%@", self.signModel.returnAmount]];
    
    self.lab2.frame = CGRectMake(0, self.height/2.0+10, self.width, 30);
    self.lab2.text = [NSString stringWithFormat:@"今日签到成功！已获得%@工豆",self.signModel.returnAmount];
    if ([self.signModel.isOpen isEqualToString:@"1"]) {
        self.lab2.text = [NSString stringWithFormat:@"今日签到成功！已获得%@工分",self.signModel.returnAmount];
    }
    else if ([self.signModel.isOpen isEqualToString:@"0"]) {
        self.lab2.text = [NSString stringWithFormat:@"今日签到成功！已获得%@工豆",self.signModel.returnAmount];
    }
    [self.lab2 setFontColor:[UIColor redColor] string:self.signModel.returnAmount];

    if (self.signModel.win) {//有红包时
        self.lab3.frame = CGRectMake(0, self.height/2+73, self.width, 30);
        self.lab.frame = CGRectMake(0, self.height/2+32, self.width, 20);
        self.lab.text = [NSString stringWithFormat:@"人品爆表！抽到%@元红包",self.signModel.winAmount];
        [self.lab setFontColor:[UIColor redColor] string:[NSString stringWithFormat:@"%@", self.signModel.winAmount]];

        if ([self.signModel.rewardAmt intValue] != 0) {
            self.lab11.frame = CGRectMake(0, self.height/2+50, self.width, 20);
            self.lab11.text = [NSString stringWithFormat:@"抢光红包再奖励%@元",self.signModel.rewardAmt];
            [self.lab11 setFontColor:[UIColor redColor] string:[NSString stringWithFormat:@"%@", self.signModel.rewardAmt]];
        }
    }
    else{//没有红包时
            self.lab3.frame = CGRectMake(0, self.height/2+30, self.width, 30);

            self.lab22.frame = CGRectMake(0, self.height/2+50, self.width, 60);
            self.lab22.text = @"投资多多！好礼送不停\n签到就有机会抽到红包哟！";
    }
        self.lab3.font = [UIFont systemFontOfSize:13];
        self.lab3.textColor = [UIColor darkGrayColor];
        self.lab3.textAlignment = NSTextAlignmentCenter;
        if ([self.signModel.isOpen isEqualToString:@"1"]) {
            self.lab3.text = [NSString stringWithFormat:@"明日签到奖励%@工分，已连续签到%@天",self.signModel.nextDayBeans,self.signModel.signDays];
        }
        else if ([self.signModel.isOpen isEqualToString:@"0"]) {
            self.lab3.text = [NSString stringWithFormat:@"明日签到奖励%@工豆，已连续签到%@天",self.signModel.nextDayBeans,self.signModel.signDays];
        }
        [self.lab3 setFontColor:[UIColor redColor] string:[NSString stringWithFormat:@"%@", self.signModel.nextDayBeans]];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
