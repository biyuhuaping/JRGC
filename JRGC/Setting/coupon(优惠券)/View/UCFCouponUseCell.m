//
//  UCFCouponUseCell.m
//  JRGC
//
//  Created by NJW on 15/5/5.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFCouponUseCell.h"
#import "PrintView.h"
#import "UCFToolsMehod.h"
#import "NZLabel.h"

@interface UCFCouponUseCell ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImgeView;       // cell的背景imageview
@property (weak, nonatomic) IBOutlet NZLabel *couponValueLabel;     // 返现券面值
@property (weak, nonatomic) IBOutlet NZLabel *investValueLabel;     // 投资活动
@property (weak, nonatomic) IBOutlet UILabel *investActivityLabel;
@property (weak, nonatomic) IBOutlet UILabel *expireTimeLabel;      // 有效期
@property (strong, nonatomic) IBOutlet NZLabel *symbolLab;          //符号+/¥
@property (weak, nonatomic) PrintView *printView;
@property (strong, nonatomic) IBOutlet NZLabel *inverstPeriodLab;   //使用范围
@property (strong, nonatomic) IBOutlet UILabel *amountLab;          //金额（只在兑换券里显示）

@end

@implementation UCFCouponUseCell

+ (instancetype)cellWithTableView:(UITableView *)tableview
{
    static NSString *Id = @"Coupon";
    UCFCouponUseCell *cell = [tableview dequeueReusableCellWithIdentifier:Id];
    if (!cell) {
        cell = [[UCFCouponUseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        cell.signForOverDue.angleString = @"即将过期";
        cell.signForOverDue.angleStatus = @"2";
        cell.signForOverDue.hidden = YES;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"UCFCouponUseCell" owner:self options:nil] lastObject];
        PrintView *printView = [[PrintView alloc] initWithFrame:self.bgImgeView.bounds andTime:@"xxxx-xx-xx"];
        [printView setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:printView];
        self.printView = printView;
        printView.translatesAutoresizingMaskIntoConstraints = NO;
        NSArray *constraints1H=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[printView]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(printView)];
        NSArray *constraints1V=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[printView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(printView)];
        [self.contentView addConstraints:constraints1H];
        [self.contentView addConstraints:constraints1V];
    }
    return self;
}

- (void)setCouponModel:(UCFCouponModel *)couponModel
{
    NSString *inverstStr =  [couponModel.couponType intValue] == 3 ? @"购买期限":@"投资期限";
    switch ([couponModel.isUsed intValue]) {//isUsed：0可用 1过期 2使用
        case 0: {//未使用
            if ([couponModel.inverstPeriod isEqualToString:@"0"] || [couponModel.inverstPeriod isEqualToString:@""]) {//0 通用   "" 旧返现券
                if ([couponModel.couponType isEqualToString:@"1"]) {
                    _bgImgeView.image = [UIImage imageNamed:@"interest_bg_usable"];
                }else
                    _bgImgeView.image = [UIImage imageNamed:@"coupon_bg_usable_common"];
                _inverstPeriodLab.text = @"任意标可用";
            }else{
                if ([couponModel.couponType isEqualToString:@"1"]) {
                    _bgImgeView.image = [UIImage imageNamed:@"interest_bg_usable"];
                }else
                    _bgImgeView.image = [UIImage imageNamed:@"coupon_bg_usable"];
                _inverstPeriodLab.text = [NSString stringWithFormat:@"%@ ≥%@天 可用",inverstStr,couponModel.inverstPeriod];
                [_inverstPeriodLab setFont:[UIFont boldSystemFontOfSize:10] string:[NSString stringWithFormat:@"≥%@", couponModel.inverstPeriod]];
            }
            [self.printView removeFromSuperview];
            self.printView = nil;
        }
            break;
            
        case 1: {//已过期
            if ([couponModel.inverstPeriod isEqualToString:@"0"] || [couponModel.inverstPeriod isEqualToString:@""]) {//0 通用   "" 旧返现券
                _inverstPeriodLab.text = @"任意标可用";
            }else{
                _inverstPeriodLab.text = [NSString stringWithFormat:@"%@ ≥%@天 可用",inverstStr,couponModel.inverstPeriod];
                [_inverstPeriodLab setFont:[UIFont boldSystemFontOfSize:10] string:[NSString stringWithFormat:@"≥%@", couponModel.inverstPeriod]];
            }
            self.signForOverDue.hidden = YES;
            self.bgImgeView.image = [UIImage imageNamed:@"coupon_bg_unusable"];
            self.printView.conponType = 2;
        }
            break;
            
        case 2: {//已使用
            if ([couponModel.inverstPeriod isEqualToString:@"0"] || [couponModel.inverstPeriod isEqualToString:@""]) {//0 通用   "" 旧返现券
                _inverstPeriodLab.text = @"任意标可用";
            }else{
                _inverstPeriodLab.text = [NSString stringWithFormat:@"%@ ≥%@天 可用",inverstStr,couponModel.inverstPeriod];
                [_inverstPeriodLab setFont:[UIFont boldSystemFontOfSize:10] string:[NSString stringWithFormat:@"≥%@", couponModel.inverstPeriod]];
            }
            self.signForOverDue.hidden = YES;
            self.bgImgeView.image = [UIImage imageNamed:@"coupon_bg_unusable"];
            self.printView.useTime = couponModel.useTime;
        }
            break;
    }
    
    if ([couponModel.couponType isEqualToString:@"1"]) {
        _symbolLab.font = [UIFont boldSystemFontOfSize:18];
        self.couponValueLabel.text = couponModel.backIntrestRate;
        _symbolLab.text = @"+";
        [_couponValueLabel setFont:[UIFont systemFontOfSize:15] string:@"%"];
    }else if ([couponModel.couponType intValue] == 3) {
        self.couponValueLabel.text = @"";
        _symbolLab.font = [UIFont boldSystemFontOfSize:20];
        _symbolLab.text = [NSString stringWithFormat:@"%@克",couponModel.useInvest];
        [ _symbolLab setFont:[UIFont boldSystemFontOfSize:14] string:@"克"];
    }
    else{
        self.couponValueLabel.text = couponModel.useInvest;
        _symbolLab.text = @"¥";
        _symbolLab.font = [UIFont boldSystemFontOfSize:18];
    }
    
    NSString *temp = [UCFToolsMehod AddComma:couponModel.investMultip];
    if([couponModel.couponType intValue] == 3)
    {
        self.investValueLabel.text = [NSString stringWithFormat:@"购买%@g可用", temp];
    }else{
        self.investValueLabel.text = [NSString stringWithFormat:@"投资¥%@可用", temp];
    }
    [_investValueLabel setFont:[UIFont boldSystemFontOfSize:10] string:[NSString stringWithFormat:@"¥%@", temp]];
    self.investActivityLabel.text = couponModel.remark;
    self.expireTimeLabel.text = [NSString stringWithFormat:@"有效期 %@", couponModel.overdueTime];

    self.signForOverDue.hidden = ([couponModel.flag integerValue] == 0)?NO:YES;
    self.donateButton.hidden = ([couponModel.isDonateEnable integerValue] == 0)?YES:NO;//是否可赠送	0：否 1：是
}

@end
