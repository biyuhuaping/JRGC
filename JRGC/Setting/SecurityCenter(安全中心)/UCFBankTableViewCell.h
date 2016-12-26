//
//  UCFBankTableViewCell.h
//  JRGC
//
//  Created by NJW on 15/5/21.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UCFBankModel;
@interface UCFBankTableViewCell : UITableViewCell

@property (nonatomic, strong) UCFBankModel *bankModel;

+ (instancetype)cellWithTableView:(UITableView *)tableview;
@end
