//
//  UCFTipButton.m
//  JRGC
//
//  Created by NJW on 16/8/8.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFTipButton.h"
#import "HWWeakTimer.h"

@interface UCFTipButton ()

@end

@implementation UCFTipButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColorWithRGB(0xfff6c7);
//        [self setTitle:@"银行卡已失效，升级银行存管账户重新激活" forState:UIControlStateNormal];
        [self setTitleColor:UIColorWithRGB(0x6b4508) forState:UIControlStateNormal];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.font = [UIFont systemFontOfSize:12];
//        [self setImage:[UIImage imageNamed:@"homepage_message_arrow"] forState:UIControlStateNormal];
//        [HWWeakTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(rotateText) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = UIColorWithRGB(0xfff6c7);
//    [self setTitle:@"银行卡已失效，升级银行存管账户重新激活" forState:UIControlStateNormal];
    [self setTitleColor:UIColorWithRGB(0x6b4508) forState:UIControlStateNormal];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.font = [UIFont systemFontOfSize:12];
//    [self setImage:[UIImage imageNamed:@"homepage_message_arrow"] forState:UIControlStateNormal];
}


- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(15, 0, contentRect.size.width, contentRect.size.height);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    if (contentRect.size.height == 37) {
        return CGRectMake(SCREEN_WIDTH-15-7, 12, 7, 12);
    }
    else
        return CGRectMake(SCREEN_WIDTH-15-7, 12, 7, 0);
}

- (void)setHighlighted:(BOOL)highlighted
{
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    [self.imageView setFrame:CGRectMake(SCREEN_WIDTH-15-7, 12, 7, 12)];
    
    CATransition *animation = [CATransition animation];
//    animation.delegate = self;
    animation.duration = 0.5f; //动画时长
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.type = @"cube"; //过度效果
    animation.subtype = kCATransitionFromBottom; //过渡方向
    animation.startProgress = 0.0; //动画开始起点(在整体动画的百分比)
    animation.endProgress = 1.0;  //动画停止终点(在整体动画的百分比)
    animation.removedOnCompletion = NO;
    [self.titleLabel.layer addAnimation:animation forKey:@"animation"];
    
    
//    CATransition *animation = [CATransition animation];
//    //    animation.delegate = self;
//    animation.duration = 0.8f;
//    animation.timingFunction = UIViewAnimationCurveEaseInOut;
//    animation.fillMode = kCAFillModeForwards;
//    animation.type = kCATransitionMoveIn;
//    animation.subtype = kCATransitionFromBottom;
//    [self.titleLabel.layer addAnimation:animation forKey:@"animation"];
    
}


//- (void)rotateText
//{
//    NSArray *arr = [NSArray arrayWithObjects:self.titleLabel.text, self.titleLabel.text, nil];
//    
//    [self updateLab:self.titleLabel andTextStr:arr];
//}
//
//- (void)updateLab:(UILabel *)label andTextStr:(NSArray *)arr {
//    static int i = 0;
//    if (arr.count == 0) {
//        return;
//    }
//    if (i == arr.count - 1) {
//        i = 0;
//    }else{
//        i ++;
//    }
//    label.text = [arr objectAtIndex:i];
//
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
