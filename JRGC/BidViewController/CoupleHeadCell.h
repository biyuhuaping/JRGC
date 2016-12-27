//
//  CoupleHeadCell.h
//  JRGC
//
//  Created by 金融工场 on 15/5/21.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoupleHeadCell : UITableViewCell
@property(nonatomic, strong)UILabel     *needsInvestLabel;
@property(nonatomic, strong)UILabel     *canInvestLabel;
@property(nonatomic, strong)UIView      *keYongBaseView;
@property(nonatomic, strong)UILabel     *keYongTipLabel;
@property(nonatomic, strong)UILabel     *KeYongMoneyLabel;
@property(nonatomic, strong)UILabel     *totalKeYongTipLabel;
@property(nonatomic, strong)UIView      *inputBaseView;
@property(nonatomic, strong)UITextField      *inputMoneyTextFieldLable;
@property(nonatomic, strong)UIButton         *allTouziBtn;

@end
