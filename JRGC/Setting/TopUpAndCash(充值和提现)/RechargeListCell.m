//
//  RechargeListCell.m
//  JRGC
//
//  Created by 金融工场 on 15/5/19.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "RechargeListCell.h"
#import "Common.h"
#import "UCFToolsMehod.h"
@implementation RechargeListCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}
- (void)initView
{
    UIView * sepView = [Common addSepateViewWithRect:CGRectMake(0, 0, ScreenWidth, 10.0f) WithColor:UIColorWithRGB(0xf2f2f2)];
    [self addSubview:sepView];
    
//    [Common addLineViewColor:UIColorWithRGB(0xd8d8d8) With:sepView isTop:YES];
    [Common addLineViewColor:UIColorWithRGB(0xd8d8d8) With:sepView isTop:NO];
    
    UIView *topGrayView = [Common addSepateViewWithRect:CGRectMake(0, CGRectGetMaxY(sepView.frame), ScreenWidth, 37) WithColor:UIColorWithRGB(0xf9f9f9)];
    [self addSubview:topGrayView];
    [Common addLineViewColor:UIColorWithRGB(0xeff0f3) With:topGrayView isTop:NO];
    
    _orderTipLabel = [[UILabel alloc] init];
    _orderTipLabel.text = @"订单号";
    _orderTipLabel.frame = CGRectMake(15, 0, 16 * 3, 37);
    _orderTipLabel.textColor = UIColorWithRGB(0x333333);
    _orderTipLabel.font = [UIFont systemFontOfSize:14.0f];
    _orderTipLabel.backgroundColor = [UIColor clearColor];
//    _orderTipLabel.backgroundColor = [UIColor greenColor];

    [topGrayView addSubview:_orderTipLabel];
    
    _orderNumLabel = [[UILabel alloc] init];
    _orderNumLabel.text = @"ETEEEEE@!@#E$@#@#qq";
    _orderNumLabel.textColor = UIColorWithRGB(0x999999);
//    _orderNumLabel.backgroundColor = [UIColor redColor];
    _orderNumLabel.frame = CGRectMake(CGRectGetMaxX(_orderTipLabel.frame), 0, ScreenWidth - CGRectGetMaxX(_orderTipLabel.frame) - 90, 37);
    _orderNumLabel.font = [UIFont systemFontOfSize:12.0f];
    [topGrayView addSubview:_orderNumLabel];
    
    _statueLabel = [[UILabel alloc] init];
    _statueLabel.font = [UIFont systemFontOfSize:14.0f];
    _statueLabel.textColor = [UIColor lightGrayColor];
    _statueLabel.frame = CGRectMake(ScreenWidth - 90, 0, 75, 37);
    _statueLabel.text = @"支付成功";
    _statueLabel.textAlignment = NSTextAlignmentRight;
    _statueLabel.textColor = UIColorWithRGB(0x999999);
    [topGrayView addSubview:_statueLabel];
    
    _moneyTipLabel = [[UILabel alloc] init];
    _moneyTipLabel.text = @"金额";
    _moneyTipLabel.frame = CGRectMake(15, CGRectGetMaxY(topGrayView.frame), 14 * 3, 27);
    _moneyTipLabel.textColor = UIColorWithRGB(0x555555);
    _moneyTipLabel.font = [UIFont systemFontOfSize:12.0f];
    _moneyTipLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_moneyTipLabel];
    
    _moneyLabel = [[UILabel alloc] init];
    _moneyLabel.text = @"¥1000";
    _moneyLabel.frame = CGRectMake(CGRectGetMaxX(_moneyTipLabel.frame) + 10,CGRectGetMaxY(topGrayView.frame),ScreenWidth - CGRectGetMaxX(_moneyTipLabel.frame) - 10 - 15, 27);
    _moneyLabel.textColor = UIColorWithRGB(0x555555);
    _moneyLabel.textAlignment = NSTextAlignmentRight;
    _moneyLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    _moneyLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_moneyLabel];
    
    UIView * sepView1 = [Common addSepateViewWithRect:CGRectMake(15, CGRectGetMaxY(_moneyLabel.frame), ScreenWidth, 0.5f) WithColor:UIColorWithRGB(0xeff0f3)];
    [self addSubview:sepView1];
    
    _beginLabel = [[UILabel alloc] init];
    _beginLabel.text = @"发生时间";
    _beginLabel.frame = CGRectMake(15, CGRectGetMaxY(sepView1.frame), 14 * 4, 27);
    _beginLabel.textColor = UIColorWithRGB(0x555555);
    _beginLabel.font = [UIFont systemFontOfSize:12.0f];
    _beginLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_beginLabel];
    
    _timeValueLabel = [[UILabel alloc] init];
    _timeValueLabel.text = @"2015-11-28 12:20:17";
    _timeValueLabel.frame = CGRectMake(CGRectGetMaxX(_beginLabel.frame) + 10,CGRectGetMaxY(sepView1.frame),ScreenWidth - CGRectGetMaxX(_beginLabel.frame) - 10 - 15, 27);
    _timeValueLabel.textColor = UIColorWithRGB(0x555555);
    _timeValueLabel.textAlignment = NSTextAlignmentRight;
    _timeValueLabel.font = [UIFont systemFontOfSize:12.0f];
    _timeValueLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_timeValueLabel];
    
    UIView * sepView2 = [Common addSepateViewWithRect:CGRectMake(0, CGRectGetMaxY(_timeValueLabel.frame)-0.5, ScreenWidth, 0.5f) WithColor:UIColorWithRGB(0xd8d8d8)];
    [self addSubview:sepView2];

}
-(void)setDataDict:(NSDictionary *)dataDict{
    _dataDict = dataDict;
    _orderNumLabel.text = [_dataDict objectForKey:@"payNum"];
    NSString *payAmt = [_dataDict objectForKey:@"payAmt"];
    NSString *payAmtStr = [UCFToolsMehod AddComma:[NSString stringWithFormat:@"%.2lf",[payAmt doubleValue]]];
    _moneyLabel.text = [NSString stringWithFormat:@"¥%@",payAmtStr];
    _timeValueLabel.text = [_dataDict objectForKey:@"createTime"];
    NSInteger statue = [[_dataDict objectForKey:@"status"] integerValue];
    if (statue == 1) {
        _statueLabel.textColor = UIColorWithRGB(0x555555);
        _statueLabel.text = @"未支付";
        
    } else if (statue == 2) {
        _statueLabel.textColor = UIColorWithRGB(0x555555);
        _statueLabel.text = @"支付中";
    } else if (statue == 3) {
        _statueLabel.text = @"充值成功";
        _statueLabel.textColor = UIColorWithRGB(0x4aa1f9);
        
    } else {
        _statueLabel.textColor = UIColorWithRGB(0x555555);
        _statueLabel.text = @"充值失败";
        
    }
}
- (void)awakeFromNib {
    // Initialization code
     [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
