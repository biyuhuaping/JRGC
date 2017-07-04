//
//  UCFCalendarHeaderView.h
//  TestCalenar
//
//  Created by njw on 2017/6/23.
//  Copyright © 2017年 njw. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UCFCalendarHeaderView, UCFCalendarCollectionViewCell;
@protocol UCFCalendarHeaderViewDelegate <NSObject>

- (void)calendar:(UCFCalendarCollectionViewCell *)calendar didClickedDay:(NSString *)day;

@end

@interface UCFCalendarHeaderView : UIView
@property(assign,nonatomic) SelectAccoutType accoutType;//选择的账户 默认是P2P账户 hqy添加
@property (strong, nonatomic) NSDictionary *calendarHeaderInfo;
@property (weak, nonatomic) id<UCFCalendarHeaderViewDelegate> delegate;
@property (copy, nonatomic) NSString *currentDay;
+ (CGFloat)viewHeight;
@end
