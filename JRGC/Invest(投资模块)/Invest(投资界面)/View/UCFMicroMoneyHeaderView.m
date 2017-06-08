//
//  UCFMicroMoneyHeaderView.m
//  JRGC
//
//  Created by njw on 2017/6/8.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFMicroMoneyHeaderView.h"
#import "SDCycleScrollView.h"

@interface UCFMicroMoneyHeaderView ()
@property (weak, nonatomic) SDCycleScrollView *cycleView;

@end

@implementation UCFMicroMoneyHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    NSArray *images = @[[UIImage imageNamed:@"banner_unlogin_default"]];
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero imagesGroup:images];
    //    cycleScrollView.delegate = self;
    cycleScrollView.autoScrollTimeInterval = 7.0;
    [self addSubview:cycleScrollView];
    self.cycleView = cycleScrollView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.cycleView.frame = CGRectMake(0, 10, ScreenWidth, self.height - 20);
}

@end
