//
//  UCFGoldFlexibleCell.h
//  JRGC
//
//  Created by njw on 2017/8/14.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UCFHomeListCellPresenter, UCFGoldFlexibleCell, UCFHomeListCellModel, UCFGoldModel;
@protocol UCFGoldFlexibleCellDelegate <NSObject>
@optional
- (void)homelistCell:(UCFGoldFlexibleCell *)homelistCell didClickedBuyButtonWithModel:(UCFHomeListCellModel *)model;
- (void)goldList:(UCFGoldFlexibleCell *)goldListCell didClickedBuyFilexGoldWithModel:(UCFGoldModel *)model;

@end

@interface UCFGoldFlexibleCell : UITableViewCell
@property (strong, nonatomic) UCFHomeListCellPresenter *presenter;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) id<UCFGoldFlexibleCellDelegate> delegate;
@property (strong, nonatomic) UCFGoldModel *goldmodel;
@end
