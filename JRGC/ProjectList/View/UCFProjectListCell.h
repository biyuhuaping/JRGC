//
//  UCFProjectListCell.h
//  JRGC
//
//  Created by NJW on 2016/11/21.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    UCFProjectListCellTypeProject = 0,
    UCFProjectListCellTypeTransfer,
    UCFProjectListCellTypeBatchBid,
} UCFProjectListCellType;

@class UCFProjectListCell, UCFProjectListModel, UCFTransferModel, UCFBatchBidModel;
@protocol UCFProjectListCellDelegate <NSObject>
@optional
- (void)cell:(UCFProjectListCell*)cell clickInvestBtn:(UIButton *)button withModel:(UCFProjectListModel*)model;
- (void)cell:(UCFProjectListCell*)cell clickInvestBtn1:(UIButton *)button withModel:(UCFTransferModel *)model;
- (void)cell:(UCFProjectListCell*)cell clickInvestBtn2:(UIButton *)button withModel:(UCFBatchBidModel *)model;

@end

@interface UCFProjectListCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *minInvestLab;   //起投金额
@property (strong, nonatomic) IBOutlet UILabel *remainingLab;   //可投金额
@property (nonatomic, strong) UCFProjectListModel *model;
@property (nonatomic, strong) UCFTransferModel *transferModel;
@property (nonatomic, strong) UCFBatchBidModel *batchBidModel;
@property (nonatomic, weak) id<UCFProjectListCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *investButton;
@property (nonatomic, assign) UCFProjectListCellType type;

@end
