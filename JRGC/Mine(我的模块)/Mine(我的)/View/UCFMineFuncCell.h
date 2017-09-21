//
//  UCFMineFuncCell.h
//  JRGC
//
//  Created by njw on 2017/9/19.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UCFMineFuncCell;
@protocol UCFMineFuncCellDelegate <NSObject>

- (void)mineFuncCell:(UCFMineFuncCell *)mineFuncCell didClickedCalendarButton:(UIButton *)button;
- (void)mineFuncCell:(UCFMineFuncCell *)mineFuncCell didClickedMyReservedButton:(UIButton *)button;
@end

@interface UCFMineFuncCell : UITableViewCell
@property (weak, nonatomic) id<UCFMineFuncCellDelegate> delegate;
@end
