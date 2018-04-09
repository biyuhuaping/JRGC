//
//  UCFExtractGoldCell.h
//  JRGC
//
//  Created by njw on 2017/11/10.
//  Copyright © 2017年 JRGC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UCFExtractGoldModel;
@protocol UCFExtractGoldCellDelegate <NSObject>
- (void)bottomButton:(UIButton *)button ClickedWithModel:(UCFExtractGoldModel *)extractGoldModel;
@end

@class UCFExtractGoldFrameModel;
@interface UCFExtractGoldCell : UITableViewCell
@property (nonatomic, strong) UCFExtractGoldFrameModel *frameModel;
@property (weak, nonatomic) id<UCFExtractGoldCellDelegate> delegate;
@end
