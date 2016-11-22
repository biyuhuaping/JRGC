//
//  UCFBindCardTwoTableViewCell.h
//  JRGC
//
//  Created by NJW on 15/8/19.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UCFBindCardTwoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *bindBankLocation;

+ (instancetype)cellWithTableView:(UITableView *)tableview;
@end
