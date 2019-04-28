//
//  UCFRegisterdSucceedViewController.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/21.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFRegisterdSucceedViewController.h"
#import "UCFCouponPopup.h"
#import "NZLabel.h"
#import "BaseScrollview.h"
#import "UCFMicroBankOpenAccountViewController.h"
@interface UCFRegisterdSucceedViewController ()<PublicPopupWindowViewDelegate>

@property (nonatomic, strong) MyRelativeLayout *rootLayout;

@property (nonatomic, strong) MyLinearLayout *scrollLayout;

@property (nonatomic, strong) BaseScrollview *scrollView;

@property (nonatomic, strong) MyRelativeLayout *bkLayout;

@property (nonatomic, strong) UIImageView *titleBkImageView; //密码

@property (nonatomic, strong) UIImageView *titleImageView; //密码

@property (nonatomic, strong) NZLabel     *navTitleLabel;//导航标题

@property (nonatomic, strong) UIButton   *closeBtn;

@property (nonatomic, strong) NZLabel     *titleLabel;//输入验证码标题

@property (nonatomic, strong) MyRelativeLayout *tipsLayout;

@property (nonatomic, strong) UIImageView *tipsTitleImageView; //tips图片

@property (nonatomic, strong) NZLabel     *tipsTitleLabel;//开通存管账户 保障资金安全

@property (nonatomic, strong) NZLabel     *tipsContentLabel;//由徽商银行提供资金存管 为保障您的资金安全，请及时开通存管账户

@property (nonatomic, strong) NZLabel     *openAccoutLabel; //完成开户奖励

@property (nonatomic, strong) NZLabel     *openAccoutAwardLabel;//200元优惠券

@property (nonatomic, strong) UIView  *leftRound;

@property (nonatomic, strong) UIView  *rightRound;

@property (nonatomic, strong) UIView  *leftLineView;

@property (nonatomic, strong) UIView  *rightLineView;

@property (nonatomic, strong) UIButton *openAccoutBtn;

@end

@implementation UCFRegisterdSucceedViewController

- (void)loadView
{
    self.rootLayout = [MyRelativeLayout new];
    self.rootLayout.backgroundColor = [Color color:PGColorOpttonRateNoramlTextColor];
    self.rootLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
    self.view = self.rootLayout;
    [self.rootLayout addSubview: self.scrollView];
    [self.scrollView addSubview:self.scrollLayout];
    [self.scrollLayout addSubview:self.bkLayout];
    
    [self.bkLayout addSubview:self.titleBkImageView];
    [self.bkLayout addSubview:self.navTitleLabel];
    [self.bkLayout addSubview:self.closeBtn];
    [self.bkLayout addSubview:self.titleImageView];
    [self.bkLayout addSubview:self.titleLabel];
    [self.bkLayout addSubview:self.tipsLayout];
    [self.tipsLayout addSubview:self.tipsTitleImageView];
    [self.tipsLayout addSubview:self.tipsTitleLabel];
    [self.tipsLayout addSubview:self.tipsContentLabel];
//    [self.tipsLayout addSubview:self.openAccoutLabel];
//    [self.tipsLayout addSubview:self.leftRound];
//    [self.tipsLayout addSubview:self.rightRound];
//    [self.tipsLayout addSubview:self.openAccoutAwardLabel];
    [self.tipsLayout addSubview:self.openAccoutBtn];
    
    [self getRegistResultData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addLeftButton];
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    lineViewAA.hidden= YES;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)getToBack
{

    UCFPopViewWindow *popView = [UCFPopViewWindow new];
    popView.delegate = self;
    popView.type = POPOpenAccountRenounce;
    popView.popViewTag = 10001;
    [popView startPopView];
}
- (void)popEnterButtonClick:(UIButton *)btn
{
    [self goToOpenAccount];
}
- (void)popCancelButtonClick:(UIButton *__nullable)btn
{
    [self.rt_navigationController popToRootViewControllerAnimated:YES];
    [UCFCouponPopup startQueryCouponPopup];//去调取首页优惠券弹框
}
- (BaseScrollview *)scrollView
{
    if (nil == _scrollView) {
        _scrollView = [BaseScrollview new];
        _scrollView.scrollEnabled = YES;
        _scrollView.backgroundColor = [Color color:PGColorOpttonRegisterBackgroundColor];
        _scrollView.leftPos.equalTo(@0);
        _scrollView.rightPos.equalTo(@0);
        _scrollView.topPos.equalTo(@0);
        _scrollView.bottomPos.equalTo(@0);
    }
    return _scrollView;
}

- (MyLinearLayout *)scrollLayout
{
    if (nil == _scrollLayout) {
        _scrollLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
        _scrollLayout.backgroundColor = [Color color:PGColorOpttonRegisterBackgroundColor];
        _scrollLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
        _scrollLayout.myHorzMargin = 0;                          //同时指定左右边距为0表示宽度和父视图一样宽
        _scrollLayout.heightSize.lBound(self.scrollView.heightSize, 10, 1); //高度虽然是wrapContentHeight的。但是最小的高度不能低于父视图的高度加10.
        
    }
    return _scrollLayout;
}
- (MyRelativeLayout *)bkLayout
{
    if (nil == _bkLayout) {
        _bkLayout = [MyRelativeLayout new];
        _bkLayout.backgroundColor = [Color color:PGColorOpttonRegisterBackgroundColor];
        _bkLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
        _bkLayout.myHeight = 661;
        _bkLayout.myTop = 0;
        _bkLayout.myLeft = 0;
        _bkLayout.myWidth = PGScreenWidth;
    }
    return _bkLayout;
}
- (UIButton *)closeBtn
{
    if (nil == _closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //        [_closeBtn setFrame:CGRectMake(25, 0, 25, 25)];
        _closeBtn.myWidth = 25;
        _closeBtn.myHeight = 25;
        _closeBtn.myLeft = 25;
        _closeBtn.centerYPos.equalTo(self.navTitleLabel.centerYPos);
        [_closeBtn setBackgroundColor:[UIColor clearColor]];
//        [_closeBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_closeBtn setTitleColor:[UIColor colorWithWhite:1 alpha:0.7] forState:UIControlStateHighlighted];
//        [_closeBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -15, 0.0, 0.0)];
        [_closeBtn setImage:[UIImage imageNamed:@"icon_close_white"]forState:UIControlStateNormal];
        //[leftButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateHighlighted];
         _closeBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_closeBtn addTarget:self action:@selector(getToBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}
- (NZLabel *)navTitleLabel
{
    if (nil == _navTitleLabel) {
        _navTitleLabel = [NZLabel new];
        _navTitleLabel.myTop = PGStatusBarHeight +10;
        _navTitleLabel.centerXPos.equalTo(self.bkLayout.centerXPos);
        _navTitleLabel.textAlignment = NSTextAlignmentCenter;
        _navTitleLabel.font = [Color gc_Font:18.0];
        _navTitleLabel.textColor = [Color color:PGColorOptionThemeWhite];
        _navTitleLabel.text = @"注册成功";
        //        _titleLabel.myVisibility = MyVisibility_Gone;
        [_navTitleLabel sizeToFit];
    }
    return _navTitleLabel;
}
- (UIImageView *)titleBkImageView
{
    if (nil == _titleBkImageView) {
        _titleBkImageView = [[UIImageView alloc] init];
        _titleBkImageView.myTop = 20;
        _titleBkImageView.myLeft = 0;
        _titleBkImageView.myWidth = PGScreenWidth;
        _titleBkImageView.myHeight = PGScreenWidth *1.2;
        _titleBkImageView.image = [UIImage imageNamed:@"bg_light"];
    }
    return _titleBkImageView;
}

- (UIImageView *)titleImageView
{
    if (nil == _titleImageView) {
        _titleImageView = [[UIImageView alloc] init];
        _titleImageView.topPos.equalTo(self.navTitleLabel.bottomPos).offset(35);
        _titleImageView.centerXPos.equalTo(self.bkLayout.centerXPos);
        _titleImageView.myWidth = 190;
        _titleImageView.myHeight = 110;
        _titleImageView.image = [UIImage imageNamed:@"icon_gift"];
    }
    return _titleImageView;
}
- (NZLabel *)titleLabel
{
    if (nil == _titleLabel) {
        _titleLabel = [NZLabel new];
        _titleLabel.topPos.equalTo(self.titleImageView.bottomPos).offset(10);
        _titleLabel.centerXPos.equalTo(self.bkLayout.centerXPos);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [Color gc_Font:15.0];
        _titleLabel.textColor = [Color color:PGColorOpttonRegisterdSucceedColor];
        _titleLabel.text = @"新手大礼包已发放至您的账户";
//        _titleLabel.myVisibility = MyVisibility_Gone;
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (MyRelativeLayout *)tipsLayout
{
    if (nil == _tipsLayout) {
        _tipsLayout = [MyRelativeLayout new];
        _tipsLayout.backgroundColor = [Color color:PGColorOptionThemeWhite];
//        _tipsLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
        _tipsLayout.myHeight = 400;
        _tipsLayout.topPos.equalTo(self.titleLabel.bottomPos).offset(20);
        _tipsLayout.myLeft = 15;
        _tipsLayout.myRight = 15;
        _tipsLayout.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *sbv)
        { //viewLayoutCompleteBlock是在1.2.3中添加的新功能，目的是给完成了布局的子视图一个机会进行一些特殊的处理，viewLayoutCompleteBlock只会在子视图布局完成后调用一次.其中的sbv就是子视图自己，而layout则是父布局视图。因为这个block是完成布局后执行的。所以这时候子视图的frame值已经被计算出来，因此您可以在这里设置一些和frame关联的属性。
            //设置圆角的半径
            sbv.layer.cornerRadius = 10;
            //切割超出圆角范围的子视图
            sbv.layer.masksToBounds = YES;
        };
//        _tipsLayout.tag = 1005;
//        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(layoutClick:)];
//        [_inviteLayout addGestureRecognizer:tapGesturRecognizer];
        
    }
    return _tipsLayout;
}
- (UIImageView *)tipsTitleImageView
{
    if (nil == _tipsTitleImageView) {
        _tipsTitleImageView = [[UIImageView alloc] init];
        _tipsTitleImageView.myTop = 30;
        _tipsTitleImageView.centerXPos.equalTo(self.tipsLayout.centerXPos);
        _tipsTitleImageView.widthSize.equalTo(self.bkLayout.widthSize).multiply(0.73);
        _tipsTitleImageView.heightSize.equalTo(_tipsTitleImageView.widthSize).multiply(0.62);
//        v2.widthSize.equalTo(rootLayout.widthSize).multiply(0.8);  //子视图的宽度是父视图宽度的0.8
        _tipsTitleImageView.image = [UIImage imageNamed:@"bg_huishang"];
    }
    return _tipsTitleImageView;
}


- (NZLabel *)tipsTitleLabel
{
    if (nil == _tipsTitleLabel) {
        _tipsTitleLabel = [NZLabel new];
        _tipsTitleLabel.topPos.equalTo(self.tipsTitleImageView.bottomPos).offset(15);
        _tipsTitleLabel.centerXPos.equalTo(self.tipsTitleImageView.centerXPos);
        _tipsTitleLabel.textAlignment = NSTextAlignmentCenter;
        _tipsTitleLabel.font = [Color gc_Font:20.0];
        _tipsTitleLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _tipsTitleLabel.text = @"开通存管账户 保障资金安全";
        [_tipsTitleLabel sizeToFit];
    }
    return _tipsTitleLabel;
}
- (NZLabel *)tipsContentLabel
{
    if (nil == _tipsContentLabel) {
        _tipsContentLabel = [NZLabel new];
        _tipsContentLabel.topPos.equalTo(self.tipsTitleLabel.bottomPos).offset(8);
        _tipsContentLabel.centerXPos.equalTo(self.tipsTitleImageView.centerXPos);
        _tipsContentLabel.textAlignment = NSTextAlignmentCenter;
        _tipsContentLabel.font = [Color gc_Font:15.0];
        _tipsContentLabel.textColor = [Color color:PGColorOptionTitleGray];
        _tipsContentLabel.text = @"由徽商银行提供资金存管\n为保障您的资金安全，请及时开通存管账户";
        _tipsContentLabel.wrapContentHeight = YES;
        [_tipsContentLabel sizeToFit];
    }
    return _tipsContentLabel;
}
- (NZLabel *)openAccoutLabel
{
    if (nil == _openAccoutLabel) {
        _openAccoutLabel = [NZLabel new];
        _openAccoutLabel.topPos.equalTo(self.tipsContentLabel.bottomPos).offset(30);
        _openAccoutLabel.centerXPos.equalTo(self.tipsTitleImageView.centerXPos);
        _openAccoutLabel.textAlignment = NSTextAlignmentCenter;
        _openAccoutLabel.font = [Color gc_Font:18.0];
        _openAccoutLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _openAccoutLabel.text = @"完成开户奖励";
        [_openAccoutLabel sizeToFit];
    }
    return _openAccoutLabel;
}
- (UIView *)leftRound
{
    if (nil == _leftRound) {
        _leftRound = [UIView new];
        _leftRound.backgroundColor = self.scrollLayout.backgroundColor;
        _leftRound.centerYPos.equalTo(self.openAccoutLabel.centerYPos);
        _leftRound.myWidth = 16;
        _leftRound.myHeight = 16;
        _leftRound.myLeft = -8;
        _leftRound.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *sbv)
        { //viewLayoutCompleteBlock是在1.2.3中添加的新功能，目的是给完成了布局的子视图一个机会进行一些特殊的处理，viewLayoutCompleteBlock只会在子视图布局完成后调用一次.其中的sbv就是子视图自己，而layout则是父布局视图。因为这个block是完成布局后执行的。所以这时候子视图的frame值已经被计算出来，因此您可以在这里设置一些和frame关联的属性。
            //设置圆角的半径
            sbv.layer.cornerRadius = 8;
            //切割超出圆角范围的子视图
            sbv.layer.masksToBounds = YES;
        };
    }
    return _leftRound;
}
- (UIView *)rightRound
{
    if (nil == _rightRound) {
        _rightRound = [UIView new];
        _rightRound.backgroundColor = self.scrollLayout.backgroundColor;
        _rightRound.centerYPos.equalTo(self.openAccoutLabel.centerYPos);
        _rightRound.myWidth = 16;
        _rightRound.myHeight = 16;
        _rightRound.myRight = -8;
        _rightRound.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *sbv)
        { //viewLayoutCompleteBlock是在1.2.3中添加的新功能，目的是给完成了布局的子视图一个机会进行一些特殊的处理，viewLayoutCompleteBlock只会在子视图布局完成后调用一次.其中的sbv就是子视图自己，而layout则是父布局视图。因为这个block是完成布局后执行的。所以这时候子视图的frame值已经被计算出来，因此您可以在这里设置一些和frame关联的属性。
            //设置圆角的半径
            sbv.layer.cornerRadius = 8;
            //切割超出圆角范围的子视图
            sbv.layer.masksToBounds = YES;
        };
    }
    return _rightRound;
}

- (NZLabel *)openAccoutAwardLabel
{
    if (nil == _openAccoutAwardLabel) {
        _openAccoutAwardLabel = [NZLabel new];
        _openAccoutAwardLabel.topPos.equalTo(self.openAccoutLabel.bottomPos).offset(10);
        _openAccoutAwardLabel.centerXPos.equalTo(self.tipsTitleImageView.centerXPos);
        _openAccoutAwardLabel.textAlignment = NSTextAlignmentCenter;
        _openAccoutAwardLabel.font = [Color gc_Font:25.0];
//        _openAccoutAwardLabel.textColor = [Color color:PGColorOptionTitleBlack];
//        _openAccoutAwardLabel.text = @"完成开户奖";
//        [_openAccoutAwardLabel sizeToFit];
    }
    return _openAccoutAwardLabel;
}
- (UIButton *)openAccoutBtn
{
    if (nil == _openAccoutBtn) {
        _openAccoutBtn = [UIButton buttonWithType:0];
        _openAccoutBtn.myBottom = 30;
        _openAccoutBtn.rightPos.equalTo(@30);
        _openAccoutBtn.leftPos.equalTo(@30);
        _openAccoutBtn.heightSize.equalTo(@40);
        [_openAccoutBtn setTitle:@"立即开通" forState:UIControlStateNormal];
        _openAccoutBtn.titleLabel.font= [Color gc_Font:15.0];
        [_openAccoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_openAccoutBtn addTarget:self action:@selector(goToOpenAccount) forControlEvents:UIControlEventTouchUpInside];
        _openAccoutBtn.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *sbv)
        { //viewLayoutCompleteBlock是在1.2.3中添加的新功能，目的是给完成了布局的子视图一个机会进行一些特殊的处理，viewLayoutCompleteBlock只会在子视图布局完成后调用一次.其中的sbv就是子视图自己，而layout则是父布局视图。因为这个block是完成布局后执行的。所以这时候子视图的frame值已经被计算出来，因此您可以在这里设置一些和frame关联的属性。
            //设置圆角的半径
            sbv.layer.cornerRadius = 20;
            //切割超出圆角范围的子视图
            sbv.layer.masksToBounds = YES;
        };
        //输入正常,按钮可点击
        [_openAccoutBtn setBackgroundImage:[Image gradientImageWithBounds:CGRectMake(0, 0, PGScreenWidth - 50, 40) andColors:@[(id)UIColorWithRGB(0xFF4133),(id)UIColorWithRGB(0xFF7F40)] andGradientType:1] forState:UIControlStateNormal];
    }
    return _openAccoutBtn;
}
- (void)goToOpenAccount
{
    _titleLabel.myVisibility = MyVisibility_Visible;
    UCFMicroBankOpenAccountViewController *vc = [[UCFMicroBankOpenAccountViewController alloc] init];
    [self.rt_navigationController pushViewController:vc animated:YES complete:nil];
}

#pragma mark - 请求网络及回调
//获取注册成功活动反的数据
- (void)getRegistResultData{
    NSString *userId = SingleUserInfo.loginData.userInfo.userId;
    //    NSString *strParameters = [NSString stringWithFormat:@"userId=%@",userId];//5644  931407
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"userId", nil];
    
    [[NetworkModule sharedNetworkModule] newPostReq:dic tag:kSXTagRegistResult owner:self signature:NO Type:SelectAccoutDefault];
}

//开始请求
- (void)beginPost:(kSXTag)tag
{
    //    [GiFHUD show];
}

//请求成功及结果
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSMutableDictionary *dic = [result objectFromJSONString];
    
    id ret = dic[@"ret"];
    if (tag.intValue == kSXTagRegistResult) {
        if ([ret boolValue]) {
            
            //restype：A 券 B公分 1:工豆
            
            NSDictionary *tempDic = @{@"A":@"返现券", @"B":@"返息券",@"C":@"公分",@"1":@"工豆",@"G":@"返金券"};
            NSArray *registResult =[[dic objectForKey:@"data"] objectForKey:@"registResult"];
            NSMutableAttributedString *rsultStr = [[NSMutableAttributedString alloc] init];
            
            for (int i = 0; i < registResult.count; i ++) {
                
                NSString *restype =  [[registResult objectAtIndex:i] objectForKey:@"restype"];
                NSString *resvalue = [NSString stringWithFormat:@"%@",[[registResult objectAtIndex:i] objectForKey:@"resvalue"] ];
                if ([restype isEqualToString:@"A"])
                {
                    //                    tempStr = [NSString stringWithFormat:@"%@元",resvalue];
                    //                    //设置字体颜色
                    //                    NSString *str1 = [NSString stringWithFormat:@"%@元%@",resvalue,[tempDic objectForKey:restype]];
                    
                    [rsultStr appendAttributedString:[self setAttributedStringValue:resvalue andColor:[UIColor redColor] andFont:[UIFont systemFontOfSize:14]]];
                    [rsultStr appendAttributedString:[self setAttributedStringValue:[NSString stringWithFormat:@"元%@",[tempDic objectForKey:restype]] andColor:UIColorWithRGB(0xA9B1B5) andFont:[UIFont systemFontOfSize:14]]];
                    
                }
                else if ([restype isEqualToString:@"B"])
                {
                    //                    tempStr = [NSString stringWithFormat:@"%@个",resvalue];
                    //                    [tempStr appendFormat:@"%@%%%@",resvalue,[tempDic objectForKey:restype]];
                    
                    [rsultStr appendAttributedString:[self setAttributedStringValue:[NSString stringWithFormat:@"%@%%",resvalue] andColor:[UIColor redColor] andFont:[UIFont systemFontOfSize:14]]];
                    [rsultStr appendAttributedString:[self setAttributedStringValue:[tempDic objectForKey:restype] andColor:UIColorWithRGB(0xA9B1B5) andFont:[UIFont systemFontOfSize:14]]];
                }
                else if ([restype isEqualToString:@"C"])
                {
                    //                    tempStr = [NSString stringWithFormat:@"%@个",resvalue];
                    //                    [tempStr appendFormat:@"%@个%@",resvalue,[tempDic objectForKey:restype]];
                    [rsultStr appendAttributedString:[self setAttributedStringValue:resvalue andColor:[UIColor redColor] andFont:[UIFont systemFontOfSize:14]]];
                    [rsultStr appendAttributedString:[self setAttributedStringValue:[NSString stringWithFormat:@"个%@",[tempDic objectForKey:restype]] andColor:UIColorWithRGB(0xA9B1B5) andFont:[UIFont systemFontOfSize:14]]];
                }
                else if ([restype isEqualToString:@"1"])
                {
                    //                    tempStr = [NSString stringWithFormat:@"%@个",resvalue];
                    //                    [tempStr appendFormat:@"%@个%@",resvalue,[tempDic objectForKey:restype]];
                    [rsultStr appendAttributedString:[self setAttributedStringValue:resvalue andColor:[UIColor redColor] andFont:[UIFont systemFontOfSize:14]]];
                    [rsultStr appendAttributedString:[self setAttributedStringValue:[NSString stringWithFormat:@"个%@",[tempDic objectForKey:restype]] andColor:UIColorWithRGB(0xA9B1B5) andFont:[UIFont systemFontOfSize:14]]];
                }
                else if ([restype isEqualToString:@"G"])
                {
                    //                    tempStr = [NSString stringWithFormat:@"%@个",resvalue];
                    //                    [tempStr appendFormat:@"%@个%@",resvalue,[tempDic objectForKey:restype]];
                    [rsultStr appendAttributedString:[self setAttributedStringValue:resvalue andColor:[UIColor redColor] andFont:[UIFont systemFontOfSize:14]]];
                    [rsultStr appendAttributedString:[self setAttributedStringValue:[NSString stringWithFormat:@"克%@",[tempDic objectForKey:restype]] andColor:UIColorWithRGB(0xA9B1B5) andFont:[UIFont systemFontOfSize:14]]];
                }
                
                if (i +1 != registResult.count) {
                    [rsultStr appendAttributedString:[self setAttributedStringValue:[NSString stringWithFormat:@"、"] andColor:UIColorWithRGB(0xA9B1B5) andFont:[UIFont systemFontOfSize:14]]];
                }
            }
            [rsultStr appendAttributedString:[self setAttributedStringValue:[NSString stringWithFormat:@"已经转入您的账户中"] andColor:UIColorWithRGB(0xA9B1B5) andFont:[UIFont systemFontOfSize:14]]];
            self.openAccoutAwardLabel.attributedText = rsultStr;
            [self.openAccoutAwardLabel sizeToFit];
            
        }
        //        else {
        //            _customLabel.text = @"恭喜您注册成功！";
        //        }
        
    }
}
//请求失败
- (void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
- (NSAttributedString *)setAttributedStringValue:(NSString *)str andColor:(UIColor *)color andFont:(UIFont *)font
{
    //设置字体格式和大小,设置字体颜色  A9B1B5
    NSString *str1 = str;
    NSDictionary *dictAttr1 = @{NSFontAttributeName:font,NSForegroundColorAttributeName:color};
    NSAttributedString *attr1 = [[NSAttributedString alloc]initWithString:str1 attributes:dictAttr1];
    return attr1;
}
@end
