//
//  UCFExtractViewCell.h
//  JRGC
//
//  Created by hanqiyuan on 2017/11/6.
//  Copyright © 2017年 JRGC. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "UCFDrawGoldModel.h"

@class UCFExtractViewCell ,UCFDrawGoldModel;
@protocol UCFExtractViewCellDelegate <NSObject> 
- (void)clickSubtractBtnCell:(UCFExtractViewCell *)cell withgoldModel:(UCFDrawGoldModel *)goldModel;
- (void)clickAddBtnCell:(UCFExtractViewCell *)cell withgoldModel:(UCFDrawGoldModel *)goldModel;
@end

@interface UCFExtractViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *goldGoodsNumberLabel;
@property(strong ,nonatomic)  UCFDrawGoldModel  *goldModel;
@property(assign ,nonatomic)  id<UCFExtractViewCellDelegate>  delegate;
@end
