//
//  InvestmentDetailTableViewCell.h
//  JRGC
//
//  Created by HeJing on 15/4/27.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UCFInvestDetailModel;
@interface InvestmentDetailTableViewCell : UITableViewCell
@property(assign,nonatomic) SelectAccoutType accoutType;//选择的账户 默认是P2P账户 hqy添加

- (void)setValueOfTableViewCellLabel:(UCFInvestDetailModel *)model type:(NSString*)tp;

@end
