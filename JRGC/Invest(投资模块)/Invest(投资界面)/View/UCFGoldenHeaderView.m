//
//  UCFGoldenHeaderView.m
//  JRGC
//
//  Created by njw on 2017/7/12.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldenHeaderView.h"
#import "ToolSingleTon.h"

@interface UCFGoldenHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *realGoldPriceLabel;

@end

@implementation UCFGoldenHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setRealGoldPrice) name:CURRENT_GOLD_PRICE object:nil];
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
    [[ToolSingleTon sharedManager] getGoldPrice];
}

- (void)setRealGoldPrice
{
    self.realGoldPriceLabel.text = [NSString stringWithFormat:@"%.2f", [ToolSingleTon sharedManager].readTimePrice];
}

@end
