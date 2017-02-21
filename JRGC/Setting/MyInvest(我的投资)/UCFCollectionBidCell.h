//
//  UCFCollectionBidCell.h
//  JRGC
//
//  Created by njw on 2017/2/20.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UCFCollectionBidCell;
@protocol UCFCollectionBidCellDelegate <NSObject>

- (void)collectionCell:(UCFCollectionBidCell *)currentView didClickedBatchBidButton:(UIButton *)batchBidButton;
- (void)collectionCell:(UCFCollectionBidCell *)currentView didClickedMoreButton:(UIButton *)MoreButton;

@end

@interface UCFCollectionBidCell : UITableViewCell
@property (nonatomic, weak) id<UCFCollectionBidCellDelegate> delegate;
@end
