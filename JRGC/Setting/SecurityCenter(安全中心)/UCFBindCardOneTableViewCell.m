//
//  UCFBindCardOneTableViewCell.m
//  JRGC
//
//  Created by NJW on 15/5/11.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFBindCardOneTableViewCell.h"

@interface UCFBindCardOneTableViewCell ()

@end

@implementation UCFBindCardOneTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableview
{
    static NSString *ID = @"bindcardone";
    UCFBindCardOneTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UCFBindCardOneTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"UCFBindCardOneTableViewCell" owner:self options:nil] lastObject];
        self.bindCard.layer.cornerRadius = 8;
        self.bindCard.clipsToBounds = YES;
        self.bindCard.layer.borderWidth = 0.5;
        self.bindCard.layer.borderColor = UIColorWithRGB(0xc8c8c8).CGColor;
        UIImageView *cardLeftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
        cardLeftImageView.contentMode = UIViewContentModeCenter;
        self.bindCard.leftView = cardLeftImageView;
        self.bindCard.leftViewMode = UITextFieldViewModeAlways;
        cardLeftImageView.image = [UIImage imageNamed:@"safecenter_icon_bankcard"];
    }
    return self;
}

@end
