//
//  UCFGoldRechargeFourthCell.h
//  JRGC
//
//  Created by njw on 2017/8/10.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UCFGoldRechargeFourthCell;
@protocol UCFGoldRechargeFourthCellDelegate <NSObject>
- (void)goldRechargeCell:(UCFGoldRechargeFourthCell *)goldRechargeCell didClickedCheckButton:(UIButton *)checkButton;
@end;

@interface UCFGoldRechargeFourthCell : UITableViewCell
@property (weak, nonatomic) id<UCFGoldRechargeFourthCellDelegate> delegate;
@end
