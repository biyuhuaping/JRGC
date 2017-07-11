//
//  UCFPickView.h
//  JRGC
//
//  Created by njw on 2017/7/11.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UCFPickView;
@protocol UCFPickViewDelegate <NSObject>

- (void)pickerView:(UCFPickView *)pickerView selectedMonth:(NSString *)month withIndex:(NSInteger)index;

@end

@interface UCFPickView : UIView
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (copy, nonatomic) NSString *currentMonth;
@property (weak, nonatomic) id<UCFPickViewDelegate> delegate;
- (void)show;
- (void)hidden;
@end
