//
//  BankDetailTableViewCell.m
//  JRGC
//
//  Created by zrc on 2018/11/19.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import "BankDetailTableViewCell.h"
#import "MBProgressHUD.h"
@interface BankDetailTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *bankNameLab;
@property (weak, nonatomic) IBOutlet UILabel *bankNoLab;
@property (weak, nonatomic) IBOutlet UILabel *bankLocationLab;

@end
@implementation BankDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)copyToBoard:(UIButton *)sender {
    NSInteger tag = sender.tag;
    UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
    if (tag == 100) {
        [pastboard setString:_bankNameLab.text];
    } else if (tag == 101) {
        [pastboard setString:_bankNoLab.text];
    } else if (tag == 102) {
        [pastboard setString:_bankLocationLab.text];
    }
    [MBProgressHUD displayHudError:@"复制成功"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
