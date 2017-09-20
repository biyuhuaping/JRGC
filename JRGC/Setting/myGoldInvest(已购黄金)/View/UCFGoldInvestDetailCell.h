//
//  UCFGoldInvestDetailCell.h
//  JRGC
//
//  Created by hanqiyuan on 2017/7/13.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UCFGoldInvestDetailCellDelegate <NSObject>

@optional

-(void)gotoGoldDetialVC;

@end

@interface UCFGoldInvestDetailCell : UITableViewCell

@property(nonatomic,assign)id<UCFGoldInvestDetailCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *expiredDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *expiredDateStrLabel;
@property (weak, nonatomic) IBOutlet UILabel *perGiveGoldAmount;
@property (weak, nonatomic) IBOutlet UILabel *nmPrdClaimNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *periodTermLabel;
- (IBAction)gotoGoldDetialVC:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *dealGoldPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentTypeLabel;
@property (nonatomic,strong)NSDictionary *dataDict;

@end


@interface UCFGoldInvestDetailSecondCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *hasGiveGoldAmountLabel;//	已获增金克重	string
@property (weak, nonatomic) IBOutlet UILabel *perGiveGoldAmountLabel;//	预期增金克重	string
@property (weak, nonatomic) IBOutlet UILabel *purchaseGoldAmountLabel;//	购买黄金克重	string
@property (weak, nonatomic) IBOutlet UILabel *totalGoldAmountLabel;
@property (nonatomic,strong)NSDictionary *dataDict;

@end


@interface UCFGoldInvestDetailFourCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *paymentType;

@property (nonatomic,strong)NSDictionary *dataDict;

@end
@interface UCFGoldInvestDetailFiveCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewLeft;
@property (weak, nonatomic) IBOutlet UILabel *refundDateLabel;//回金日期
@property (weak, nonatomic) IBOutlet UILabel *refundGoldAmountLabel;//回金克重
@property (weak, nonatomic) IBOutlet UILabel *refundTypeLabel;//回金类型	string	买金/增金
@property (weak, nonatomic) IBOutlet UILabel *refundStatusLabel;//回金状态	string	未回/已回
@property (nonatomic,strong)NSDictionary *dataDict;

@end
