//
//  FundDetailTableViewCell.m
//  JRGC
//
//  Created by NJW on 15/4/22.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "FundDetailTableViewCell.h"

@implementation FundDetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"FundDetailTableViewCell" owner:self options:nil] lastObject];
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableview
{
    
    static NSString *ID = @"funddetailcell";
    FundDetailTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[self class] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

@end
