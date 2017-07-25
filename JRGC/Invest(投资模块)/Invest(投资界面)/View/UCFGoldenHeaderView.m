//
//  UCFGoldenHeaderView.m
//  JRGC
//
//  Created by njw on 2017/7/12.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldenHeaderView.h"
#import "ToolSingleTon.h"
#import "RotationButton.h"
@interface UCFGoldenHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *realGoldPriceLabel;
@property (assign, nonatomic) BOOL isStopTrans; //是否停止旋转
@property (weak, nonatomic) IBOutlet RotationButton *refreshBtn;
//@property (assign,nonatomic) CGFloat angle;
//@property (assign, nonatomic) BOOL isLoading;
@end

@implementation UCFGoldenHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setRealGoldPrice) name:CURRENT_GOLD_PRICE object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTransState) name:CURRENT_GOLD_PRICE object:nil];
//    _isStopTrans = NO;
//    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTransState) name:CURRENT_GOLD_PRICE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginGetGoldPrice) name:BEHIN_GET_GOLD_PRICE object:nil];
}

+ (CGFloat)viewHeight
{
    return 236;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.height = self.goldValueBackView.bottom + 10;
    self.realGoldPriceLabel.text = [NSString stringWithFormat:@"%.2f", [ToolSingleTon sharedManager].readTimePrice];
}
- (IBAction)refreshRealGoldPrice:(id)sender {
    self.refreshBtn.userInteractionEnabled = NO;
    [[ToolSingleTon sharedManager] getGoldPrice];
    [self startAnimation];
}

- (void)startAnimation
{
    [self.refreshBtn buttonBeginTransform];
}

- (void)endAnimation
{
    [self.refreshBtn buttonEndTransform];
}
- (void)beginGetGoldPrice
{
    if (self.refreshBtn.userInteractionEnabled) {
        [self refreshRealGoldPrice:nil];
    }
}
- (void)changeTransState
{
    dispatch_queue_t queue= dispatch_get_main_queue();
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), queue, ^{
        DBLog(@"主队列--延迟执行------%@",[NSThread currentThread]);
        self.refreshBtn.userInteractionEnabled = YES;
        [self setRealGoldPrice];
        [self endAnimation];
    });
}

- (void)setRealGoldPrice
{
    self.realGoldPriceLabel.text = [NSString stringWithFormat:@"%.2f", [ToolSingleTon sharedManager].readTimePrice];
}

@end
