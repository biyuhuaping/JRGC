//
//  UCFGoldIncreListCell.h
//  JRGC
//
//  Created by njw on 2017/8/21.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UCFGoldIncreaseListModel;
@interface UCFGoldIncreListCell : UITableViewCell
@property (nonatomic, strong) UCFGoldIncreaseListModel *model;
@property (nonatomic, weak) UITableView *tableview;
@property (nonatomic, strong) NSIndexPath *indexPath;
@end
