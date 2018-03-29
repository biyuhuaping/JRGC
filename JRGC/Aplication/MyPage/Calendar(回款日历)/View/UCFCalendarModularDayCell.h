//
//  UCFCalendarModularDayCell.h
//  JRGC
//
//  Created by 张瑞超 on 2017/10/11.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCFCalendarGroup.h"

@interface UCFCalendarModularDayCell : UITableViewCell
@property (strong, nonatomic) UCFCalendarGroup *group;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) UITableView *tableview;
@end
