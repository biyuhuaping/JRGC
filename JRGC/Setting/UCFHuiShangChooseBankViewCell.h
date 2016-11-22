//
//  UCFHuiShangChooseBankViewCell.h
//  JRGC
//
//  Created by 狂战之巅 on 16/8/15.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCFHuiShangChooseBankViewController.h"

@interface UCFHuiShangChooseBankViewCell : UITableViewCell

@property (nonatomic, assign) UCFHuiShangChooseBankViewController *db;

@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *bankName;
@property (strong, nonatomic) IBOutlet UIImageView *isQuick;

- (void)showInfo:(id)data;

@end
