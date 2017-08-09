//
//  UCFColdChargeThirdCell.h
//  JRGC
//
//  Created by njw on 2017/8/9.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UCFColdChargeThirdCell;
@protocol UCFColdChargeThirdCellDelegate <NSObject>
- (void)goldRechargeCell:(UCFColdChargeThirdCell *)rechargeCell didClickRechargeButton:(UIButton *)rechargeButton;
@end

@interface UCFColdChargeThirdCell : UITableViewCell
@property (weak, nonatomic) id<UCFColdChargeThirdCellDelegate> delegate;
@end
