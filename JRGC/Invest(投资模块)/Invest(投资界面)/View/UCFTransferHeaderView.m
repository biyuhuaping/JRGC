//
//  UCFTransferHeaderView.m
//  JRGC
//
//  Created by njw on 2017/6/8.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFTransferHeaderView.h"
#import "SDCycleScrollView.h"

@interface UCFTransferHeaderView ()
@property (weak, nonatomic) SDCycleScrollView *cycleView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIButton *rateOrderButton;
@property (weak, nonatomic) IBOutlet UIButton *limitOrderButton;
@property (weak, nonatomic) IBOutlet UIButton *sumOrderButton;
@property (assign, nonatomic) BOOL rateState;
@property (assign, nonatomic) BOOL limitState;
@property (assign, nonatomic) BOOL sumState;
@property (assign, nonatomic) NSInteger index;
@end

@implementation UCFTransferHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    NSArray *images = @[[UIImage imageNamed:@"banner_unlogin_default"]];
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero imagesGroup:images];
    //    cycleScrollView.delegate = self;
    cycleScrollView.autoScrollTimeInterval = 7.0;
    [self addSubview:cycleScrollView];
    self.cycleView = cycleScrollView;
    
    self.index = 0;
    self.rateState = YES;
    self.limitState = YES;
    self.sumState = YES;
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.cycleView.frame = CGRectMake(0, 10, ScreenWidth, 100);
    
}

#pragma mark - button点击事件
- (IBAction)rateOrder:(UIButton *)sender {
    if (sender.tag-100 == self.index) {
        self.rateState = !self.rateState;
    }
    self.index = sender.tag -100;
    if (self.rateState) {
        DBLOG(@"rate up");
    }
    else {
        DBLOG(@"rate down");
    }
}

- (IBAction)limitOrder:(UIButton *)sender {
    if (sender.tag-100 == self.index) {
        self.limitState = !self.limitState;
    }
    self.index = sender.tag -100;
    if (self.limitState) {
        DBLOG(@"limit up");
    }
    else {
        DBLOG(@"limit down");
    }
}

- (IBAction)sumOrder:(UIButton *)sender {
    if (sender.tag-100 == self.index) {
        self.sumState = !self.sumState;
    }
    self.index = sender.tag -100;
    if (self.sumState) {
        DBLOG(@"sum up");
    }
    else {
        DBLOG(@"sum down");
    }
}


@end
