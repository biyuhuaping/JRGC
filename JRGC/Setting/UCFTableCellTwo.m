//
//  UCFTableCellTwo.m
//  JRGC
//
//  Created by NJW on 16/8/9.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFTableCellTwo.h"
#import "UCFNoDataView.h"

@interface UCFTableCellTwo ()
@property (weak, nonatomic) UITableView *tableView;
@property (weak, nonatomic) UIView *downLine;
@property (nonatomic, assign) CGFloat downLeftSpace;
@property (nonatomic, strong) UIView *noDataView;                 // 无数据界面
@property (nonatomic, weak) UILabel *errorLbl;
@property (nonatomic, weak) UIImageView *iconView;

@end

@implementation UCFTableCellTwo

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"huishangTwo";
    UCFTableCellTwo *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.tableView = tableView;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.textLabel.font = [UIFont systemFontOfSize:14];
        self.textLabel.textColor = UIColorWithRGB(0x555555);
        self.detailTextLabel.font = [UIFont systemFontOfSize:10];
        self.detailTextLabel.textColor = UIColorWithRGB(0xc8c8c8);
        UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 50)];
        self.accessoryView = valueLabel;
        valueLabel.font = [UIFont systemFontOfSize:14];
        valueLabel.textAlignment = NSTextAlignmentRight;
        valueLabel.textColor = UIColorWithRGB(0xfd4d4c);
        self.valueLabel = valueLabel;
        
        UIView *downLine = [[UIView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:downLine];
        [downLine setBackgroundColor:UIColorWithRGB(0xe3e5ea)];
        self.downLine = downLine;
        
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectZero];
        iconView.image = [UIImage imageNamed:@"default_icon.png"];
        self.iconView = iconView;
        
        UILabel *errorLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        errorLbl.textColor = UIColorWithRGB(0x8591b3);
        errorLbl.font = [UIFont systemFontOfSize:12];
        errorLbl.textAlignment = NSTextAlignmentCenter;
        errorLbl.text = @"暂无数据";
        self.errorLbl = errorLbl;
        
        UIView *noDataView = [[UIView alloc] initWithFrame:CGRectZero];
//        self.noDataView.backgroundColor = UIColorWithRGB(0xebebee);
        self.noDataView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:noDataView];
        [noDataView addSubview:errorLbl];
        [noDataView addSubview:iconView];
        self.noDataView = noDataView;
        self.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGPoint textCenter = self.textLabel.center;
    textCenter.y = 25;
    self.textLabel.center = textCenter;
    
    CGFloat detailLabelY = CGRectGetMaxY(self.textLabel.frame);
    CGRect detailFrame = self.detailTextLabel.frame;
    detailFrame.origin.y = detailLabelY;
    self.detailTextLabel.frame = detailFrame;

    self.downLine.frame = CGRectMake(self.downLeftSpace, self.frame.size.height - 0.5, ScreenWidth-self.downLeftSpace, 0.5);
    
    if (self.isHasData) {
        self.noDataView.frame = CGRectZero;
        self.iconView.frame = CGRectZero;
        self.errorLbl.frame = CGRectZero;
        self.downLine.hidden = NO;
    }
    else {
        self.noDataView.frame = CGRectMake(0, 0, ScreenWidth, 150);
        self.iconView.frame = CGRectMake(0, 0, 35, 35);
        CGPoint center = self.noDataView.center;
        center.y -= 10;
        self.iconView.center = center;
        
        self.errorLbl.frame = CGRectMake(CGRectGetMinX(self.iconView.frame)-10, CGRectGetMaxY(self.iconView.frame), 55, 27);
        self.downLine.hidden = YES;
        self.noDataView.backgroundColor = [UIColor clearColor];
    }
    self.noDataView.backgroundColor = UIColorWithRGB(0xebebee);
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    
    // 根据cell显示的具体位置, 来设置背景view显示的分割线
    // 获得cell这组的总行数
    NSInteger totalRows = [self.tableView numberOfRowsInSection:indexPath.section];
    if (totalRows == 1) { // 这组只有1行
//        self.downLine.hidden = NO;
        self.downLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
        self.downLeftSpace = 0;
    } else if (indexPath.row == 0) { // 这组的首行(第0行)
//        self.downLine.hidden = NO;
        self.downLeftSpace = 15;
    } else if (indexPath.row == totalRows - 1) { // 这组的末行(最后1行)
//        self.downLine.hidden = NO;
        self.downLeftSpace = 0;
        self.downLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
    } else {
        self.downLeftSpace = 15;
    }
}

- (void)setListModel:(UCFHuiBuinessListModel *)listModel
{
    _listModel = listModel;
    self.textLabel.text = listModel.desc;
    self.detailTextLabel.text = listModel.createDate;
    if ([listModel.amount hasPrefix:@"-"]) {
        self.valueLabel.textColor = UIColorWithRGB(0x4db94f);
    }
    else {
        self.valueLabel.textColor = UIColorWithRGB(0xfd4d4c);
    }
    self.valueLabel.text = listModel.amount;
}

@end
