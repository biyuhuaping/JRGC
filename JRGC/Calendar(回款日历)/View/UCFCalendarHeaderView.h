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
- (void)calendar:(UCFCalendarHeaderView *)calendar didClickedHeader:(UIButton *)headerBtn;
@end

@interface UCFCalendarHeaderView : UIView
@property(assign,nonatomic) SelectAccoutType accoutType;//选择的账户 默认是P2P账户 hqy添加
@property (strong, nonatomic) NSDictionary *calendarHeaderInfo;
@property (weak, nonatomic) id<UCFCalendarHeaderViewDelegate> delegate;
@property (copy, nonatomic) NSString *currentDay;
@property (weak, nonatomic) IBOutlet UILabel *currentDayLabel;
@property (weak, nonatomic) UICollectionView *calendar;
@property (weak, nonatomic) UILabel *monthLabel;
+ (CGFloat)viewHeight;
- (void)getClendarInfoWithMonth:(NSString *)month;
- (void)headerViewInitUI;

@end
