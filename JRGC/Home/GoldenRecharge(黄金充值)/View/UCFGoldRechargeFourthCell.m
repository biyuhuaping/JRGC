//
//  UCFGoldRechargeFourthCell.m
//  JRGC
//
//  Created by njw on 2017/8/10.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldRechargeFourthCell.h"
#import "UCFContractModel.h"

#define font 13
@interface UCFGoldRechargeFourthCell () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (assign, nonatomic) BOOL isSelect;
@end

@implementation UCFGoldRechargeFourthCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = UIColorWithRGB(0xebebee);
    [self protocolIsSelect:self.isSelect];
}

- (void)protocolIsSelect:(BOOL)select  {
    NSMutableString *str1 = [NSMutableString stringWithFormat:@"点击查看银行限额"];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str1];
    NSString *str = [NSString stringWithFormat:@"银行限额"];
    NSString *strV = [NSString stringWithFormat:@"checkbanklimit://"];
    [attributedString addAttribute:NSLinkAttributeName
                             value:strV
                             range:[[attributedString string] rangeOfString:str]];
    
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
    if ([[URL scheme] isEqualToString:@"checkbanklimit"]) {
//        UCFContractModel *contract = [self.constracts firstObject];
//        NSLog(@"委托协议---------------");
        if ([self.delegate respondsToSelector:@selector(goldRechargeCell:didClickedCheckButton:)]) {
            [self.delegate goldRechargeCell:self didClickedCheckButton:nil];
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
