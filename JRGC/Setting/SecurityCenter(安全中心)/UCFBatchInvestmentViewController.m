//
//  UCFBatchInvestmentViewController.m
//  JRGC
//
//  Created by 金融工场 on 2017/2/15.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFBatchInvestmentViewController.h"
#import "BatchSetView.h"
#import "NZLabel.h"
#import "UCFBatchSetNumWebViewController.h"
#import "FullWebViewController.h"
#define TITLEHEIGHT 44
#define TITLEWIDTH  SCREEN_WIDTH/3
#define IMAGEVIEWWIDTH 15
#define WORDHEIGHT 14
#define WORDCOLORBLUE UIColorWithRGB(0x6280a8)
#define WORDCOLORGRAY UIColorWithRGB(0x999999)
#define TITLECOLORGRAY UIColorWithRGB(0xf9f9f9)
static NSString *firstStr = @"批量出借授权开启后可一次性出借多个小额项目";
static NSString *secondStr = @"为保证您的资金安全，请合理选择";
static NSString *thirdStr = @"批量出借授权已经开启";
@interface UCFBatchInvestmentViewController ()
{
    UIButton *selectButton;
    UIButton *investmentButton;
    BOOL      isFirstFixed;   //是否第一次修改最大限投金额
}
@property (nonatomic, strong) UIView *firstView;    //申请view
@property (nonatomic, strong) UIView *secondView;   //设置额度view
@property (nonatomic, strong) UIView *thirdView;    //成功view
@property (nonatomic, strong) UILabel *tipLabel;    //蓝色提醒lable
@property (nonatomic, strong) UIScrollView *baseScrollView;
@property (nonatomic, strong) NSArray *quotaArr;    //额度数组
@property (nonatomic, copy)   NSString  *batchInvestment;//先前选中的金额

@end

@implementation UCFBatchInvestmentViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
- (void)addRightButtonWithImage:(UIImage *)rightButtonimage;
{
    UIButton *rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightbutton.frame = CGRectMake(0, 0, 25, 25);
    rightbutton.backgroundColor = [UIColor clearColor];
    [rightbutton setImage:rightButtonimage forState:UIControlStateNormal];
    [rightbutton addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightbutton];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)clickRightBtn
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"\"自动投标\"是金融工场为方便出借人出借小额项目特推出的，一次可出借多个项目。批量出借后系统会自动匹配，直至完成所有出借为止" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
    [alert show];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    baseTitleLabel.text = @"批量出借授权";
    [self addRightButtonWithImage:[UIImage imageNamed:@"icon_question.png"]];

    [self addLeftButton];
    self.view.backgroundColor = [UIColor colorWithRed:234/255.0 green:235.0/255.0 blue:239.0/255.0 alpha:1];
    [self createHeadTitleView];
    [self initTipView];
    [self initScrollView];
    [self cretateInvestmentView];
    [self initView];

    // Do any additional setup after loading the view.
}
//蓝底提醒图
- (void)initTipView
{
    UIView *tipView = [[UIView alloc] initWithFrame:CGRectMake(0, TITLEHEIGHT, ScreenWidth, 35)];
    tipView.backgroundColor = UIColorWithRGB(0x5B6993);
    [self.view addSubview:tipView];
    
    _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, ScreenWidth - 15, 35)];
    _tipLabel.font = [UIFont systemFontOfSize:13.0f];
    _tipLabel.text = @"批量出借授权开启后可一次性出借多个小额项目";
    _tipLabel.textColor = [UIColor whiteColor];
    [tipView addSubview:_tipLabel];

}
//主要内容下面是个滚动视图
- (void)initScrollView
{
    _baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, TITLEHEIGHT + 35, ScreenWidth, ScreenHeight - TITLEHEIGHT - 35 -67)];
    _baseScrollView.contentSize = CGSizeMake(ScreenWidth * 3, ScreenHeight - TITLEHEIGHT - 35 - 67);
    _baseScrollView.backgroundColor = [UIColor clearColor];
    _baseScrollView.bounces = NO;
    _baseScrollView.scrollEnabled = NO;
    [self.view addSubview:_baseScrollView];
    if (self.isStep == 1) {
        [self initFirstSectionView];
    } else if (self.isStep == 2) {
        [[NetworkModule sharedNetworkModule] newPostReq:@{@"userId":[[NSUserDefaults standardUserDefaults] valueForKey:UUID]} tag:kSXTagBatchNumList owner:self signature:YES Type:self.accoutType];
    }
    
    
}
- (void)initFirstSectionView
{
    BatchSetView *view1= [[BatchSetView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 80)];
    view1.backgroundColor = [UIColor whiteColor];
    view1.iconName = @"auto_fast";
    view1.title = @"投标更快捷";
    view1.des = @"开启批量出借授权，即可在批量投标中使用批量出借功能，快速出借多个小额项目。";
    [_baseScrollView addSubview:view1];
    [Common addLineViewColor:UIColorWithRGB(0xd8d8d8) With:view1 isTop:YES];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetHeight(view1.frame) - 1, CGRectGetWidth(view1.frame) , 1)];
    lineView.backgroundColor = UIColorWithRGB(0xe3e5ea);
    [view1 addSubview:lineView];
    
    BatchSetView *view2= [[BatchSetView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(view1.frame), SCREEN_WIDTH, 80)];
    view2.backgroundColor = [UIColor whiteColor];
    view2.frame = CGRectMake(0, CGRectGetMaxY(view1.frame), ScreenWidth, 80);
    view2.iconName = @"auto_safe";
    view2.title = @"安全有保障";
    view2.des = @"依托徽商银行存管账户，您的账户资金更有保障。";
    [_baseScrollView addSubview:view2];
    [Common addLineViewColor:UIColorWithRGB(0xd8d8d8) With:view2 isTop:NO];
    
    NSString *totalStr = [NSString stringWithFormat:@"本人同意签署《批量出借咨询与服务协议》"];
    NZLabel *label1 = [[NZLabel alloc] init];
    label1.font = [UIFont systemFontOfSize:12.0f];
    CGSize size = [Common getStrHeightWithStr:totalStr AndStrFont:12 AndWidth:ScreenWidth - 25];
    label1.numberOfLines = 0;
    label1.frame = CGRectMake(23, CGRectGetMaxY(view2.frame) + 10, ScreenWidth-25, size.height);
    label1.text = totalStr;
    label1.userInteractionEnabled = YES;
    label1.textColor = UIColorWithRGB(0x999999);
    
    __weak typeof(self) weakSelf = self;
    [label1 addLinkString:@"《批量出借咨询与服务协议》" block:^(ZBLinkLabelModel *linkModel) {
        [weakSelf showHeTong];
    }];
    [label1 setFontColor:UIColorWithRGB(0x4aa1f9) string:@"《批量出借咨询与服务协议》"];
    
    [_baseScrollView addSubview:label1];
    
    UIImageView * imageView1 = [[UIImageView alloc] init];
    imageView1.frame = CGRectMake(CGRectGetMinX(label1.frame) - 7, CGRectGetMinY(label1.frame) + 5, 5, 5);
    imageView1.image = [UIImage imageNamed:@"point.png"];
    [_baseScrollView addSubview:imageView1];
    

}
- (void)showHeTong
{
    NSString *strParameters = [NSString stringWithFormat:@"userId=%@&contractType=107&prdType=2",[[NSUserDefaults standardUserDefaults] valueForKey:UUID]];
    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagGetContractMsg owner:self Type:SelectAccoutTypeP2P];
}
- (void)initSecondSectionView
{
    NSString *totalStr = [NSString stringWithFormat:@"单次最高限额："];
    CGSize size = [Common getStrHeightWithStr:totalStr AndStrFont:12 AndWidth:ScreenWidth - 25];
    NZLabel *label1 = [[NZLabel alloc] init];
    label1.font = [UIFont systemFontOfSize:13.0f];
    label1.numberOfLines = 0;
    label1.frame = CGRectMake(ScreenWidth + 15, 15, ScreenWidth-25, size.height);
    label1.text = totalStr;
    label1.userInteractionEnabled = YES;
    label1.textColor = UIColorWithRGB(0x4aa1f9);
    [_baseScrollView addSubview:label1];
    
    [self initSecondBtnView:CGRectGetMaxY(label1.frame) + 15];
}
- (void)initThirdSectionView
{
    UIImageView *sucessImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth * 2 + (ScreenWidth - 220)/2, (CGRectGetHeight(_baseScrollView.frame) - 99 - 30)/2 - 50, 220, 99)];
    sucessImageView.image = [UIImage imageNamed:@"automatic_success"];
    [_baseScrollView addSubview:sucessImageView];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth * 2, CGRectGetMaxY(sucessImageView.frame) + 20, ScreenWidth, 16)];
    tipLabel.text = [NSString stringWithFormat:@"单次最高限额：%@",[selectButton titleForState:UIControlStateNormal]];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.font = [UIFont systemFontOfSize:13.0f];
    tipLabel.textColor = UIColorWithRGB(0x5b6993);
    [_baseScrollView addSubview:tipLabel];
    
    
}
- (void)initSecondBtnView:(CGFloat)offY
{
//    self.quotaArr = @[@"100万",@"50万",@"10万",@"5万",@"1万"];
    CGFloat intervalLength = 10.0f;
    CGFloat statrOrendLength = ScreenWidth + 15.0f;
    CGFloat btnWidth = (ScreenWidth - 15.0f * 2 - 10.0f * 2)/3;
    CGFloat btnHeight = (btnWidth * 7) / 9;
    for (int i = 0; i < self.quotaArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(statrOrendLength + (btnWidth + intervalLength) * (i%3) ,offY + (i/3) * (btnHeight + intervalLength), btnWidth, btnHeight);
        [button setBackgroundImage:[Common batchImageNormalState:button.frame] forState:UIControlStateNormal];
        [button setBackgroundImage:[Common batchImageSelectedState:button.frame] forState:UIControlStateSelected];
        button.tag = 1000 + [[self.quotaArr[i] valueForKey:@"id"] integerValue];
        [button addTarget:self action:@selector(changeBtnState:) forControlEvents:UIControlEventTouchUpInside];
        NSString *title = [self.quotaArr[i] valueForKey:@"title"];
        [button setTitle:[NSString stringWithFormat:@"%@",title] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:20.0f];
        [button setTitleColor:UIColorWithRGB(0x666666) forState:UIControlStateNormal];
        
        NSRange range = [title rangeOfString:@"万"];
        if (range.location != NSNotFound) {
            NSMutableAttributedString *attrituteString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",[self.quotaArr[i] valueForKey:@"title"]]];
            [attrituteString setAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]} range:range];
            button.titleLabel.attributedText = attrituteString;
        }
        
        if (self.batchInvestment.length == 0 && i== 0) {
            button.selected = YES;
            selectButton = button;
        } else {
            if ([self.batchInvestment isEqualToString:title]) {
                button.selected = YES;
                selectButton = button;
            }
        }

        [_baseScrollView addSubview:button];
    }
}
- (void)changeBtnState:(UIButton *)button
{
    if (selectButton == button) {
        selectButton.selected = !button.selected;
        if (!selectButton.selected) {
            selectButton = nil;
        }
    } else {
        selectButton.selected = NO;
        button.selected = YES;
        selectButton = button;
    }
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
    
    UIView *bottmLineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(bottomView.frame) - 1, ScreenWidth, 1)];
    bottmLineView.backgroundColor = UIColorWithRGB(0xd8d8d8);
    [bottomView addSubview:bottmLineView];
}
//初始化标题view
- (void)initView {
    switch (self.isStep) {
        case 1:{
            _tipLabel.text = firstStr;
            _baseScrollView.contentOffset = CGPointMake(0, 0);

            //显示注册成功页面
            [self showApplyView];
        }
            break;
        case 2:{
            _tipLabel.text = secondStr;
            _baseScrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
            //显示徽商绑定页面
            [self showDepositoryView];
        }
            break;
        case 3:{
            _tipLabel.text = thirdStr;
            _baseScrollView.contentOffset = CGPointMake(SCREEN_WIDTH * 2, 0);
            //显示设置交易密码
            [self showPassWordView];
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
    baseTitleLabel.text = @"自动投标授权";
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
    [self registerFinshView];
    [self saveView];
    [self passWordBeforeView];
}

- (void)showPassWordView {
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
- (void)cretateInvestmentView
{
    UIView *investBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight -NavigationBarHeight - 67, ScreenWidth, 67)];
    investBaseView.backgroundColor = [UIColor clearColor];
    investBaseView.tag = 9000;
    [self.view addSubview:investBaseView];
    
    UIView *bkView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 57)];
    bkView.backgroundColor = [UIColor whiteColor];
    [investBaseView addSubview:bkView];
    
    investmentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    investmentButton.frame = CGRectMake(XPOS, 20,ScreenWidth - XPOS*2, 37);
    investmentButton.titleLabel.font = [UIFont systemFontOfSize:16];
    investmentButton.backgroundColor = UIColorWithRGB(0xfd4d4c);
    investmentButton.layer.cornerRadius = 2.0;
    investmentButton.layer.masksToBounds = YES;
    NSString *buttonTitle = @"";
    if (self.isStep == 1) {
        buttonTitle = @"申请开通";
    } else if (self.isStep == 2) {
        buttonTitle = @"提交";
    }
    [investmentButton setTitle:buttonTitle forState:UIControlStateNormal];
    [investmentButton addTarget:self action:@selector(checkIsCanInvest) forControlEvents:UIControlEventTouchUpInside];
    [investBaseView addSubview:investmentButton];
    
    UIImageView *shadowView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, 10)];
    UIImage *tabImag = [UIImage imageNamed:@"tabbar_shadow.png"];
    shadowView.image = [tabImag resizableImageWithCapInsets:UIEdgeInsetsMake(2, 1, 2, 1) resizingMode:UIImageResizingModeStretch];
    [investBaseView addSubview:shadowView];
}
- (void)checkIsCanInvest
{
    NSString *title = [investmentButton titleForState:UIControlStateNormal];
    if ([title isEqualToString:@"申请开通"]) {
        [[NetworkModule sharedNetworkModule] newPostReq:@{@"userId":[[NSUserDefaults standardUserDefaults] valueForKey:UUID]} tag:kSXTagBatchNumList owner:self signature:YES Type:self.accoutType];
    } else if ([title isEqualToString:@"提交"]) {

        if (selectButton) {
            
            NSDictionary *dict = @{@"investLimitId":[NSString stringWithFormat:@"%ld",selectButton.tag - 1000],@"userId":[[NSUserDefaults standardUserDefaults] valueForKey:UUID]};
            [[NetworkModule sharedNetworkModule] newPostReq:dict tag:kSXTagSetBatchNum owner:self signature:YES Type:self.accoutType];

        } else {
            [MBProgressHUD displayHudError:@"请选择额度"];
        }
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    NSMutableDictionary *dic = [result objectFromJSONString];
    if (tag.integerValue == kSXTagBatchNumList) {
        if ([dic[@"ret"] boolValue]) {
            isFirstFixed = [dic[@"data"][@"openOrEdit"] isEqualToString:@"1"] ? NO : YES;
            self.batchInvestment =  [[dic objectSafeArrayForKey:@"data"] objectSafeArrayForKey:@"currentLimit"];
            self.quotaArr = [[dic objectSafeArrayForKey:@"data"] objectSafeArrayForKey:@"BatchNumList"];
            [self initSecondSectionView];
            [investmentButton setTitle:@"提交" forState:UIControlStateNormal];
            self.isStep = 2;
            [self initView];
        } else {
            [MBProgressHUD displayHudError:dic[@"message"]];
        }
    } else if (tag.integerValue == kSXTagSetBatchNum) {

         if ([dic[@"ret"] boolValue]) {
             if (isFirstFixed) {
                 NSMutableDictionary  *dataDict = [NSMutableDictionary dictionaryWithDictionary:dic[@"data"][@"params"]];
                 NSString *urlStr = dic[@"data"][@"url"];
                 UCFBatchSetNumWebViewController *webView = [[UCFBatchSetNumWebViewController alloc]initWithNibName:@"UCFBatchSetNumWebViewController" bundle:nil];
                 webView.url = urlStr;
                 webView.webDataDic =dataDict;
                 webView.navTitle = @"批量出借授权";
                 webView.sourceType = _sourceType;
                 webView.accoutType = self.accoutType;
                 [self.navigationController pushViewController:webView animated:YES];
             } else {
                 [self initThirdSectionView];
                 self.isStep = 3;
                 [self initView];
                 [investmentButton setTitle:@"返回" forState:UIControlStateNormal];
             }
         } else {
             [MBProgressHUD displayHudError:dic[@"message"]];
         }
    } else if (tag.integerValue == kSXTagGetBatchContractMsg) {
        NSString *Data = (NSString *)result;
        NSDictionary * dic = [Data objectFromJSONString];
        NSString *status = [dic objectSafeForKey:@"status"];
        if ([status intValue] == 1) {
            NSString *contractMessStr = [dic objectSafeForKey:@"contractContent"];
            FullWebViewController *controller = [[FullWebViewController alloc] initWithHtmlStr:contractMessStr title:[dic objectSafeForKey:@"contractName"]];
            controller.baseTitleType = @"detail_heTong";
            [self.navigationController pushViewController:controller animated:YES];
        }

    }else if(tag.intValue == kSXTagGetContractMsg) {
        NSString *Data = (NSString *)result;
        NSDictionary * dic = [Data objectFromJSONString];
        NSDictionary *dictionary =  [dic objectSafeDictionaryForKey:@"contractMess"];
        NSString *status = [dic objectSafeForKey:@"status"];
        if ([status intValue] == 1) {
            NSString *contractMessStr = [dictionary objectSafeForKey:@"contractMess"];
            FullWebViewController *controller = [[FullWebViewController alloc] initWithHtmlStr:contractMessStr title:@"批量出借咨询与服务协议"];
            controller.baseTitleType = @"detail_heTong";
            [self.navigationController pushViewController:controller animated:YES];
        }else{
            //            [self showHTAlertdidFinishGetUMSocialDataResponse];
        }
    }

}
- (void)dealloc
{
    if ([self.sourceType isEqualToString:@"personCenter"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getPersonalCenterNetData" object:nil];
    } else if([self.sourceType isEqualToString:@"P2POrHonerAccoutVC"]){
                [[NSNotificationCenter defaultCenter] postNotificationName:RELOADP2PORHONERACCOTDATA object:nil];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadMianViewData" object:nil];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshUserState" object:nil];
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
