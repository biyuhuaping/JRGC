//
//  WeChatStylePlaceHolder.m
//  CYLTableViewPlaceHolder
//
//  Created by 陈宜龙 on 15/12/23.
//  Copyright © 2015年 http://weibo.com/luohanchenyilong/ ÂæÆÂçö@iOSÁ®ãÂ∫èÁä≠Ë¢Å. All rights reserved.
//

static float const kUIemptyOverlayLabelX         = 0;
static float const kUIemptyOverlayLabelY         = 0;
static float const kUIemptyOverlayLabelHeight    = 20;

#import "WeChatStylePlaceHolder.h"
#import "UILabel+Misc.h"
@interface WeChatStylePlaceHolder ()<UIGestureRecognizerDelegate>
{
    NSString *_errorTitle;
    BOOL    isGold;
    NSString *_btnStr;
}
@property (nonatomic, strong) UIImageView *emptyOverlayImageView;

@end

@implementation WeChatStylePlaceHolder

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [self sharedInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self = [self sharedInit];
    }
    return self;
}

- (instancetype)sharedInit {
    self.backgroundColor = [UIColor whiteColor];
  
    self.contentMode =   UIViewContentModeTop;
    [self addUIemptyOverlayImageView];
    [self addUIemptyOverlayLabel];
    [self setupUIemptyOverlay];
//    UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width - 112) / 2, (self.frame.size.height - 112) / 2, 112, 112)];
//    centerView.backgroundColor = [UIColor clearColor];
//    [self addSubview:centerView];
//
//    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 83, 83)];
//    NSString *imageStr = isGold ? @"gold_transaction_icon_NoRecords" : @"default_icon.png";
//    iconView.image = [UIImage imageNamed:imageStr];
//    [centerView addSubview:iconView];
//    UIColor *showColor = isGold ? UIColorWithRGB(0xe3a257) : UIColorWithRGB(0x8591b3);
//    UILabel *errorLbl = [UILabel labelWithFrame:CGRectMake(-20, CGRectGetMaxY(iconView.frame) + 15, 152, 14) text:@"暂无数据" textColor:showColor font:[UIFont systemFontOfSize:14]];
//    [centerView addSubview:errorLbl];
    return self;
}

- (void)addUIemptyOverlayImageView {
    self.emptyOverlayImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 83, 83)];
    self.emptyOverlayImageView.center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2 - 100);
    self.emptyOverlayImageView.image = [UIImage imageNamed:@"default_icon"];
    [self addSubview:self.emptyOverlayImageView];
}

- (void)addUIemptyOverlayLabel {
    CGRect emptyOverlayViewFrame = CGRectMake(kUIemptyOverlayLabelX, kUIemptyOverlayLabelY+20, CGRectGetWidth(self.frame), kUIemptyOverlayLabelHeight);
    UILabel *emptyOverlayLabel = [[UILabel alloc] initWithFrame:emptyOverlayViewFrame];
    emptyOverlayLabel.textAlignment = NSTextAlignmentCenter;
    emptyOverlayLabel.numberOfLines = 0;
    emptyOverlayLabel.backgroundColor = [UIColor clearColor];
    emptyOverlayLabel.text = @"暂无数据";
    emptyOverlayLabel.font = [UIFont boldSystemFontOfSize:14];
    emptyOverlayLabel.frame = ({
        CGRect frame = emptyOverlayLabel.frame;
        frame.origin.y = CGRectGetMaxY(self.emptyOverlayImageView.frame) + 10;
        frame;
    });
    emptyOverlayLabel.textColor = UIColorWithRGB(0x8591b3);
    [self addSubview:emptyOverlayLabel];
}

- (void)setupUIemptyOverlay {
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPressUIemptyOverlay = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressUIemptyOverlay:)];
    [longPressUIemptyOverlay setMinimumPressDuration:0.001];
    [self addGestureRecognizer:longPressUIemptyOverlay];
    self.userInteractionEnabled = YES;
}

- (void)longPressUIemptyOverlay:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.emptyOverlayImageView.alpha = 0.4;
    }
    if ( gesture.state == UIGestureRecognizerStateEnded ) {
        self.emptyOverlayImageView.alpha = 1;
        if ([self.delegate respondsToSelector:@selector(emptyOverlayClicked:)]) {
            [self.delegate emptyOverlayClicked:nil];
        }
    }
}

@end
