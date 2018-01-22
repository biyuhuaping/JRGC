//
//  UCFTableCellOne.h
//  JRGC
//
//  Created by NJW on 16/8/9.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UCFTableCellOne : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *addedProfitTipLabel;
@property (weak, nonatomic) IBOutlet UILabel *addedProfit;
@property (weak, nonatomic) IBOutlet UILabel *availableBalance;
@property (weak, nonatomic) IBOutlet UILabel *frozenMoney;
// 用户信息
@property (nonatomic, strong) NSDictionary *accountInfo;

@end
