//
//  UCFGoldIncreTransFirstCell.h
//  JRGC
//
//  Created by njw on 2017/8/22.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UCFGoldIncreTransListModel, UCFGoldIncreSecCell;
@interface UCFGoldIncreTransListCell : UITableViewCell
@property (nonatomic, strong) UCFGoldIncreTransListModel *model;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) UITableView *tableview;
@end
