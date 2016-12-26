//
//  RechargeListCell.h
//  JRGC
//
//  Created by 金融工场 on 15/5/19.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RechargeListCell : UITableViewCell
@property(nonatomic, strong)UILabel     *orderTipLabel;
@property(nonatomic, strong)UILabel     *orderNumLabel;
@property(nonatomic, strong)UILabel     *statueLabel;
@property(nonatomic, strong)UILabel     *moneyTipLabel;
@property(nonatomic, strong)UILabel     *moneyLabel;
@property(nonatomic, strong)UILabel     *beginLabel;
@property(nonatomic, strong)UILabel     *timeValueLabel;
@property(nonatomic, strong)NSDictionary    *dataDict;
@end
