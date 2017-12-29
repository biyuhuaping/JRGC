//
//  UCFGoldRewardTableViewCell.m
//  JRGC
//
//  Created by hanqiyuan on 2017/12/29.
//  Copyright © 2017年 JRGC. All rights reserved.
//

#import "UCFGoldRewardTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UILabel+Misc.h"
#define ViewWidth 80
@implementation UCFGoldRewardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.scrollView.contentSize = CGSizeMake( ViewWidth * self.rewardsArray.count,0);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    //    self.scrollView.delegate = self;
    self.scrollView.bounces = NO;
    NSArray *subArray = @[@"次",@"",@"",@"",@"",@"",@"",@""];
    for (int i = 0; i < self.rewardsArray.count; i++)
    {
        float  imageViewHight = 80;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(ViewWidth * i, 0,ViewWidth, imageViewHight )];
        NSString *rewardImageUrl = [self.rewardsArray[i] objectForKey:@"rewardImageUrl"];
        NSString *rewardValue = [self.rewardsArray[i] objectForKey:@"rewardValue"];
        NSString *rewardType = [self.rewardsArray[i] objectForKey:@"rewardType"];
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.bounds =  CGRectMake(0, 0,32, 25);
        imageView.center = CGPointMake(ViewWidth /2, imageViewHight/2 - 15);
        [imageView sd_setImageWithURL:[NSURL URLWithString:rewardImageUrl] placeholderImage:[UIImage imageNamed:@"goldRewardImage"]];
        UILabel  *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame) + 5,ViewWidth, 35)];
        titleLabel.numberOfLines = 0;
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = UIColorWithRGB(0x555555);
        titleLabel.text = [NSString stringWithFormat:@"%@%@\n%@",rewardValue,subArray[i], rewardType];
        [view addSubview:imageView];
        [view addSubview:titleLabel];
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = view.bounds;
        button.tag = 100 + i;
        [button addTarget:self action:@selector(clickGoldRewardCellWithButton:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        [self.scrollView addSubview:view];
    }
}
-(void)clickGoldRewardCellWithButton:(UIButton * )button
{
    if ([self.delegate respondsToSelector:@selector(clickGoldRewardCellWithButton:)])
    {
        [self.delegate clickGoldRewardCellWithButton:button.tag - 100];
    }
}
@end
