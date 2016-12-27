//
//  UCFFundsDetailHeaderView.m
//  JRGC
//
//  Created by NJW on 15/4/28.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFFundsDetailHeaderView.h"
#import "FundsDetailGroup.h"

@implementation UCFFundsDetailHeaderView

+ (instancetype)headerViewWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"fundsdetailheader";
    UCFFundsDetailHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (nil == header) {
        header = [[[self class] alloc] initWithReuseIdentifier:ID];
    }
    return header;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *bgview = [[UIView alloc] init];
        [bgview setBackgroundColor:[UIColor lightGrayColor]];
        [self.contentView addSubview:bgview];
        self.bgView = bgview;
        
        UILabel *nameLabel = [[UILabel alloc] init];
//        nameLabel.textColor = UIColorWithRGB(0x434343);
        nameLabel.font = [UIFont systemFontOfSize:14];
        [self.bgView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        UILabel *status = [[UILabel alloc] init];
//        status.textColor = UIColorWithRGB(0x434343);
        status.font = [UIFont systemFontOfSize:14];
        [self.bgView addSubview:status];
        self.statusLabel = status;
    }
    return self;
}


- (void)layoutSubviews
{
#warning 一定要调用super的方法
    [super layoutSubviews];
    
    self.bgView.frame = CGRectMake(0, 12, ScreenWidth, self.contentView.bounds.size.height - 12);
    [self.nameLabel setFrame:CGRectMake(8, CGRectGetHeight(self.bgView.frame)/2.0-15, ScreenWidth - 60, 30)];
    [self.statusLabel setFrame:CGRectMake(CGRectGetMinX(self.nameLabel.frame)+CGRectGetWidth(self.nameLabel.frame), CGRectGetMinY(self.nameLabel.frame), 60, 30)];
}

- (void)setFundsDetailGroup:(FundsDetailGroup *)fundsDetailGroup{
    _fundsDetailGroup = fundsDetailGroup;
    [_nameLabel setText:fundsDetailGroup.name];
    [_statusLabel setText:fundsDetailGroup.status];
}

@end
