//
//  UCFAccountCell.m
//  JRGC
//
//  Created by NJW on 16/4/8.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFAccountCell.h"
#include "FundAccountItem.h"

@interface UCFAccountCell ()
@property (nonatomic, weak) UITableView *tableView;

/**
 *  下分隔线
 */
@property (weak, nonatomic) UIView *downSeperateLine;
@end

@implementation UCFAccountCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"accountMenu";
    UCFAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.tableView = tableView;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:UIColorWithRGB(0xf8f8f8)];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.textColor = UIColorWithRGB(0x434343);
        self.textLabel.font = [UIFont systemFontOfSize:12];
        self.detailTextLabel.textColor = UIColorWithRGB(0x434343);
        self.detailTextLabel.font = [UIFont systemFontOfSize:12];
        UIView *downLine = [[UIView alloc] initWithFrame:CGRectZero];
        downLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
        [self.contentView addSubview:downLine];
        self.downSeperateLine = downLine;
    }
    return self;
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    NSInteger totalRows = [self.tableView numberOfRowsInSection:indexPath.section];
    
    if (totalRows == 1) { // 这组只有1行
        self.downSeperateLine.hidden = NO;
    } else if (indexPath.row == 0) { // 这组的首行(第0行)
        self.downSeperateLine.hidden = YES;
    } else if (indexPath.row == totalRows - 1) { // 这组的末行(最后1行)
        self.downSeperateLine.hidden = NO;
    } else {
        self.downSeperateLine.hidden = YES;
    }

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.downSeperateLine.frame = CGRectMake(0, CGRectGetHeight(self.frame)-1, ScreenWidth, 0.5);
}

- (void)setItem:(FundAccountItem *)item
{
    _item = item;
    self.textLabel.text = item.ItemName;
    
    self.detailTextLabel.text = [NSString stringWithFormat:@"¥%@",item.ItemData];//[UCFToolsMehod AddComma:[NSString stringWithFormat:@"%@",item.ItemData]]];
}

@end
