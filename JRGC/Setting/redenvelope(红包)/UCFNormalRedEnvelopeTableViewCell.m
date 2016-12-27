//
//  UCFNormalRedEnvelopeTableViewCell.m
//  JRGC
//
//  Created by NJW on 15/5/7.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFNormalRedEnvelopeTableViewCell.h"
#import "UCFRedEnvelopeModel.h"

@interface UCFNormalRedEnvelopeTableViewCell ()
// 标题一
@property (weak, nonatomic) IBOutlet UILabel *titleFirstLabel;
// 标题二
@property (weak, nonatomic) IBOutlet UILabel *titleSecondLabel;
// 标题三
@property (weak, nonatomic) IBOutlet UILabel *titleThirdLabel;
// 红包状态
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
// 红包详情
@property (weak, nonatomic) IBOutlet UILabel *markLabel;
// 过期时间
@property (weak, nonatomic) IBOutlet UILabel *expireTimeLabel;

@property (weak, nonatomic) IBOutlet UIView *upView;

@end

@implementation UCFNormalRedEnvelopeTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"sendredenvelope";
    UCFNormalRedEnvelopeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UCFNormalRedEnvelopeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"UCFNormalRedEnvelopeTableViewCell" owner:self options:nil] lastObject];
        
        UIView *linetop = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 0.5)];
        linetop.backgroundColor = UIColorWithRGB(0xd8d8d8);
        [self addSubview:linetop];
        
        UIView *segLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.upView.frame)-0.5, ScreenWidth, 0.5)];
        segLine.backgroundColor = UIColorWithRGB(0xeff0f3);
        [self.upView addSubview:segLine];
        
        UIView *linebottom = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-0.5, ScreenWidth, 0.5)];
        linebottom.backgroundColor = UIColorWithRGB(0xd8d8d8);
        [self addSubview:linebottom];
        
        
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

    switch ([redEnvelope.status integerValue]) {
        case 0: {
            _statusLabel.text = @"未领取";
        }
            break;
        case 3: {
            _statusLabel.text = @"已领完";
        }
            break;
            
        case 2: {
            _statusLabel.text = @"已过期";
        }
            break;
    }
    _markLabel.text = [NSString stringWithFormat:@"%@个红包，%@个已领取", redEnvelope.redCount, redEnvelope.readyCount];
    if (redEnvelope.redEnvelopeType == UCFRedEnvelopeStateknocked) {
        _markLabel.text = @"已存入工豆账户";
        _titleSecondLabel.text = @"";
        _titleThirdLabel.text = @"";
        _statusLabel.text = [NSString stringWithFormat:@"¥%@", redEnvelope.redInvest];
    }
    _expireTimeLabel.text = [NSString stringWithFormat:@"有效期 %@", redEnvelope.endTime];
}

@end
