//
//  UCFIdNumberTextField.m
//  JRGC
//
//  Created by Qnwi on 16/2/24.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFIdNumberTextField.h"

#define lineYPos 5

@implementation UCFIdNumberTextField
{
    UITextField *_textFldHead;
    UITextField *_textFldMid;
    UITextField *_textFldEnd;
    NSString *_curtext;//输出的text
    NSString *_fldText;
}

- (NSString*)curText
{
    return _curtext;
}

- (id)initWithFrame:(CGRect)frame withText:(NSString*)fldText
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _fldText = fldText;
        [self drawTextField];
    }
    return self;
}

- (void)drawTextField
{
    CGFloat widHead = self.frame.size.width * 3 / 9;
    CGFloat widMid = self.frame.size.width * 4 / 9;
    CGFloat widEnd = self.frame.size.width - widHead - widMid;
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(widHead, lineYPos, 1, 30)];
    line1.backgroundColor = UIColorWithRGB(0xe3e5ea);
    [self addSubview:line1];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(widHead + widMid, lineYPos, 1, 30)];
    line2.backgroundColor = UIColorWithRGB(0xe3e5ea);
    [self addSubview:line2];
    
    _textFldHead = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, widHead, 40)];
    _textFldHead.font = [UIFont systemFontOfSize:16];
    _textFldHead.textColor = UIColorWithRGB(0x555555);
    _textFldHead.tag = 1001;
    _textFldHead.delegate = self;
    _textFldHead.textAlignment = NSTextAlignmentCenter;
    _textFldHead.text = [_fldText substringWithRange:NSMakeRange(0, 6)];
    [self addSubview:_textFldHead];
    
    _textFldMid = [[UITextField alloc] initWithFrame:CGRectMake(widHead + 1, 0, widMid - 2, 40)];
    _textFldMid.font = [UIFont systemFontOfSize:16];
    _textFldMid.textColor = UIColorWithRGB(0x555555);
    _textFldMid.tag = 1002;
    _textFldMid.delegate = self;
    _textFldMid.textAlignment = NSTextAlignmentCenter;
    _textFldMid.text = [_fldText substringWithRange:NSMakeRange(6, 8)];
    [self addSubview:_textFldMid];
    
    _textFldEnd = [[UITextField alloc] initWithFrame:CGRectMake(widHead + widMid + 1, 0, widEnd - 1, 40)];
    _textFldEnd.font = [UIFont systemFontOfSize:16];
    _textFldEnd.textColor = UIColorWithRGB(0x555555);
    _textFldEnd.tag = 1003;
    _textFldEnd.delegate = self;
    _textFldEnd.textAlignment = NSTextAlignmentCenter;
    _textFldEnd.text = [_fldText substringWithRange:NSMakeRange(14, 4)];
    [self addSubview:_textFldEnd];
    
}

#pragma mark -textfieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    if (textField.tag == 1001) {
        if (existedLength - selectedLength + replaceLength > 6) {
            [_textFldMid becomeFirstResponder];
            return NO;
        }
    } else if (textField.tag == 1002) {
        if (existedLength - selectedLength + replaceLength > 8) {
            [_textFldEnd becomeFirstResponder];
            return NO;
        }
    } else if (textField.tag == 1003) {
        if (existedLength - selectedLength + replaceLength > 4) {
            return NO;
        }
    }
    return YES;
}

@end
