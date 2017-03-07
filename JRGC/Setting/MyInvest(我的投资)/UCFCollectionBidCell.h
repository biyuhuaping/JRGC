//
//  UCFCollectionBidCell.h
//  JRGC
//
//  Created by njw on 2017/2/20.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NZLabel.h"
@class UCFCollectionBidCell, UCFCollectionBidModel;
@protocol UCFCollectionBidCellDelegate <NSObject>

- (void)collectionCell:(UCFCollectionBidCell *)currentView didClickedBatchBidButton:(UIButton *)batchBidButton;
- (void)collectionCell:(UCFCollectionBidCell *)currentView didClickedMoreButton:(UIButton *)MoreButton;

@end

@interface UCFCollectionBidCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *collectionBidName;
@property (weak, nonatomic) IBOutlet UIView *progressValueView;
@property (weak, nonatomic) IBOutlet NZLabel *preYearRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *returnModeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moreValueLabel;
@property (nonatomic, weak) id<UCFCollectionBidCellDelegate> delegate;

@property (nonatomic, strong) UCFCollectionBidModel *collectionBidModel;
@end
