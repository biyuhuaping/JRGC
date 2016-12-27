//
//  UCFFundDetialTableViewCell.h
//  JRGC
//
//  Created by NJW on 15/5/4.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FundsDetailFrame;
@interface UCFFundDetialTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableview;
@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, strong) FundsDetailFrame *fundsFrame;
@end
