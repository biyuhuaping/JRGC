//
//  UCFGoldRechargeCell.h
//  JRGC
//
//  Created by njw on 2017/7/13.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UCFGoldRechargeModel, UCFGoldRechargeCell;
@protocol UCFGoldRechargeCellDelegate <NSObject>
- (void)goldCell:(UCFGoldRechargeCell *)goldCell didDialedWithNO:(NSString *)No;
@end

@interface UCFGoldRechargeCell : UITableViewCell
@property (strong, nonatomic) UCFGoldRechargeModel *model;
@property (weak, nonatomic)  id<UCFGoldRechargeCellDelegate> delegate;
@property (strong, nonatomic) NSIndexPath *indexPath;
@end
