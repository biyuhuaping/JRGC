//
//  UCFCalendarModularHeaderView.h
//  JRGC
//
//  Created by 张瑞超 on 2017/10/11.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UCFCalendarModularHeaderView, UCFCalendarCollectionViewCell;
@protocol UCFCalendarModularHeaderViewDelegate <NSObject>

- (void)calendar:(UCFCalendarCollectionViewCell *)calendar didClickedDay:(NSString *)day;
- (void)calendar:(UCFCalendarModularHeaderView *)calendar didClickedHeader:(UIButton *)headerBtn;
@end
@interface UCFCalendarModularHeaderView : UIView
@property(assign,nonatomic) SelectAccoutType accoutType;//选择的账户 默认是P2P账户 hqy添加
@property (strong, nonatomic) NSDictionary *calendarHeaderInfo;
@property (weak, nonatomic) id<UCFCalendarModularHeaderViewDelegate> delegate;
@property (copy, nonatomic) NSString *currentDay;
@property (weak, nonatomic) IBOutlet UILabel *currentDayLabel;
@property (weak, nonatomic) UICollectionView *calendar;
@property (weak, nonatomic) UILabel *monthLabel;
+ (CGFloat)viewHeight;
- (void)getClendarInfoWithMonth:(NSString *)month;
- (void)headerViewInitUI;
@end
