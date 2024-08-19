//
//  UCFGoldRebateCell.h
//  JRGC
//
//  Created by 张瑞超 on 2017/9/5.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UCFGoldRebateCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *bidName;
@property (weak, nonatomic) IBOutlet UILabel *bidInterest;
@property (weak, nonatomic) IBOutlet UILabel *bidTime;
@property (weak, nonatomic) IBOutlet UILabel *bidDealType;
@property (weak, nonatomic) IBOutlet UILabel *bidState;
@property (weak, nonatomic) IBOutlet UILabel *investPeopleName;
@property (weak, nonatomic) IBOutlet UILabel *investBeginTime;
@property (weak, nonatomic) IBOutlet UILabel *investQXTime;
@property (weak, nonatomic) IBOutlet UILabel *investPlanDate;
@property (weak, nonatomic) IBOutlet UILabel *investActualTime;
@property (weak, nonatomic) IBOutlet UILabel *investNum;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *auctualDateHeight;
@property (weak, nonatomic) IBOutlet UILabel *myFeedBackMoney;
@end
