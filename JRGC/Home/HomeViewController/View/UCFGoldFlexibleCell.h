//
//  UCFGoldFlexibleCell.h
//  JRGC
//
//  Created by njw on 2017/8/14.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UCFHomeListCellPresenter, UCFGoldFlexibleCell, UCFHomeListCellModel;
@protocol UCFGoldFlexibleCellDelegate <NSObject>

- (void)homelistCell:(UCFGoldFlexibleCell *)homelistCell didClickedBuyButtonWithModel:(UCFHomeListCellModel *)model;
@end

@interface UCFGoldFlexibleCell : UITableViewCell
@property (strong, nonatomic) UCFHomeListCellPresenter *presenter;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) id<UCFGoldFlexibleCellDelegate> delegate;
@end
