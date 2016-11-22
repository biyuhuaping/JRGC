//
//  UCFRedEnvelopeTableViewCell.m
//  JRGC
//
//  Created by NJW on 15/5/7.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFRedEnvelopeTableViewCell.h"
#import "UCFRedEnvelopeModel.h"
#import "UCFAngleView.h"

@interface UCFRedEnvelopeTableViewCell ()
// 标题一
@property (weak, nonatomic) IBOutlet UILabel *titleFirstLabel;
// 标题二
@property (weak, nonatomic) IBOutlet UILabel *titleSecondLabel;
// 标题三
@property (weak, nonatomic) IBOutlet UILabel *titleThirdLabel;
// 红包状态
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
// 红包的详情
@property (weak, nonatomic) IBOutlet UILabel *markLabel;
// 红包的过期时间
@property (weak, nonatomic) IBOutlet UILabel *expireTimeLabel;
// 发红包的按钮
@property (weak, nonatomic) IBOutlet UIButton *sendEnvelopeButton;

// 是否即将到期的标识视图
@property (weak, nonatomic) IBOutlet UCFAngleView *signView;

@property (weak, nonatomic) IBOutlet UIView *upBackView;

@property (weak, nonatomic) IBOutlet UIView *downBackView;

@end

@implementation UCFRedEnvelopeTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"sendredenvelope";
    UCFRedEnvelopeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UCFRedEnvelopeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.signView.angleString = @"即将过期";
        cell.signView.angleStatus = @"2";
        cell.signView.hidden = YES;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"UCFRedEnvelopeTableViewCell" owner:self options:nil] lastObject];
        
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
        topLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
        [self.upBackView addSubview:topLine];
        
        UIView *midLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.upBackView.frame)-0.5, ScreenWidth, 0.5)];
        midLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
        [self.upBackView addSubview:midLine];
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.downBackView.frame)-9.5, ScreenWidth, 0.5)];
        bottomLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
        [self.downBackView addSubview:bottomLine];
        
        UIImage *normalImageForTopUp = [[UIImage imageNamed:@"btn_red"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5];
        UIImage *highlightImageForTopUp = [[UIImage imageNamed:@"btn_red_highlight"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5];
        [self.sendEnvelopeButton setBackgroundImage:normalImageForTopUp forState:UIControlStateNormal];
        [self.sendEnvelopeButton setBackgroundImage:highlightImageForTopUp forState:UIControlStateHighlighted];
    }
    return self;
}

- (void)setRedEnvelope:(UCFRedEnvelopeModel *)redEnvelope
{
    _redEnvelope = redEnvelope;
    _titleFirstLabel.text = [redEnvelope.cardType isEqualToString:@"1"] ? @"工豆红包" : @"返现券红包";
    _titleSecondLabel.text = [NSString stringWithFormat:@"¥%@", redEnvelope.redInvest];
    if (redEnvelope.drewardamt.doubleValue > 0) {
        _titleThirdLabel.text = [NSString stringWithFormat:@"(抢光红包再奖励¥%@)", redEnvelope.drewardamt];
    }
    else _titleThirdLabel.text = @"";
    
    _statusLabel.text = @"";
    
    _markLabel.text = [NSString stringWithFormat:@"%@个红包，%@个已领取", redEnvelope.redCount, redEnvelope.readyCount];
    _expireTimeLabel.text = [NSString stringWithFormat:@"有效期 %@", redEnvelope.endTime];
    
    self.signView.hidden = [redEnvelope.flag isEqualToString:@"0"] ? NO : YES;
}

- (IBAction)sendRedEnvelope:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(redEnvelopeTableViewCell:sendRedEnvelope:)]) {
        [self.delegate redEnvelopeTableViewCell:self sendRedEnvelope:self.redEnvelope];
    }
}
@end
