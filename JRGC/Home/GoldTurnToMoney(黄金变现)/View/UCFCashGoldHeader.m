//
//  UCFCashGoldHeader.m
//  JRGC
//
//  Created by njw on 2017/8/18.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFCashGoldHeader.h"
#import "ToolSingleTon.h"
#import "RotationButton.h"

@interface UCFCashGoldHeader ()
@property (weak, nonatomic) IBOutlet RotationButton *refreshGoldPricebtn;
@property (weak, nonatomic) IBOutlet UILabel *goldCurrentPriceLabel;

@end

@implementation UCFCashGoldHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTransState) name:CURRENT_GOLD_PRICE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginGetGoldPrice) name:BEHIN_GET_GOLD_PRICE object:nil];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.goldCurrentPriceLabel.text = [NSString stringWithFormat:@"%.2f", [ToolSingleTon sharedManager].readTimePrice];
}

- (IBAction)refreshRealGoldPrice:(RotationButton *)sender {
    self.refreshGoldPricebtn.userInteractionEnabled = NO;
    [[ToolSingleTon sharedManager] getGoldPrice];
    [self startAnimation];
}

- (void)startAnimation
{
    [self.refreshGoldPricebtn buttonBeginTransform];
}

- (void)endAnimation
{
    [self.refreshGoldPricebtn buttonEndTransform];
}

- (void)beginGetGoldPrice
{
    if ([[Common getCurrentVC] isKindOfClass:[self.hostVc class]]) {
        if (self.refreshGoldPricebtn.userInteractionEnabled) {
            [self refreshRealGoldPrice:nil];
        }
    }
}
- (void)changeTransState
{
    dispatch_queue_t queue= dispatch_get_main_queue();
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), queue, ^{
        DBLog(@"主队列--延迟执行------%@",[NSThread currentThread]);
        self.refreshGoldPricebtn.userInteractionEnabled = YES;
        [self setRealGoldPrice];
        [self endAnimation];
    });
}

- (void)setRealGoldPrice
{
    self.goldCurrentPriceLabel.text = [NSString stringWithFormat:@"%.2f", [ToolSingleTon sharedManager].readTimePrice];
}

@end
