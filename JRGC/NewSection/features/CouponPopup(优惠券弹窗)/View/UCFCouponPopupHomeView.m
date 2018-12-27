//
//  UCFCouponPopupHomeView.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2018/12/12.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import "UCFCouponPopupHomeView.h"
#import "UCFCouponPopupCell.h"
#import "UCFSelectionCouponsCell.h"
#import "TYAlertController+BlurEffects.h"
#import "UIView+TYAlertView.h"
#import "AppDelegate.h"
#import "BaseNavigationViewController.h"
#import "UCFCouponViewController.h"
@interface UCFCouponPopupHomeView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIImageView *tableViewHeadImageView;

@property (nonatomic, strong) UIView *projectionView;//阴影

//@property (nonatomic, strong) UIView *lineView;//阴影

@property (nonatomic, strong) UIImageView *cancelImageView;

@property (nonatomic, strong) BaseBottomButtonView *tableViewFootView;//查看更多

@property (nonatomic, copy) UCFCouponPopupModel *arryData;//查看更多

@end

@implementation UCFCouponPopupHomeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame withModel:(UCFCouponPopupModel *)model
{
    self = [super initWithFrame:frame];
    if (self) {
    
        self.rootLayout.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.arryData = [model copy];
        [self.rootLayout addSubview:self.tableViewHeadImageView];
        [self.rootLayout addSubview:self.tableView];
        [self.rootLayout addSubview:self.tableViewFootView];
        [self.rootLayout addSubview:self.projectionView];
        [self.rootLayout addSubview:self.cancelImageView];
    }
    return self;
}

- (UITableView *)tableView
{
    if (nil == _tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource =self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.backgroundColor = [Color color:PGColorOptionGrayBackgroundColor];
//        _tableView.tableHeaderView = self.tableViewHeadImageView;
//        _tableView.tableFooterView = self.tableViewFootView;
        _tableView.centerYPos.equalTo(@(20));
        _tableView.centerXPos.equalTo(self.rootLayout.centerXPos);
        _tableView.widthSize.equalTo(self.rootLayout.widthSize).multiply(0.8);//子视图的宽度是父视图宽度的0.1
        _tableView.heightSize.equalTo(@292);
        
    }
    return _tableView;
}


- (UIImageView *)tableViewHeadImageView
{
    if (nil == _tableViewHeadImageView) {
        _tableViewHeadImageView = [[UIImageView alloc] init];
        if ([self.arryData.data.type isEqualToString:@"NEW"]) {
            
            _tableViewHeadImageView.image = [UIImage imageNamed:@"new_arrival_coupons"];
        }else
        {
            _tableViewHeadImageView.image = [UIImage imageNamed:@"expiration_reminder"];
        }
        _tableViewHeadImageView.bottomPos.equalTo(self.tableView.topPos);
        _tableViewHeadImageView.widthSize.equalTo(self.tableView.widthSize);
        _tableViewHeadImageView.heightSize.equalTo(self.tableView.widthSize).multiply(0.49);
        _tableViewHeadImageView.centerXPos.equalTo(self.tableView.centerXPos);
        _tableViewHeadImageView.backgroundColor = [UIColor whiteColor];
        _tableViewHeadImageView.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *sbv)
        { //viewLayoutCompleteBlock是在1.2.3中添加的新功能，目的是给完成了布局的子视图一个机会进行一些特殊的处理，viewLayoutCompleteBlock只会在子视图布局完成后调用一次.其中的sbv就是子视图自己，而layout则是父布局视图。因为这个block是完成布局后执行的。所以这时候子视图的frame值已经被计算出来，因此您可以在这里设置一些和frame关联的属性。
            //2.将指定的几个角切为圆角
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:sbv.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = sbv.bounds;
            maskLayer.path = maskPath.CGPath;
            sbv.layer.mask = maskLayer;
        };
    }
    return  _tableViewHeadImageView;
}


- (BaseBottomButtonView *)tableViewFootView
{
    if (nil == _tableViewFootView) {
        _tableViewFootView = [[BaseBottomButtonView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth*0.8, 57)];
        [_tableViewFootView.enterButton addTarget:self action:@selector(queryMore) forControlEvents:UIControlEventTouchUpInside];
        _tableViewFootView.topPos.equalTo(self.tableView.bottomPos);
        _tableViewFootView.widthSize.equalTo(self.tableView.widthSize);
        _tableViewFootView.heightSize.equalTo(@57);
        _tableViewFootView.centerXPos.equalTo(self.tableView.centerXPos);
        
        [_tableViewFootView setButtonTitleWithString:@"查看更多"];
        if ([self.arryData.data.type isEqualToString:@"NEW"]) {
            
            [_tableViewFootView setButtonTitleWithColor:[UIColor colorWithRed:219/255.0 green:81/255.0 blue:39/255.0 alpha:1.0]];
            [_tableViewFootView setViewBackgroundColor:[UIColor colorWithRed:253/255.0 green:76/255.0 blue:69/255.0 alpha:1.0]];
            [_tableViewFootView setButtonBackgroundColor:[UIColor whiteColor]];
        }else
        {
            [_tableViewFootView setButtonTitleWithColor:[UIColor colorWithRed:114/255.0 green:96/255.0 blue:251/255.0 alpha:1.0]];
            [_tableViewFootView setViewBackgroundColor:[UIColor colorWithRed:114/255.0 green:96/255.0 blue:251/255.0 alpha:1.0]];
            [_tableViewFootView setButtonBackgroundColor:[UIColor whiteColor]];
        }
       
//        [_tableViewFootView setButtonBorderColor:[Color color:PGColorOptionThemeGreenColor]];
        [_tableViewFootView setProjectionViewHidden:NO];
        _tableViewFootView.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *sbv)
        { //viewLayoutCompleteBlock是在1.2.3中添加的新功能，目的是给完成了布局的子视图一个机会进行一些特殊的处理，viewLayoutCompleteBlock只会在子视图布局完成后调用一次.其中的sbv就是子视图自己，而layout则是父布局视图。因为这个block是完成布局后执行的。所以这时候子视图的frame值已经被计算出来，因此您可以在这里设置一些和frame关联的属性。
            //2.将指定的几个角切为圆角
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:sbv.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = sbv.bounds;
            maskLayer.path = maskPath.CGPath;
            sbv.layer.mask = maskLayer;
        };
    }
    return _tableViewFootView;
}
- (UIView *)projectionView {
    if (nil == _projectionView) {
        _projectionView = [UIView new];
        _projectionView.backgroundColor = [DBColor colorWithHexString:@"d6d6d6" andAlpha:0.1];
        _projectionView.topPos.equalTo(self.tableViewFootView.topPos).offset(-13);
        _projectionView.leftPos.equalTo(self.tableViewFootView.leftPos);
        _projectionView.rightPos.equalTo(self.tableViewFootView.rightPos);
        _projectionView.heightSize.equalTo(@13);
    }
    return _projectionView;
}
//- (UIView *)lineView {
//    if (nil == _lineView) {
//        _lineView = [UIView new];
//        _lineView.backgroundColor = [UIColor whiteColor];
//        _lineView.topPos.equalTo(self.tableViewFootView);
//        _lineView.centerXPos.equalTo(self.tableViewFootView.centerXPos);
//        _lineView.widthSize.equalTo(@0.5);
//        _lineView.heightSize.equalTo(@25);
//    }
//    return _lineView;
//}
//- (UIButton*)cancelButton{
//
//    if(_cancelButton==nil)
//    {
//        _cancelButton = [UIButton buttonWithType:0];
//        _cancelButton.topPos.equalTo(self.tableView.bottomPos).offset(50);
//        _cancelButton.centerXPos.equalTo(self.tableView.centerXPos);
//        _cancelButton.widthSize.equalTo(@30);
//        _cancelButton.heightSize.equalTo(@30);
//
//    }
//    return _cancelButton;
//}
- (UIImageView *)cancelImageView
{
    if (nil == _cancelImageView) {
        _cancelImageView = [[UIImageView alloc] init];
        _cancelImageView.image = [self image:[UIImage imageNamed:@"ad_close"] rotation:UIImageOrientationDown];
        _cancelImageView.topPos.equalTo(self.tableViewFootView.bottomPos);
        _cancelImageView.widthSize.equalTo(@30);
        _cancelImageView.heightSize.equalTo(@55);
        _cancelImageView.centerXPos.equalTo(self.tableView.centerXPos);
//        _cancelImageView.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelhideInWindow)];
        // 允许用户交互
        _cancelImageView.userInteractionEnabled = YES;
        
        [_cancelImageView addGestureRecognizer:tap];
    }
    
    return  _cancelImageView;
}
- (void)cancelhideInWindow
{
    [self hideInWindow];
}
#pragma mark ---- UITableViewDelegate ----

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 92;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arryData.data.couponList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Listcell_cell";
    //自定义cell类
    UCFCouponPopupCell *cell = (UCFCouponPopupCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UCFCouponPopupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell refreshCellData:[self.arryData.data.couponList objectAtIndex:indexPath.row]];
    [cell.immediateUseBtn addTarget:self action:@selector(immediateUseBtnClick) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}
- (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 33 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}
- (void)queryMore
{
    //切换到优惠券页面
    [UIView animateWithDuration:0.2
                          delay:0.2
         usingSpringWithDamping:.5
          initialSpringVelocity:.5
                        options:UIViewAnimationOptionRepeat
                     animations:^{
                         [self hideInWindow];
                     } completion:^(BOOL finished) {
                         AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                         UINavigationController *nav = [delegate.tabBarController.viewControllers objectAtIndex:4];
                         UCFCouponViewController *coupon = [[UCFCouponViewController alloc] initWithNibName:@"UCFCouponViewController" bundle:nil];
                         [nav pushViewController:coupon animated:NO];
                         [delegate.tabBarController setSelectedIndex:4];
                     }];
}
- (void)immediateUseBtnClick
{
    //切换到投资列表页面
    [UIView animateWithDuration:0.2
                          delay:0.2
         usingSpringWithDamping:.5
          initialSpringVelocity:.5
                        options:UIViewAnimationOptionRepeat
                     animations:^{
                         [self hideInWindow];
                     } completion:^(BOOL finished) {
                         AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                         [delegate.tabBarController setSelectedIndex:1];
                     }];
}

@end
