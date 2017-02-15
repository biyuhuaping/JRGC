//
//  UCFBatchInvestmentViewController.m
//  JRGC
//
//  Created by 金融工场 on 2017/2/15.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFBatchInvestmentViewController.h"
#define TITLEHEIGHT 44
#define TITLEWIDTH  SCREEN_WIDTH/3
#define IMAGEVIEWWIDTH 15
#define WORDHEIGHT 14
#define WORDCOLORBLUE UIColorWithRGB(0x6280a8)
#define WORDCOLORGRAY UIColorWithRGB(0x999999)
#define TITLECOLORGRAY UIColorWithRGB(0xf9f9f9)
@interface UCFBatchInvestmentViewController ()
@property (nonatomic, strong) UIView *firstView;    //标题注册view
@property (nonatomic, strong) UIView *secondView;   //标题徽商view
@property (nonatomic, strong) UIView *thirdView;    //标题密码view
@end

@implementation UCFBatchInvestmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createHeadTitleView];
    _isStep = 1;
    [self initView];
    // Do any additional setup after loading the view.
}
//初始化titleView
- (void)createHeadTitleView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-15, TITLEHEIGHT)]; //箭头位置所以单独处理15像素
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    //第一个视图
    self.firstView = [[UIView alloc] initWithFrame:CGRectMake(0 , 0, TITLEWIDTH, TITLEHEIGHT)];
    [bottomView addSubview:self.firstView];
    
    UIImageView *arrowImView1 = [[UIImageView alloc] init];
    [self.firstView addSubview:arrowImView1];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.text = @"开启授权";
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont systemFontOfSize:14.0];
    [self.firstView addSubview:label1];
    
    NSDictionary * dic1 = [NSDictionary dictionaryWithObjectsAndKeys:label1.font, NSFontAttributeName,nil];
    CGSize titleSize = [label1.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:dic1 context:nil].size;
    CGFloat arrowX = (CGRectGetWidth(self.firstView.frame) - titleSize.width - IMAGEVIEWWIDTH)/2;
    
    arrowImView1.frame = CGRectMake(arrowX, (CGRectGetHeight(self.firstView.frame) - IMAGEVIEWWIDTH)/2, IMAGEVIEWWIDTH, IMAGEVIEWWIDTH);
    label1.frame = CGRectMake(CGRectGetMaxX(arrowImView1.frame)+5, (CGRectGetHeight(self.firstView.frame) - WORDHEIGHT)/2, titleSize.width, WORDHEIGHT);
    
    //第二个视图
    self.secondView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.firstView.frame), 0, TITLEWIDTH, TITLEHEIGHT)];
    [bottomView addSubview:self.secondView];
    
    UIImageView *arrowImView2 = [[UIImageView alloc] init];
    arrowImView2.tag = 200;
    [self.secondView addSubview:arrowImView2];
    
    UIImageView *hookImView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 13, 44)];
    hookImView2.tag = 201;
    [self.secondView addSubview:hookImView2];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = @"设置限额";
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = [UIFont systemFontOfSize:14.0];
    [self.secondView addSubview:label2];
    
    NSDictionary * dic2 = [NSDictionary dictionaryWithObjectsAndKeys:label2.font, NSFontAttributeName,nil];
    CGSize titleSize2 = [label2.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:dic2 context:nil].size;
    CGFloat arrowX2 = (CGRectGetWidth(self.secondView.frame) - titleSize2.width - IMAGEVIEWWIDTH - 15)/2;
    arrowImView2.frame = CGRectMake(arrowX2 + 15, (CGRectGetHeight(self.secondView.frame) - IMAGEVIEWWIDTH)/2, IMAGEVIEWWIDTH, IMAGEVIEWWIDTH);
    label2.frame = CGRectMake(CGRectGetMaxX(arrowImView2.frame)+5, (CGRectGetHeight(self.secondView.frame) - WORDHEIGHT)/2, titleSize2.width, WORDHEIGHT);
    
    //第三个视图
    self.thirdView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.secondView.frame), 0, TITLEWIDTH+15, TITLEHEIGHT)];
    [bottomView addSubview:self.thirdView];
    
    UIImageView *arrowImView3 = [[UIImageView alloc] init];
    arrowImView3.tag = 300;
    [self.thirdView addSubview:arrowImView3];
    
    UIImageView *hookImView3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 13, 44)];
    hookImView3.tag = 301;
    [self.thirdView addSubview:hookImView3];
    
    UILabel *label3 = [[UILabel alloc] init];
    label3.text = @"授权完成";
    label3.textAlignment = NSTextAlignmentCenter;
    label3.font = [UIFont systemFontOfSize:14.0];
    [self.thirdView addSubview:label3];
    
    NSDictionary * dic3 = [NSDictionary dictionaryWithObjectsAndKeys:label3.font, NSFontAttributeName,nil];
    CGSize titleSize3 = [label3.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:dic3 context:nil].size;
    
    CGFloat arrowX3 = (CGRectGetWidth(self.thirdView.frame) - titleSize3.width - IMAGEVIEWWIDTH - 15)/2;
    
    arrowImView3.frame = CGRectMake(arrowX3, (CGRectGetHeight(self.thirdView.frame) - IMAGEVIEWWIDTH)/2, IMAGEVIEWWIDTH, IMAGEVIEWWIDTH);
    label3.frame = CGRectMake(CGRectGetMaxX(arrowImView3.frame)+5, (CGRectGetHeight(self.thirdView.frame) - WORDHEIGHT)/2, titleSize3.width, WORDHEIGHT);
    
    
    UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
    topLineView.backgroundColor = UIColorWithRGB(0xd8d8d8);
    [bottomView addSubview:topLineView];
    
    UIView *bottmLineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(bottomView.frame) - 0.5, ScreenWidth, 0.5)];
    bottmLineView.backgroundColor = UIColorWithRGB(0xd8d8d8);
    [bottomView addSubview:bottmLineView];
}
//初始化标题view
- (void)initView {
    switch (self.isStep) {
        case 1:{
            //显示注册成功页面
            [self showApplyView];
        }
            break;
        case 2:{
            //显示徽商绑定页面
            [self changeTitleViewController:SetQuota];
        }
            break;
        case 3:{
            //显示设置交易密码
            [self changeTitleViewController:BachEnd];
        }
            break;
    }
}
- (void)changeTitleViewController:(BachStep)type {
    if(type == BachApply) {

    }
    else if(type == SetQuota) {

    }
    else if(type == BachEnd) {

    }
}
- (void)showApplyView {
    baseTitleLabel.text = @"开通批量投资";
    [self registerView];
    [self saveBeforeView];
    [self passWordBeforeView];
}
- (void)saveView {//徽商选中的样子
    self.secondView.backgroundColor = [UIColor whiteColor];
    for (UIView *views  in self.secondView.subviews) {
        if ([views isKindOfClass:[UIImageView class]]) {
            if (views.tag == 200) {
                ((UIImageView *)views).image = [UIImage imageNamed:@"ic_step_2_normal"];
            }
            else {
                ((UIImageView *)views).image = [UIImage imageNamed:@"step_arrow_gray"];
            }
        }
        if ([views isKindOfClass:[UILabel class]]) {
            ((UILabel *)views).textColor = WORDCOLORBLUE;
        }
    }
}
- (void)saveBeforeView {//徽商未选中的样子
    self.secondView.backgroundColor = [UIColor whiteColor];
    for (UIView *views  in self.secondView.subviews) {
        if ([views isKindOfClass:[UIImageView class]]) {
            if (views.tag == 200) {
                ((UIImageView *)views).image = [UIImage imageNamed:@"ic_step_2_gray"];
            }
            else {
                ((UIImageView *)views).image = [UIImage imageNamed:@"step_arrow_transparent"];
            }
        }
        if ([views isKindOfClass:[UILabel class]])  {
            ((UILabel *)views).textColor = WORDCOLORGRAY;
        }
    }
}
- (void)passWordBeforeView {//密码未选中的样子
    self.thirdView.backgroundColor = [UIColor whiteColor];
    for (UIView *views  in self.thirdView.subviews) {
        if ([views isKindOfClass:[UIImageView class]]) {
            if (views.tag == 300) {
                ((UIImageView *)views).image = [UIImage imageNamed:@"ic_step_3_gray"];
            }
            else {
                ((UIImageView *)views).image = [UIImage imageNamed:@"step_arrow_transparent"];
            }
        }
        if ([views isKindOfClass:[UILabel class]]) {
            ((UILabel *)views).textColor = WORDCOLORGRAY;
        }
    }
}

- (void)showDepositoryView {
    baseTitleLabel.text = @"开通徽商存管";
    [self registerFinshView];
    [self saveView];
    [self passWordBeforeView];
}

- (void)showPassWordView {
    baseTitleLabel.text = @"设置交易密码";
    [self registerFinshView];
    [self saveViewFinsh];
    [self passWordView];
}
- (void)saveViewFinsh {//徽商完成的样子
    self.secondView.backgroundColor = TITLECOLORGRAY;
    for (UIView *views  in self.secondView.subviews) {
        if ([views isKindOfClass:[UIImageView class]]) {
            if (views.tag == 200) {
                ((UIImageView *)views).image = [UIImage imageNamed:@"authentication_icon_finish"];
            }
            else {
                ((UIImageView *)views).image = [UIImage imageNamed:@"step_arrow_gray"];
            }
        }
        if ([views isKindOfClass:[UILabel class]]) {
            ((UILabel *)views).textColor = WORDCOLORGRAY;
        }
    }
}
- (void)passWordView {//密码选中的样子
    self.thirdView.backgroundColor = [UIColor whiteColor];
    for (UIView *views  in self.thirdView.subviews) {
        if ([views isKindOfClass:[UIImageView class]]) {
            if (views.tag == 300) {
                ((UIImageView *)views).image = [UIImage imageNamed:@"ic_step_3"];
            }
            else {
                ((UIImageView *)views).image = [UIImage imageNamed:@"step_arrow_gray"];
            }
        }
        if ([views isKindOfClass:[UILabel class]]) {
            ((UILabel *)views).textColor = WORDCOLORBLUE;
        }
    }
}

#pragma mark - 1
/**
 *  选中的样子：   有步骤图片，字体和图片都是蓝色，背景为白色
 未选中样子：  有步骤图片，字体和图片都是灰色，背景为白色
 完成的样子：  有完成图片，字体和图片都是灰色，背景为灰色
 */

- (void)registerView//注册选中的样子
{
    for (UIView *views  in self.firstView.subviews) {
        if ([views isKindOfClass:[UIImageView class]]) {
            ((UIImageView *)views).image = [UIImage imageNamed:@"ic_step_one"];
        }
        if ([views isKindOfClass:[UILabel class]]) {
            ((UILabel *)views).textColor = UIColorWithRGB(0x6280a8);
        }
    }
}

- (void)registerFinshView//注册完成的样子
{
    self.firstView.backgroundColor = UIColorWithRGB(0xf9f9f9);
    for (UIView *views  in self.firstView.subviews) {
        if ([views isKindOfClass:[UIImageView class]]) {
            ((UIImageView *)views).image = [UIImage imageNamed:@"authentication_icon_finish"];
        }
        if ([views isKindOfClass:[UILabel class]]) {
            ((UILabel *)views).textColor = WORDCOLORGRAY;
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
