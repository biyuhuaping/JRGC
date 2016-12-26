//
//  UCFGivingPointCell.h
//  JRGC
//  返息券样式
//  Created by 秦 on 2016/11/9.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCFCouponModel.h"

@interface UCFGivingPointCell : UITableViewCell

@property (strong, nonatomic) UCFCouponModel *couponModel;
@property (strong, nonatomic) IBOutlet UIButton *donateButton;      //赠送按钮

+ (instancetype)cellWithTableView:(UITableView *)tableview;

@end
