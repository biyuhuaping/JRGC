//
//  UCFFundDetialTableViewCell.m
//  JRGC
//
//  Created by NJW on 15/5/4.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//
// 流水标题的字体
#define UCFWaterTitleFont [UIFont systemFontOfSize:14]
// 账单内容的字体
#define UCFTextFont [UIFont systemFontOfSize:12]
// 分割线高度
#define UCFLineHeight 0.5

#import "UCFFundDetialTableViewCell.h"
#import "FundsDetailFrame.h"
#import "FundsDetailModel.h"
#import "NSString+FormatForThousand.h"
#import "UCFToolsMehod.h"

@interface UCFFundDetialTableViewCell ()
// 流水标题的背景视图
@property (nonatomic, weak) UIView *waterNameBgView;
// 流水标题
@property (nonatomic, weak) UILabel *waterTitleLabel;
// 金额
@property (nonatomic, weak) UILabel *moneyLabel;
// 冻结金额
@property (nonatomic, weak) UILabel *frozenLabel;
// 发生时间
@property (nonatomic, weak) UILabel *happenTimeLabel;
// 备注
@property (nonatomic, weak) UILabel *markLabel;
// 第一分割线
@property (nonatomic, weak) UIView *firstLine;
// 第二分割线
@property (nonatomic, weak) UIView *secondLine;
// 第三分割线
@property (nonatomic, weak) UIView *thirdLine;
// 第四分割线
@property (nonatomic, weak) UIView *fourthLine;
// 顶部分割线
@property (nonatomic, weak) UIView *topLine;
// 底部分割线
@property (nonatomic, weak) UIView *bottomLine;

// 标题一
@property (nonatomic, weak) UILabel *moneyTitleLabel;
// 标题二
@property (nonatomic, weak) UILabel *frozenTitleLabel;
// 标题三
@property (nonatomic, weak) UILabel *happenTimeTitleLabel;
// 标题四
@property (nonatomic, weak) UILabel *markTitleLabel;
@end

@implementation UCFFundDetialTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableview
{
    static NSString *ID = @"fundsdetailcell";
    UCFFundDetialTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UCFFundDetialTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)setFrame:(CGRect)frame
{
    if (self.isFirst) {
        frame.origin.y += 10;
        frame.size.height -= 20;
    }
    else {
        
        frame.size.height -= 10;
    }
    
    [super setFrame:frame];
}

- (void)setFundsFrame:(FundsDetailFrame *)fundsFrame
{
    _fundsFrame = fundsFrame;
    
    // 设置frame
    [self setContentFrame];
    // 设置数据
    [self setData];
}

- (void)setContentFrame
{
    self.waterTitleLabel.frame = self.fundsFrame.nameF;
    self.moneyTitleLabel.frame = self.fundsFrame.jinETitleF;
    
    self.moneyLabel.frame = self.fundsFrame.jinEF;
    
    self.secondLine.frame = CGRectMake(15, CGRectGetMaxY(_moneyTitleLabel.frame), ScreenWidth - 15, UCFLineHeight);
    
    self.frozenTitleLabel.frame = self.fundsFrame.frozenJinETitleF;
    
    self.frozenLabel.frame = self.fundsFrame.frozenJinEF;
    
    self.thirdLine.frame = CGRectMake(15, CGRectGetMaxY(_frozenTitleLabel.frame), ScreenWidth - 15, UCFLineHeight);
    
    self.happenTimeTitleLabel.frame = self.fundsFrame.happendTimeTitleF;
    
    self.happenTimeLabel.frame = self.fundsFrame.happendTimeF;
    
    self.fourthLine.frame = CGRectMake(15, CGRectGetMaxY(_happenTimeTitleLabel.frame), ScreenWidth - 15, UCFLineHeight);
    
    self.markTitleLabel.frame = self.fundsFrame.markTitleF;

    self.markLabel.frame = self.fundsFrame.markF;
}

- (void)setData
{
    self.waterTitleLabel.text = self.fundsFrame.fundsDetailModel.waterTypeName;
    if ([_fundsFrame.fundsDetailModel.cashValue isEqualToString:@"0.00"]) {
        [self.moneyLabel setText:[NSString stringWithFormat:@"¥%@", [UCFToolsMehod AddComma:self.fundsFrame.fundsDetailModel.cashValue]]];
        _moneyLabel.textColor = [UIColor blackColor];
    } else if ([self.fundsFrame.fundsDetailModel.cashValue hasPrefix:@"-"]) {
        DLog(@"====>%@", self.fundsFrame.fundsDetailModel.cashValue);
        NSString *temp = [self.fundsFrame.fundsDetailModel.cashValue stringByReplacingOccurrencesOfString:@"-" withString:@""];
        DLog(@"===>%@", temp);
        [self.moneyLabel setText:[NSString stringWithFormat:@"¥-%@", [UCFToolsMehod AddComma:temp]]];
        _moneyLabel.textColor = UIColorWithRGB(0x4db94f);
    } else {
        [self.moneyLabel setText:[NSString stringWithFormat:@"¥%@", [UCFToolsMehod AddComma:self.fundsFrame.fundsDetailModel.cashValue]]];
        _moneyLabel.textColor = UIColorWithRGB(0xfd4d4c);
    }
    
    if ([_fundsFrame.fundsDetailModel.frozen isEqualToString:@"0.00"]) {
        [self.frozenLabel setText:[NSString stringWithFormat:@"¥%@", [UCFToolsMehod AddComma:self.fundsFrame.fundsDetailModel.frozen]]];
        _frozenLabel.textColor = [UIColor blackColor];
    } else if ([self.fundsFrame.fundsDetailModel.frozen hasPrefix:@"-"]) {
        NSString *temp = [self.fundsFrame.fundsDetailModel.frozen stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [self.frozenLabel setText:[NSString stringWithFormat:@"¥-%@", [UCFToolsMehod AddComma:temp]]];
        _frozenLabel.textColor = UIColorWithRGB(0x4db94f);
    } else {
        [self.frozenLabel setText:[NSString stringWithFormat:@"¥%@", [UCFToolsMehod AddComma:self.fundsFrame.fundsDetailModel.frozen]]];
        _frozenLabel.textColor = UIColorWithRGB(0xfd4d4c);
    }
    [self.happenTimeLabel setText:self.fundsFrame.fundsDetailModel.createTime];
    [self.markLabel setText:self.fundsFrame.fundsDetailModel.remark];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 标题背景视图
        UIView *waterNameBgView = [[UIView alloc] init];
        waterNameBgView.frame = CGRectMake(0, 0, ScreenWidth, 37);
        [self.contentView addSubview:waterNameBgView];
        self.waterNameBgView = waterNameBgView;
        [waterNameBgView setBackgroundColor:UIColorWithRGB(0xf9f9f9)];
        
        // 顶部分割线
        UIView *line_top = [[UIView alloc] init];
        [self.contentView addSubview:line_top];
        [line_top setFrame:CGRectMake(0, CGRectGetMinY(waterNameBgView.frame), ScreenWidth, 0.5)];
        [line_top setBackgroundColor:UIColorWithRGB(0xd8d8d8)];
        self.topLine = line_top;
        
        // 顶部分割线
        UIView *line_bottom = [[UIView alloc] init];
        [self.contentView addSubview:line_bottom];
        [line_bottom setBackgroundColor:UIColorWithRGB(0xd8d8d8)];
        self.bottomLine = line_bottom;
        
        // 第一分割线
        UIView *line_first = [[UIView alloc] init];
        [self.contentView addSubview:line_first];
        [line_first setFrame:CGRectMake(0, CGRectGetMaxY(waterNameBgView.frame), ScreenWidth, 0.5)];
        [line_first setBackgroundColor:UIColorWithRGB(0xeff0f3)];
        self.firstLine = line_first;
        
        // 第二分割线
        UIView *line_second = [[UIView alloc] init];
        [self.contentView addSubview:line_second];
        [line_second setBackgroundColor:UIColorWithRGB(0xeff0f3)];
        self.secondLine = line_second;
        
        // 第三分割线
        UIView *line_third = [[UIView alloc] init];
        [self.contentView addSubview:line_third];
        [line_third setBackgroundColor:UIColorWithRGB(0xeff0f3)];
        self.thirdLine = line_third;
        
        // 第四分割线
        UIView *line_fourth = [[UIView alloc] init];
        [self.contentView addSubview:line_fourth];
        [line_fourth setBackgroundColor:UIColorWithRGB(0xeff0f3)];
        self.fourthLine = line_fourth;
        
        // 流水标题
        UILabel *waterTitleLabel = [[UILabel alloc] init];
        [waterNameBgView addSubview:waterTitleLabel];
        waterTitleLabel.font = UCFWaterTitleFont;
        [waterTitleLabel setTextColor:UIColorWithRGB(0x333333)];
        self.waterTitleLabel = waterTitleLabel;
        // 金额
        UILabel *moneyLabel = [[UILabel alloc] init];
        [self.contentView addSubview:moneyLabel];
        [moneyLabel setTextColor:UIColorWithRGB(0x555555)];
        moneyLabel.textAlignment = NSTextAlignmentRight;
        [moneyLabel setFont:UCFTextFont];
        self.moneyLabel = moneyLabel;
        // 冻结金额
        UILabel *frozenLabel = [[UILabel alloc] init];
        [self.contentView addSubview:frozenLabel];
        frozenLabel.textAlignment = NSTextAlignmentRight;
        [frozenLabel setFont:UCFTextFont];
        self.frozenLabel = frozenLabel;
        // 发生时间
        UILabel *happenTimeLabel = [[UILabel alloc] init];
        [self.contentView addSubview:happenTimeLabel];
        [happenTimeLabel setTextColor:UIColorWithRGB(0x555555)];
        happenTimeLabel.textAlignment = NSTextAlignmentRight;
        [happenTimeLabel setFont:UCFTextFont];
        self.happenTimeLabel = happenTimeLabel;
        // 备注
        UILabel *markLabel = [[UILabel alloc] init];
        markLabel.numberOfLines = 0;
        [self.contentView addSubview:markLabel];
        [markLabel setTextColor:UIColorWithRGB(0x555555)];
        markLabel.textAlignment = NSTextAlignmentRight;
        markLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [markLabel setFont:UCFTextFont];
        self.markLabel = markLabel;
//        markLabel.backgroundColor = [UIColor redColor];
        
        // 标题一
        UILabel *moneyTitleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:moneyTitleLabel];
        moneyTitleLabel.text = @"金额";
        [moneyTitleLabel setTextColor:UIColorWithRGB(0x555555)];
        [moneyTitleLabel setFont:UCFTextFont];
        self.moneyTitleLabel = moneyTitleLabel;
        
        // 标题二
        UILabel *frozenTitleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:frozenTitleLabel];
        [frozenTitleLabel setTextColor:UIColorWithRGB(0x555555)];
        [frozenTitleLabel setText:@"冻结资金"];
        [frozenTitleLabel setFont:UCFTextFont];
        self.frozenTitleLabel = frozenTitleLabel;
        
        // 标题三
        UILabel *happenTimeTitleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:happenTimeTitleLabel];
        [happenTimeTitleLabel setText:@"发生时间"];
        [happenTimeTitleLabel setTextColor:UIColorWithRGB(0x555555)];
        [happenTimeTitleLabel setFont:UCFTextFont];
        self.happenTimeTitleLabel = happenTimeTitleLabel;
        
        // 标题四
        UILabel *markTitleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:markTitleLabel];
        [markTitleLabel setText:@"备注"];
        [markTitleLabel setTextColor:UIColorWithRGB(0x555555)];
        [markTitleLabel setFont:UCFTextFont];
        self.markTitleLabel = markTitleLabel;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.bottomLine setFrame:CGRectMake(0, CGRectGetHeight(self.frame) -0.5, ScreenWidth, 0.5)];
}

@end
