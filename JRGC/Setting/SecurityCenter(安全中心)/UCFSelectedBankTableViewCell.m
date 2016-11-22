//
//  UCFSelectedBankTableViewCell.m
//  JRGC
//
//  Created by NJW on 15/5/22.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFSelectedBankTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UCFBankModel.h"

@interface UCFSelectedBankTableViewCell ()
// 银行图标
@property (weak, nonatomic) IBOutlet UIImageView *bankProfileImageView;
// 银行名称
@property (weak, nonatomic) IBOutlet UILabel *bankName;
// 快捷支付图标
@property (weak, nonatomic) IBOutlet UIImageView *signForPayImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightSpaceForQuickSign;

@end

@implementation UCFSelectedBankTableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableview
{
    static NSString *ID = @"selectedbank";
    UCFSelectedBankTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UCFSelectedBankTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"银行";
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.textColor = UIColorWithRGB(0x555555);
        cell.textLabel.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"UCFSelectedBankTableViewCell" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)setBankModel:(UCFBankModel *)bankModel
{
    _bankModel = bankModel;
    [self.bankProfileImageView sd_setImageWithURL:[NSURL URLWithString:bankModel.url] placeholderImage:nil];
    self.bankName.text = bankModel.bankName;
    if (bankModel.isSupportQuickPay) {
        self.signForPayImageView.hidden = NO;
    }
    else {
        self.rightSpaceForQuickSign.constant = 0;
        [self.signForPayImageView removeFromSuperview];
        self.signForPayImageView = nil;
    }
}
@end
