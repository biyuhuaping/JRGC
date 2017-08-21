//
//  UCFHomeInvestCell.h
//  JRGC
//
//  Created by njw on 2017/7/31.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UCFHomeListCellPresenter, UCFHomeInvestCell, UCFMicroMoneyModel;
@protocol UCFHomeInvestCellDelegate <NSObject>
@optional
- (void)homeInvestCell:(UCFHomeInvestCell *)homeInvestCell didClickedInvestButtonAtIndexPath:(NSIndexPath *)indexPath;
- (void)microMoneyListCell:(UCFHomeInvestCell *)microMoneyCell didClickedInvestButtonWithModel:(UCFMicroMoneyModel *)model;
@end

@interface UCFHomeInvestCell : UITableViewCell
@property (strong, nonatomic) UCFHomeListCellPresenter *presenter;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) id<UCFHomeInvestCellDelegate> delegate;
@property (strong, nonatomic) UCFMicroMoneyModel *microModel;
@end
