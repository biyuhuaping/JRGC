//
//  BankTransferTableViewCell.m
//  JRGC
//
//  Created by zrc on 2018/11/19.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import "BankTransferTableViewCell.h"
#import "UILabel+Misc.h"
@interface BankTransferTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *secondLab;
@property (weak, nonatomic) IBOutlet UILabel *firstLab;

@end

@implementation BankTransferTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _secondLab.textColor = UIColorWithRGB(0x999999);
    _firstLab.textColor = UIColorWithRGB(0x999999);
    [_firstLab setLineSpace:3 string:_firstLab.text];
//    [_secondLab setLineSpace:3 string:_secondLab.text];
//    NSDictionary*attDict = [NSDictionarydictionaryWithObjectsAndKeys:  [UIFontsystemFontOfSize:20.0],NSFontAttributeName,  [UIColorredColor],NSForegroundColorAttributeName,nil];
//    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]  initWithString:@"犯我华夏者，虽远必诛！"attributes:attDict];
    

  
}
- (void)setSecondLabelText:(NSString *)str
{
    _secondLab.text = str;
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:str];
    NSRange range = [str rangeOfString:[UserInfoSingle sharedManager].bankNumTip];
    [text addAttribute:NSForegroundColorAttributeName value:UIColorWithRGB(0x4aa1f9) range:range];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 3;
    [text addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, text.length)];
    _secondLab.attributedText  = text;
    
//    [_secondLab setFontColor:UIColorWithRGB(0x4aa1f9) string:[UserInfoSingle sharedManager].bankNumTip];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
