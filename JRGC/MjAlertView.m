//
//  MjAlertView.m
//  CustomAlertView
//
//  Created by NJW on 15/8/4.
//  Copyright (c) 2015年 NJW. All rights reserved.
//

#import "MjAlertView.h"
#import "NZLabel.h"
#import "MongoliaLayerCenter.h"
#define SCREEN_WIDTH_5 ([UIScreen mainScreen].bounds.size.width == 320)
#define SCREEN_WIDTH_6 ([UIScreen mainScreen].bounds.size.width == 375)
#define SCREEN_WIDTH_6P ([UIScreen mainScreen].bounds.size.width == 414)

#define CancelButtonTag 0
@interface MjAlertView ()<UIWebViewDelegate>
{
    UIWebView *_webView;
}
@property (nonatomic, strong) NSMutableArray *buttonArray;

@property (nonatomic, assign) NSInteger currentSelectSortBtnTag;

@end

@implementation MjAlertView

- (instancetype)initTypeOneAlertViewWithBlock:(MyBlock)block
{
    self = [self init];
    if (self) {
        self.block = block;
        self.alertAnimateType = MjAlertViewAnimateTypePop;
        self.alertviewType = MjAlertViewTypeTypeOne;
    }
    return self;
}
// 创建红包的弹框
- (instancetype)initRedBagAlertViewWithBlock:(MyBlock)block delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle
{
    self = [self init];
    if (self) {
        self.block = block;
        self.delegate = delegate;
        
        if (cancelButtonTitle.length>0) {
            UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.showView addSubview:cancel];
            self.cancelButton = cancel;
            self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
            [cancel setTitle:cancelButtonTitle forState:UIControlStateNormal];
            [cancel addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        }

        self.alertviewType = MjAlertViewTypeRedBag;
        self.alertAnimateType = MjAlertViewAnimateTypePop;
    }
    return self;
}

// 创建提示签到弹框
- (instancetype)initSignAlertViewWithBlock:(MyBlock)block delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle withOtherButtons:(NSArray *)otherButtons
{
    self = [self init];
    if (self) {
        self.block = block;
        self.delegate = delegate;
        
        if (cancelButtonTitle.length>0) {
            UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.showView addSubview:cancel];
            self.cancelButton = cancel;
            [cancel setTitle:cancelButtonTitle forState:UIControlStateNormal];
            [cancel addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        for (int i=0; i<otherButtons.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.showView addSubview:button];
            [self.buttonArray addObject:button];
            button.tag = i+1;
            [button setTitle:(NSString *)otherButtons[i] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        // 设置本身的透明度及背景颜色
        /*如果直接设置view的透明度会导致其子控件跟随其改变透明度，而此方法不会传递其透明度*/
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        
        self.alertviewType = MjAlertViewTypeSign;
        self.alertAnimateType = MjAlertViewAnimateTypePop;
    }
    return self;
}

#pragma mark - 提现手续费弹框
- (instancetype)initCashAlertViewWithCashMoney:(NSString *)cashMoney  ActualAccount:(NSString *)actualAccount FeeMoney:(NSString *)feemMoney  delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle withOtherButtonTitle:(NSString*)otherButtonTitle{
    
    self = [self init];
    if (self) {
        
        UIView * view  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 37)];
        view.backgroundColor = UIColorWithRGB(0xf9f9f9);
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 9, 300-30, 20)];
        titleLabel.text = @"提示";
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = UIColorWithRGB(0x555555);
        titleLabel.textAlignment = NSTextAlignmentLeft;
        [view addSubview:titleLabel];
        
        [self.showView addSubview:view];
        
        NZLabel  *actualMoneyLabel = [[NZLabel alloc]init];
        actualMoneyLabel.textColor = UIColorWithRGB(0x555555);
        actualMoneyLabel.text = [NSString stringWithFormat:@"实际到账金额%@",actualAccount];
        [actualMoneyLabel setFontColor:UIColorWithRGB(0xfd4d4c) string:actualAccount];
        actualMoneyLabel.frame =CGRectMake(15, CGRectGetMaxY(view.frame)+10, 240-30,[self getTextHight:actualMoneyLabel.text withFont:16]);
        actualMoneyLabel.numberOfLines = 0;
        actualMoneyLabel.textAlignment = NSTextAlignmentLeft;
        actualMoneyLabel.font = [UIFont systemFontOfSize:16];
        [self.showView addSubview:actualMoneyLabel];
        
        NZLabel  *cashMoneyLabel = [[NZLabel alloc]init];
        cashMoneyLabel.textColor = UIColorWithRGB(0x555555);
        cashMoneyLabel.text = [NSString stringWithFormat:@"提现金额%@",cashMoney];
        [cashMoneyLabel setFontColor:UIColorWithRGB(0xfd4d4c) string:cashMoney];
        cashMoneyLabel.frame =CGRectMake(15, CGRectGetMaxY(actualMoneyLabel.frame)+15, 240-30,[self getTextHight:cashMoneyLabel.text withFont:13]);
        cashMoneyLabel.numberOfLines = 0;
        cashMoneyLabel.textAlignment = NSTextAlignmentLeft;
        cashMoneyLabel.font = [UIFont systemFontOfSize:13];
        [self.showView  addSubview:cashMoneyLabel];
      
        NZLabel  *feeMoneyLabel = [[NZLabel alloc]init];
        feeMoneyLabel.textColor = UIColorWithRGB(0x555555);
        feeMoneyLabel.text = [NSString stringWithFormat:@"提现手续费%@",feemMoney];
        [feeMoneyLabel setFontColor:UIColorWithRGB(0xfd4d4c) string:feemMoney];
        feeMoneyLabel.frame =CGRectMake(15, CGRectGetMaxY(cashMoneyLabel.frame)+10, 240-30,[self getTextHight:feeMoneyLabel.text withFont:13]);
        feeMoneyLabel.numberOfLines = 0;
        feeMoneyLabel.textAlignment = NSTextAlignmentLeft;
        feeMoneyLabel.font = [UIFont systemFontOfSize:13];
        
        [self.showView  addSubview:feeMoneyLabel];
        
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        if (cancelButtonTitle) {
            cancel.frame = CGRectMake(15, CGRectGetMaxY(feeMoneyLabel.frame)+15, 120, 37);
            cancel.backgroundColor  = UIColorWithRGB(0x8296af);
            cancel.titleLabel.textColor = [UIColor whiteColor];
            cancel.titleLabel.font = [UIFont systemFontOfSize:16];
            cancel.layer.cornerRadius = 2;
            [cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cancel setTitle:cancelButtonTitle forState:UIControlStateNormal];
            [cancel addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            cancel.tag = CancelButtonTag;
            [self.showView  addSubview:cancel];
        }
        UIButton *otherButton = [UIButton buttonWithType:UIButtonTypeCustom];
        if (otherButtonTitle) {
            otherButton.frame = CGRectMake(CGRectGetMaxX(cancel.frame)+30, CGRectGetMaxY(feeMoneyLabel.frame)+15, 120, 37);
            otherButton.backgroundColor = UIColorWithRGB(0xfd4d4c);
            otherButton.titleLabel.font = [UIFont systemFontOfSize:16];
            otherButton.layer.cornerRadius = 2;
            [otherButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [otherButton setTitle:otherButtonTitle forState:UIControlStateNormal];
            otherButton.tag =CancelButtonTag +1;
            [otherButton addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.showView  addSubview:otherButton];
        }
        [self.showView  setFrame:CGRectMake(0, 0, 300, CGRectGetMaxY(cancel.frame)+15)];
        self.showView.layer.cornerRadius = 5;
        self.showView.layer.masksToBounds = YES;
        self.showView.backgroundColor = [UIColor whiteColor];
        self.alertviewType = MjAlertViewTypeCustom;
        self.delegate = delegate;
        // 默认显示动画类型
        self.alertAnimateType = MjAlertViewAnimateTypeNone;
    }
    return self;
}
-(instancetype)initRechargeViewWithTitle:(NSString *)title errorMessage:(NSString *)errorMessge message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle{
    self = [self init];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 300-30, 20)];
        titleLabel.text = title;
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.textColor = UIColorWithRGB(0x333333);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.showView addSubview:titleLabel];
        
        NZLabel  *errorMessagelabel = [[NZLabel alloc]init];
        errorMessagelabel.textColor = UIColorWithRGB(0x555555);
        errorMessagelabel.text =  errorMessge;
        errorMessagelabel.frame =CGRectMake(15, CGRectGetMaxY(titleLabel.frame)+5, 300-30,[self getTextHight:errorMessagelabel.text withFont:12]);
        errorMessagelabel.numberOfLines = 0;
        errorMessagelabel.textAlignment = NSTextAlignmentCenter;
        errorMessagelabel.font = [UIFont systemFontOfSize:12];
        [self.showView addSubview:errorMessagelabel];
//        NZLabel  *messageLabel = [[NZLabel alloc]init];
//        messageLabel.textColor = UIColorWithRGB(0x555555);
//         messageLabel.numberOfLines = 0;
//        messageLabel.text =  message;
//        messageLabel.frame =CGRectMake(26, CGRectGetMaxY(errorMessagelabel.frame)+10, 300-52,[self getTextHight:messageLabel.text labelWidth:300-52  withFont:12]);
//        [messageLabel setFontColor:UIColorWithRGB(0xfd4d4c) string:@"网银转账"];
//        [messageLabel setFontColor:UIColorWithRGB(0xfd4d4c) string:@"支付宝"];
//        messageLabel.textAlignment = NSTextAlignmentLeft;
//        messageLabel.font = [UIFont systemFontOfSize:12];
//        [self.showView addSubview:messageLabel];
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(errorMessagelabel.frame)+9, 300-30, 40)];
        [_webView setScalesPageToFit:YES];
        _webView.delegate  = self;
        _webView.userInteractionEnabled = NO;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        [_webView loadHTMLString:message baseURL:nil];
        [self.showView addSubview:_webView];
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        if (cancelButtonTitle) {
            cancel.frame = CGRectMake(15, CGRectGetMaxY(_webView.frame)+15, 300-30, 37);
            if ([message isEqualToString:@""]) {
            cancel.frame = CGRectMake(15, CGRectGetMaxY(errorMessagelabel.frame)+15, 300-30, 37);
            }
            cancel.backgroundColor  = UIColorWithRGB(0xfd4d4c);
            cancel.titleLabel.textColor = [UIColor whiteColor];
            cancel.titleLabel.font = [UIFont systemFontOfSize:16];
            cancel.layer.cornerRadius = 2;
            [cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cancel setTitle:cancelButtonTitle forState:UIControlStateNormal];
            [cancel addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            cancel.tag = CancelButtonTag;
            [self.showView  addSubview:cancel];
        }
        [self.showView  setFrame:CGRectMake(0, 0, 300, CGRectGetMaxY(cancel.frame)+15)];
        self.showView.layer.cornerRadius = 5;
        self.showView.layer.masksToBounds = YES;
        self.showView.backgroundColor = [UIColor whiteColor];
        self.alertviewType = MjAlertViewTypeCustom;
        self.delegate = delegate;
        // 默认显示动画类型
        self.alertAnimateType = MjAlertViewAnimateTypeNone;
    }
    
    
    return self;
    
}
#pragma 集合标详情里的排序弹框
-(instancetype)initCollectionViewWithTitle:(NSString *)title sortArray:(NSArray *)sortArray selectedSortButtonTag:(NSInteger)tag delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle withOtherButtonTitle:(NSString*)otherButtonTitle{
    self = [self init];
    if (self) {
        
        UIView * headerView  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 250, 37)];
        headerView.backgroundColor = UIColorWithRGB(0xf9f9f9);
        [self.showView addSubview:headerView];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, 100, 20)];
        titleLabel.text = title ;
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = UIColorWithRGB(0x333333);
        titleLabel.textAlignment = NSTextAlignmentLeft;
        [headerView addSubview:titleLabel];
        UIView * lineView  = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(headerView.frame)-0.5 , CGRectGetWidth(headerView.frame), 0.5)];
        lineView.backgroundColor = UIColorWithRGB(0xe3e5ea);
        [headerView addSubview:lineView];
        
        float buttonWidth = 67.0f;
        float buttonHeight = 27.0f;
        
        for (int i=0; i<sortArray.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(15+(10+buttonWidth)*i, CGRectGetMaxY(headerView.frame)+20, buttonWidth, buttonHeight);
            button.tag = i;
            button.layer.cornerRadius = 2;
            button.layer.borderWidth = 0.5;
            button.layer.borderColor = [UIColor whiteColor].CGColor;
            if (i == tag ) {
                _currentSelectSortBtnTag = tag;
                [button setSelected:YES];
                 button.layer.borderColor = UIColorWithRGB(0xfd4d4c).CGColor;
            }
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            [button setTitleColor:UIColorWithRGB(0x555555) forState:UIControlStateNormal];
            [button setTitleColor:UIColorWithRGB(0xfd4d4c) forState:UIControlStateSelected];
            [button setTitle:(NSString *)sortArray[i] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(clickSortButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.showView addSubview:button];
            [self.buttonArray addObject:button];
        }
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        if (cancelButtonTitle) {
            cancel.frame = CGRectMake(CGRectGetWidth(headerView.frame)- 8 - 30,3.5,30, 30);
            [cancel setBackgroundImage:[UIImage imageNamed:@"calculator_gray_close.png"] forState:UIControlStateNormal];
            [cancel addTarget:self action:@selector(clickConfirmButton:) forControlEvents:UIControlEventTouchUpInside];
            cancel.tag = CancelButtonTag;
            [self.showView  addSubview:cancel];
        }
        UIButton *otherButton = [UIButton buttonWithType:UIButtonTypeCustom];
        if (otherButtonTitle) {
            otherButton.frame = CGRectMake(15, CGRectGetMaxY(headerView.frame)+20*2+buttonHeight, 250-30, 37);;
            otherButton.backgroundColor = UIColorWithRGB(0xfd4d4c);
            otherButton.titleLabel.font = [UIFont systemFontOfSize:16];
            otherButton.layer.cornerRadius = 2;
            [otherButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [otherButton setTitle:otherButtonTitle forState:UIControlStateNormal];
            otherButton.tag =CancelButtonTag +1;
            [otherButton addTarget:self action:@selector(clickConfirmButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.showView  addSubview:otherButton];
        }

        [self.showView  setFrame:CGRectMake(0, 0, 250, CGRectGetMaxY(otherButton.frame)+15)];
        self.showView.layer.cornerRadius = 5;
        self.showView.layer.masksToBounds = YES;
        self.showView.backgroundColor = [UIColor whiteColor];
        self.alertviewType = MjAlertViewTypeCustom;
        self.delegate = delegate;
        // 默认显示动画类型
        self.alertAnimateType = MjAlertViewAnimateTypeNone;
    }
    return self;
}
-(void)clickSortButton:(UIButton*)sortButton{
    if (_currentSelectSortBtnTag != sortButton.tag) {
        //置灰上一个选择的button
        UIButton *beforeBtn = _buttonArray[_currentSelectSortBtnTag];
        [beforeBtn setSelected:NO];
        beforeBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        //设置当前选择的button
        [sortButton setSelected:YES];
        sortButton.layer.borderColor = UIColorWithRGB(0xfd4d4c).CGColor;
        _currentSelectSortBtnTag = sortButton.tag;
    }
}
#pragma  首页邀请新政策弹框
-(instancetype)initInviteFriendsToMakeMoneyDelegate:(id)delegate{
    self = [self init];
    if (self) {
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:FirstAlertViewShowTime];
    [[NSUserDefaults standardUserDefaults]  synchronize];
    UIImageView *headerView  = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 373)];
    headerView.userInteractionEnabled = YES;
    headerView.image = [UIImage imageNamed:@"new_friend_bg.png"];
    
    [self.showView addSubview:headerView];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((ScreenWidth - 194)/2.0, CGRectGetMaxY(headerView.frame)-20-37, 194, 37);
    button.layer.cornerRadius = 17.5;
    button.userInteractionEnabled = YES;
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.backgroundColor = UIColorWithRGB(0xfd4d4c);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"立即查看详情" forState:UIControlStateNormal];
    button.tag = CancelButtonTag + 1;
    [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:button];
      
        
//    NZLabel *detailLab = [[NZLabel alloc] initWithFrame:CGRectMake(ScreenWidth /2 - 100, CGRectGetMidY(button.frame)-44-20, 200, 20)];
//    detailLab.text = @"每邀请一位奖励50-2400元";
//    detailLab.font = [UIFont systemFontOfSize:15];
//    detailLab.textColor = UIColorWithRGB(0x333333);
//    [detailLab setFontColor:UIColorWithRGB(0xfd4d4c) string:@"50-2400元"];
//    detailLab.textAlignment = NSTextAlignmentCenter;
//    [headerView addSubview:detailLab];
//        
//    NZLabel *titleLab = [[NZLabel alloc] initWithFrame:CGRectMake(ScreenWidth /2 - 75, CGRectGetMidY(detailLab.frame)-20 - 20, 150, 20)];
//    titleLab.text = @"2017邀友赚钱新政策";
//    titleLab.font = [UIFont systemFontOfSize:15];
//    titleLab.textColor = UIColorWithRGB(0x333333);
//
//    titleLab.textAlignment = NSTextAlignmentCenter;
//    [headerView addSubview:titleLab];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(ScreenWidth /2 - 100, CGRectGetMinY(button.frame) - 106, 200, 100)];
    webView.backgroundColor = [UIColor clearColor];
    [webView loadHTMLString: [[MongoliaLayerCenter sharedManager].mongoliaLayerDic valueForKey:@"novicePoliceContext"]  baseURL:nil];
    [headerView addSubview:webView];

    UIButton *cancelbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelbutton.frame = CGRectMake(ScreenWidth - 34 - 19, CGRectGetMaxY(headerView.frame)-228-34,34, 34);
    [cancelbutton setBackgroundImage:[UIImage imageNamed:@"new_friend_close"] forState:UIControlStateNormal];
    cancelbutton.tag = CancelButtonTag;
    [cancelbutton addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:cancelbutton];
        
        
    [self.showView  setFrame:CGRectMake(0, 0, ScreenWidth, 373)];
    self.showView.center = CGPointMake(ScreenWidth /2, ScreenHeight /2 - 72);
    self.showView.backgroundColor = [UIColor clearColor];
    self.alertviewType = MjAlertViewTypeInviteFriends;
    self.delegate =  delegate;
    // 默认显示动画类型
    self.alertAnimateType = MjAlertViewAnimateTypeNone;
       
    }
    return self;
}
-(instancetype)initPlatformUpgradeNotice:(id)delegate withAuthorizationDate:(NSString *)date{
    self = [self init];
    if (self) {

        
        UIImageView *headerView  = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 250, 80)];
        headerView.userInteractionEnabled = YES;
        headerView.image = [UIImage imageNamed:@"level_up"];
        [self.showView addSubview:headerView];
        
        UIView *whiteBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 70, 250, 300)];
        whiteBaseView.backgroundColor = [UIColor whiteColor];
        whiteBaseView.layer.cornerRadius = 5;
        whiteBaseView.layer.masksToBounds = YES;
        [self.showView addSubview:whiteBaseView];
        
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 15, CGRectGetWidth(whiteBaseView.frame) - 20, 220)];
        textView.backgroundColor = [UIColor whiteColor];
//        textView.textColor = UIColorWithRGB(0x666666);
//        textView.font = [UIFont systemFontOfSize:11.0f];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 5;// 字体的行间距
        NSDictionary *attributes = @{
                                     NSFontAttributeName:[UIFont systemFontOfSize:11.2],
                                     NSParagraphStyleAttributeName:paragraphStyle,
                                     NSForegroundColorAttributeName :UIColorWithRGB(0x555555)
                                     };
        NSString *str = [NSString stringWithFormat:@"尊敬的用户：\n       感谢您一直以来对金融工场平台的大力支持，为了给您提供更优质、专业的服务，金融工场平台品牌将作如下调整：\n1、现由北京凤凰信用管理有限公司运营的金融工场品牌自%@起由北京豆哥投资管理有限公司负责运营与使用。\n2、金融工场平台原用户的权益不受影响，北京凤凰信用管理有限公司运营的工场微金（网址:www.gongchangp2p.cn）平台将继续履行金融工场与原用户订立的服务协议，继续根据相关协议向原用户提供相关服务，直至相关协议履行完毕。\n感谢您对金融工场平台的信任和支持！\n\n\t\t北京豆哥投资管理有限公司",date];
        textView.attributedText = [[NSAttributedString alloc] initWithString:str attributes:attributes];
        textView.editable = NO;
        [whiteBaseView addSubview:textView];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((CGRectGetWidth(whiteBaseView.frame) - 135)/2,CGRectGetMaxY(textView.frame) + 15, 135, 32);
        [button setBackgroundColor:UIColorWithRGB(0xfd4d4c)];
        button.layer.cornerRadius = 16.0f;
        [button addTarget:self action:@selector(readAndConfirm:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [button setTitle:@"阅读并确认" forState:UIControlStateNormal];
        [whiteBaseView addSubview:button];

        [self.showView bringSubviewToFront:headerView];
        self.showView.frame = CGRectMake(0, 0, 250, 380);
        self.showView.backgroundColor = [UIColor clearColor];
        self.delegate =  delegate;
        // 默认显示动画类型
        self.alertAnimateType = MjAlertViewAnimateTypeNone;
        
    }
    return self;
}
- (void)webViewDidFinishLoad:(UIWebView*)webView{
    //字体大小
    [_webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '275%'"];
    //字体颜色
//        [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#555555'"];
    //页面背景色
    [_webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#FFFFF'"];
//    float  _scrollViewHeight =  _webView.scrollView.contentSize.height;
//
//    CGRect rect = _webView.frame ;
//    rect.size.height = _scrollViewHeight;
//    
//    _webView.frame = rect;
    
    
}
- (instancetype)initCustomAlertViewWithBlock:(MyBlock)block
{
    self = [self init];
    if (self) {
        self.block = block;
        self.alertAnimateType = MjAlertViewAnimateTypeNone;
        self.alertviewType = MjAlertViewTypeCustom;
    }
    return self;
}

- (NSMutableArray *)buttonArray
{
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

- (void)setShowViewbackImage:(UIImage *)showViewbackImage
{
    _showViewbackImage = showViewbackImage;
    self.backgroudImageView.image = self.showViewbackImage;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 初始化
        [self initiaMyView];
        [self.buttonArray removeAllObjects];
    }
    return self;
}

#pragma mark - 初始化
- (void)initiaMyView
{
    // 设置本身的透明度及背景颜色
    /*如果直接设置view的透明度会导致其子控件跟随其改变透明度，而此方法不会传递其透明度*/
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    // 设置横竖屏粘结
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // 背景图片
    UIImageView *backgroudImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    backgroudImageView.image = nil;
    [self addSubview:backgroudImageView];
    self.backgroudImageView = backgroudImageView;
    
    // 显示的view
    UIView *showView = [[UIView alloc] initWithFrame:CGRectZero];
    showView.backgroundColor = [UIColor clearColor];
    [self addSubview:showView];
    self.showView = showView;
    
    // 标题label
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    // 信息label
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self addSubview:messageLabel];
    self.messageLabel = messageLabel;
    
    // 默认是正常类型
    self.alertviewType = MjAlertViewTypeNormal;
    
    // 默认显示动画类型
    self.alertAnimateType = MjAlertViewAnimateTypeNone;
}

#pragma mark - 设置其尺寸
- (void)didMoveToWindow
{
    // 设置满屏显示
    self.frame = self.window.bounds;
}

- (void)didMoveToSuperview
{
    switch (self.alertAnimateType) {
        case MjAlertViewAnimateTypePop: {
            self.backgroudImageView.center = self.center;
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - 设置内部控件
- (void)layoutSubviews
{
    [super layoutSubviews];
    switch (self.alertviewType) {
        case MjAlertViewTypeRedBag: {
            self.showView.frame = CGRectMake(0, 0, 260, 340);
            CGFloat cancelButtonX = 40;
            CGFloat cancelButtonY = self.showView.frame.size.height - 50;
            CGFloat cancelButtonW = self.showView.frame.size.width - cancelButtonX * 2;
            CGFloat cancelButtonH = 30;
            self.cancelButton.frame = CGRectMake(cancelButtonX, cancelButtonY, cancelButtonW, cancelButtonH);
            // 回调数据块设置显示
            if (self.block) {
                self.block(self.showView);
            }
        }
            break;
        case MjAlertViewTypeSign:{
            self.showView.frame = CGRectMake(0, 0, 268, 202);
            CGFloat cancelButtonX = 20;
            CGFloat cancelButtonY = self.showView.frame.size.height - 57;
            CGFloat cancelButtonW = (self.showView.frame.size.width - cancelButtonX * 3)/2.0;
            CGFloat cancelButtonH = 37;
            self.cancelButton.frame = CGRectMake(cancelButtonX, cancelButtonY, cancelButtonW, cancelButtonH);
            if (self.buttonArray.count == 1) {
                CGFloat buttonX = 20 *2 + cancelButtonW;
                UIButton *button = [_buttonArray firstObject];
                button.frame = CGRectMake(buttonX, cancelButtonY, cancelButtonW, cancelButtonH);
                
            }
            // 回调数据块设置显示
            if (self.block) {
                self.block(self.showView);
            }
        }
            break;
            
        case MjAlertViewTypeTypeOne:{
            // 回调数据块设置显示
            if (self.block) {
                self.showView.layer.cornerRadius = 5.0f;
                self.showView.clipsToBounds = YES;
                self.block(self.showView);
            }
        }
            break;
        default:
            if (self.block) {
                self.block(self.showView);
            }
            break;
    }
    if(self.alertviewType == MjAlertViewTypeInviteFriends){
        self.showView.center = CGPointMake(ScreenWidth/2, 373/2);
    }else{
        self.showView.center = self.center;
    }
    
}

#pragma mark - 设置显示类型
- (void)setAlertviewType:(MjAlertViewType)alertviewType
{
    _alertviewType = alertviewType;
    switch (alertviewType) {
        case MjAlertViewTypeRedBag: {
            //清除不必要的控件
            [self.messageLabel removeFromSuperview];
            self.messageLabel = nil;
            // 设置背景图片的大小
            [self.backgroudImageView setFrame:CGRectMake(0, 0, 320, 568)];
            [self bringSubviewToFront:self.showView];
            // 设置弹框的按钮
            UIImage *imgNormal = [self newImageWithOldImage:@"btn_red" onLeftCapWidth:2.5 andTopCapHeight:2.5];
            UIImage *imgSelected = [self newImageWithOldImage:@"btn_red_highlight" onLeftCapWidth:2.5 andTopCapHeight:2.5];
            [self.cancelButton setBackgroundImage:imgNormal forState:UIControlStateNormal];
            [self.cancelButton setBackgroundImage:imgSelected forState:UIControlStateHighlighted];
        }
            break;
        case MjAlertViewTypeSign:{
            //清除不必要的控件
            [self.messageLabel removeFromSuperview];
            self.messageLabel = nil;
            [self.titleLabel removeFromSuperview];
            self.titleLabel = nil;
            // 设置背景图片的大小
            [self.backgroudImageView setFrame:CGRectMake(0, 0, 268, 202)];
            self.backgroudImageView.image = [UIImage imageNamed:@"reminder_bg"];
            [self bringSubviewToFront:self.showView];
            // 设置弹框的按钮
            UIImage *imgNormal = [self newImageWithOldImage:@"btn_bule" onLeftCapWidth:2.5 andTopCapHeight:2.5];
            UIImage *imgSelected = [self newImageWithOldImage:@"btn_bule_highlight" onLeftCapWidth:2.5 andTopCapHeight:2.5];
            [self.cancelButton setBackgroundImage:imgNormal forState:UIControlStateNormal];
            [self.cancelButton setBackgroundImage:imgSelected forState:UIControlStateHighlighted];
            self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
            if (_buttonArray.count == 1) {
                UIButton *button = [_buttonArray firstObject];
                UIImage *imgNormal = [self newImageWithOldImage:@"btn_red" onLeftCapWidth:2.5 andTopCapHeight:2.5];
                UIImage *imgSelected = [self newImageWithOldImage:@"btn_red_highlight" onLeftCapWidth:2.5 andTopCapHeight:2.5];
                [button setBackgroundImage:imgNormal forState:UIControlStateNormal];
                [button setBackgroundImage:imgSelected forState:UIControlStateHighlighted];
                button.titleLabel.font = [UIFont systemFontOfSize:14];
            }
        }
            break;
        default:
            break;
    }
}
#pragma mark - 设置动画类型
- (void)setAlertAnimateType:(MjAlertViewAnimateType)alertAnimateType
{
    _alertAnimateType = alertAnimateType;
    switch (alertAnimateType) {
        case MjAlertViewAnimateTypePop: {
            CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
            popAnimation.duration = 0.4;
            popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                                    [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                                    [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                                    [NSValue valueWithCATransform3D:CATransform3DIdentity]];
            popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
            popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                             [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                             [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
            for (UIView *view in self.subviews) {
                [view.layer addAnimation:popAnimation forKey:nil];
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 按钮点击事件处理
- (void)readAndConfirm:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(mjalertView:didClickedButton:andClickedIndex:)]) {
        [self.delegate mjalertView:self didClickedButton:button andClickedIndex:0];
        [self hide];
    }
}
- (void)btnClicked:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(mjalertView:didClickedButton:andClickedIndex:)]) {
        [self.delegate mjalertView:self didClickedButton:button andClickedIndex:button.tag];
        [self hide];
    }
    else if (button == self.cancelButton) {
        [self hide];
    }
}
//集合标详情 项目排序弹框 点击确认 按钮 触发该事件
- (void)clickConfirmButton:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(mjalertView:didClickedButton:andClickedIndex:)]) {
        [self.delegate mjalertView:self didClickedButton:button andClickedIndex:_currentSelectSortBtnTag];
        [self hide];
    }
}

#pragma mark - 显示
- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    NSLog(@"%@", NSStringFromCGRect(self.showView.frame));
}

#pragma mark - 隐藏
- (void)hide
{
    [self removeFromSuperview];
}

#pragma mark - 拉伸图片
- (UIImage *)newImageWithOldImage:(NSString *)image onLeftCapWidth:(CGFloat)widthScale andTopCapHeight:(CGFloat)heightScale
{
    return [[UIImage imageNamed:image] stretchableImageWithLeftCapWidth:widthScale topCapHeight:heightScale];
}
#pragma mark - 计算字体所需高度
-(float)getTextHight:(NSString *)string withFont:(CGFloat)font{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(220, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:font]} context:nil];
    
    float size = ceilf(rect.size.height);
    return size;
    
    
}
#pragma mark - 计算字体所需高度
-(float)getTextHight:(NSString *)string labelWidth:(float)width withFont:(CGFloat)font{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:font]} context:nil];
    float size = ceilf(rect.size.height);
    return size;
    
}
#pragma mark - 计算字体所需高度
- (CGSize)sizeWithText:(NSString *)text withTextName:(NSString *)name withFont:(CGFloat)font withStandardW:(CGFloat)standardW withStandardH:(CGFloat)standardH
{
    CGSize size = CGSizeZero;
    CGSize standardSize = CGSizeZero;
    if (standardW) {
        standardSize = CGSizeMake(standardW, MAXFLOAT);
    }
    else if (standardH) {
        standardSize = CGSizeMake(MAXFLOAT, standardH);
    }
    
#if __IPHONE_7_0 | __IPHONE_7_1 | __IPHONE_8_0 | __IPHONE_8_1 | __IPHONE_8_2 | __IPHONE_8_3 | __IPHONE_8_4

    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:name size:font], NSFontAttributeName, nil];
        
    size = [text boundingRectWithSize:standardSize options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
#else
    size = [text sizeWithFont:[UIFont fontWithName:name size:font] constrainedToSize:standardSize];
#endif
    return size;
}

- (void)dealloc
{
    self.buttonArray = nil;
}


@end
