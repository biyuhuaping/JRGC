//
//  UCFBankCard.m
//  JRGC
//
//  Created by NJW on 15/5/22.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFBankCard.h"
#import "Common.h"

@interface UCFBankCard ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bankImageViewTopSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bankImageViewLeftSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bankImageViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bankImageViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bankImageAndTitleSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bankTypeTrailSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bankCardNoLeftSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bankCardNoBottomSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bankCardNoTopSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *useNameLeftSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *quickPayTrailSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *quickPayBottomSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *quickPayWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *quickPayHeight;

@end

@implementation UCFBankCard

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"UCFBankCard" owner:self options:nil] lastObject];
        self.frame = frame;
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    self.image_bankCardValuable.hidden = YES;//***“银行卡失效”文字初始化时候隐藏
    NSString *machineType = [Common machineName];
    if ([machineType isEqualToString:@"4"] || [machineType isEqualToString:@"5"]) {
        
    }
    else if ([machineType isEqualToString:@"6"]) {
        self.bankImageViewTopSpace.constant = 10;
        self.bankImageViewLeftSpace.constant = 22;
        self.bankImageViewWidth.constant = 40;
        self.bankImageViewHeight.constant = 40;
        self.bankImageAndTitleSpace.constant = 7;
//        self.bankTypeTrailSpace.constant = ;
        self.bankCardNoLeftSpace.constant = 24;
        self.bankCardNoBottomSpace.constant = 20;
        self.bankCardNoTopSpace.constant = 12;
        self.useNameLeftSpace.constant = self.bankCardNoLeftSpace.constant;
        self.quickPayTrailSpace.constant = 24;
        self.quickPayBottomSpace.constant = 20;
        self.quickPayWidth.constant = 42;
        self.quickPayHeight.constant = 23;
    }
    else if ([machineType isEqualToString:@"6Plus"]) {
        self.bankImageViewTopSpace.constant = 10;
        self.bankImageViewLeftSpace.constant = 24;
        self.bankImageViewWidth.constant = 43;
        self.bankImageViewHeight.constant = 43;
        self.bankImageAndTitleSpace.constant = 6;
        self.bankTypeTrailSpace.constant = 26;
        self.bankCardNoLeftSpace.constant = 26;
        self.bankCardNoBottomSpace.constant = 22;
        self.bankCardNoTopSpace.constant = 13;
        self.useNameLeftSpace.constant = self.bankCardNoLeftSpace.constant;
        self.quickPayTrailSpace.constant = 26;
        self.quickPayBottomSpace.constant = 22;
        self.quickPayWidth.constant = 46;
        self.quickPayHeight.constant = 26;
    } else {
        self.bankImageViewTopSpace.constant = 10;
        self.bankImageViewLeftSpace.constant = 24;
        self.bankImageViewWidth.constant = 43;
        self.bankImageViewHeight.constant = 43;
        self.bankImageAndTitleSpace.constant = 6;
        self.bankTypeTrailSpace.constant = 26;
        self.bankCardNoLeftSpace.constant = 26;
        self.bankCardNoBottomSpace.constant = 22;
        self.bankCardNoTopSpace.constant = 13;
        self.useNameLeftSpace.constant = self.bankCardNoLeftSpace.constant;
        self.quickPayTrailSpace.constant = 26;
        self.quickPayBottomSpace.constant = 22;
        self.quickPayWidth.constant = 46;
        self.quickPayHeight.constant = 26;
    }
}
//***当银行卡失效的时候页面部分至灰色
-(void)thisBankCardInvaluable:(BOOL)_gray
{
    if(_gray==YES){
    self.quickPayImageView.image = [Common grayImage:self.quickPayImageView.image];
    self.bankCardImageView.image = [Common grayImage:self.bankCardImageView.image];
    self.image_bankCardValuable.hidden = NO;
    }
}
@end
