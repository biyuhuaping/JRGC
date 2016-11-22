//
//  UCFBindCardTwoTableViewCell.m
//  JRGC
//
//  Created by NJW on 15/8/19.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFBindCardTwoTableViewCell.h"

@implementation UCFBindCardTwoTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableview
{
    static NSString *ID = @"bindcardone";
    UCFBindCardTwoTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UCFBindCardTwoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"UCFBindCardTwoTableViewCell" owner:self options:nil] lastObject];
        
        self.bindBankLocation.layer.cornerRadius = 8;
        self.bindBankLocation.clipsToBounds = YES;
        self.bindBankLocation.layer.borderWidth = 0.5;
        self.bindBankLocation.layer.borderColor = UIColorWithRGB(0xc8c8c8).CGColor;
        UIImageView *cardLocationLeftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
        cardLocationLeftImageView.contentMode = UIViewContentModeCenter;
        self.bindBankLocation.leftView = cardLocationLeftImageView;
        self.bindBankLocation.leftViewMode = UITextFieldViewModeAlways;
        cardLocationLeftImageView.image = [UIImage imageNamed:@"safecenter_icon_branch"];
    }
    return self;
}

@end
