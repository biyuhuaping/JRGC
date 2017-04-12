 //
//  SelectCoupleCell.m
//  JRGC
//
//  Created by 金融工场 on 15/5/21.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "SelectCoupleCell.h"
#import "Common.h"
#import "UCFToolsMehod.h"
@implementation SelectCoupleCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
        self.backgroundColor = UIColorWithRGB(0xebebee);

    }
    return self;
}
- (void)initView
{
    _selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_selectedBtn setBackgroundImage:[UIImage imageNamed:@"invest_btn_select_normal.png"] forState:UIControlStateNormal];
    [_selectedBtn setBackgroundImage:[UIImage imageNamed:@"invest_btn_select_highlight.png"] forState:UIControlStateSelected];
    _selectedBtn.frame = CGRectMake(12, (82- 25)/2.0, 25, 25);
    [_selectedBtn addTarget:self action:@selector(changeSelectedStatue:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_selectedBtn];
    
    _baseImageView = [[UIImageView alloc] init];
    _baseImageView.userInteractionEnabled = YES;
    UIImage *baseImage = [UIImage imageNamed:@"invest_bg_coupon.png"];
    [baseImage resizableImageWithCapInsets:UIEdgeInsetsMake(0,130, 0, 120) resizingMode:UIImageResizingModeTile];
    _baseImageView.image = [UIImage imageNamed:@"invest_bg_coupon.png"];
    _baseImageView.frame = CGRectMake(CGRectGetMaxX(_selectedBtn.frame) + 8, 10, ScreenWidth - CGRectGetMaxX(_selectedBtn.frame) - 8 -15, 72);
    _baseImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:_baseImageView];
    
    UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [imageBtn addTarget:self action:@selector(changeSelectedStatue:) forControlEvents:UIControlEventTouchUpInside];
    imageBtn.frame = CGRectMake(0, 0, _baseImageView.frame.size.width, _baseImageView.frame.size.height);
    [_baseImageView addSubview:imageBtn];
    
    _angleView = [[UIImageView alloc] init];
    UIImage *angleImage = [UIImage imageNamed:@"invest_bg_label.png"];
    angleImage = [angleImage stretchableImageWithLeftCapWidth:18 topCapHeight:10];
    _angleView.backgroundColor = [UIColor clearColor];
    _angleView.image = angleImage;
    _angleView.frame = CGRectMake(CGRectGetWidth(_baseImageView.frame) - 70, - 3.5, 63, 17);
    [_baseImageView addSubview:_angleView];
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.frame = CGRectMake(3, 4, CGRectGetWidth(_angleView.frame) - 6, CGRectGetHeight(_angleView.frame) - 8);
    tipLabel.text = @"即将过期";
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.font = [UIFont systemFontOfSize:11.0f];
    [_angleView addSubview:tipLabel];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.frame = CGRectMake(10, 12, 13, 19);
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.tag = 4568;
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font = [UIFont boldSystemFontOfSize:19.0f];
    nameLabel.text = @"¥";
    [_baseImageView addSubview:nameLabel];
    
    _moneyLabel = [[UILabel alloc] init];
    _moneyLabel.text = @"50";
    _moneyLabel.frame = CGRectMake(CGRectGetMaxX(nameLabel.frame), 6, 27 * 3, 26);
    _moneyLabel.backgroundColor = [UIColor clearColor];
    _moneyLabel.textColor = [UIColor whiteColor];
    _moneyLabel.font = [UIFont boldSystemFontOfSize:26];
    [_baseImageView addSubview:_moneyLabel];
    
    _useLimtLabel = [[UILabel alloc] init];
    _useLimtLabel.frame = CGRectMake(10, 56, CGRectGetWidth(_baseImageView.frame) - 135, 10.0f);
    _useLimtLabel.textAlignment = NSTextAlignmentLeft;
    _useLimtLabel.textColor = UIColorWithRGB(0x999999);
    _useLimtLabel.font = [UIFont systemFontOfSize:10.0f];
    _useLimtLabel.text = @"投资¥100,000可用";
    [_baseImageView addSubview:_useLimtLabel];

    _sourceLabel = [[UILabel alloc] init];
    _sourceLabel.frame = CGRectMake(CGRectGetMinX(nameLabel.frame), CGRectGetMaxY(_moneyLabel.frame) + 3, 138, 10.0f);
    _sourceLabel.textColor = [UIColor whiteColor];
    _sourceLabel.font = [UIFont systemFontOfSize:10.0f];
    _sourceLabel.textAlignment = NSTextAlignmentLeft;
    _sourceLabel.text = @"投资返券活动赠送";
    _sourceLabel.backgroundColor = [UIColor clearColor];
    [_baseImageView addSubview:_sourceLabel];

    _timeLabel = [[UILabel alloc] init];
    _timeLabel.frame = CGRectMake(CGRectGetMaxX(_moneyLabel.frame), CGRectGetMinY(_sourceLabel.frame), CGRectGetWidth(_baseImageView.frame) - CGRectGetMaxX(_moneyLabel.frame) - 10, 10.0f);
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.font = [UIFont systemFontOfSize:10];
    _timeLabel.text = @"有效期:2015-03-25";
    [_baseImageView addSubview:_timeLabel];
    
    
    _investLimitLab =  [[UILabel alloc] init];
    _investLimitLab.frame = CGRectMake(CGRectGetWidth(_baseImageView.frame) - 200, CGRectGetMinY(_useLimtLabel.frame), 190, 10.0f);
    _investLimitLab.textAlignment = NSTextAlignmentRight;
    _investLimitLab.textColor = UIColorWithRGB(0x648bc2);
    _investLimitLab.font = [UIFont systemFontOfSize:10.0f];
    _investLimitLab.text = @"投资期限>=30天可用";
    [_baseImageView addSubview:_investLimitLab];
}
- (void)layoutSubviews
{
    NSInteger statue = [[self.dataDict objectForKey:@"status"]integerValue];
    if (statue == 0 || statue == 2)
    {
        if (_listType == 1) {
            [_selectedBtn setBackgroundImage:[UIImage imageNamed:@"invest_btn_select_normal.png"] forState:UIControlStateNormal];
            [_selectedBtn setBackgroundImage:[UIImage imageNamed:@"invest_btn_choice_highlight.png"] forState:UIControlStateSelected];
        } else {
            [_selectedBtn setBackgroundImage:[UIImage imageNamed:@"invest_btn_select_normal.png"] forState:UIControlStateNormal];
            [_selectedBtn setBackgroundImage:[UIImage imageNamed:@"invest_btn_select_highlight.png"] forState:UIControlStateSelected];
        }
        if (![[self.dataDict objectForKey:@"inverstPeriod"] isEqual:[NSNull null]]) {
            NSInteger inverstPeriod = [[self.dataDict objectForKey:@"inverstPeriod"] integerValue];
            if (inverstPeriod == 0) {
                if (_listType == 1) {
                    _baseImageView.image = [UIImage imageNamed:@"invest_bg_interest.png"];
                } else {
                    _baseImageView.image = [UIImage imageNamed:@"invest_bg_coupon_common.png"];
                }
                _investLimitLab.text = @"任意标可用";
                _investLimitLab.textColor = UIColorWithRGB(0x648bc2);
                
            } else {
                if (_listType == 1) {
                    _baseImageView.image = [UIImage imageNamed:@"invest_bg_interest.png"];
                } else {
                    _baseImageView.image = [UIImage imageNamed:@"invest_bg_coupon.png"];
                }
                _investLimitLab.text = [NSString stringWithFormat:@"投资期限≥%ld天可用",(long)inverstPeriod];
                _investLimitLab.textColor = UIColorWithRGB(0x999999);
            }

            
        } else {
            if (_listType == 1) {
                _baseImageView.image = [UIImage imageNamed:@"invest_bg_interest.png"];
            } else {
                _baseImageView.image = [UIImage imageNamed:@"invest_bg_coupon_common.png"];
            }
            _investLimitLab.text = @"任意标可用";
        }
 
        NSString *moneyStr = @"0";
        if (_listType == 0) {
            moneyStr = [NSString stringWithFormat:@"%.2f",[[self.dataDict objectForKey:@"beanCount"] intValue]/100.0f];
            NSArray *moneyStrArr = [moneyStr componentsSeparatedByString:@"."];
            if (moneyStrArr.count == 2) {
                NSString *firstStr = [moneyStrArr objectAtIndex:0];
                NSString *secondStr = [moneyStrArr objectAtIndex:1];
                if ([secondStr isEqualToString:@"00"]) {
                    moneyStr = firstStr;
                }
            }
            _moneyLabel.text = moneyStr;
        } else {
            UILabel *nameLabel = [_baseImageView viewWithTag:4568];
            nameLabel.text = @"+";
            moneyStr = [NSString stringWithFormat:@"%@%%",[self.dataDict objectForKey:@"backInterestRate"]];
            NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:18.0],NSFontAttributeName,nil];
            NSMutableAttributedString *attributeMoneyString = [[NSMutableAttributedString alloc] initWithString:moneyStr];
            [attributeMoneyString setAttributes:attributeDict range:[moneyStr rangeOfString:@"%"]];
            _moneyLabel.attributedText = attributeMoneyString;
        }
        NSString *limte = [UCFToolsMehod AddComma:[NSString stringWithFormat:@"%d",[[self.dataDict objectForKey:@"investMultip"] intValue]]];
        _useLimtLabel.text = [NSString stringWithFormat:@"投资¥%@可用",limte];
        NSString *sourStr =[NSString stringWithFormat:@"%@",[self.dataDict objectForKey:@"remark"]];
        _sourceLabel.text = sourStr;
        NSString *endTime = [NSString stringWithFormat:@"有效期 %@",[self.dataDict objectForKey:@"overdueTime"]];
        NSString *sourAndTimeStr = [NSString stringWithFormat:@"%@",endTime];
        _timeLabel.text = sourAndTimeStr;
        NSString *validityStatus = [NSString stringWithFormat:@"%@",[_dataDict objectForKey:@"validityStatus"]];
        if (_listType == 1) {
            if ([[_dataDict objectForKey:@"flag"] isEqualToString:@"0"]) {
                _angleView.hidden = NO;
            } else {
                _angleView.hidden = YES;
            }
        } else {
            if ([validityStatus isEqualToString:@"1"]) {
                _angleView.hidden = YES;
            } else {
                _angleView.hidden = NO;
            }
        }
    }
}
- (void)changeSelectedStatue:(UIButton *)btn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selctTheModelIndex:)]) {
        [self.delegate selctTheModelIndex:_selectedBtn];
//        [self.delegate selctTheModelIndex:_selectedBtn.tag];
    }
//    _selectedBtn.selected = !_selectedBtn.selected;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
