//
//  UCFTransferHeaderView.m
//  JRGC
//
//  Created by njw on 2017/6/8.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFTransferHeaderView.h"
#import "SDCycleScrollView.h"
#import "UCFCycleModel.h"
#import "JSONKit.h"
#import "UIImageView+WebCache.h"
#import "UIButton+MLSpace.h"
@interface UCFTransferHeaderView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIButton *rateOrderButton;
@property (weak, nonatomic) IBOutlet UIButton *limitOrderButton;
@property (weak, nonatomic) IBOutlet UIButton *sumOrderButton;
@property (weak, nonatomic) IBOutlet UIView *buttonBaseView;
@property (weak, nonatomic) IBOutlet UIView *bottomBaseView;
@property (assign, nonatomic) BOOL rateState;
@property (assign, nonatomic) BOOL limitState;
@property (assign, nonatomic) BOOL sumState;
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) NSMutableArray *iconArray;
@end

@implementation UCFTransferHeaderView

- (NSMutableArray *)iconArray
{
    if (nil == _iconArray) {
        _iconArray = [NSMutableArray array];
    }
    return _iconArray;
}


- (void)awakeFromNib
{
    [super awakeFromNib];

    self.backgroundColor = UIColorWithRGB(0xebebee);
    self.rateState = YES;
    self.limitState = YES;
    self.sumState = YES;
    self.backgroundColor = UIColorWithRGB(0xebebee);
    self.bottomBaseView.backgroundColor =  [Color color:PGColorOptionThemeWhite];
    [Common addLineViewColor:UIColorWithRGB(0xd8d8d8) With:self.buttonBaseView isTop:NO];
    [Common addLineViewColor:UIColorWithRGB(0xd8d8d8) With:self.bottomBaseView isTop:YES];
    [Common addLineViewColor:UIColorWithRGB(0xe3e5ea) With:self.bottomBaseView isTop:NO];
    
    [_rateOrderButton setTitleColor:[Color color:PGColorOptionTitleGray] forState:UIControlStateNormal];
    [_limitOrderButton setTitleColor:[Color color:PGColorOptionTitleGray] forState:UIControlStateNormal];
    [_sumOrderButton setTitleColor:[Color color:PGColorOptionTitleGray] forState:UIControlStateNormal];


    [_rateOrderButton layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:5];
    [_limitOrderButton layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:5];
    [_sumOrderButton layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:5];
    
//    [self.rateOrderButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
//    [self.rateOrderButton setImageEdgeInsets:UIEdgeInsetsMake(0, 50, 0, 0)];
//    
//    [self.limitOrderButton setTitleEdgeInsets:UIEdgeInsetsMake(0, (ScreenWidth * 120.0f )/320.0f - ScreenWidth / 3.0 - 7, 0, 0)];
//    [self.limitOrderButton setImageEdgeInsets:UIEdgeInsetsMake(0, (ScreenWidth * 120.0f )/320.0f - ScreenWidth / 3.0 -7 + 43, 0, 0)];
//    
//    [self.sumOrderButton setTitleEdgeInsets:UIEdgeInsetsMake(0, (ScreenWidth * 215.0f )/320.0f - ScreenWidth / 3.0 *2 - 7, 0, 0)];
//    [self.sumOrderButton setImageEdgeInsets:UIEdgeInsetsMake(0, (ScreenWidth * 215.0f )/320.0f - ScreenWidth / 3.0 *2 - 7 + 43, 0, 0)];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.iconArray.count>0) {
        for (UIView *view in self.buttonBaseView.subviews) {
            NSInteger index = view.tag - 100;
            if (index >= 0) {
                UCFCycleModel *model = [self.iconArray objectAtIndex:index];
                for (UIView *view1 in view.subviews) {
                    if ([view1 isKindOfClass:[UIImageView class]]) {
                        UIImageView *image = (UIImageView *)view1;
                        [image sd_setImageWithURL:[NSURL URLWithString:model.thumb]];
                    }
                    else if ([view1 isKindOfClass:[UILabel class]]) {
                        UILabel *label = (UILabel *)view1;
                        label.text = model.title;
                    }
                }
            }
        }
    }
    
}
- (void)initData
{
    [self calcueAllStateButton];
    [_rateOrderButton setTitleColor:UIColorWithRGB(0x555555) forState:UIControlStateNormal];
    [_limitOrderButton setTitleColor:UIColorWithRGB(0x555555) forState:UIControlStateNormal];
    [_sumOrderButton setTitleColor:UIColorWithRGB(0x555555) forState:UIControlStateNormal];
}
#pragma mark - button点击事件
- (IBAction)rateOrder:(UIButton *)sender {
    if (sender.tag-100 == self.index) {
        self.rateState = !self.rateState;
    }
    self.index = sender.tag -100;
    [self calcueAllStateButton];
    if (self.rateState) {
        DDLogDebug(@"利率  升序");
        [self.rateOrderButton setImage:[UIImage imageNamed:@"transfer_screen_icon_up"] forState:UIControlStateNormal];
    }
    else {
        DDLogDebug(@"利率  降序");
      [self.rateOrderButton setImage:[UIImage imageNamed:@"transfer_screen_icon_dnow"] forState:UIControlStateNormal];
    }
    if ([self.delegate respondsToSelector:@selector(transferHeaderView:didClickOrderButton:andIsIncrease:)]) {
        [self.delegate transferHeaderView:self didClickOrderButton:sender andIsIncrease:self.rateState];
    }
    [self changeButtonTitleColor:sender];

}

- (IBAction)limitOrder:(UIButton *)sender {
    if (sender.tag-100 == self.index) {
        self.limitState = !self.limitState;
    }
    self.index = sender.tag -100;
    [self calcueAllStateButton];
    if (self.limitState) {
        DDLogDebug(@"期限  升序");
        [self.limitOrderButton setImage:[UIImage imageNamed:@"transfer_screen_icon_up"] forState:UIControlStateNormal];
    }
    else {
        DDLogDebug(@"期限  降序");
        [self.limitOrderButton setImage:[UIImage imageNamed:@"transfer_screen_icon_dnow"] forState:UIControlStateNormal];
    }
    if ([self.delegate respondsToSelector:@selector(transferHeaderView:didClickOrderButton:andIsIncrease:)]) {
        [self.delegate transferHeaderView:self didClickOrderButton:sender andIsIncrease:self.limitState];
    }
    [self changeButtonTitleColor:sender];

}

- (IBAction)sumOrder:(UIButton *)sender {
    if (sender.tag-100 == self.index) {
        self.sumState = !self.sumState;
    }
    self.index = sender.tag -100;
    [self calcueAllStateButton];
    // 期限 YES 升序 NO 降序
    if (self.sumState) {
        DDLogDebug(@"金额  降序");
        [self.sumOrderButton setImage:[UIImage imageNamed:@"transfer_screen_icon_dnow"] forState:UIControlStateNormal];
    }
    else {
        DDLogDebug(@"金额  升序");
        [self.sumOrderButton setImage:[UIImage imageNamed:@"transfer_screen_icon_up"] forState:UIControlStateNormal];
    }
    if ([self.delegate respondsToSelector:@selector(transferHeaderView:didClickOrderButton:andIsIncrease:)]) {
        [self.delegate transferHeaderView:self didClickOrderButton:sender andIsIncrease:self.sumState];
    }
    [self changeButtonTitleColor:sender];
}
- (void)changeButtonTitleColor:(UIButton *)button
{
    [_rateOrderButton setTitleColor:UIColorWithRGB(0x555555) forState:UIControlStateNormal];
    [_limitOrderButton setTitleColor:UIColorWithRGB(0x555555) forState:UIControlStateNormal];
    [_sumOrderButton setTitleColor:UIColorWithRGB(0x555555) forState:UIControlStateNormal];
    [button setTitleColor:UIColorWithRGB(0xf5343c) forState:UIControlStateNormal];
}

- (void)calcueAllStateButton
{
    [self.rateOrderButton setImage:[UIImage imageNamed:@"transfer_screen_icon_normal"] forState:UIControlStateNormal];
    [self.limitOrderButton setImage:[UIImage imageNamed:@"transfer_screen_icon_normal"] forState:UIControlStateNormal];
    [self.sumOrderButton setImage:[UIImage imageNamed:@"transfer_screen_icon_normal"] forState:UIControlStateNormal];
}




@end
