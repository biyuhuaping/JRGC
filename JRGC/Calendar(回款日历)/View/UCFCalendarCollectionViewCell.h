//
//  UCFCalendarCollectionViewCell.h
//  TestCalenar
//
//  Created by njw on 2017/7/2.
//  Copyright © 2017年 njw. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UCFCalendarCollectionViewCell;
@protocol UCFCalendarCollectionViewCellDelegate <NSObject>

- (void)calendar:(UCFCalendarCollectionViewCell *)calendarCell didClickedDay:(NSString *)day;

@end

@interface UCFCalendarCollectionViewCell : UICollectionViewCell
@property (copy, nonatomic) NSString *month;
@property (copy, nonatomic) NSMutableArray *days;
@property (weak, nonatomic) id<UCFCalendarCollectionViewCellDelegate> delegate;
@end
