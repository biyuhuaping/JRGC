//
//  UCFBankTableViewCell.m
//  JRGC
//
//  Created by NJW on 15/5/21.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFBankTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UCFBankModel.h"

@interface UCFBankTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *bankProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *signForPayImageView;

@end

@implementation UCFBankTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableview
{
    static NSString *ID = @"bankInfo";
    UCFBankTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UCFBankTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"UCFBankTableViewCell" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)setBankModel:(UCFBankModel *)bankModel
{
    _bankModel = bankModel;
    [self.bankProfileImageView sd_setImageWithURL:[NSURL URLWithString:bankModel.url] placeholderImage:nil];
    self.bankNameLabel.text = bankModel.bankName;
    if (bankModel.isSupportQuickPay) {
        self.signForPayImageView.hidden = NO;
    }
    else
        self.signForPayImageView.hidden = YES;
}


@end
