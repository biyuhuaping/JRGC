//
//  UCFCalendarDayCell.h
//  JRGC
//
//  Created by njw on 2017/7/4.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UCFCalendarGroup;
@interface UCFCalendarDayCell : UITableViewCell
@property (strong, nonatomic) UCFCalendarGroup *group;
@property (strong, nonatomic) NSIndexPath *indexPath;
@end
