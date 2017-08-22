//
//  UCFGoldCashButtonCell.h
//  JRGC
//
//  Created by njw on 2017/8/15.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UCFGoldCashButtonCell;
@protocol UCFGoldCashButtonCellDelegate <NSObject>
- (void)goldCashcell:(UCFGoldCashButtonCell *)cashCell didClickCashGoldButton:(UIButton *)cashButton;
@end
@interface UCFGoldCashButtonCell : UITableViewCell
@property (nonatomic, weak) id<UCFGoldCashButtonCellDelegate> delegate;
@property (nonatomic, assign) BOOL canCash;
@end
