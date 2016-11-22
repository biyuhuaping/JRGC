//
//  UCFExchangeCell.h
//  JRGC
//
//  Created by biyuhuaping on 16/4/25.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCFExchangeModel.h"

@interface UCFExchangeCell : UITableViewCell

@property (strong, nonatomic) UCFExchangeModel *exchangeModel;
+ (instancetype)cellWithTableView:(UITableView *)tableview;

@end
