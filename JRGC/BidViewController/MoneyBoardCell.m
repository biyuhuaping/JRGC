//
//  MoneyBoardCell.m
//  JRGC
//
//  Created by 金融工场 on 15/4/29.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "MoneyBoardCell.h"
#import "Masonry.h"
#import "Common.h"
#import "UCFToolsMehod.h"
@implementation MoneyBoardCell 

- (void)awakeFromNib {
     [super awakeFromNib];

}
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
    CGFloat height = 0.0f;
    _topView = [[UIView alloc] init];
    _topView.backgroundColor = UIColorWithRGB(0xebebee);

    _topView.frame = CGRectMake(0, 0, ScreenWidth, 10.0f);
    [Common addLineViewColor:UIColorWithRGB(0xd8d8d8) With:_topView isTop:YES];
    [Common addLineViewColor:UIColorWithRGB(0xd8d8d8) With:_topView isTop:NO];
    [self addSubview:_topView];
    height += 10;
    _keYongBaseView = [[UIView alloc] init];
    _keYongBaseView.frame = CGRectMake(0, CGRectGetMaxY(_topView.frame), ScreenWidth, 37);
    _keYongBaseView.backgroundColor = UIColorWithRGB(0xf9f9f9);
    [self addSubview:_keYongBaseView];
    [Common addLineViewColor:UIColorWithRGB(0xeff0f3) With:_keYongBaseView isTop:NO];

    _keYongTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 10.5, [Common getStrWitdth:@"可用金额" TextFont:[UIFont systemFontOfSize:14]].width, 16)];
    _keYongTipLabel.font = [UIFont systemFontOfSize:14.0f];
    _keYongTipLabel.text = @"可用金额";
    _keYongTipLabel.backgroundColor = [UIColor clearColor];
    _keYongTipLabel.textColor = UIColorWithRGB(0x333333);
    [_keYongBaseView addSubview:_keYongTipLabel];
    
    _KeYongMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_keYongTipLabel.frame) + 5, 10, 100, 17)];
    _KeYongMoneyLabel.backgroundColor = [UIColor clearColor];
    _KeYongMoneyLabel.textColor = UIColorWithRGB(0xfd4d4c);
    _KeYongMoneyLabel.text = @"¥10000";
    _KeYongMoneyLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    [_keYongBaseView addSubview:_KeYongMoneyLabel];
    
    _totalKeYongTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_KeYongMoneyLabel.frame), CGRectGetMaxY(_KeYongMoneyLabel.frame) - 12, [Common getStrWitdth:@"(我的余额+我的工豆)" TextFont:[UIFont systemFontOfSize:10]].width, 12)];
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
    _inputBaseView.userInteractionEnabled = YES;
//    _inputBaseView.backgroundColor = [UIColor ];
    [self addSubview:_inputBaseView];

    _inputMoneyTextFieldLable = [[UITextField alloc] initWithFrame:CGRectMake(10.0f, 0, CGRectGetWidth(_inputBaseView.frame) - 70, CGRectGetHeight(_inputBaseView.frame))];
    _inputMoneyTextFieldLable.delegate = self;
    _inputMoneyTextFieldLable.keyboardType = UIKeyboardTypeDecimalPad;
    _inputMoneyTextFieldLable.backgroundColor = [UIColor clearColor];
    [_inputMoneyTextFieldLable addTarget:self action:@selector(textfieldLength:) forControlEvents:UIControlEventEditingChanged];
    _inputMoneyTextFieldLable.textColor = UIColorWithRGB(0x555555);
    _inputMoneyTextFieldLable.placeholder = @"100元起投";
//    _inputMoneyTextFieldLable.backgroundColor = [UIColor redColor];
    [_inputBaseView addSubview:_inputMoneyTextFieldLable];
    
    _allTouziBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _allTouziBtn.frame = CGRectMake(CGRectGetWidth(_inputBaseView.frame) - 50 , 0, 44, CGRectGetHeight(_inputBaseView.frame));
    [_allTouziBtn setTitle:@"全投" forState:UIControlStateNormal];
    [_allTouziBtn setTitleColor:UIColorWithRGB(0x4aa1f9) forState:UIControlStateNormal];
    _allTouziBtn.backgroundColor = [UIColor clearColor];
    _allTouziBtn.tag = 500;
    [_allTouziBtn addTarget:self action:@selector(allInvestOrChargeClick:) forControlEvents:UIControlEventTouchUpInside];
    _allTouziBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    _allTouziBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [_inputBaseView addSubview:_allTouziBtn];

    _calulatorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _calulatorBtn.frame = CGRectMake(CGRectGetMaxX(_inputBaseView.frame) + 10, CGRectGetMidY(_inputBaseView.frame) - 29/2.0, 29, 29);
    [_calulatorBtn addTarget:self action:@selector(showCalulatorView) forControlEvents:UIControlEventTouchUpInside];
    [_calulatorBtn setBackgroundImage:[UIImage imageNamed:@"invest_btn_jisuanqi.png"] forState:UIControlStateNormal];
    [self addSubview:_calulatorBtn];
    
    _midSepView = [[UIView alloc] init];
    _midSepView.backgroundColor = UIColorWithRGB(0xf2f2f2);
    _midSepView.frame = CGRectMake(0, CGRectGetMaxY(_inputBaseView.frame) + 10, ScreenWidth, 10.0f);
    [Common addLineViewColor:UIColorWithRGB(0xd8d8d8) With:_midSepView isTop:YES];
    [Common addLineViewColor:UIColorWithRGB(0xd8d8d8) With:_midSepView isTop:NO];
    [self addSubview:_midSepView];

    _myMoneyAccountLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, CGRectGetMaxY(_midSepView.frame) + 14,  [Common getStrWitdth:@"我的余额" TextFont:[UIFont systemFontOfSize:14]].width, 16)];
    _myMoneyAccountLabel.font = [UIFont systemFontOfSize:14.0f];
    _myMoneyAccountLabel.text = @"我的余额";
    _myMoneyAccountLabel.backgroundColor = [UIColor clearColor];
    _myMoneyAccountLabel.textColor = UIColorWithRGB(0x333333);
    [self addSubview:_myMoneyAccountLabel];
    
    _myMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_myMoneyAccountLabel.frame) + 5,CGRectGetMaxY(_midSepView.frame) + 14, ScreenWidth - CGRectGetMaxX(_myMoneyAccountLabel.frame) - 5 - 44 - 20, 16)];
    _myMoneyLabel.backgroundColor = [UIColor clearColor];
    _myMoneyLabel.textColor = UIColorWithRGB(0x555555);
    _myMoneyLabel.text = @"¥10000";
    _myMoneyLabel.backgroundColor = [UIColor whiteColor];
    _myMoneyLabel.font = [UIFont systemFontOfSize:14.0f];
    [self  addSubview:_myMoneyLabel];
    
    _rechargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rechargeBtn.tag = 501;
    _rechargeBtn.frame = CGRectMake(ScreenWidth - 15 - 44 , CGRectGetMaxY(_midSepView.frame), 44, 44);
    [_rechargeBtn setTitle:@"充值" forState:UIControlStateNormal];
    [_rechargeBtn addTarget:self action:@selector(allInvestOrChargeClick:) forControlEvents:UIControlEventTouchUpInside];
    [_rechargeBtn setTitleColor:UIColorWithRGB(0x4aa1f9) forState:UIControlStateNormal];
    _rechargeBtn.backgroundColor = [UIColor clearColor];
    _rechargeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    _rechargeBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self addSubview:_rechargeBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(_midSepView.frame) + 44, ScreenWidth - 15, 0.5)];
    lineView.backgroundColor = UIColorWithRGB(0xe3e5ea);
    [self addSubview:lineView];
    

    _gongDouAccout = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, CGRectGetMaxY(lineView.frame) + 14,[Common getStrWitdth:@"我的工豆" TextFont:[UIFont systemFontOfSize:14]].width, 16)];
    _gongDouAccout.font = [UIFont systemFontOfSize:14.0f];
    _gongDouAccout.text = @"我的工豆";
    _gongDouAccout.backgroundColor = [UIColor clearColor];
    _gongDouAccout.textColor = UIColorWithRGB(0x333333);
    [self addSubview:_gongDouAccout];
    
    _gongDouCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_gongDouAccout.frame) + 5,CGRectGetMaxY(lineView.frame) + 14,ScreenWidth - CGRectGetMaxX(_gongDouAccout.frame) - 5 - 80 , 16)];
    _gongDouCountLabel.backgroundColor = [UIColor clearColor];
    _gongDouCountLabel.textColor = UIColorWithRGB(0x555555);
    _gongDouCountLabel.text = @"¥10000";
    _gongDouCountLabel.backgroundColor = [UIColor whiteColor];
    _gongDouCountLabel.font = [UIFont systemFontOfSize:14.0f];
    [self  addSubview:_gongDouCountLabel];
    
    _gongDouSwitch = [[UISwitch alloc] init];
    _gongDouSwitch.frame = CGRectMake(ScreenWidth - 66, CGRectGetMaxY(lineView.frame) + 7, 51, 100);
    _gongDouSwitch.onTintColor = UIColorWithRGB(0xfd4d4c);
    [_gongDouSwitch addTarget:self action:@selector(changeSwitchStatue:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_gongDouSwitch];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(lineView.frame) + 43, ScreenWidth, 0.5)];
    lineView1.backgroundColor = UIColorWithRGB(0xd8d8d8);
    //    lineView1.backgroundColor = [UIColor whiteColor];
    [self addSubview:lineView1];
    
}
- (void)layoutSubviews
{
    if (!_isTransid) {
        
        if (_isCollctionkeyBid) {
          
            _totalKeYongTipLabel.text = @"(我的余额)";
            NSString *minInvestStr = [NSString stringWithFormat:@"%@",[[_dataDict objectForKey:@"colPrdClaimDetail"] objectForKey:@"colMinInvest"]];
      
            NSString *palceText = [NSString stringWithFormat:@"%@元起投", minInvestStr];
            if ([[_dataDict objectForKey:@"batchAmount"] intValue ] > 0) {
                palceText = [palceText stringByAppendingString:[NSString stringWithFormat:@",限投%@元",[_dataDict objectForKey:@"batchAmount"]] ];
            }
            _inputMoneyTextFieldLable.font = [UIFont systemFontOfSize:15.0f];
            _inputMoneyTextFieldLable.placeholder = palceText;
            double availableBalance = [[_dataDict objectForKey:@"availableBalance"]  doubleValue];
            NSString *availableStr = [UCFToolsMehod AddComma:[NSString stringWithFormat:@"%.2f",availableBalance]];
            self.myMoneyLabel.text = [NSString stringWithFormat:@"¥%@",availableStr];
            double gondDouBalance = [[_dataDict objectForKey:@"beanAmount"] doubleValue];
            NSString *gondDouBalancStr = [UCFToolsMehod AddComma:[NSString stringWithFormat:@"%.2f",gondDouBalance/100.0f]];
            
            self.gongDouCountLabel.text = [NSString stringWithFormat:@"¥%@",gondDouBalancStr];
            if (self.gongDouSwitch.on == NO) {
                gondDouBalance = 0;
            }
            NSString *totalMoney = [UCFToolsMehod AddComma:[NSString stringWithFormat:@"%.2lf",availableBalance + gondDouBalance/100.0f]];
            self.KeYongMoneyLabel.text = [NSString stringWithFormat:@"¥%@",totalMoney];
            CGSize size = [Common getStrWitdth:self.KeYongMoneyLabel.text TextFont:_KeYongMoneyLabel.font];
            self.KeYongMoneyLabel.frame = CGRectMake(CGRectGetMinX(self.KeYongMoneyLabel.frame), CGRectGetMinY(self.KeYongMoneyLabel.frame), size.width, CGRectGetHeight(self.KeYongMoneyLabel.frame));
            _totalKeYongTipLabel.frame = CGRectMake(CGRectGetMaxX(_KeYongMoneyLabel.frame) + 5, CGRectGetMaxY(_KeYongMoneyLabel.frame) - 12, 11 * 12, 12);
            if (_isCompanyAgent) {
                _gongDouAccout.hidden = YES;
                _gongDouCountLabel.hidden = YES;
                _gongDouSwitch.hidden = YES;
            }
        }else{
    
        NSString *palceText = [NSString stringWithFormat:@"%@元起投",[[_dataDict objectForKey:@"data"] objectForKey:@"minInvest"]];
        if ([[[_dataDict objectForKey:@"data"] objectForKey:@"maxInvest"] length] != 0) {
            NSString *maxInvest = [[_dataDict objectForKey:@"data"] objectForKey:@"maxInvest"];
            palceText = [palceText stringByAppendingString:[NSString stringWithFormat:@",限投%@元",maxInvest]];
        }
        _inputMoneyTextFieldLable.font = [UIFont systemFontOfSize:15.0f];
        _inputMoneyTextFieldLable.placeholder = palceText;
        double availableBalance = [[[_dataDict objectForKey:@"actUser"] objectForKey:@"availableBalance"] doubleValue];
        NSString *availableStr = [UCFToolsMehod AddComma:[NSString stringWithFormat:@"%.2f",availableBalance]];
        self.myMoneyLabel.text = [NSString stringWithFormat:@"¥%@",availableStr];
        double gondDouBalance = [[[_dataDict objectForKey:@"beanUser"] objectForKey:@"availableBalance"] doubleValue];
        NSString *gondDouBalancStr = [UCFToolsMehod AddComma:[NSString stringWithFormat:@"%.2f",gondDouBalance/100.0f]];

        self.gongDouCountLabel.text = [NSString stringWithFormat:@"¥%@",gondDouBalancStr];
        if (self.gongDouSwitch.on == NO) {
            gondDouBalance = 0;
        }
        NSString *totalMoney = [UCFToolsMehod AddComma:[NSString stringWithFormat:@"%.2lf",availableBalance + gondDouBalance/100.0f]];
        self.KeYongMoneyLabel.text = [NSString stringWithFormat:@"¥%@",totalMoney];
        CGSize size = [Common getStrWitdth:self.KeYongMoneyLabel.text TextFont:_KeYongMoneyLabel.font];
        self.KeYongMoneyLabel.frame = CGRectMake(CGRectGetMinX(self.KeYongMoneyLabel.frame), CGRectGetMinY(self.KeYongMoneyLabel.frame), size.width, CGRectGetHeight(self.KeYongMoneyLabel.frame));
        _totalKeYongTipLabel.frame = CGRectMake(CGRectGetMaxX(_KeYongMoneyLabel.frame) + 5, CGRectGetMaxY(_KeYongMoneyLabel.frame) - 12, 11 * 12, 12);
        if (_isCompanyAgent) {
            _gongDouAccout.hidden = YES;
            _gongDouCountLabel.hidden = YES;
            _gongDouSwitch.hidden = YES;
         }
      }
    } else{
            _keYongTipLabel.text = @"我的余额";
            _rechargeBtn.frame = CGRectMake(ScreenWidth - 15 - 44 , CGRectGetMaxY(_topView.frame), 44, 37);
            
            _totalKeYongTipLabel.hidden = YES;
            _inputMoneyTextFieldLable.placeholder = [NSString stringWithFormat:@"%@起投",[[_dataDict objectForKey:@"data"] objectForKey:@"investAmt"]];
            double availableBalance = [[[_dataDict objectForKey:@"data"] objectForKey:@"actBalance"] doubleValue];
            NSString *availableStr = [UCFToolsMehod AddComma:[NSString stringWithFormat:@"%.2f",availableBalance]];
            self.myMoneyLabel.text = [NSString stringWithFormat:@"¥%@",availableStr];
            double gondDouBalance = [[[_dataDict objectForKey:@"data"] objectForKey:@"beanBalance"] doubleValue];
            self.gongDouCountLabel.text = [NSString stringWithFormat:@"¥%.2lf",gondDouBalance];
            if (self.gongDouSwitch.on == NO) {
                gondDouBalance = 0;
            }
            NSString *totalMoney = [UCFToolsMehod AddComma:[NSString stringWithFormat:@"%.2lf",availableBalance + gondDouBalance]];
            self.KeYongMoneyLabel.text = [NSString stringWithFormat:@"¥%@",totalMoney];
            CGSize size = [Common getStrWitdth:self.KeYongMoneyLabel.text TextFont:_KeYongMoneyLabel.font];
            self.KeYongMoneyLabel.frame = CGRectMake(CGRectGetMinX(self.KeYongMoneyLabel.frame), CGRectGetMinY(self.KeYongMoneyLabel.frame), size.width, CGRectGetHeight(self.KeYongMoneyLabel.frame));
            _totalKeYongTipLabel.frame = CGRectMake(CGRectGetMaxX(_KeYongMoneyLabel.frame) + 5, CGRectGetMaxY(_KeYongMoneyLabel.frame) - 12, 11 * 12, 12);
    }


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
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(reloadSuperView:)]) {
        [self.delegate reloadSuperView:textField];
    }
}
- (void)showCalulatorView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showCalutorView)]) {
        [self.delegate showCalutorView];
    }
}
- (void)changeSwitchStatue:(UISwitch *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeGongDouSwitchStatue:)]) {
        [self.delegate changeGongDouSwitchStatue:sender];
    }
}
- (void)allInvestOrChargeClick:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(allInvestOrGotoPay:)]) {
        [self.delegate allInvestOrGotoPay:button.tag];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
