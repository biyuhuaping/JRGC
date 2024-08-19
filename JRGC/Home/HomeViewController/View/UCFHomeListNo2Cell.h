//
//  UCFHomeListNo2Cell.h
//  JRGC
//
//  Created by njw on 2017/7/31.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UCFHomeListCellPresenter;
@interface UCFHomeListNo2Cell : UITableViewCell
@property (strong, nonatomic) UCFHomeListCellPresenter *presenter;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) UITableView *tableView;
@end
