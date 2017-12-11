//
//  UCFAssetProofApplyFirstCell.h
//  JRGC
//
//  Created by hanqiyuan on 2017/12/1.
//  Copyright © 2017年 JRGC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UCFAssetProofListModel.h"
@protocol UCFAssetProofApplyFirstCellDelegate <NSObject>

- (void)gotoAssetProofApplyVC;
- (void)seeAssetProofModel;
@end
@interface UCFAssetProofApplyFirstCell : UITableViewCell
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tipLabel1Height;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tipLabel2Height;
@property (strong, nonatomic) IBOutlet UILabel *tipLabel1;
@property (strong, nonatomic) IBOutlet UILabel *tipLabel2;
@property (nonatomic,assign) id<UCFAssetProofApplyFirstCellDelegate> delegate;
@end
@interface UCFAssetProofApplySecondCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *applyTimeLabel ;//申请时间
@property (weak, nonatomic) IBOutlet UILabel *proofFileNameLabel ;// 文件名称;
@property (weak, nonatomic) IBOutlet UIImageView *applyStatusImageView ;//   开具时间
@property (weak, nonatomic) IBOutlet UILabel *tipLabel ;// 下载或者备注;
@property (weak, nonatomic) IBOutlet UIButton *download;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidth;
@property (strong, nonatomic)UCFAssetProofListModel *assetProofModel;
@end
