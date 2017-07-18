//
//  UCFMyGoldInvestInfoCell.h
//  JRGC
//
//  Created by hanqiyuan on 2017/7/13.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UCFMyGoldInvestInfoCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nmPrdClaimNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *dealGoldPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *purchaseGoldAmountLabel;
@property (strong, nonatomic) IBOutlet UILabel *perGiveGoldAmountLabel;
@property (strong, nonatomic) IBOutlet UIView *hasGiveGoldAmountLabel;
@property (strong, nonatomic) IBOutlet UILabel *startDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *expiredDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderStatusNameLabel;

@property (strong, nonatomic) NSDictionary *dataDict;

@end
