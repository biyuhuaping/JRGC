//
//  UCFCalendarDetailHeaderView.h
//  TestCalenar
//
//  Created by njw on 2017/7/2.
//  Copyright © 2017年 njw. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UCFCalendarDetailHeaderView, UCFCalendarGroup;
@protocol UCFCalendarDetailHeaderViewDelegate <NSObject>

- (void)calendarDetailHeaderView:(UCFCalendarDetailHeaderView *)calendarDetailHeader didClicked:(UIButton  *)button;

@end

@interface UCFCalendarDetailHeaderView : UITableViewHeaderFooterView
@property (weak, nonatomic) id<UCFCalendarDetailHeaderViewDelegate> delegate;
@property (strong, nonatomic) UCFCalendarGroup *group;
@end
