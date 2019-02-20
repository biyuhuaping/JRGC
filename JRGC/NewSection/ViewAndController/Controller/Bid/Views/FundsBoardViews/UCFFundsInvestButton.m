//
//  UCFFundsInvestButton.m
//  JRGC
//
//  Created by zrc on 2018/12/19.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import "UCFFundsInvestButton.h"
#import "NSObject+Compression.h"
@interface UCFFundsInvestButton ()
@property(nonatomic, weak)UCFBidViewModel *myVM;
@property(nonatomic, weak)UCFPureTransPageViewModel *mytransVM;
@end

@implementation UCFFundsInvestButton
- (void)showView:(UCFBidViewModel *)viewModel
{
    self.myVM = viewModel;
    
}
- (void)showTransView:(UCFPureTransPageViewModel *)viewModel
{
    self.mytransVM = viewModel;
}
- (void)createSubviews
{
    UIButton *investmentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    investmentButton.myHorzMargin = 0;
    investmentButton.myTop = 0;
    investmentButton.myHeight = 50;
    investmentButton.layer.masksToBounds = YES;
//    [investmentButton setBackgroundColor:UIColorWithRGB(0xFD4D4C)];
//    investmentButton.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *v) {
//        v.layer.cornerRadius = 2.0;
//    } ;
    [investmentButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [investmentButton setTitle:@"立即出借" forState:UIControlStateNormal];
    [self addSubview:investmentButton];
    
    [investmentButton setBackgroundImage:[UIImage gc_styleImageSize:CGSizeMake(ScreenWidth, 50)] forState:UIControlStateNormal];
    
//    UIImageView *shadowView = [[UIImageView alloc] init];
//    shadowView.myHeight = 10;
//    shadowView.myTop = -10;
//    shadowView.myHorzMargin = 0;
//    shadowView.tag = TABIMAGEVIEWTAG;
//    UIImage *tabImag = [UIImage imageNamed:@"tabbar_shadow.png"];
//    shadowView.image = [tabImag resizableImageWithCapInsets:UIEdgeInsetsMake(2, 1, 2, 1) resizingMode:UIImageResizingModeStretch];
    
//    [self addSubview:shadowView];
}
- (void)click:(UIButton *)button
{
    if (self.myVM) {
        [self.myVM dealInvestLogic];
    }
    if (self.mytransVM) {
        [self.mytransVM dealInvestLogic];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
