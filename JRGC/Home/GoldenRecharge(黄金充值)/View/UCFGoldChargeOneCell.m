//
//  UCFGoldChargeOneCell.m
//  JRGC
//
//  Created by njw on 2017/8/9.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldChargeOneCell.h"

@implementation UCFGoldChargeOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = UIColorWithRGB(0xebebee);
    [self.textField addTarget:self action:@selector(textfieldLength:) forControlEvents:UIControlEventEditingChanged];
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 37)];
    self.textField.leftView = leftView;
    self.textField.leftViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
    self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
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
            if(str.length > 2)
            {
                textField.text = [textField.text substringToIndex:textField.text.length-1];
            }
            NSString *firStr = [array objectAtIndex:0];
            if (firStr == nil || firStr.length == 0) {
                textField.text = [NSString stringWithFormat:@"0%@",textField.text];
            }
        }
    }
    return textField;
}

@end
