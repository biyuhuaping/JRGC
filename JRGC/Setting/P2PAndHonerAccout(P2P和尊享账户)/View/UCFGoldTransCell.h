//
//  UCFGoldTransCell.h
//  JRGC
//
//  Created by 张瑞超 on 2017/7/10.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCFGoldTradeListModel.h"
@interface UCFGoldTransCell : UITableViewCell
@property (nonatomic, strong) UCFGoldTradeListModel *model;
@property (nonatomic, assign) BOOL isEndCell;
@end
