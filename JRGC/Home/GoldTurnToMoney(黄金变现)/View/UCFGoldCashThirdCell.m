//
//  UCFGoldCashThirdCell.m
//  JRGC
//
//  Created by njw on 2017/8/15.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldCashThirdCell.h"

@interface UCFGoldCashThirdCell ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
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
    [button setTitle:@"全部变现" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:UIColorWithRGB(0x4aa1f9) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cashAll:) forControlEvents:UIControlEventTouchUpInside];
    self.textField.rightView = button;
    self.textField.rightViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
    self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
}

- (void)cashAll:(UIButton *)button {
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.leftView.frame = CGRectMake(0, 0, 6, self.height);
    self.cashAllButton.frame = CGRectMake(0, 0, 72, self.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
