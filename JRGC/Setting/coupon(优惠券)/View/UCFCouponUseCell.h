//
//  UCFCouponUseCell.h
//  JRGC
//
//  Created by NJW on 15/5/5.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCFCouponModel.h"
#import "UCFAngleView.h"

@interface UCFCouponUseCell : UITableViewCell

@property (strong, nonatomic) UCFCouponModel *couponModel;
@property (strong, nonatomic) IBOutlet UIButton *donateButton;      //赠送按钮
@property (strong, nonatomic) IBOutlet UCFAngleView *signForOverDue;// 过期标志

+ (instancetype)cellWithTableView:(UITableView *)tableview;

@end
