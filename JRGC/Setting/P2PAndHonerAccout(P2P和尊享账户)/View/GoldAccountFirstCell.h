//
//  GoldAccountFirstCell.h
//  JRGC
//
//  Created by 张瑞超 on 2017/7/6.
//  Copyright © 2017年 qinwei. All rights reserved.
//
#import <UIKit/UIKit.h>

@class GoldAccountFirstCell;
@protocol GoldAccountFirstCellDeleage <NSObject>
    - (void)goldAccountFirstCell:(GoldAccountFirstCell *)goldFirstCell didClickedRechargeButton:(UIButton *)button;
    - (void)goldAccountFirstCell:(GoldAccountFirstCell *)goldFirstCell didClickedCashButton:(UIButton *)button;
@end

@interface GoldAccountFirstCell : UITableViewCell
    
@property (weak, nonatomic) id<GoldAccountFirstCellDeleage> delegate;
    
@end
