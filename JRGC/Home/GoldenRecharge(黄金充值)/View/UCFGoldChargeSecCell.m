//
//  UCFGoldChargeSecCell.m
//  JRGC
//
//  Created by njw on 2017/8/9.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldChargeSecCell.h"
#import "UCFContractModel.h"

#define font 13
@interface UCFGoldChargeSecCell () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (assign, nonatomic) BOOL isSelect;
@end

@implementation UCFGoldChargeSecCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = UIColorWithRGB(0xebebee);
}

- (void)setConstracts:(NSArray *)constracts
{
    _constracts = constracts;
    if (constracts.count>0) {
        [self protocolIsSelect:self.isSelect withConstract:constracts];
    }
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
    _textView.linkTextAttributes = @{NSForegroundColorAttributeName: UIColorWithRGB(0x4aa1f9),
                                     NSUnderlineColorAttributeName: [UIColor lightGrayColor],
                                     NSUnderlineStyleAttributeName: @(NSUnderlinePatternSolid)};
    _textView.textColor = UIColorWithRGB(0x999999);
    _textView.backgroundColor = UIColorWithRGB(0xebebee);
    _textView.delegate = self;
    _textView.editable = NO; //必须禁止输入，否则点击将弹出输入键盘
    _textView.scrollEnabled = NO;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    if ([[URL scheme] isEqualToString:@"weituohuakuan0"]) {
        UCFContractModel *contract = [self.constracts firstObject];
        NSLog(@"委托协议---------------");
        if ([self.delegate respondsToSelector:@selector(goldRechargeSecCell:didClickedConstractWithId:)]) {
            [self.delegate goldRechargeSecCell:self didClickedConstractWithId:contract.Id];
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

@end
