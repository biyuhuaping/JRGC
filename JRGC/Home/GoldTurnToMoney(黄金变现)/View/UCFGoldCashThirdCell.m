//
//  UCFGoldCashThirdCell.m
//  JRGC
//
//  Created by njw on 2017/8/15.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldCashThirdCell.h"

@interface UCFGoldCashThirdCell () <UITextFieldDelegate>

@property (weak, nonatomic) UIView *leftView;
@property (weak, nonatomic) UIButton *cashAllButton;
@end

@implementation UCFGoldCashThirdCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectZero];
    self.textField.leftView = leftView;
    self.leftView = leftView;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cashAllButton = button;
    [self.textField addTarget:self action:@selector(textfieldLength:) forControlEvents:UIControlEventEditingChanged];
    [button setTitle:@"全部变现" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:UIColorWithRGB(0x4aa1f9) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cashAll:) forControlEvents:UIControlEventTouchUpInside];
    self.textField.rightView = button;
    self.textField.rightViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
    self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
}

- (void)cashAll:(UIButton *)button {
    self.textField.text = self.avavilableGoldAmount;
}

- (UITextField *)textfieldLength:(UITextField *)textField
{
    if (textField == self.textField) {
        NSString *str = textField.text;
        NSArray *array = [str componentsSeparatedByString:@"."];
        
        NSString *jeLength = [array firstObject];
        if (jeLength.length > 7) {
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
    }
    if ([textField.text doubleValue] > [self.avavilableGoldAmount doubleValue]) {
        textField.text = self.avavilableGoldAmount;
    }
    return textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text floatValue] > [self.avavilableGoldAmount floatValue]) {
        textField.text = self.avavilableGoldAmount;
    }
    [self.tableview reloadData];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.leftView.frame = CGRectMake(0, 0, 6, self.height);
    self.cashAllButton.frame = CGRectMake(0, 0, 72, self.height);
}

@end
