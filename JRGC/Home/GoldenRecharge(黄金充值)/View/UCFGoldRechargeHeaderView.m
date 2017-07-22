//
//  UCFGoldRechargeHeaderView.m
//  JRGC
//
//  Created by njw on 2017/7/13.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldRechargeHeaderView.h"
#import "MBProgressHUD.h"
#import "UCFContractModel.h"


#define font 13
@interface UCFGoldRechargeHeaderView () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (assign, nonatomic) BOOL isSelect;
@end

@implementation UCFGoldRechargeHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
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

- (void)protocolIsSelect:(BOOL)select withConstract:(NSArray *)constracts {
    
    NSMutableString *contractsStr = [NSMutableString string];
    [contractsStr appendString:@"我已阅读并同意"];
    for (UCFContractModel *contract in constracts) {
        [contractsStr appendString:@"《"];
        [contractsStr appendString:contract.contractName];
        [contractsStr appendString:@"》"];
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:contractsStr];
    for (UCFContractModel *contract in constracts) {
        NSString *str = [NSString stringWithFormat:@"《%@》", contract.contractName];
        NSString *strV = [NSString stringWithFormat:@"weituohuakuan%lu://", (unsigned long)[constracts indexOfObject:contract]];
        [attributedString addAttribute:NSLinkAttributeName
                                 value:strV
                                 range:[[attributedString string] rangeOfString:str]];
    }
    
//    UIImage *image = [UIImage imageNamed:select == YES ? @"purchases_check_box_sel" : @"purchases_check_box_nor"];
//    CGSize size = CGSizeMake(font + 2, font + 2);
//    UIGraphicsBeginImageContextWithOptions(size, false, 0);
//    [image drawInRect:CGRectMake(0, 2, 17, 17)];
//    UIImage *resizeImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
//    textAttachment.image = resizeImage;
//    NSMutableAttributedString *imageString = (id) [NSMutableAttributedString attributedStringWithAttachment:textAttachment];
//
//    [imageString addAttribute:NSLinkAttributeName
//                        value:@"checkbox://"
//                        range:NSMakeRange(0, imageString.length)];
//    [attributedString insertAttributedString:imageString atIndex:0];
    
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:NSMakeRange(0, attributedString.length)];
    _textView.attributedText = attributedString;
    _textView.linkTextAttributes = @{NSForegroundColorAttributeName: [UIColor blueColor],
                                     NSUnderlineColorAttributeName: [UIColor lightGrayColor],
                                     NSUnderlineStyleAttributeName: @(NSUnderlinePatternSolid)};
    
    _textView.delegate = self;
    _textView.editable = NO; //必须禁止输入，否则点击将弹出输入键盘
    _textView.scrollEnabled = NO;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    if ([[URL scheme] isEqualToString:@"weituohuakuan0"]) {
        UCFContractModel *contract = [self.constracts firstObject];
        NSLog(@"委托协议---------------");
        if ([self.delegate respondsToSelector:@selector(goldRechargeHeader:didClickedConstractWithId:)]) {
            [self.delegate goldRechargeHeader:self didClickedConstractWithId:contract.Id];
        }
        return NO;
    }
//    else if ([[URL scheme] isEqualToString:@"checkbox"]) {
//        self.isSelect = !self.isSelect;
//        [self protocolIsSelect:self.isSelect];
//        return NO;
//    }
    return YES;
}


- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    [UIMenuController sharedMenuController].menuVisible = NO;
    
    //    [_neiRongTextView resignFirstResponder];
    
    [self setNeiRong];
    
    return  NO;
    
}

- (void)setNeiRong {
    
    //     再次
//    [self protocolIsSelect:self.isSelect];
    
}
- (IBAction)handIn:(UIButton *)sender {
    [self endEditing:YES];
    NSString *inputMoney = [Common deleteStrHeadAndTailSpace:self.textField.text];
    if ([Common isPureNumandCharacters:inputMoney]) {
        [MBProgressHUD displayHudError:@"请输入正确金额"];
        return;
    }
    inputMoney = [NSString stringWithFormat:@"%.2f",[inputMoney doubleValue]];
    NSComparisonResult comparResult = [@"0.01" compare:[Common deleteStrHeadAndTailSpace:inputMoney] options:NSNumericSearch];
    //ipa 版本号 大于 或者等于 Apple 的版本，返回，不做自己服务器检测
    if (comparResult == NSOrderedDescending) {
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入充值金额" message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        //        [alert show];
        [MBProgressHUD displayHudError:@"请输入充值金额"];
        return;
    }
    comparResult = [inputMoney compare:@"10000000.00" options:NSNumericSearch];
    if (comparResult == NSOrderedDescending || comparResult == NSOrderedSame) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"充值金额不可大于1000万" message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(goldRechargeHeader:didClickedHandInButton:withMoney:)]) {
        [self.delegate goldRechargeHeader:self didClickedHandInButton:sender withMoney:inputMoney];
    }
}

- (void)setConstracts:(NSArray *)constracts
{
    _constracts = constracts;
    if (constracts.count>0) {
        [self protocolIsSelect:self.isSelect withConstract:constracts];
    }
}

@end
