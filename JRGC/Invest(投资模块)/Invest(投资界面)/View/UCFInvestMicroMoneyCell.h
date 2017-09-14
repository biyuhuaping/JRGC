//
//  UCFInvestMicroMoneyCell.h
//  JRGC
//
//  Created by njw on 2017/9/7.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UCFMicroMoneyModel;

@class UCFInvestMicroMoneyCell, UCFMicroMoneyModel, UCFGoldModel;
@protocol UCFInvestMicroMoneyCellDelegate <NSObject>

- (void)homelistCell:(UCFInvestMicroMoneyCell *)homelistCell didClickedProgressViewAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface UCFInvestMicroMoneyCell : UITableViewCell
@property (nonatomic, strong) UCFMicroMoneyModel *microMoneyModel;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) id<UCFInvestMicroMoneyCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (strong, nonatomic) UCFMicroMoneyModel *honerListModel;
@property (strong, nonatomic) UCFGoldModel *goldModel;
@end
