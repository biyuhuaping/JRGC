//
//  SubInvestmentCell.h
//  JRGC
//
//  Created by 金融工场 on 15/6/29.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "InvestmentCell.h"

@interface SubInvestmentCell : InvestmentCell

@property (nonatomic,strong)NSString *p2POrHonerType;//账户类型
@property (weak, nonatomic) IBOutlet UIButton *msgButton;

@end
