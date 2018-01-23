//
//  CoupleHeadView.h
//  JRGC
//
//  Created by 金融工场 on 15/5/22.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//
@class CoupleHeadView;
@protocol CoupleHeadViewDelegate <NSObject>

- (void)allInvestOrGotoPay:(NSInteger)mark;

@end
#import <UIKit/UIKit.h>

@interface CoupleHeadView : UIView
@property(nonatomic, strong)UILabel     *needsInvestLabel;
@property(nonatomic, strong)UILabel     *canInvestLabel;
@property(nonatomic, strong)UIView      *keYongBaseView;
@property(nonatomic, strong)UILabel     *keYongTipLabel;
@property(nonatomic, strong)UILabel     *KeYongMoneyLabel;
@property(nonatomic, strong)UILabel     *totalKeYongTipLabel;
@property(nonatomic, strong)UILabel     *needInvestMoney;
@property(nonatomic, strong)UIView      *inputBaseView;
@property(nonatomic, strong)UITextField      *inputMoneyTextFieldLable;
@property(nonatomic, strong)UIButton         *allTouziBtn;
@property(nonatomic, assign)id<CoupleHeadViewDelegate> delegate;

@property(assign,nonatomic) SelectAccoutType accoutType;//选择的账户 默认是P2P账户 hqy添加
@end
