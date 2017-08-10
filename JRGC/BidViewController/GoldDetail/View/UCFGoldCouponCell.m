//
//  UCFGoldCouponCell.m
//  JRGC
//
//  Created by hanqiyuan on 2017/8/7.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldCouponCell.h"
#import "UILabel+Misc.h"
@implementation UCFGoldCouponCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(UCFGoldCouponModel *)model
{
    /*
     
     goldAccount	返金克重	string
     goldCouponId	黄金券ID	string
     investMin	最小投资克重	string
     investPeriod	投资期限	string
     issueTime	券发放时间	string
     overdueTime	过期时间	string
     remark	备注字段	string
     validityStatus	是否即将过期	string	0是，1否
     
     */
    self.goldAccountLab.text  = [NSString stringWithFormat:@"%@克",model.goldAccount];
    [self.goldAccountLab setFont:[UIFont systemFontOfSize:20] string:@"克"];
    self.remarkLab.text = model.remark;
    self.overdueTimeLab.text = [NSString stringWithFormat:@"有效期至%@",model.overdueTime];
    self.investMinLab.text  = [NSString stringWithFormat:@"购买%@克可用",model.investMin];
    self.investPeriodLab.text  = [NSString stringWithFormat:@"购买期限≥%@天可用",model.investPeriod];
    if ([model.validityStatus boolValue]) {
        self.angleView.hidden = NO;
        UILabel *tipLabel = [[UILabel alloc] init];
        tipLabel.frame = CGRectMake(3, 4, CGRectGetWidth(_angleView.frame) - 6, CGRectGetHeight(_angleView.frame) - 8);
        tipLabel.text = @"即将过期";
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.textColor = [UIColor whiteColor];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.font = [UIFont systemFontOfSize:11.0f];
        [self.angleView addSubview:tipLabel];
    }else{
        self.angleView.hidden = YES;
    }
    self.cellBtn.selected = model.isSelectedStatus;
}
@end
