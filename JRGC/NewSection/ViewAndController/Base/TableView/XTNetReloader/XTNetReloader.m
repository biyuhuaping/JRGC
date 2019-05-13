//
//  XTNetReloader.m
//  Demo_MjRefresh
//
//  Created by TuTu on 15/12/8.
//  Copyright © 2015年 teason. All rights reserved.
//

//#define NO_WIFI_WORDS                   @"暂无网络\n请检查网络原因"
#define NO_WIFI_WORDS                   @"服务器开小差了\n请稍后再试"
#define ScreenWidth           [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight          [[UIScreen mainScreen] bounds].size.height
float const width_displayNoWifiView  = 200.0 ;
float const height_displayNoWifiView = 150.0 ;

float const width_labelshow          = 300.0 ;
float const height_labelshow         = 35.0 ;
float const fontSize_labelshow       = 14.0 ;

float const flexY_lb_bt              = 10.0 ;

float const width_bt                 = 145.0 ;
float const height_bt                = 37.0 ;
float const fontSize_bt              = 15.0 ;

#import "XTNetReloader.h"

@interface XTNetReloader ()

@property (nonatomic, strong) UIImageView *nowifiImgView ;
@property (nonatomic, strong) UILabel *lb ;
@property (nonatomic, strong) UILabel *lbup;
@property (nonatomic, strong) UIButton *bt ;
@property (nonatomic, copy) ReloadButtonClickBlock reloadButtonClickBlock ;

@end

@implementation XTNetReloader

- (void)showInView:(UIView *)viewWillShow {
    [viewWillShow addSubview:self] ;
}

- (void)dismiss {
    [self removeFromSuperview] ;
}

- (instancetype)initWithFrame:(CGRect)frame
                  reloadBlock:(ReloadButtonClickBlock)reloadBlock {
    self = [super initWithFrame:frame];
    if (self) {
        self.reloadButtonClickBlock = reloadBlock ;
        [self setup] ;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews] ;
    
    CGRect rectLabelup = CGRectZero ;
    rectLabelup.origin.x = (self.frame.size.width - width_labelshow) / 2.0 ;
    rectLabelup.origin.y = (self.frame.size.height - height_displayNoWifiView - height_labelshow - flexY_lb_bt - height_bt-self.nowifiImgView.frame.size.height) / 2.0+20 ;
    rectLabelup.size = CGSizeMake(width_labelshow, height_labelshow) ;
    self.lbup.frame = rectLabelup ;
    
    CGRect rectWifi = CGRectZero ;
    rectWifi.size = CGSizeMake(width_displayNoWifiView, height_displayNoWifiView) ;
    rectWifi.origin.x = (self.frame.size.width - width_displayNoWifiView) / 2.0 ;
    rectWifi.origin.y = (self.frame.size.height - height_displayNoWifiView - height_labelshow - flexY_lb_bt - height_bt) / 2.0 ;
    self.nowifiImgView.frame = rectWifi ;
    
    CGRect rectLabel = CGRectZero ;
    rectLabel.origin.x = (self.frame.size.width - width_labelshow) / 2.0 ;
    rectLabel.origin.y = rectWifi.origin.y + rectWifi.size.height ;
    rectLabel.size = CGSizeMake(width_labelshow, height_labelshow) ;
    self.lb.frame = rectLabel ;
    
    CGRect rectButton = CGRectZero ;
//    rectButton.origin.x = (self.frame.size.width - width_bt) / 2.0 ;
//    rectButton.origin.y = rectLabel.origin.y + rectLabel.size.height + flexY_lb_bt ;
//    rectButton.size = CGSizeMake(width_bt, height_bt) ;
//    rectButton.origin.x = (self.frame.size.width - width_bt) / 2.0 ;
//    rectButton.origin.y = rectLabel.origin.y + rectLabel.size.height + flexY_lb_bt ;
    rectButton.size = CGSizeMake(ScreenWidth, ScreenHeight) ;

    self.bt.frame = rectButton ;
}

- (void)setup {
    [self configure] ;
    [self nowifiImgView] ;
    [self lb] ;
    [self bt] ;
}

- (void)configure {
    self.backgroundColor = [UIColor whiteColor] ;
}
- (UILabel *)lbup {
    if (!_lbup) {
        _lbup = [[UILabel alloc] init] ;
//        _lbup.text = NO_WIFI_WORDS ;
        _lbup.font = [UIFont boldSystemFontOfSize:22] ;
        _lbup.textAlignment = NSTextAlignmentCenter ;
//        _lbup.textColor = [Color color:6];
        if (![_lbup superview]) {
            [self addSubview:_lbup] ;
        }
    }
    return _lbup ;
}

- (UIImageView *)nowifiImgView {
    if (!_nowifiImgView) {
        _nowifiImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_icon"]] ;
        _nowifiImgView.contentMode = UIViewContentModeScaleAspectFit ;
        if (![_nowifiImgView superview]) {
            [self addSubview:_nowifiImgView] ;
        }
    }
    return _nowifiImgView ;
}

- (UILabel *)lb {
    if (!_lb) {
        _lb = [[UILabel alloc] init] ;
        _lb.text = @"暂无网络";//NO_WIFI_WORDS
        _lb.font = [UIFont boldSystemFontOfSize:fontSize_labelshow] ;
        _lb.textAlignment = NSTextAlignmentCenter ;
        _lb.textColor = UIColorWithRGB(0xB1B5C2);
        if (![_lb superview]) {
            [self addSubview:_lb] ;
        }
    }
    return _lb ;
}

- (UIButton *)bt {
    if (!_bt) {
        _bt = [[UIButton alloc] init] ;
        _bt.backgroundColor = [UIColor clearColor];
//        [_bt setTitle:@"重新加载" forState:0] ;
//        _bt.titleLabel.font = [UIFont systemFontOfSize: 15.0];
//        [_bt setTitleColor:[Color color:25] forState:0] ;
//        _bt.titleLabel.font = [UIFont systemFontOfSize:fontSize_bt] ;
//        _bt.layer.cornerRadius = 2.0f ;
//        _bt.layer.borderWidth = 0.5f ;
//        _bt.layer.borderColor = [Color color:25].CGColor ;
        [_bt addTarget:self action:@selector(reloadButtonClicked) forControlEvents:UIControlEventTouchUpInside] ;
        if (![_bt superview]) {
            [self addSubview:_bt] ;
        }
    }
    return _bt ;
}

- (void)reloadButtonClicked {
    self.reloadButtonClickBlock() ;
}

@end




