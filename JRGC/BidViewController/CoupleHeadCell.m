//
//  CoupleHeadCell.m
//  JRGC
//
//  Created by 金融工场 on 15/5/21.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "CoupleHeadCell.h"
#import "Common.h"

@implementation CoupleHeadCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}
- (void)initView
{
    UIView *headBaseView = [[UIView alloc] init];
    headBaseView.frame = CGRectMake(0, 0, ScreenWidth, 68.0f);
    headBaseView.backgroundColor = UIColorWithRGB(0x5b6993);
    [self addSubview:headBaseView];
    
    UILabel *needInvestMoney = [[UILabel alloc] init];
    needInvestMoney.frame = CGRectMake(0, 15, ScreenWidth/2, 14.0f);
    needInvestMoney.textAlignment = NSTextAlignmentCenter;
    needInvestMoney.textColor = [UIColor whiteColor];
    needInvestMoney.font = [UIFont systemFontOfSize:14.0f];
    needInvestMoney.text = @"需投资金额";
    needInvestMoney.backgroundColor = [UIColor clearColor];
    [headBaseView addSubview:needInvestMoney];
    
    UILabel *canInvestMoney = [[UILabel alloc] init];
    canInvestMoney.frame = CGRectMake(ScreenWidth/2, 15, ScreenWidth/2, 14.0f);
    canInvestMoney.textAlignment = NSTextAlignmentCenter;
    canInvestMoney.textColor = [UIColor whiteColor];
    canInvestMoney.font = [UIFont systemFontOfSize:14.0f];
    canInvestMoney.text = @"可投金额";
    canInvestMoney.backgroundColor = [UIColor clearColor];
    [headBaseView addSubview:canInvestMoney];
    
    _needsInvestLabel = [[UILabel alloc] init];
    _needsInvestLabel.frame = CGRectMake(8, CGRectGetMaxY(canInvestMoney.frame) + 5, ScreenWidth/2 - 16, 20);
    _needsInvestLabel.textColor = UIColorWithRGB(0xffb96e);
    _needsInvestLabel.font = [UIFont boldSystemFontOfSize:19];
    _needsInvestLabel.text = @"¥9,000,888.12";
    _needsInvestLabel.textAlignment = NSTextAlignmentCenter;
    [headBaseView addSubview:_needsInvestLabel];
 
    UIImageView *lessIcon = [[UIImageView alloc] init];
    lessIcon.image = [UIImage imageNamed:@"invest_icon_lessthan.png"];
    lessIcon.frame = CGRectMake((ScreenWidth - 16)/2, CGRectGetMinY(_needsInvestLabel.frame) + 2, 16, 16);
    [headBaseView addSubview:lessIcon];
    
    _canInvestLabel = [[UILabel alloc] init];
    _canInvestLabel.frame = CGRectMake(CGRectGetMaxX(lessIcon.frame), CGRectGetMinY(_needsInvestLabel.frame), ScreenWidth/2 - 16, 20);
    _canInvestLabel.textColor = [UIColor whiteColor];
    _canInvestLabel.font = [UIFont boldSystemFontOfSize:19.0f];
    _canInvestLabel.text = @"¥19,000,888.12";
    _canInvestLabel.textAlignment = NSTextAlignmentCenter;
    [headBaseView addSubview:_canInvestLabel];
    
    _keYongBaseView = [[UIView alloc] init];
    _keYongBaseView.frame = CGRectMake(0, CGRectGetMaxY(headBaseView.frame), ScreenWidth, 37);
    _keYongBaseView.backgroundColor = UIColorWithRGB(0xf9f9f9);
    [self.contentView addSubview:_keYongBaseView];
    [Common addLineViewColor:UIColorWithRGB(0xeff0f3) With:_keYongBaseView isTop:NO];

    _keYongTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 10.5, 14 * 4, 16)];
    _keYongTipLabel.font = [UIFont systemFontOfSize:14.0f];
    _keYongTipLabel.text = @"可用金额";
    _keYongTipLabel.backgroundColor = [UIColor clearColor];
    _keYongTipLabel.textColor = UIColorWithRGB(0x333333);
    [_keYongBaseView addSubview:_keYongTipLabel];

    _KeYongMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_keYongTipLabel.frame) + 5, 10, 100, 17)];
    _KeYongMoneyLabel.backgroundColor = [UIColor clearColor];
    _KeYongMoneyLabel.textColor = UIColorWithRGB(0xfd4d4c);
    _KeYongMoneyLabel.text = @"¥10000";
    _KeYongMoneyLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    [_keYongBaseView addSubview:_KeYongMoneyLabel];

    _totalKeYongTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_KeYongMoneyLabel.frame), CGRectGetMaxY(_KeYongMoneyLabel.frame) - 12, 11 * 12, 12)];
    _totalKeYongTipLabel.font = [UIFont systemFontOfSize:10.0f];
    _totalKeYongTipLabel.textColor = UIColorWithRGB(0x999999);
    _totalKeYongTipLabel.text = @"(我的余额+我的工豆)";
    _totalKeYongTipLabel.backgroundColor = [UIColor clearColor];
    [_keYongBaseView addSubview:_totalKeYongTipLabel];

    _inputBaseView = [[UIView alloc] initWithFrame:CGRectMake(15.0f, CGRectGetMaxY(_keYongBaseView.frame) + 10, ScreenWidth - 69.0f, 37.0f)];
    _inputBaseView.backgroundColor = UIColorWithRGB(0xf2f2f2);
    _inputBaseView.layer.borderColor = UIColorWithRGB(0xd8d8d8).CGColor;
    _inputBaseView.layer.borderWidth = 0.5f;
    _inputBaseView.layer.cornerRadius = 4.0f;
    [self.contentView addSubview:_inputBaseView];

    _inputMoneyTextFieldLable = [[UITextField alloc] initWithFrame:CGRectMake(10.0f, 10.5f, CGRectGetWidth(_inputBaseView.frame) - 10, 16.0f)];
    _inputMoneyTextFieldLable.keyboardType = UIKeyboardTypeDecimalPad;
    _inputMoneyTextFieldLable.backgroundColor = [UIColor clearColor];
    [_inputMoneyTextFieldLable addTarget:self action:@selector(textfieldLength:) forControlEvents:UIControlEventEditingChanged];
    _inputMoneyTextFieldLable.placeholder = @"100元起投";
    [_inputBaseView addSubview:_inputMoneyTextFieldLable];

    _allTouziBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _allTouziBtn.frame = CGRectMake(CGRectGetMaxX(_inputBaseView.frame) , CGRectGetMaxY(_keYongBaseView.frame) + 10, 69 - 15, CGRectGetHeight(_inputBaseView.frame));
    [_allTouziBtn setTitle:@"充值" forState:UIControlStateNormal];
    [_allTouziBtn setTitleColor:UIColorWithRGB(0x4aa1f9) forState:UIControlStateNormal];
    _allTouziBtn.backgroundColor = [UIColor clearColor];
    _allTouziBtn.tag = 500;
    [_allTouziBtn addTarget:self action:@selector(gotoPay:) forControlEvents:UIControlEventTouchUpInside];
    _allTouziBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    _allTouziBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    [self.contentView addSubview:_allTouziBtn];
}
- (void)gotoPay:(UIButton *)button
{
    
}
- (UITextField *)textfieldLength:(UITextField *)textField
{
    NSString *str = textField.text;
    NSArray *array = [str componentsSeparatedByString:@"."];
    
    NSString *jeLength = [array firstObject];
    if (jeLength.length > 9) {
        textField.text = [textField.text substringToIndex:textField.text.length-1];
    }
    if (array.count == 1) {
        if (jeLength != nil&& jeLength.length > 0) {
            NSString *firstStr = [jeLength substringToIndex:1];
            if ([firstStr isEqualToString:@"0"]) {
                textField.text = @"0";
            }
        }
        
    }
    
    if(array.count > 2)
    {
        textField.text = [textField.text substringToIndex:textField.text.length-1];
    }
    if(array.count == 2)
    {
        str = [array objectAtIndex:1];
        
        if(str.length > 2)
        {
            textField.text = [textField.text substringToIndex:textField.text.length-1];
        }
        NSString *firStr = [array objectAtIndex:0];
        if (firStr == nil || firStr.length == 0) {
            textField.text = [NSString stringWithFormat:@"0%@",textField.text];
        }
    }
    
    return textField;
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
