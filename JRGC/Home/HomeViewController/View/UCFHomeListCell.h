//
//  UCFHomeListCell.h
//  JRGC
//
//  Created by njw on 2017/5/6.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCFHomeListCellPresenter.h"
#import "UCFHomeListCellModel.h"

@class UCFHomeListCell, UCFHomeListCellPresenter, UCFMicroMoneyModel;
@protocol UCFHomeListCellDelegate <NSObject>

- (void)homelistCell:(UCFHomeListCell *)homelistCell didClickedProgressViewWithPresenter:(UCFHomeListCellModel *)model;
@end

@protocol UCFHomeListCellHonorDelegate <NSObject>

- (void)homelistCell:(UCFHomeListCell *)homelistCell didClickedProgressViewAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface UCFHomeListCell : UITableViewCell
@property (strong, nonatomic) UCFHomeListCellPresenter *presenter;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) UITableView *tableView;
@property (weak, nonatomic) id<UCFHomeListCellDelegate> delegate;
@property (weak, nonatomic) id<UCFHomeListCellHonorDelegate> honorDelegate;
@property (weak, nonatomic) UCFMicroMoneyModel *microMoneyModel;
@end
