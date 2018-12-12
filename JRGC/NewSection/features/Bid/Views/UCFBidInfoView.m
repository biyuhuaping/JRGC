//
//  UCFBidInfoView.m
//  JRGC
//
//  Created by zrc on 2018/12/11.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import "UCFBidInfoView.h"

@interface UCFBidInfoView ()
@property(nonatomic, strong) UILabel *rateLab;              //利率
@property(nonatomic, strong) UILabel *rateTipLab;           //利率提示标签
@property(nonatomic, strong) UILabel *timeLimitLab;         //期限
@property(nonatomic, strong) UILabel *timeLimitTipLab;      //期限提示标签
@property(nonatomic, strong) UILabel *moneyAmountLab;       //可投金额
@property(nonatomic, strong) UILabel *moneyAmountTipLab;    //可投金额
@end

@implementation UCFBidInfoView


- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = UIColorWithRGB(0xffffff);
    }
    return self;
}

- (void)bidLayoutSubViewsFrame
{
    
}

@end
