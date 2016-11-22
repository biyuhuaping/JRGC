//
//  UCFFundsDetailTableViewCell.h
//  JRGC
//
//  Created by NJW on 15/4/28.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FundsDetailModel;
@interface UCFFundsDetailTableViewCell : UITableViewCell

@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *value;

@property (nonatomic, strong) FundsDetailModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
