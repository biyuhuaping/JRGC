//
//  BaseBottomButtonView.m
//  JFTPay
//
//  Created by kuangzhanzhidian on 2018/6/20.
//  Copyright © 2018年 kuangzhanzhidian. All rights reserved.
//

#import "BaseBottomButtonView.h"

@interface BaseBottomButtonView()

@property (nonatomic, strong) UIView *projectionView;//投影


@end
@implementation BaseBottomButtonView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];// 先调用父类的initWithFrame方法
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self.rootLayout addSubview:self.projectionView];
        [self.rootLayout addSubview:self.enterButton];
    }
    return self;
}
- (UIView *)projectionView {
    if (nil == _projectionView) {
        _projectionView = [UIView new];
        _projectionView.backgroundColor = UIColorWithRGB(0xd6d6d6);
        _projectionView.topPos.equalTo(self.rootLayout.topPos).offset(-13);
        _projectionView.leftPos.equalTo(@0);
        _projectionView.rightPos.equalTo(@0);
        _projectionView.heightSize.equalTo(@13);
    }
    return _projectionView;
}
//- (UIImage *)blurryGPUImage:(UIImage *)image withBlurLevel:(CGFloat)blur {
//    
//    // 高斯模糊
//    GPUImageGaussianBlurFilter * blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
//    blurFilter.blurRadiusInPixels = blur;
//    UIImage *blurredImage = [blurFilter imageByFilteringImage:image];
//    
//    return blurredImage;
//}

- (UIButton *)enterButton
{
    if (nil == _enterButton) {
        _enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_enterButton setTitle:@"确定" forState:UIControlStateNormal];
        [_enterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _enterButton.bottomPos.equalTo(@10);
        _enterButton.leftPos.equalTo(@15);
        _enterButton.rightPos.equalTo(@15);
        _enterButton.heightSize.equalTo(@37);
        _enterButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_enterButton setBackgroundColor:[UIColor whiteColor]];
        _enterButton.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *sbv)
        {//viewLayoutCompleteBlock是在子视图布局完成后给子视图一个机会进行一些特殊设置的block。这里面我们将子视图的半径设置为尺寸的一半，这样就可以实现在任意的屏幕上，这个子视图总是呈现为圆形。viewLayoutCompleteBlock只会在布局完成后调用一次，就会被布局系统销毁。
            sbv.layer.cornerRadius = 2;
        };
        
    }
    return _enterButton;
}

- (void)setButtonTitleWithString:(NSString *)title
{
    [self.enterButton setTitle:title forState:UIControlStateNormal];
}
- (void)setButtonTitleWithColor:(UIColor *)color
{
    [self.enterButton setTitleColor:color forState:UIControlStateNormal];
}
- (void)setButtonBackgroundColor:(UIColor *)BackgroundColor
{
    [self.enterButton setBackgroundColor:BackgroundColor];
}
- (void)setButtonBorderColor:(UIColor *)BackgroundColor
{
    [self.enterButton.layer setBorderWidth:0.5]; //边框宽度
    [self.enterButton.layer setBorderColor:BackgroundColor.CGColor];//边框颜色
}
- (void)setViewBackgroundColor:(UIColor *)BackgroundColor
{
    self.projectionView.backgroundColor = BackgroundColor;
    self.rootLayout.backgroundColor = BackgroundColor;

}
- (void)setProjectionViewHidden:(BOOL)hidden
{
    self.projectionView.hidden = hidden;
}
@end
