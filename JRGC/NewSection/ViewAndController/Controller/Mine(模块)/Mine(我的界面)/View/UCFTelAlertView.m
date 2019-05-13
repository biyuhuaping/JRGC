//
//  UCFTelAlertView.m
//  JRGC
//
//  Created by zrc on 2019/1/22.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFTelAlertView.h"

@implementation UCFTelAlertView

- (instancetype)initWithNotiMessage:(NSString *)message
{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        
        UIView *whiteView = [[UIView alloc] init];
        whiteView.backgroundColor = [UIColor whiteColor];
        whiteView.frame = CGRectMake(30, 0, ScreenWidth - 60, 400);
        whiteView.clipsToBounds = YES;
        whiteView.layer.cornerRadius = 5.0f;
        [self addSubview:whiteView];
        
        
        CGFloat offY = 0.0f;
        UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, CGRectGetWidth(whiteView.frame), 21)];
        lab1.text = @"客户维护";
        lab1.font = [UIFont systemFontOfSize:20.0f];
        lab1.textColor = [Color color:PGColorOptionTitleBlack];
        lab1.textAlignment = NSTextAlignmentCenter;
        [whiteView addSubview:lab1];
        offY += CGRectGetMaxY(lab1.frame);
        offY += 20;
        
        UILabel *desLab1 = [[UILabel alloc] init];
        desLab1.text = message;
        CGSize size = [Common getStrHeightWithStr:message AndStrFont:13 AndWidth:CGRectGetWidth(whiteView.frame) - 30];
        desLab1.numberOfLines = 0;
        desLab1.textColor = [Color color:PGColorOptionTitleGray];
        desLab1.font = [UIFont systemFontOfSize:13.0f];
        desLab1.frame = CGRectMake(15, offY, CGRectGetWidth(whiteView.frame) - 30, size.height);
        [whiteView addSubview:desLab1];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(desLab1.frame) + 10, CGRectGetWidth(whiteView.frame) - 30, 0.5)];
        lineView.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
        [whiteView addSubview:lineView];
        
        UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(lineView.frame) + 20, CGRectGetWidth(whiteView.frame) - 30, 21)];
        lab2.text = @"联系客服";
        lab2.font = [UIFont systemFontOfSize:20.0f];
        lab2.textColor = [Color color:PGColorOptionTitleBlack];;
        lab2.textAlignment = NSTextAlignmentCenter;
        [whiteView addSubview:lab2];
        
        UILabel *desLab2 = [[UILabel alloc] init];
        desLab2.text = @"呼叫:400-0322-988";
        desLab2.textColor =  [Color color:PGColorOptionTitleGray];;
        desLab2.font = [UIFont systemFontOfSize:13.0f];
        desLab2.textAlignment = NSTextAlignmentCenter;
        desLab2.frame = CGRectMake(15, CGRectGetMaxY(lab2.frame) + 10, CGRectGetWidth(whiteView.frame) - 30, 15);
        [whiteView addSubview:desLab2];
        
        UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        button1.frame = CGRectMake(15, CGRectGetMaxY(desLab2.frame) + 20, (CGRectGetWidth(whiteView.frame) - 30)/2 - 10, 40);
        [button1 setBackgroundColor:[UIColor colorWithRed:99/255.0f green:144/255.0f blue:198/255.0f alpha:1]];
        [button1 setTitle:@"取消" forState:UIControlStateNormal];
        button1.clipsToBounds = YES;
        [button1 addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        button1.layer.cornerRadius = 4.0f;
        [whiteView addSubview:button1];
        
        UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        button2.frame = CGRectMake(CGRectGetMaxX(button1.frame) + 20, CGRectGetMaxY(desLab2.frame) + 20, CGRectGetWidth(button1.frame), 40);
        [button2 setBackgroundColor: [Color color:PGColorOptionTitlerRead]];
        [button2 setTitle:@"立即拨打" forState:UIControlStateNormal];
        button2.clipsToBounds = YES;
            [button2 addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        button2.layer.cornerRadius = 4.0f;
        [whiteView addSubview:button2];
        
        offY = CGRectGetMaxY(button2.frame) + 20;
        whiteView.frame = CGRectMake(30, (ScreenHeight - offY)/2, ScreenWidth - 60, offY);
    }
    return self;
}
- (void)click
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4000322988"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    [self hide];
}
- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}
- (void)hide {
    [self removeFromSuperview];
}

@end
