//
//  UCFGoldMoneyBoadCell.m
//  JRGC
//
//  Created by hanqiyuan on 2017/7/11.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldMoneyBoadCell.h"
#import "ToolSingleTon.h"
@interface UCFGoldMoneyBoadCell()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *GoldCalculatorView;
@property (weak, nonatomic) IBOutlet UISwitch *goldSwitch;
- (IBAction)clickGoldRechargeButton:(id)sender;
- (IBAction)clickAllInvestmentBtn:(id)sender;
- (IBAction)clickGoldSwitch:(UISwitch *)sender;


- (IBAction)showGoldCalculatorView:(id)sender;
@end
@implementation UCFGoldMoneyBoadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.moneyTextField  addTarget:self action:@selector(textfieldChangedLength:) forControlEvents:UIControlEventEditingChanged];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)layoutSubviews
{
    [super layoutSubviews];
}
-(void)setDataDict:(NSDictionary *)dataDict
{
    _dataDict = dataDict;
    NSDictionary *userAccountInfoDict = [_dataDict objectForKey:@"userAccountInfo"];
    self.availableAllMoneyLabel.text = [NSString stringWithFormat:@"¥%@",[userAccountInfoDict objectForKey:@"availableAllMoney"]];
    self.availableMoneyLabel.text = [NSString stringWithFormat:@"¥%@",[userAccountInfoDict objectForKey:@"availableMoney"]];
    self.accountBeanLabel.text = [NSString stringWithFormat:@"¥%@",[userAccountInfoDict objectForKey:@"accountBean"]];

}


- (IBAction)clickGoldRechargeButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(gotoGoldRechargeVC)]) {
        [self.delegate gotoGoldRechargeVC];
    }
}

- (IBAction)clickAllInvestmentBtn:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickAllInvestmentBtn)]) {
        [self.delegate clickAllInvestmentBtn];
    }
}

- (IBAction)clickGoldSwitch:(UISwitch *)sender{
    
}

- (IBAction)showGoldCalculatorView:(id)sender
{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(showGoldCalculatorView)]) {
        [self.delegate showGoldCalculatorView];
    }
    
}
- (UITextField *)textfieldChangedLength:(UITextField *)textField
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
        
        if(str.length > 3)
        {
            textField.text = [textField.text substringToIndex:textField.text.length-1];
        }
        NSString *firStr = [array objectAtIndex:0];
        if (firStr == nil || firStr.length == 0) {
            textField.text = [NSString stringWithFormat:@"0%@",textField.text];
        }
    }
    double amountPay = [textField.text doubleValue] * [ToolSingleTon sharedManager].readTimePrice;
    self.estimatAmountPayableLabel.text = [NSString stringWithFormat:@"¥%.2lf",amountPay];
    
    return textField;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
