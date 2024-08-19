//
//  UCFGoldRechargeRecordCell.h
//  JRGC
//
//  Created by njw on 2017/7/19.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UCFGoldRechargeHistoryModel;
@interface UCFGoldRechargeRecordCell : UITableViewCell
@property (weak, nonatomic) UITableView *tableview;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) UCFGoldRechargeHistoryModel *model;
@end
