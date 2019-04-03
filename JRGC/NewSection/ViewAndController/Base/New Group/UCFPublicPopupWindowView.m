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
static NSString *TextTitleHint = @"提示";
static NSString *TextButtonOpenAccount = @"立即开户";
static NSString *TextOpenAccountHint = @"您尚未开通\n徽商银行微金存管账户";
//static NSString *TextopenAccountFailure = @"您尚未开通\n徽商银行微金存管账户";

@interface UCFPublicPopupWindowView ()

@property (nonatomic, strong) MyRelativeLayout *bkLayout;

@property (nonatomic, strong) UIImageView *bkImageView;

@property (nonatomic, strong) NZLabel     *titleLabel;

@property (nonatomic, strong) NZLabel     *contentLabel;

@property (nonatomic, assign) POPWINDOWS type;

@property (nonatomic, copy)   NSString  *contentStr;

@end
@implementation UCFPublicPopupWindowView

- (id)initWithFrame:(CGRect)frame withType:(POPWINDOWS)type withContent:(NSString *__nonnull)contentStr
{
    self = [super initWithFrame:frame];
    if (self) {
       
        [self loadPopViewWithType:type withContent:contentStr];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame withType:(POPWINDOWS)type
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadPopViewWithType:type withContent:nil];
    }
    return self;
}
- (void)loadPopViewWithType:(POPWINDOWS)type withContent:(NSString *)contentStr
{
    //        self.userInteractionEnabled = NO;
    //        self.rootLayout.userInteractionEnabled = NO;
    self.type = type;
    if (!contentStr && contentStr.length >0 && [contentStr isKindOfClass:[NSString class]]) {
        self.contentStr = contentStr;
    }
    self.rootLayout.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    self.rootLayout.userInteractionEnabled = NO;
    [self.rootLayout addSubview:self.bkLayout];
    
    //         [self.bkLayout addSubview:self.cancelButton];
    if (type == POPOpenAccountWindow)
    {
        [self addPOPOpenAccountWindow];
    }
    else if (type == POPRegisterVerifyPhoneNum){
        
    }
}
#pragma mark - add Gesture
- (void)addSingleGesture
{
    self.rootLayout.userInteractionEnabled = YES;
    //单指单击
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTap.enabled = YES;
    //增加事件者响应者，
    [self.rootLayout addGestureRecognizer:singleTap];
}
#pragma mark 手指点击事件
- (void)singleTap:(UITapGestureRecognizer *)sender
{
//    [self hide];
    if ([self.delegate respondsToSelector:@selector(popClickCloseBackgroundView)]) {
        [self.delegate popClickCloseBackgroundView];
    }
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
        // linear.widthSize.equalTo(@(screenWidth)).multiply(0.24).min(90.0f);
        _titleLabel.topPos.equalTo(self.bkImageView.bottomPos).offset(10);
        _titleLabel.myLeft= 25;
        _titleLabel.myRight= 25;
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [Color gc_Font:15.0];
        _titleLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _titleLabel.userInteractionEnabled = YES;
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (NZLabel *)contentLabel
{
    if (nil == _contentLabel) {
        _contentLabel = [NZLabel new];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.font = [Color gc_Font:15.0];
        _contentLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _contentLabel.userInteractionEnabled = YES;
//        [_contentLabel setFontColor:[Color color:PGColorOptionCellContentBlue] string:@"《金融工场用户服务协议》"];
        [_contentLabel sizeToFit];
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
//        _cancelButton.topPos.equalTo(self.passWordLine.bottomPos).offset(25);
        _cancelButton.rightPos.equalTo(@25);
        _cancelButton.leftPos.equalTo(@25);
        _cancelButton.heightSize.equalTo(@40);
        [_cancelButton setTitle:@"登录" forState:UIControlStateNormal];
        _cancelButton.titleLabel.font= [Color gc_Font:15.0];
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelButton setBackgroundImage:[Image gradientImageWithBounds:CGRectMake(0, 0, PGScreenWidth - 50, 40) andColors:@[(id)UIColorWithRGB(0xFF4133),(id)UIColorWithRGB(0xFF7F40)] andGradientType:1] forState:UIControlStateNormal];
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

