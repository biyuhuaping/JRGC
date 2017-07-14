//
//  UCFGoldRechargeHeaderView.m
//  JRGC
//
//  Created by njw on 2017/7/13.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldRechargeHeaderView.h"

#define font 13
@interface UCFGoldRechargeHeaderView () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (assign, nonatomic) BOOL isSelect;
@end

@implementation UCFGoldRechargeHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self protocolIsSelect:self.isSelect];
}


- (void)protocolIsSelect:(BOOL)select {
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"我已阅读并同意《委托划款授权书》"];
    [attributedString addAttribute:NSLinkAttributeName
                             value:@"weituohuakuan://"
                             range:[[attributedString string] rangeOfString:@"《委托划款授权书》"]];
    
    UIImage *image = [UIImage imageNamed:select == YES ? @"purchases_check_box_sel" : @"purchases_check_box_nor"];
    CGSize size = CGSizeMake(font + 2, font + 2);
    UIGraphicsBeginImageContextWithOptions(size, false, 0);
    [image drawInRect:CGRectMake(0, 2, 17, 17)];
    UIImage *resizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = resizeImage;
    NSMutableAttributedString *imageString = (id) [NSMutableAttributedString attributedStringWithAttachment:textAttachment];
    
    [imageString addAttribute:NSLinkAttributeName
                        value:@"checkbox://"
                        range:NSMakeRange(0, imageString.length)];
    [attributedString insertAttributedString:imageString atIndex:0];
    
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
    if ([[URL scheme] isEqualToString:@"weituohuakuan"]) {
        
        NSLog(@"委托协议---------------");
        return NO;
    } else if ([[URL scheme] isEqualToString:@"checkbox"]) {
        self.isSelect = !self.isSelect;
        [self protocolIsSelect:self.isSelect];
        return NO;
    }
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
    [self protocolIsSelect:self.isSelect];
    
}
@end
