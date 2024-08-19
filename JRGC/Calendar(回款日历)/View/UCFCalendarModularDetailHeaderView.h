//
//  UCFCalendarModularDetailHeaderView.h
//  JRGC
//
//  Created by 张瑞超 on 2017/10/11.
//  Copyright © 2017年 qinwei. All rights reserved.
//
@class UCFCalendarModularDetailHeaderView, UCFCalendarGroup;
@protocol UCFCalendarModularDetailHeaderView <NSObject>

- (void)calendarDetailHeaderView:(UCFCalendarModularDetailHeaderView *)calendarDetailHeader didClicked:(UIButton  *)button;
@end
#import <UIKit/UIKit.h>

@interface UCFCalendarModularDetailHeaderView : UITableViewHeaderFooterView
@property (weak, nonatomic) id<UCFCalendarModularDetailHeaderView> delegate;
@property (strong, nonatomic) UCFCalendarGroup *group;
@end
