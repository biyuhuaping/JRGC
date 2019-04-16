//
//  UCFPublicPopupWindowView.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/4/1.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFPublicPopupWindowView.h"
#import "TYAlertController+BlurEffects.h"
#import "UIView+TYAlertView.h"
#define getWidth(width)\
({\
    PGScreenWidth < 375? width -10 : width;\
})
//一个按钮的高度
#define ContentButtonHeight 170
//两个按钮的高度
#define ContentBothButtonHeight 203
static NSString *TextTitleHint = @"提示";
static NSString *TextButtonTitleEnter = @"确定";
static NSString *TextButtonTitleLogin = @"去登录";
static NSString *TextButtonTitleLoginAgain = @"重新输入";
static NSString *TextButtonOpenAccount = @"立即开户";
static NSString *TextButtonOpenAccountPassWord = @"立即设置";
static NSString *TextButtonOpenAccountAgain = @"继续开户";
static NSString *TextButtonSettingPassWordEnter = @"继续设置";
static NSString *TextButtonRegisterEnter = @"继续注册";
static NSString *TextButtonDontCancel = @"我不要了";
static NSString *TextButtonRiskEnter = @"风险评测";
static NSString *TextButtonMomentCancel = @"一会再说";
static NSString *TextButtonIKnowEnter = @"知道了";
static NSString *TextButtonStartEnter = @"开启";
static NSString *TextButtonCancelEnter = @"取消";
static NSString *TextButtonVersionEnter = @"更新";
static NSString *TextButtonAgainCancel = @"下次再说";
static NSString *TextButtonAgainLogin = @"重新登录";
static NSString *TextButtonContactService = @"联系客服";

static NSString *TextOpenAccountHint = @"您尚未开通\n徽商银行微金存管账户";
static NSString *TextOpenAccountPassWordHint = @"未设置微金交易密码不能\n投标、提现、充值";
static NSString *TextOpenAccountRiskHint = @"出借前需完成风险测评";
static NSString *TextRegisterRenounceTitle = @"完成注册奖励";
static NSString *TextRegisterRenounceContent = @"200元优惠券";
static NSString *TextRegisterSucceedRenounceContent = @"未开通微金徽商存管不能\n投标、提现、充值";
static NSString *TextLoginSucceedGestureContent = @"手势密码设置成功！";
static NSString *TextLoginSucceedFaceIDContent = @"是否启用Face ID面容解锁";
static NSString *TextLoginSucceedTouchIDContent = @"是否启用Touch ID指纹解锁";
static NSString *TextLoginSucceedVerifyTouchIDTitle = @"金融工场”的触控ID";
static NSString *TextLoginSucceedVerifyTouchIDContent = @"通过home键验证已有手机指纹";
static NSString *TextVersionUpdatingTitle = @"发现新版本";


static BOOL isLoginOut = NO;//退出登录

static BOOL isForcedUpdating = NO;//强制更新


@interface UCFPublicPopupWindowView ()

@property (nonatomic, strong) MyRelativeLayout *bkLayout;

@property (nonatomic, strong) UIButton *enterButton;

@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) UIImageView *bkImageView;

@property (nonatomic, strong) NZLabel     *titleLabel;

@property (nonatomic, strong) NZLabel     *contentLabel;

@property (nonatomic, assign) POPWINDOWS type;

@property (nonatomic, copy)   NSString  *contentStr;

@property (nonatomic, copy)   NSString  *titleStr;

@property (nonatomic, copy)   NSString *PopContent;

@property (nonatomic, copy)   NSString *PopTitle;

@property (nonatomic, assign) CGFloat *contentHeight;

@property (nonatomic ,assign) NSInteger popViewTag;

@end
@implementation UCFPublicPopupWindowView






+ (void)loadPopupWindowWithType:(POPWINDOWS)type
                    withContent:(NSString *__nullable)contentStr
                      withTitle:(NSString *__nullable)titletStr
               withInController:(UIViewController *__nullable)controller
                   withDelegate:(id __nullable)delegate
                 withPopViewTag:(NSInteger )viewTag
{

    if ([UCFPublicPopupWindowView checkPopupWindowView])
    {
        //如果有退出登录或者强制更新,则不让弹框出现
    }
    else
    {
        UCFPublicPopupWindowView *popup = [[UCFPublicPopupWindowView alloc] initWithFrame:CGRectMake(0, 0, PGScreenWidth, PGScreenHeight) withType:type withContent:contentStr withTitle:titletStr withPopViewTag:viewTag];
        if (type == POPMessageLoginOut || type == POPMessageLoginOutService) {
            [popup setLoginOut:YES];
        }
        if (type == POPMessageForcedUpdating) {
            [popup setForcedUpdating:YES];
        }
        
        if (delegate != nil) {
            popup.delegate = delegate;
        }
        if (controller == nil || ![controller isKindOfClass:[UIViewController class]]) {
            [popup showInWindow];
        }
        else{
            [popup showInController:controller ];
        }
    }
}

- (void)closePopupWindowView//手动b关闭弹框,一般不要去调
{
    [self clearPopupWindowView];
}

+ (BOOL)checkPopupWindowView
{
    //主线程中
    NSLock *lock = [[NSLock alloc] init];
    [lock lock];
    BOOL tempBl;
    if (isForcedUpdating || isLoginOut )
    {
        tempBl = YES;
    }
    else
    {
        tempBl = NO;
    }
    [lock unlock];
    return tempBl;
}

- (void)setForcedUpdating:(BOOL)forcedUpdating
{
    //主线程中
    NSLock *lock = [[NSLock alloc] init];
    [lock lock];
    isForcedUpdating = forcedUpdating;
    [lock unlock];
}

- (void)setLoginOut:(BOOL)loginOut
{
    //主线程中
    NSLock *lock = [[NSLock alloc] init];
    [lock lock];
    isLoginOut = loginOut;
    [lock unlock];
}




- (void)buttonClick
{
    if (self.type == POPMessageForcedUpdating) {
        //如果是强制更新,则不做操作,不让强制更新的弹框消失
    }
    else
    {
        if (self.type == POPMessageLoginOut  || self.type == POPMessageLoginOutService) {
            [self setLoginOut:NO];
        }
        [self clearPopupWindowView];
    }
}
- (void)enterButtonClick:(UIButton *)btn
{
    [self buttonClick];
    if (self.delegate && [self.delegate respondsToSelector:@selector(popEnterButtonClick:)]) {
        [self.delegate popEnterButtonClick:btn];
    }
}
-(void)cancelButtonClick:(UIButton *)btn
{
    [self buttonClick];
    if (self.delegate && [self.delegate respondsToSelector:@selector(popCancelButtonClick:)]) {
        [self.delegate popCancelButtonClick:btn];
    }
}

- (void)clearPopupWindowView
{
    [self hideView];
    if ([self superview]) {
        [self removeFromSuperview];
    }
}

- (id)initWithFrame:(CGRect)frame
           withType:(POPWINDOWS)type
        withContent:(NSString *__nonnull)contentStr
          withTitle:(NSString *__nonnull)titleStr
     withPopViewTag:(NSInteger )viewTag
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //        self.userInteractionEnabled = NO;
        //        self.rootLayout.userInteractionEnabled = NO;
        self.type = type;
        if (contentStr && contentStr.length >0 && [contentStr isKindOfClass:[NSString class]]) {
            self.contentStr = contentStr;
        }
        else
        {
            self.contentStr = @"";
        }
        if (titleStr && titleStr.length >0 && [titleStr isKindOfClass:[NSString class]]) {
            self.titleStr = titleStr;
        }
        else
        {
            self.titleStr = @"";
        }
        if (viewTag != 0 && viewTag) {
            self.popViewTag = viewTag;
        }
        [self.rootLayout addSubview:self.bkLayout];
        self.rootLayout.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        //    self.rootLayout.userInteractionEnabled = NO;
        //    self.bkLayout.userInteractionEnabled = NO;
        
        if (type == POPOpenAccountWindow)
        {
            [self addPOPOpenAccountWindow];
        }
        
        else if (type == POPOpenAccountPassWord)
        {
            [self addPOPOpenAccountPassWord];
        }
        else if (type == POPMessageWindow)
        {
            [self addPOPMessageWindow];
        }
        else if (type == POPRegisterVerifyPhoneNum)
        {
            [self addPOPRegisterVerifyPhoneNum];
        }
        else if (type == POPRegisterRenounce)
        {
            [self addPOPRegisterRenounce];
        }
        else if (type == POPRegisterSucceedRenounce)
        {
            [self addPOPRegisterSucceedRenounce];
        }
        else if (type == POPLoginVerifyPhoneNum)
        {
            [self addPOPLoginVerifyPhoneNum];
        }
        else if (type == POPOpenAccountRenounce)
        {
            [self addPOPOpenAccountRenounce];
        }
        else if (type == POPOpenAccountPassWordRenounce)
        {
            [self addPOPOpenAccountPassWordRenounce];
        }
        else if (type == POPOpenAccountRiskRenounce)
        {
            [self addPOPOpenAccountRiskRenounce];
        }
        else if (type == POPMessageIKnowWindow)
        {
            [self addPOPMessageIKnowWindow];
        }
        else if (type == POPLoginSucceedTouchID)
        {
            [self addPOPLoginSucceedTouchID];
        }
        else if (type == POPLoginSucceedFaceID)
        {
            [self addPOPLoginSucceedFaceID];
        }
        else if (type == POPLoginSucceedVerifyTouchID)
        {
            [self addPOPLoginSucceedVerifyTouchID];
        }
        else if (type == POPMessageIKnowWindowButton)
        {
            [self addPOPMessageIKnowWindowButton];
        }
        else if (type == POPMessageLoginOut)
        {
            [self addPOPMessageLoginOut];
        }
        else if (type == POPMessageLoginOutService)
        {
            [self addPOPMessageLoginOutService];
        }
        
        else if (type == POPMessageForcedUpdating)
        {
            [self addPOPMessageForcedUpdating];
        }
        else if (type == POPMessageNormalUpdating)
        {
            [self addPOPMessageNormalUpdating];
        }
        else if (type == POPMessageNormalEnter)
        {
            [self addPOPMessageNormalEnter];
        }
        
    }
    return self;
}

#pragma mark - add Gesture
- (void)addSingleGesture
{
//    self.rootLayout.userInteractionEnabled = YES;
    //单指单击
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTap.enabled = YES;
    //增加事件者响应者，
    [self.rootLayout addGestureRecognizer:singleTap];
}
#pragma mark 手指点击事件
- (void)singleTap:(UITapGestureRecognizer *)sender
{
    [self hideView];
//    if ([self.delegate respondsToSelector:@selector(popClickCloseBackgroundView)]) {
//        [self.delegate popClickCloseBackgroundView];
//    }
}
- (MyRelativeLayout *)bkLayout
{
    if (nil == _bkLayout) {
        _bkLayout = [MyRelativeLayout new];
        _bkLayout.backgroundColor = [Color color:PGColorOptionThemeWhite];
        _bkLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
        _bkLayout.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *sbv)
        { //viewLayoutCompleteBlock是在1.2.3中添加的新功能，目的是给完成了布局的子视图一个机会进行一些特殊的处理，viewLayoutCompleteBlock只会在子视图布局完成后调用一次.其中的sbv就是子视图自己，而layout则是父布局视图。因为这个block是完成布局后执行的。所以这时候子视图的frame值已经被计算出来，因此您可以在这里设置一些和frame关联的属性。
            //设置圆角的半径
            sbv.layer.cornerRadius = 10;
            //切割超出圆角范围的子视图
            sbv.layer.masksToBounds = YES;
        };
    }
    return _bkLayout;
}

- (UIImageView *)bkImageView
{
    if (nil == _bkImageView) {
        _bkImageView = [[UIImageView alloc] init];
        _bkImageView.backgroundColor = [UIColor whiteColor];
    }
    return  _bkImageView;
}

- (NZLabel *)titleLabel
{
    if (nil == _titleLabel) {
        _titleLabel = [NZLabel new];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [Color gc_Font:25.0];
        _titleLabel.textColor = [Color color:PGColorOptionTitleBlack];
//        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (NZLabel *)contentLabel
{
    if (nil == _contentLabel) {
        _contentLabel = [NZLabel new];
        _contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _contentLabel.numberOfLines = 0;
        _contentLabel.preferredMaxLayoutWidth = getWidth(310);
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.wrapContentHeight = YES;   //高度自动计算。
        _contentLabel.textColor = [Color color:PGColorOptionTitleBlack];
//        [_contentLabel setFontColor:[Color color:PGColorOptionCellContentBlue] string:@"《金融工场用户服务协议》"];
//        [_contentLabel sizeToFit];
//        __weak typeof(self) weakSelf = self;
//        [_registerAgreeLabel addLinkString:@"《金融工场用户服务协议》" block:^(ZBLinkLabelModel *linkModel) {
//            //注册协议 加载本地文件
//            UCFXieYiViewController *zhuCeXieYi = [[UCFXieYiViewController alloc] init];
//            zhuCeXieYi.titleName = @"金融工场用户服务协议";
//            NSString *path = [[NSBundle mainBundle] pathForResource:@"jrgcuserxieyi" ofType:@"docx"];
//            zhuCeXieYi.filePath = [NSURL fileURLWithPath:path];
//            [weakSelf.rt_navigationController pushViewController:zhuCeXieYi animated:YES];
//        }];
    }
    return _contentLabel;
}
- (UIButton*)enterButton
{
    
    if(nil == _enterButton)
    {
        _enterButton = [UIButton buttonWithType:0];
        _enterButton.titleLabel.font= [Color gc_Font:15.0];
        [_enterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_enterButton setBackgroundImage:[Image gradientImageWithBounds:CGRectMake(0, 0, PGScreenWidth - 50, 40) andColors:@[(id)UIColorWithRGB(0xFF4133),(id)UIColorWithRGB(0xFF7F40)] andGradientType:1] forState:UIControlStateNormal];
        _enterButton.tag = self.popViewTag;
        [_enterButton addTarget:self action:@selector(enterButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _enterButton.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *sbv)
        { //viewLayoutCompleteBlock是在1.2.3中添加的新功能，目的是给完成了布局的子视图一个机会进行一些特殊的处理，viewLayoutCompleteBlock只会在子视图布局完成后调用一次.其中的sbv就是子视图自己，而layout则是父布局视图。因为这个block是完成布局后执行的。所以这时候子视图的frame值已经被计算出来，因此您可以在这里设置一些和frame关联的属性。
            //设置圆角的半径
            sbv.layer.cornerRadius = 20;
            //切割超出圆角范围的子视图
            sbv.layer.masksToBounds = YES;
        };
    }
    return _enterButton;
}
- (UIButton*)cancelButton
{

    if(nil == _cancelButton)
    {
        _cancelButton = [UIButton buttonWithType:0];
        _cancelButton.topPos.equalTo(self.enterButton.bottomPos).offset(7);
//        _cancelButton.rightPos.equalTo(self.enterButton.rightPos);
//        _cancelButton.leftPos.equalTo(self.enterButton.leftPos);
        _cancelButton.myLeft = 0;
        _cancelButton.myRight = 0;
        _cancelButton.heightSize.equalTo(@40);
        _cancelButton.titleLabel.font= [Color gc_Font:15.0];
        [_cancelButton setTitleColor:[Color color:PGColorOptionCellContentBlue] forState:UIControlStateNormal];
        [_cancelButton setBackgroundColor:[Color color:PGColorOptionThemeWhite]];
        _cancelButton.tag = self.popViewTag;
        [_cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *sbv)
        { //viewLayoutCompleteBlock是在1.2.3中添加的新功能，目的是给完成了布局的子视图一个机会进行一些特殊的处理，viewLayoutCompleteBlock只会在子视图布局完成后调用一次.其中的sbv就是子视图自己，而layout则是父布局视图。因为这个block是完成布局后执行的。所以这时候子视图的frame值已经被计算出来，因此您可以在这里设置一些和frame关联的属性。
            //设置圆角的半径
            sbv.layer.cornerRadius = 20;
            //切割超出圆角范围的子视图
            sbv.layer.masksToBounds = YES;
        };
    }
    return _cancelButton;
}

#pragma mark-各种弹框类型
- (void)addPOPOpenAccountWindow
{
    [self.bkLayout addSubview:self.bkImageView];
    [self.bkLayout addSubview:self.contentLabel];
    [self.bkLayout addSubview:self.enterButton];
    
    self.bkLayout.myHeight = 347;
    self.bkLayout.myCenterX = 0;
    self.bkLayout.myCenterY = 0;
    self.bkLayout.myWidth = getWidth(310);
    
    self.bkImageView.myTop = 30;
    self.bkImageView.myWidth = 288;
    self.bkImageView.myHeight = 184;
    self.bkImageView.centerXPos.equalTo(self.bkLayout.centerXPos);
    self.bkImageView.image = [UIImage imageNamed:@"bg_huishang"];
    
    self.contentLabel.topPos.equalTo(self.bkImageView.bottomPos).offset(10);
    self.contentLabel.myLeft= 25;
    self.contentLabel.myRight= 25;
    self.contentLabel.font = [Color gc_Font:15.0];
    self.contentLabel.text = TextOpenAccountHint;
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentLabel sizeToFit];
    
    self.enterButton.myBottom = 25;
    self.enterButton.rightPos.equalTo(@25);
    self.enterButton.leftPos.equalTo(@25);
    self.enterButton.heightSize.equalTo(@40);
    [_enterButton setTitle:TextButtonOpenAccount forState:UIControlStateNormal];
    
    [self addSingleGesture];
}
- (void)addPOPOpenAccountPassWord
{
    [self.bkLayout addSubview:self.bkImageView];
    [self.bkLayout addSubview:self.contentLabel];
    [self.bkLayout addSubview:self.enterButton];
    
    self.bkLayout.myHeight = 347;
    self.bkLayout.myCenterX = 0;
    self.bkLayout.myCenterY = 0;
    self.bkLayout.myWidth = getWidth(310);
    
    self.bkImageView.myTop = 30;
    self.bkImageView.myWidth = 288;
    self.bkImageView.myHeight = 184;
    self.bkImageView.centerXPos.equalTo(self.bkLayout.centerXPos);
    self.bkImageView.image = [UIImage imageNamed:@"bg_huishang"];
    
    self.contentLabel.topPos.equalTo(self.bkImageView.bottomPos).offset(10);
    self.contentLabel.myLeft= 25;
    self.contentLabel.myRight= 25;
    self.contentLabel.font = [Color gc_Font:15.0];
    self.contentLabel.text = TextOpenAccountPassWordHint;
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentLabel sizeToFit];
    
    self.enterButton.myBottom = 25;
    self.enterButton.rightPos.equalTo(@25);
    self.enterButton.leftPos.equalTo(@25);
    self.enterButton.heightSize.equalTo(@40);
    [_enterButton setTitle:TextButtonOpenAccountPassWord forState:UIControlStateNormal];
    
    [self addSingleGesture];
}
- (void)addPOPMessageWindow
{
    [self.bkLayout addSubview:self.titleLabel];
    [self.bkLayout addSubview:self.contentLabel];
    [self.bkLayout addSubview:self.enterButton];
    
    self.bkLayout.myHeight = 347;
    self.bkLayout.myCenterX = 0;
    self.bkLayout.myCenterY = 0;
    self.bkLayout.myWidth = getWidth(310);
    
    self.bkImageView.myTop = 30;
    self.bkImageView.myWidth = 288;
    self.bkImageView.myHeight = 184;
    self.bkImageView.centerXPos.equalTo(self.bkLayout.centerXPos);
    self.bkImageView.image = [UIImage imageNamed:@"bg_huishang"];
    
    self.contentLabel.topPos.equalTo(self.bkImageView.bottomPos).offset(10);
    self.contentLabel.myLeft= 25;
    self.contentLabel.myRight= 25;
    self.contentLabel.text = TextOpenAccountHint;
    [self.contentLabel sizeToFit];
    
    self.enterButton.myBottom = 25;
    self.enterButton.rightPos.equalTo(@25);
    self.enterButton.leftPos.equalTo(@25);
    self.enterButton.heightSize.equalTo(@40);
    [_enterButton setTitle:TextButtonOpenAccount forState:UIControlStateNormal];
    
    [self addSingleGesture];
} 

- (void)addPOPRegisterVerifyPhoneNum
{
    [self.bkLayout addSubview:self.titleLabel];
    [self.bkLayout addSubview:self.contentLabel];
    [self.bkLayout addSubview:self.enterButton];
    
    self.bkLayout.myWidth = getWidth(310);
    self.bkLayout.myCenterX = 0;
    self.bkLayout.myCenterY = 0;
    
    self.titleLabel.myTop = 26;
    self.titleLabel.myLeft= 22;
    self.titleLabel.text = TextTitleHint;
    self.titleLabel.font = [Color gc_Font:25.0];
    [self.titleLabel sizeToFit];
    
    self.contentLabel.topPos.equalTo(self.titleLabel.bottomPos).offset(22);
    self.contentLabel.myLeft= 22;
    self.contentLabel.myRight= 22;
    self.contentLabel.font = [Color gc_Font:14.0];
    self.contentLabel.text = self.contentStr;
    [self.contentLabel sizeToFit];
    
    self.enterButton.myBottom = 25;
    self.enterButton.rightPos.equalTo(@25);
    self.enterButton.leftPos.equalTo(@25);
    self.enterButton.heightSize.equalTo(@40);
    [self.enterButton setTitle:TextButtonTitleLogin forState:UIControlStateNormal];
    
    [self addSingleGesture];
    
    self.bkLayout.myHeight = [self labelHeight:self.contentLabel withPopViewWidth:getWidth(310) - 22*2] + ContentButtonHeight;
}

- (void)addPOPRegisterRenounce
{
    [self.bkLayout addSubview:self.bkImageView];
    [self.bkLayout addSubview:self.titleLabel];
    [self.bkLayout addSubview:self.contentLabel];
    [self.bkLayout addSubview:self.enterButton];
    [self.bkLayout addSubview:self.cancelButton];
    
    self.bkLayout.myWidth = getWidth(310);
    self.bkLayout.myCenterX = 0;
    self.bkLayout.myCenterY = 0;
    self.bkLayout.myHeight = 393;
    
    self.bkImageView.myTop = 0;
    self.bkImageView.widthSize.equalTo(self.bkLayout.widthSize);
    self.bkImageView.myHeight = 188;
    self.bkImageView.centerXPos.equalTo(self.bkLayout.centerXPos);
    self.bkImageView.image = [UIImage imageNamed:@"bg_huishang"];

    self.titleLabel.topPos.equalTo(self.bkImageView.bottomPos).offset(16);
    self.titleLabel.centerXPos.equalTo(self.bkLayout.centerXPos);
    self.titleLabel.text = TextRegisterRenounceTitle;
    self.titleLabel.font = [Color gc_Font:18.0];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.titleLabel sizeToFit];
    
    self.contentLabel.topPos.equalTo(self.titleLabel.bottomPos).offset(8);
    self.contentLabel.centerXPos.equalTo(self.bkLayout.centerXPos);
    self.contentLabel.text = TextRegisterRenounceContent;
    self.contentLabel.font = [Color gc_Font:29.0];
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
    self.contentLabel.textColor = [Color color:PGColorOptionTitlerRead];
    [self.contentLabel sizeToFit];
    
    self.enterButton.topPos.equalTo(self.contentLabel.bottomPos).offset(14);
    self.enterButton.rightPos.equalTo(@20);
    self.enterButton.leftPos.equalTo(@20);
    self.enterButton.heightSize.equalTo(@40);
    [self.enterButton setTitle:TextButtonRegisterEnter forState:UIControlStateNormal];
    
    [self.cancelButton setTitle:TextButtonDontCancel forState:UIControlStateNormal];
    
    UIView *leftLineView = [UIView new];
    leftLineView.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
    leftLineView.myHeight = 1;
    leftLineView.myLeft = 47;
    leftLineView.rightPos.equalTo(self.titleLabel.leftPos).offset(5);
    leftLineView.centerYPos.equalTo(self.titleLabel.centerYPos);
    [self.bkLayout addSubview:leftLineView];
    
    UIView *rightLineView = [UIView new];
    rightLineView.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
    rightLineView.myHeight = 1;
    rightLineView.myRight = 47;
    rightLineView.leftPos.equalTo(self.titleLabel.rightPos).offset(5);
    rightLineView.centerYPos.equalTo(self.titleLabel.centerYPos);
    [self.bkLayout addSubview:rightLineView];
//    [self addSingleGesture];
}

- (void)addPOPRegisterSucceedRenounce
{
    [self.bkLayout addSubview:self.bkImageView];
    [self.bkLayout addSubview:self.contentLabel];
    [self.bkLayout addSubview:self.enterButton];
    [self.bkLayout addSubview:self.cancelButton];
    
    self.bkLayout.myWidth = getWidth(310);
    self.bkLayout.myCenterX = 0;
    self.bkLayout.myCenterY = 0;
    self.bkLayout.myHeight = 382;
    
    self.bkImageView.myTop = 30;
    self.bkImageView.myWidth = 288;
    self.bkImageView.myHeight = 184;
    self.bkImageView.centerXPos.equalTo(self.bkLayout.centerXPos);
    self.bkImageView.image = [UIImage imageNamed:@"bg_huishang"];
    
    self.contentLabel.topPos.equalTo(self.bkImageView.bottomPos).offset(10);
    self.contentLabel.centerXPos.equalTo(self.bkLayout.centerXPos);
    self.contentLabel.text = TextRegisterSucceedRenounceContent;
    self.contentLabel.font = [Color gc_Font:15.0];
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
    self.contentLabel.textColor = [Color color:PGColorOpttonPopcContentTextColor];
    [self.contentLabel sizeToFit];
    
    self.enterButton.topPos.equalTo(self.contentLabel.bottomPos).offset(15);
    self.enterButton.rightPos.equalTo(@20);
    self.enterButton.leftPos.equalTo(@20);
    self.enterButton.heightSize.equalTo(@40);
    [self.enterButton setTitle:TextButtonRegisterEnter forState:UIControlStateNormal];
    
    [self.cancelButton setTitle:TextButtonDontCancel forState:UIControlStateNormal];
    //    [self addSingleGesture];
}

- (void)addPOPLoginVerifyPhoneNum
{
    [self.bkLayout addSubview:self.titleLabel];
    [self.bkLayout addSubview:self.contentLabel];
    [self.bkLayout addSubview:self.enterButton];
     [self.bkLayout addSubview:self.cancelButton];
    
    self.bkLayout.myWidth = getWidth(310);
    self.bkLayout.myCenterX = 0;
    self.bkLayout.myCenterY = 0;
    
    self.titleLabel.myTop = 26;
    self.titleLabel.myLeft= 22;
    self.titleLabel.text = TextTitleHint;
    self.titleLabel.font = [Color gc_Font:25.0];
    [self.titleLabel sizeToFit];
    
    self.contentLabel.topPos.equalTo(self.titleLabel.bottomPos).offset(22);
    self.contentLabel.myLeft= 22;
    self.contentLabel.myRight= 22;
    self.contentLabel.text = self.contentStr;
    self.contentLabel.font = [Color gc_Font:14.0];
    [self.contentLabel sizeToFit];
    
    self.enterButton.topPos.equalTo(self.contentLabel.bottomPos).offset(22);
    self.enterButton.rightPos.equalTo(@25);
    self.enterButton.leftPos.equalTo(@25);
    self.enterButton.heightSize.equalTo(@40);
    [self.enterButton setTitle:TextButtonTitleLoginAgain forState:UIControlStateNormal];
    
    [self.cancelButton setTitle:TextButtonTitleLogin forState:UIControlStateNormal];
    
    [self addSingleGesture];
    ;
    self.bkLayout.myHeight = [self labelHeight:self.contentLabel withPopViewWidth:getWidth(310) - 22*2] + ContentBothButtonHeight;
//    self.contentLabel.myHeight = [self labelHeight:self.contentLabel withPopViewWidth:getWidth(310) - 22*2];
}

- (void)addPOPOpenAccountRenounce
{
    [self.bkLayout addSubview:self.bkImageView];
    [self.bkLayout addSubview:self.contentLabel];
    [self.bkLayout addSubview:self.enterButton];
    [self.bkLayout addSubview:self.cancelButton];
    
    self.bkLayout.myWidth = getWidth(310);
    self.bkLayout.myCenterX = 0;
    self.bkLayout.myCenterY = 0;
    self.bkLayout.myHeight = 382;
    
    self.bkImageView.myTop = 30;
    self.bkImageView.myWidth = 288;
    self.bkImageView.myHeight = 184;
    self.bkImageView.centerXPos.equalTo(self.bkLayout.centerXPos);
    self.bkImageView.image = [UIImage imageNamed:@"bg_huishang"];
    
    self.contentLabel.topPos.equalTo(self.bkImageView.bottomPos).offset(10);
    self.contentLabel.centerXPos.equalTo(self.bkLayout.centerXPos);
    self.contentLabel.text = TextRegisterSucceedRenounceContent;
    self.contentLabel.font = [Color gc_Font:15.0];
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
    self.contentLabel.textColor = [Color color:PGColorOptionTitleBlack];
    [self.contentLabel sizeToFit];
    
    self.enterButton.topPos.equalTo(self.contentLabel.bottomPos).offset(15);
    self.enterButton.rightPos.equalTo(@20);
    self.enterButton.leftPos.equalTo(@20);
    self.enterButton.heightSize.equalTo(@40);
    [self.enterButton setTitle:TextButtonOpenAccountAgain forState:UIControlStateNormal];
    
    [self.cancelButton setTitle:TextButtonDontCancel forState:UIControlStateNormal];
    //    [self addSingleGesture];
}

- (void)addPOPOpenAccountPassWordRenounce
{
    [self.bkLayout addSubview:self.bkImageView];
    [self.bkLayout addSubview:self.contentLabel];
    [self.bkLayout addSubview:self.enterButton];
    [self.bkLayout addSubview:self.cancelButton];
    
    self.bkLayout.myWidth = getWidth(310);
    self.bkLayout.myCenterX = 0;
    self.bkLayout.myCenterY = 0;
    self.bkLayout.myHeight = 382;
    
    self.bkImageView.myTop = 30;
    self.bkImageView.myWidth = 288;
    self.bkImageView.myHeight = 184;
    self.bkImageView.centerXPos.equalTo(self.bkLayout.centerXPos);
    self.bkImageView.image = [UIImage imageNamed:@"set_transaction_password"];
    
    self.contentLabel.topPos.equalTo(self.bkImageView.bottomPos).offset(10);
    self.contentLabel.centerXPos.equalTo(self.bkLayout.centerXPos);
    self.contentLabel.text = TextOpenAccountPassWordHint;
    self.contentLabel.font = [Color gc_Font:15.0];
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
    self.contentLabel.textColor = [Color color:PGColorOptionTitleBlack];
    [self.contentLabel sizeToFit];
    
    self.enterButton.topPos.equalTo(self.contentLabel.bottomPos).offset(15);
    self.enterButton.rightPos.equalTo(@20);
    self.enterButton.leftPos.equalTo(@20);
    self.enterButton.heightSize.equalTo(@40);
    [self.enterButton setTitle:TextButtonSettingPassWordEnter forState:UIControlStateNormal];
    
    [self.cancelButton setTitle:TextButtonDontCancel forState:UIControlStateNormal];
    //    [self addSingleGesture];
}

- (void)addPOPOpenAccountRiskRenounce
{
    [self.bkLayout addSubview:self.bkImageView];
    [self.bkLayout addSubview:self.contentLabel];
    [self.bkLayout addSubview:self.enterButton];
    [self.bkLayout addSubview:self.cancelButton];
    
    self.bkLayout.myWidth = getWidth(310);
    self.bkLayout.myCenterX = 0;
    self.bkLayout.myCenterY = 0;
    self.bkLayout.myHeight = 375;
    
    self.bkImageView.myTop = 30;
    self.bkImageView.myWidth = 288;
    self.bkImageView.myHeight = 184;
    self.bkImageView.centerXPos.equalTo(self.bkLayout.centerXPos);
    self.bkImageView.image = [UIImage imageNamed:@"risk_assessment"];
    
    self.contentLabel.topPos.equalTo(self.bkImageView.bottomPos).offset(10);
    self.contentLabel.centerXPos.equalTo(self.bkLayout.centerXPos);
    self.contentLabel.text = TextOpenAccountRiskHint;
    self.contentLabel.font = [Color gc_Font:15.0];
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
    self.contentLabel.textColor = [Color color:PGColorOptionTitleBlack];
    [self.contentLabel sizeToFit];
    
    self.enterButton.topPos.equalTo(self.contentLabel.bottomPos).offset(30);
    self.enterButton.rightPos.equalTo(@20);
    self.enterButton.leftPos.equalTo(@20);
    self.enterButton.heightSize.equalTo(@40);
    [self.enterButton setTitle:TextButtonRiskEnter forState:UIControlStateNormal];
    
    [self.cancelButton setTitle:TextButtonMomentCancel forState:UIControlStateNormal];
    //    [self addSingleGesture];
}

- (void)addPOPMessageIKnowWindow
{
    [self.bkLayout addSubview:self.titleLabel];
    [self.bkLayout addSubview:self.contentLabel];
    [self.bkLayout addSubview:self.enterButton];
    
    self.bkLayout.myWidth = getWidth(310);
    self.bkLayout.myCenterX = 0;
    self.bkLayout.myCenterY = 0;
    
    self.titleLabel.myTop = 26;
    self.titleLabel.myLeft= 22;
    self.titleLabel.text = TextTitleHint;
    self.titleLabel.font = [Color gc_Font:25.0];
    [self.titleLabel sizeToFit];
    
    self.contentLabel.topPos.equalTo(self.titleLabel.bottomPos).offset(22);
    self.contentLabel.myLeft= 22;
    self.contentLabel.myRight= 22;
    self.contentLabel.text = self.contentStr;
    self.contentLabel.font = [Color gc_Font:14.0];
    [self.contentLabel sizeToFit];
    
    self.enterButton.myBottom = 25;
    self.enterButton.rightPos.equalTo(@25);
    self.enterButton.leftPos.equalTo(@25);
    self.enterButton.heightSize.equalTo(@40);
    [self.enterButton setTitle:TextButtonIKnowEnter forState:UIControlStateNormal];
    
    [self addSingleGesture];
    
    self.bkLayout.myHeight = [self labelHeight:self.contentLabel withPopViewWidth:getWidth(310) - 22*2] + ContentButtonHeight;
}

- (void)addPOPLoginSucceedTouchID
{
    [self.bkLayout addSubview:self.titleLabel];
    [self.bkLayout addSubview:self.contentLabel];
    [self.bkLayout addSubview:self.enterButton];
    [self.bkLayout addSubview:self.cancelButton];
    
    self.bkLayout.myWidth = getWidth(310);
    self.bkLayout.myCenterX = 0;
    self.bkLayout.myCenterY = 0;
    
    self.titleLabel.myTop = 26;
    self.titleLabel.myLeft= 22;
    self.titleLabel.text = TextLoginSucceedGestureContent;
    self.titleLabel.font = [Color gc_Font:25.0];
    [self.titleLabel sizeToFit];
    
    self.contentLabel.topPos.equalTo(self.titleLabel.bottomPos).offset(22);
    self.contentLabel.myLeft= 22;
    self.contentLabel.myRight= 22;
    self.contentLabel.text = TextLoginSucceedTouchIDContent;
    self.contentLabel.font = [Color gc_Font:14.0];
    [self.contentLabel sizeToFit];
    
    self.enterButton.topPos.equalTo(self.contentLabel.bottomPos).offset(22);
    self.enterButton.rightPos.equalTo(@25);
    self.enterButton.leftPos.equalTo(@25);
    self.enterButton.heightSize.equalTo(@40);
    [self.enterButton setTitle:TextButtonStartEnter forState:UIControlStateNormal];
    
    [self.cancelButton setTitle:TextButtonCancelEnter forState:UIControlStateNormal];
    
    [self addSingleGesture];
    ;
    self.bkLayout.myHeight = [self labelHeight:self.contentLabel withPopViewWidth:getWidth(310) - 22*2] + ContentBothButtonHeight;
    //    self.contentLabel.myHeight = [self labelHeight:self.contentLabel withPopViewWidth:getWidth(310) - 22*2];
}

- (void)addPOPLoginSucceedFaceID
{
    [self.bkLayout addSubview:self.titleLabel];
    [self.bkLayout addSubview:self.contentLabel];
    [self.bkLayout addSubview:self.enterButton];
    [self.bkLayout addSubview:self.cancelButton];
    
    self.bkLayout.myWidth = getWidth(310);
    self.bkLayout.myCenterX = 0;
    self.bkLayout.myCenterY = 0;
    
    self.titleLabel.myTop = 26;
    self.titleLabel.myLeft= 22;
    self.titleLabel.text = TextLoginSucceedGestureContent;
    self.titleLabel.font = [Color gc_Font:25.0];
    [self.titleLabel sizeToFit];
    
    self.contentLabel.topPos.equalTo(self.titleLabel.bottomPos).offset(22);
    self.contentLabel.myLeft= 22;
    self.contentLabel.myRight= 22;
    self.contentLabel.text = TextLoginSucceedFaceIDContent;
    self.contentLabel.font = [Color gc_Font:14.0];
    [self.contentLabel sizeToFit];
    
    self.enterButton.topPos.equalTo(self.contentLabel.bottomPos).offset(22);
    self.enterButton.rightPos.equalTo(@25);
    self.enterButton.leftPos.equalTo(@25);
    self.enterButton.heightSize.equalTo(@40);
    [self.enterButton setTitle:TextButtonStartEnter forState:UIControlStateNormal];
    
    [self.cancelButton setTitle:TextButtonCancelEnter forState:UIControlStateNormal];
    
    [self addSingleGesture];
    ;
    self.bkLayout.myHeight = [self labelHeight:self.contentLabel withPopViewWidth:getWidth(310) - 22*2] + ContentBothButtonHeight;
    //    self.contentLabel.myHeight = [self labelHeight:self.contentLabel withPopViewWidth:getWidth(310) - 22*2];
}

- (void)addPOPLoginSucceedVerifyTouchID
{
    [self.bkLayout addSubview:self.bkImageView];
    [self.bkLayout addSubview:self.titleLabel];
    [self.bkLayout addSubview:self.contentLabel];
    [self.bkLayout addSubview:self.enterButton];
    [self.bkLayout addSubview:self.cancelButton];
    
    self.bkLayout.myWidth = getWidth(310);
    self.bkLayout.myHeight = 207;
    self.bkLayout.myCenterX = 0;
    self.bkLayout.myCenterY = 0;
    
    self.bkImageView.myTop = 30;
    self.bkImageView.myWidth = 45;
    self.bkImageView.myHeight = 45;
    self.bkImageView.centerXPos.equalTo(self.bkLayout.centerXPos);
    self.bkImageView.image = [UIImage imageNamed:@"bg_fingerprint"];
    
    self.titleLabel.topPos.equalTo(self.bkImageView.bottomPos).offset(13);
    self.titleLabel.myCenterX = 0;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = TextLoginSucceedVerifyTouchIDTitle;
    self.titleLabel.font = [Color gc_Font:25.0];
    [self.titleLabel sizeToFit];
    
    self.contentLabel.topPos.equalTo(self.titleLabel.bottomPos).offset(8);
    self.contentLabel.myLeft= 22;
    self.contentLabel.myRight= 22;
    self.contentLabel.text = TextLoginSucceedVerifyTouchIDContent;
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
    self.contentLabel.font = [Color gc_Font:14.0];
    [self.contentLabel sizeToFit];

    self.cancelButton.topPos.equalTo(self.contentLabel.bottomPos).offset(7);
    [self.cancelButton setTitle:TextButtonCancelEnter forState:UIControlStateNormal];
    
//    [self addSingleGesture];
}


- (void)addPOPMessageIKnowWindowButton
{
    [self.bkLayout addSubview:self.titleLabel];
    [self.bkLayout addSubview:self.contentLabel];
    [self.bkLayout addSubview:self.enterButton];
    
    self.bkLayout.myWidth = getWidth(310);
    self.bkLayout.myCenterX = 0;
    self.bkLayout.myCenterY = 0;
    
    self.titleLabel.myTop = 26;
    self.titleLabel.myLeft= 22;
    self.titleLabel.text = self.titleStr;
    self.titleLabel.font = [Color gc_Font:25.0];
    [self.titleLabel sizeToFit];
    
    self.contentLabel.topPos.equalTo(self.titleLabel.bottomPos).offset(22);
    self.contentLabel.myLeft= 22;
    self.contentLabel.myRight= 22;
    self.contentLabel.text = self.contentStr;
    self.contentLabel.font = [Color gc_Font:14.0];
    [self.contentLabel sizeToFit];
    
    self.enterButton.myBottom = 25;
    self.enterButton.rightPos.equalTo(@25);
    self.enterButton.leftPos.equalTo(@25);
    self.enterButton.heightSize.equalTo(@40);
    [self.enterButton setTitle:TextButtonIKnowEnter forState:UIControlStateNormal];
    
    [self addSingleGesture];
    
    self.bkLayout.myHeight = [self labelHeight:self.contentLabel withPopViewWidth:getWidth(310) - 22*2] + ContentButtonHeight;
}

- (void)addPOPMessageLoginOut
{
    [self.bkLayout addSubview:self.titleLabel];
    [self.bkLayout addSubview:self.contentLabel];
    [self.bkLayout addSubview:self.enterButton];
    [self.bkLayout addSubview:self.cancelButton];
    
    self.bkLayout.myWidth = getWidth(310);
    self.bkLayout.myCenterX = 0;
    self.bkLayout.myCenterY = 0;
    
    self.titleLabel.myTop = 26;
    self.titleLabel.myLeft= 22;
    self.titleLabel.text = TextTitleHint;
    self.titleLabel.font = [Color gc_Font:25.0];
    [self.titleLabel sizeToFit];
    
    self.contentLabel.topPos.equalTo(self.titleLabel.bottomPos).offset(22);
    self.contentLabel.myLeft= 22;
    self.contentLabel.myRight= 22;
    self.contentLabel.text = self.contentStr;
    self.contentLabel.font = [Color gc_Font:14.0];
    [self.contentLabel sizeToFit];
    
    self.enterButton.topPos.equalTo(self.contentLabel.bottomPos).offset(22);
    self.enterButton.rightPos.equalTo(@25);
    self.enterButton.leftPos.equalTo(@25);
    self.enterButton.heightSize.equalTo(@40);
    [self.enterButton setTitle:TextButtonAgainLogin forState:UIControlStateNormal];
    
    [self.cancelButton setTitle:TextButtonCancelEnter forState:UIControlStateNormal];
    
    self.bkLayout.myHeight = [self labelHeight:self.contentLabel withPopViewWidth:getWidth(310) - 22*2] + ContentBothButtonHeight;
}

- (void)addPOPMessageLoginOutService
{
    [self.bkLayout addSubview:self.titleLabel];
    [self.bkLayout addSubview:self.contentLabel];
    [self.bkLayout addSubview:self.enterButton];
    [self.bkLayout addSubview:self.cancelButton];
    
    self.bkLayout.myWidth = getWidth(310);
    self.bkLayout.myCenterX = 0;
    self.bkLayout.myCenterY = 0;
    
    self.titleLabel.myTop = 26;
    self.titleLabel.myLeft= 22;
    self.titleLabel.text = TextTitleHint;
    self.titleLabel.font = [Color gc_Font:25.0];
    [self.titleLabel sizeToFit];
    
    self.contentLabel.topPos.equalTo(self.titleLabel.bottomPos).offset(22);
    self.contentLabel.myLeft= 22;
    self.contentLabel.myRight= 22;
    self.contentLabel.text = self.contentStr;
    self.contentLabel.font = [Color gc_Font:14.0];
    [self.contentLabel sizeToFit];
    
    self.enterButton.topPos.equalTo(self.contentLabel.bottomPos).offset(22);
    self.enterButton.rightPos.equalTo(@25);
    self.enterButton.leftPos.equalTo(@25);
    self.enterButton.heightSize.equalTo(@40);
    [self.enterButton setTitle:TextButtonAgainLogin forState:UIControlStateNormal];
    
    [self.cancelButton setTitle:TextButtonContactService forState:UIControlStateNormal];
    
    self.bkLayout.myHeight = [self labelHeight:self.contentLabel withPopViewWidth:getWidth(310) - 22*2] + ContentBothButtonHeight;
}

- (void)addPOPMessageForcedUpdating
{
    [self.bkLayout addSubview:self.titleLabel];
    [self.bkLayout addSubview:self.contentLabel];
    [self.bkLayout addSubview:self.enterButton];
    
    self.bkLayout.myWidth = getWidth(310);
    self.bkLayout.myCenterX = 0;
    self.bkLayout.myCenterY = 0;
    
    self.titleLabel.myTop = 26;
    self.titleLabel.myLeft= 22;
    self.titleLabel.text = TextVersionUpdatingTitle;
    self.titleLabel.font = [Color gc_Font:25.0];
    [self.titleLabel sizeToFit];
    
    self.contentLabel.topPos.equalTo(self.titleLabel.bottomPos).offset(22);
    self.contentLabel.myLeft= 22;
    self.contentLabel.myRight= 22;
    self.contentLabel.text = self.contentStr;
    self.contentLabel.font = [Color gc_Font:14.0];
    [self.contentLabel sizeToFit];
    
    self.enterButton.myBottom = 25;
    self.enterButton.rightPos.equalTo(@25);
    self.enterButton.leftPos.equalTo(@25);
    self.enterButton.heightSize.equalTo(@40);
    [self.enterButton setTitle:TextButtonVersionEnter forState:UIControlStateNormal];
    
    self.bkLayout.myHeight = [self labelHeight:self.contentLabel withPopViewWidth:getWidth(310) - 22*2] + ContentButtonHeight;
}

- (void)addPOPMessageNormalUpdating
{
    [self.bkLayout addSubview:self.titleLabel];
    [self.bkLayout addSubview:self.contentLabel];
    [self.bkLayout addSubview:self.enterButton];
    [self.bkLayout addSubview:self.cancelButton];
    
    self.bkLayout.myWidth = getWidth(310);
    self.bkLayout.myCenterX = 0;
    self.bkLayout.myCenterY = 0;
    
    self.titleLabel.myTop = 26;
    self.titleLabel.myLeft= 22;
    self.titleLabel.text = TextVersionUpdatingTitle;
    self.titleLabel.font = [Color gc_Font:25.0];
    [self.titleLabel sizeToFit];
    
    self.contentLabel.topPos.equalTo(self.titleLabel.bottomPos).offset(22);
    self.contentLabel.myLeft= 22;
    self.contentLabel.myRight= 22;
    self.contentLabel.text = self.contentStr;
    self.contentLabel.font = [Color gc_Font:14.0];
    [self.contentLabel sizeToFit];
    
    self.enterButton.topPos.equalTo(self.contentLabel.bottomPos).offset(22);
    self.enterButton.rightPos.equalTo(@25);
    self.enterButton.leftPos.equalTo(@25);
    self.enterButton.heightSize.equalTo(@40);
    [self.enterButton setTitle:TextButtonVersionEnter forState:UIControlStateNormal];
    
    [self.cancelButton setTitle:TextButtonAgainCancel forState:UIControlStateNormal];
    
    self.bkLayout.myHeight = [self labelHeight:self.contentLabel withPopViewWidth:getWidth(310) - 22*2] + ContentBothButtonHeight;
}


- (void)addPOPMessageNormalEnter
{
    [self.bkLayout addSubview:self.titleLabel];
    [self.bkLayout addSubview:self.contentLabel];
    [self.bkLayout addSubview:self.enterButton];
    
    self.bkLayout.myWidth = getWidth(310);
    self.bkLayout.myCenterX = 0;
    self.bkLayout.myCenterY = 0;
    
    self.titleLabel.myTop = 26;
    self.titleLabel.myLeft= 22;
    self.titleLabel.text = TextTitleHint;
    self.titleLabel.font = [Color gc_Font:25.0];
    [self.titleLabel sizeToFit];
    
    self.contentLabel.topPos.equalTo(self.titleLabel.bottomPos).offset(22);
    self.contentLabel.myLeft= 22;
    self.contentLabel.myRight= 22;
    self.contentLabel.text = self.contentStr;
    self.contentLabel.font = [Color gc_Font:14.0];
    [self.contentLabel sizeToFit];
    
    self.enterButton.myBottom = 25;
    self.enterButton.rightPos.equalTo(@25);
    self.enterButton.leftPos.equalTo(@25);
    self.enterButton.heightSize.equalTo(@40);
    [self.enterButton setTitle:TextButtonTitleEnter forState:UIControlStateNormal];
    
//    [self addSingleGesture];
    
    self.bkLayout.myHeight = [self labelHeight:self.contentLabel withPopViewWidth:getWidth(310) - 22*2] + ContentButtonHeight;
}
- (CGFloat )labelHeight:(UILabel *)contentLabel withPopViewWidth:(CGFloat )popWidth
{
    // 设置文字属性 要和label的一致
    NSDictionary *attrs = @{NSFontAttributeName : contentLabel.font};
    CGSize maxSize = CGSizeMake(popWidth, MAXFLOAT);
    // 计算文字占据的高度
    CGSize size = [contentLabel.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    return size.height;
    
    
//    CGSize size = CGSizeMake(popWidth, 1000000000000.0);
//
//   NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:contentLabel.font,NSFontAttributeName ,nil];
//
//   size = [contentLabel.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;

}

//- (void)layoutSubviews {
//    // 确定子控件的frame（这里得到的self的frame/bounds才是准确的）
//    CGFloat width = self.bounds.size.width;
//    CGFloat height = self.bounds.size.height;
//    self.imageView.frame = CGRectMake(0, 0, width, width);
//    self.label.frame = CGRectMake(0, width, width, height - width);
//
//    // 一定要调用super的方法，并且放在后面比较好，不然iOS7可能会崩溃
//    [super layoutSubviews];
//}

@end

