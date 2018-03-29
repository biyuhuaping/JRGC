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

- (IBAction)clickGoldRechargeButton:(id)sender;
- (IBAction)clickAllInvestmentBtn:(id)sender;
- (IBAction)clickGoldSwitch:(UISwitch *)sender;
@property (strong, nonatomic) IBOutlet UILabel *gongDouLabel;

@property (strong, nonatomic) IBOutlet UIButton *rechargeButton1;
@property (strong, nonatomic) IBOutlet UIButton *rechargeButton2;
- (IBAction)showGoldCalculatorView:(id)sender;
@end
@implementation UCFGoldMoneyBoadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.moneyTextField.delegate = self;
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
-(void)setIsGoldCurrentAccout:(BOOL)isGoldCurrentAccout
{
    _isGoldCurrentAccout = isGoldCurrentAccout;
    if (isGoldCurrentAccout) {//活期
        self.gongDouLabel.text = @"";
        self.estimatAmountPayTitleLab.text = @"预计金额(含手续费)";
        self.getUpWeightGoldTilteLab.text = @"预期每日收益";
        self.getUpWeightGoldLabel.text = @"¥0.00";
        self.rechargeButton1.hidden = NO;
        self.estimatAmountPayableLabel.textAlignment = NSTextAlignmentRight;
        self.getUpWeightGoldLabel.textAlignment = NSTextAlignmentRight;
        for (UIView *view in self.contentView.subviews) {
            if (view.tag == 10) {
                for (UIView *view1 in view.subviews)
                {
                    [view1 removeFromSuperview];
                }
                [view removeFromSuperview];
            }
        }
    }else{//定期
        self.gongDouLabel.text = @"(含工豆)";
        self.estimatAmountPayTitleLab.text = @"预计应付金额";
        self.getUpWeightGoldTilteLab.text = @"到期收益克重";
        self.getUpWeightGoldLabel.text = @"0.000克";
        self.rechargeButton1.hidden = YES;
        self.estimatAmountPayableLabel.textAlignment = NSTextAlignmentLeft;
        self.getUpWeightGoldLabel.textAlignment = NSTextAlignmentLeft;
    }
}
-(void)setDataDict:(NSDictionary *)dataDict
{
    _dataDict = dataDict;
    NSDictionary *userAccountInfoDict = [_dataDict objectForKey:@"userAccountInfo"];
    
    BOOL isGongDouSwitch = [[NSUserDefaults standardUserDefaults] boolForKey:@"SelectGoldGongDouSwitch"];
    self.availableAllMoneyLabel.text = isGongDouSwitch ? [NSString stringWithFormat:@"¥%@",[userAccountInfoDict objectForKey:@"availableAllMoney"]] :[NSString stringWithFormat:@"¥%@",[userAccountInfoDict objectForKey:@"availableMoney"]];
    self.availableMoneyLabel.text = [NSString stringWithFormat:@"¥%@",[userAccountInfoDict objectForKey:@"availableMoney"]];
    self.accountBeanLabel.text = [NSString stringWithFormat:@"¥%@",[userAccountInfoDict objectForKey:@"accountBean"]];
    
}
-(void)setGoldModel:(UCFGoldModel *)goldModel
{
    _goldModel = goldModel;
    self.moneyTextField.placeholder = [NSString stringWithFormat:@"%@克起",goldModel.minPurchaseAmount];
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
 
    NSDictionary *userAccountInfoDict = [_dataDict objectForKey:@"userAccountInfo"];
    if (sender.on) {
        self.availableAllMoneyLabel.text = [NSString stringWithFormat:@"¥%@",[userAccountInfoDict objectForKey:@"availableAllMoney"]];
    }else{
        self.availableAllMoneyLabel.text = [NSString stringWithFormat:@"¥%@",[userAccountInfoDict objectForKey:@"availableMoney"]];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickGoldSwitch:)]) {
        [self.delegate clickGoldSwitch:sender];
    }
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
    self.estimatAmountPayableLabel.text = [NSString stringWithFormat:@"¥%.2lf",[[Common notRounding:amountPay afterPoint:2] doubleValue]];
    
    if (self.isGoldCurrentAccout) {
        double getUpWeightGold = amountPay * [self.goldModel.annualRate doubleValue] /360.0/100;
        self.getUpWeightGoldLabel.text = [NSString stringWithFormat:@"¥%.2lf",[[Common notRounding:getUpWeightGold afterPoint:2] doubleValue]];
    }else{
        double periodTerm = [[self.goldModel.periodTerm substringWithRange:NSMakeRange(0, self.goldModel.periodTerm.length - 1)] doubleValue];
        
        double getUpWeightGold = [textField.text doubleValue] *[self.goldModel.annualRate doubleValue] * periodTerm /360.0 / 100.0;
        self.getUpWeightGoldLabel.text = [NSString stringWithFormat:@"%.3lf克",[[Common notRounding:getUpWeightGold afterPoint:3] doubleValue]];
    }
    return textField;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
