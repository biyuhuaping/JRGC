//
//  UCFBindCardOneTableViewCell.h
//  JRGC
//
//  Created by NJW on 15/5/11.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UCFBindCardOneTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *bindCard;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableview;
@end
