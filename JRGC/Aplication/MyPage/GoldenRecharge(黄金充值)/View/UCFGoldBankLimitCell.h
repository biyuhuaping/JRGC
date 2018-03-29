//
//  UCFGoldBankLimitCell.h
//  JRGC
//
//  Created by njw on 2017/8/10.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UCFGoldLimitedBankModel;
@interface UCFGoldBankLimitCell : UITableViewCell
@property (nonatomic, strong) UCFGoldLimitedBankModel *bankModel;
@property (nonatomic, weak) UITableView *tableview;
@property (nonatomic, strong) NSIndexPath *indexPath;
@end
