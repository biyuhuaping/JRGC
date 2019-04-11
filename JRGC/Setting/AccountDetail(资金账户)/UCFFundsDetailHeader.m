//
//  UCFFundsDetailHeader.m
//  JRGC
//
//  Created by NJW on 15/5/4.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFFundsDetailHeader.h"

#import "FundsDetailGroup.h"

@interface UCFFundsDetailHeader ()
// 标写时间的标签
@property (nonatomic, weak) UILabel *timeLabel;
// top图标
@property (nonatomic, weak) UIView *topView;
@end

@implementation UCFFundsDetailHeader

+ (instancetype)headerViewWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"funddetailheader";
    UCFFundsDetailHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (nil == header) {
        header = [[[self class] alloc] initWithReuseIdentifier:ID];
    }
    return header;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
//        [self.contentView setBackgroundColor:UIColorWithRGB(0xf5f5f5)];
        [self.contentView setBackgroundColor:[UIColor redColor]];
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.textColor = UIColorWithRGB(0x333000);
        timeLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        UIView * topView = [[UIView alloc] init];
        [self.contentView addSubview:topView];
        
        [topView setBackgroundColor:UIColorWithRGB(0xf5f5f5)];
        topView.backgroundColor = [UIColor redColor];
        self.topView = topView;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat HPading = 15;
    // 1.添加头部图标
//    self.topView.frame = CGRectMake(0, CGRectGetHeight(self.contentView.frame) - 10, ScreenWidth, 10);
    // 2.设置时间标签的frame
    self.timeLabel.frame = CGRectMake(HPading, 0, ScreenWidth - 2*HPading, CGRectGetHeight(self.contentView.frame));
//    if (!_isFirst) {
//        // 1.添加头部图标
//        self.topView.frame = CGRectMake(0, 0, ScreenWidth, 10);
//        // 2.设置时间标签的frame
//        self.timeLabel.frame = CGRectMake(HPading, 10, ScreenWidth - 2*HPading, CGRectGetHeight(self.contentView.frame) - 10);
//    }
//    else {
//        self.topView.frame = CGRectZero;
//        self.timeLabel.frame = CGRectMake(HPading, 0, ScreenWidth - 2*HPading, CGRectGetHeight(self.contentView.frame));
//    }
    
    
}

- (void)setGroup:(FundsDetailGroup *)group
{
    // 1.设置时间标签的文字(年月)
    self.timeLabel.text = group.time;
}
@end
