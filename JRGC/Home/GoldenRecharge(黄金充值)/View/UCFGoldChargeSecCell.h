//
//  UCFGoldChargeSecCell.h
//  JRGC
//
//  Created by njw on 2017/8/9.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UCFGoldChargeSecCell;
@protocol UCFGoldChargeSecCellDelegate <NSObject>
- (void)goldRechargeSecCell:(UCFGoldChargeSecCell *)goldRechargeSecCell didClickedConstractWithId:(NSString *)constractId;
@end

@interface UCFGoldChargeSecCell : UITableViewCell
@property (strong, nonatomic) NSArray *constracts;
@property (weak, nonatomic) id<UCFGoldChargeSecCellDelegate> delegate;
@end
