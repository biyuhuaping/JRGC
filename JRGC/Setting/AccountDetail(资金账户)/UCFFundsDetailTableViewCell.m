//
//  UCFFundsDetailTableViewCell.m
//  JRGC
//
//  Created by NJW on 15/4/28.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFFundsDetailTableViewCell.h"

#import "FundsDetailModel.h"

@implementation UCFFundsDetailTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"fundDetail";
    UCFFundsDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[self class] alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}

- (void)setModel:(FundsDetailModel *)model
{
    _model = model;
    self.detailTextLabel.numberOfLines = 0;
    [self.textLabel setText:model.name];
    [self.detailTextLabel setText:model.data];
}

@end
