//
//  UCFFriendRecCell1.h
//  JRGC
//
//  Created by biyuhuaping on 16/6/16.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NZLabel.h"
@interface UCFFriendRecCell1 : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lab1;
@property (strong, nonatomic) IBOutlet UILabel *lab2;
@property (strong, nonatomic) IBOutlet UILabel *lab3;
@property (strong, nonatomic) IBOutlet UILabel *lab4;
@property (strong, nonatomic) IBOutlet UILabel *lab5;
@property (strong, nonatomic) IBOutlet UILabel *planLabel;
@property (weak, nonatomic) IBOutlet UILabel *investorLab;
@property (weak, nonatomic) IBOutlet NZLabel *payGoldGram;
@property (weak, nonatomic) IBOutlet UILabel *actulPayDateLab;

@end
