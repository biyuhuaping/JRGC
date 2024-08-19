//
//  UCFCollectionDetailCell.h
//  JRGC
//
//  Created by hanqiyuan on 2017/2/16.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UCFCollectionDetailCell;

@protocol UCFCollectionDetailCellDelegare <NSObject>

@optional

- (void)cell:(UCFCollectionDetailCell*)cell clickInvestBtn:(UIButton *)button withModel:(NSDictionary*)dataDict;

@end

@interface UCFCollectionDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *canBuyAmtLab;//可投额
@property (weak, nonatomic) IBOutlet UILabel *childPrdClaimNameLab;//子标名称
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;//状态btn
@property (weak, nonatomic) IBOutlet UILabel *totalAmtLab; //融资额
@property(assign ,nonatomic) id<UCFCollectionDetailCellDelegare> delegate;

@property (strong,nonatomic) NSDictionary *dataDict;

- (IBAction)clickInvestmentBtn:(UIButton *)sender;
@end
