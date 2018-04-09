//
//  CustomTableViewCell.m
//  SectionDemo
//
//  Created by NJW on 15/4/23.
//  Copyright (c) 2015年 NJW. All rights reserved.
//

#import "CustomTableViewCell.h"
#import "FundAccountItem.h"

@implementation CustomTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"CustomTableViewCell" owner:self options:nil] lastObject];
    }
    return self;
}

@end
