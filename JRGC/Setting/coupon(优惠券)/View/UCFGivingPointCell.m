//
//  UCFGivingPointCell.m
//  JRGC
//
//  Created by 秦 on 2016/11/9.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFGivingPointCell.h"
#import "PrintView.h"
#import "NZLabel.h"
#import "UCFToolsMehod.h"

@interface UCFGivingPointCell ()

@property (strong, nonatomic) IBOutlet UIImageView *bgImgeView;     // cell的背景imageview
@property (strong, nonatomic) IBOutlet NZLabel *symbolLab;          // 符号+/¥
@property (strong, nonatomic) IBOutlet NZLabel *couponValueLabel;   // 返现券面值
@property (strong, nonatomic) IBOutlet NZLabel *investValueLabel;   // 投资¥%@可用
@property (strong, nonatomic) IBOutlet NZLabel *inverstPeriodLab;   // 投资期限 ≥%@天 可用
@property (strong, nonatomic) IBOutlet UILabel *remarkLab;          // 返现券来源
@property (strong, nonatomic) IBOutlet UILabel *overdueTimeLabel;   // 有效期
@property (weak, nonatomic) PrintView *printView;
//@property (strong, nonatomic) IBOutlet UILabel *amountLab;          //金额（只在兑换券里显示）

//@property (strong, nonatomic) IBOutlet UILabel *issue_timeLab;      //获得时间
@property (strong, nonatomic) IBOutlet UILabel *sentDateLab;        //赠送时间
@property (strong, nonatomic) IBOutlet UILabel *targetUserNameLab;  //赠送人

@end

@implementation UCFGivingPointCell

+ (instancetype)cellWithTableView:(UITableView *)tableview
{
    static NSString *Id = @"Coupon";
    UCFGivingPointCell *cell = [tableview dequeueReusableCellWithIdentifier:Id];
    if (!cell) {
        cell = [[UCFGivingPointCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"UCFGivingPointCell" owner:self options:nil] lastObject];
        PrintView *printView = [[PrintView alloc] initWithFrame:self.contentView.bounds andTime:@"xxxx-xx-xx"];
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

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setCouponModel:(UCFCouponModel *)couponModel
{
    NSString *inverstStr =  [couponModel.couponType intValue] == 3 ? @"购买期限":@"投资期限";
    switch ([couponModel.isUsed intValue]) {//isUsed：0可用 1过期 2使用
        case 0: {//未使用
            if ([couponModel.inverstPeriod isEqualToString:@"0"] || [couponModel.inverstPeriod isEqualToString:@""]) {//0 通用   "" 旧返现券
                _inverstPeriodLab.text = @"任意标可用";
                _inverstPeriodLab.textColor = UIColorWithRGB(0x648bc2);
            }else{
                _inverstPeriodLab.text = [NSString stringWithFormat:@"%@ ≥%@天 可用",inverstStr,couponModel.inverstPeriod];
                _inverstPeriodLab.textColor = UIColorWithRGB(0x999999);
                _investValueLabel.textColor = UIColorWithRGB(0x999999);
                [_inverstPeriodLab setFont:[UIFont boldSystemFontOfSize:10] string:[NSString stringWithFormat:@"≥%@", couponModel.inverstPeriod]];
            }
            if([couponModel.couponType intValue] == 3)//黄金返金劵未使用的情况
            {
                _symbolLab.textColor = UIColorWithRGB(0xfc8f0e);
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
            self.printView.useTime = couponModel.useTime;
            
            _symbolLab.textColor = UIColorWithRGB(0xcccccc);
            _couponValueLabel.textColor = UIColorWithRGB(0xcccccc);
            _investValueLabel.textColor = UIColorWithRGB(0xcccccc);
            _inverstPeriodLab.textColor = UIColorWithRGB(0xcccccc);
            _remarkLab.textColor = UIColorWithRGB(0xcccccc);
            _overdueTimeLabel.textColor = UIColorWithRGB(0xcccccc);
            _sentDateLab.textColor = UIColorWithRGB(0xcccccc);
            _targetUserNameLab.textColor = UIColorWithRGB(0xcccccc);
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
        self.investValueLabel.text = [NSString stringWithFormat:@"购买%@克可用", couponModel.investMultip];
    }else{
       self.investValueLabel.text = [NSString stringWithFormat:@"投资¥%@可用", temp];
    }
    [_investValueLabel setFont:[UIFont boldSystemFontOfSize:10] string:[NSString stringWithFormat:@"¥%@", temp]];
    self.remarkLab.text = couponModel.remark;   //返现券来源
    self.overdueTimeLabel.text = [NSString stringWithFormat:@"有效期 %@", couponModel.overdueTime];
    self.targetUserNameLab.text = [NSString stringWithFormat:@"赠给 %@",couponModel.targetUserName];
    self.sentDateLab.text = [NSString stringWithFormat:@"赠送时间 %@",couponModel.sentDate];
}

@end
