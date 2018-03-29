//
//  UCFGoldCashThreeCell.h
//  JRGC
//
//  Created by njw on 2017/7/19.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UCFGoldCashThreeCell;
@protocol UCFGoldCashThreeCellDelegate <NSObject>
- (void)goldCashcell:(UCFGoldCashThreeCell *)cashCell didClickCashButton:(UIButton *)cashButton;
@end

@interface UCFGoldCashThreeCell : UITableViewCell
@property (weak, nonatomic) id<UCFGoldCashThreeCellDelegate> delegate;
@end
