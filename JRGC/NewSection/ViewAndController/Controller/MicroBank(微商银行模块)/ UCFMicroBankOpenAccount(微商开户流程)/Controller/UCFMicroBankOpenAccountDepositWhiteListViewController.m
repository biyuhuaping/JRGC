//
//  UCFMicroBankOpenAccountDepositWhiteListViewController.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/5.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFMicroBankOpenAccountDepositWhiteListViewController.h"
#import "BaseScrollview.h"
#import "UCFMicroBankOpenAccountDepositCellView.h"
#import "UCFMicroBankOpenAccountDepositSMSCodeCellView.h"
#import "UCFMicroBankOpenAccountDepositBankListCellView.h"
#import "UCFHuiShangChooseBankViewController.h"
#import "NZLabel.h"
#import "NSString+Misc.h"

#import "UCFMicroBankOpenAccountGetOpenAccountInfoAPI.h"
#import "UCFMicroBankOpenAccountGetOpenAccountInfoModel.h"
#import "UCFMicroBankOpenAccountZXGetOpenAccountInfoAPI.h"
#import "UCFMicroBankOpenAccountZXGetOpenAccountInfoModel.h"
#import "UCFMicroBankIdentifysendCodeInfoAPI.h"
#import "UCFMicroBankIdentifysendCodeInfoModel.h"
#import "UCFMicroBankOpenAccountViewController.h"

#import "FullWebViewController.h"
#import "AccountWebView.h"
#import "AccountSuccessVC.h"
#import "UCFMicroBankOpenAccountDepositWhiteListAndZXSucceedView.h"

@interface UCFMicroBankOpenAccountDepositWhiteListViewController ()<UIScrollViewDelegate,UITextFieldDelegate,UCFHuiShangChooseBankViewControllerDelegate>

@property (nonatomic, strong) MyRelativeLayout *rootLayout;

@property (nonatomic, strong) MyLinearLayout *scrollLayout;

@property (nonatomic, strong) BaseScrollview *scrollView;

@property (nonatomic, strong) UCFMicroBankOpenAccountDepositCellView *nameView; //姓名

@property (nonatomic, strong) UCFMicroBankOpenAccountDepositCellView *idView; //身份证

@property (nonatomic, strong) UCFMicroBankOpenAccountDepositBankListCellView *selectBankView;// 选择银行卡

@property (nonatomic, strong) UCFMicroBankOpenAccountDepositCellView *bankNumView; //输入银行卡号

@property (nonatomic, strong) UIButton *enterButton; //确认按钮

@property (nonatomic, strong) UCFMicroBankOpenAccountDepositSMSCodeCellView *smsView;//获取短信验证码

@property (nonatomic, strong) NZLabel *smsLabel; //短信验证码

@property (nonatomic, strong) NZLabel *agreementLabel; //协议

@property (nonatomic, strong) UCFMicroBankOpenAccountGetOpenAccountInfoModel *GetOpenAccountModel;

@property (nonatomic, copy)   NSString *bankId;

@end

@implementation UCFMicroBankOpenAccountDepositWhiteListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    baseTitleLabel.text = @"开通微金徽商存管账户";
    
    self.rootLayout = [MyRelativeLayout new];
    self.rootLayout.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
    self.rootLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
    self.view = self.rootLayout;
    [self.rootLayout addSubview: self.scrollView];
    [self.scrollView addSubview:self.scrollLayout];
    
    [self loadLayoutView];
    
}
- (void)loadLayoutView
{
    [self.scrollLayout addSubview:self.nameView];
    [self.scrollLayout addSubview:self.idView];
    [self.scrollLayout addSubview:self.selectBankView];
    [self.scrollLayout addSubview:self.bankNumView];
    [self.scrollLayout addSubview:self.smsView];
    [self.scrollLayout addSubview:self.enterButton];
    [self.scrollLayout addSubview:self.agreementLabel];
    [self.scrollLayout addSubview:self.smsLabel];
    
    [self queryUserData];
    //    用户P2P开户状态 1：未开户 2：已开户 3：已绑卡 4：已设交易密码 5：特殊用户
    //    if ([SingleUserInfo.loginData.userInfo.openStatus integerValue] == 1) {
    //        //正常的新用户
    //        self.enterButton.topPos.equalTo(self.selectBankView.bottomPos).offset(20);
    //    }
    //    else if ([SingleUserInfo.loginData.userInfo.openStatus integerValue] == 2){
    //        //只有老的白名单用户存在已开户未绑卡状态,所以需要在这个开户页面去绑定银行卡
    //        [self.scrollLayout addSubview:self.BankNumView];
    //    }
    //    else
    //    {
    //        //未知状态
    //    }
    
    
    
}
- (BaseScrollview *)scrollView
{
    if (nil == _scrollView) {
        _scrollView = [BaseScrollview new];
        _scrollView.delegate = self;
        _scrollView.scrollEnabled = NO;
        _scrollView.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
        _scrollView.leftPos.equalTo(@0);
        _scrollView.rightPos.equalTo(@0);
        _scrollView.topPos.equalTo(@10);
        _scrollView.bottomPos.equalTo(@0);
    }
    return _scrollView;
}

- (MyLinearLayout *)scrollLayout
{
    if (nil == _scrollLayout) {
        _scrollLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
        _scrollLayout.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
        _scrollLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
        _scrollLayout.myHorzMargin = 0;                          //同时指定左右边距为0表示宽度和父视图一样宽
        _scrollLayout.heightSize.lBound(self.scrollView.heightSize, 10, 1); //高度虽然是wrapContentHeight的。但是最小的高度不能低于父视图的高度加10.
        
    }
    return _scrollLayout;
}

- (UCFMicroBankOpenAccountDepositCellView *)nameView
{
    if (nil == _nameView) {
        _nameView = [[UCFMicroBankOpenAccountDepositCellView alloc] initWithFrame:CGRectMake(0, 0, PGScreenWidth, 50)];
        _nameView.myTop = 0;
        _nameView.myLeft = 0;
        _nameView.titleImageView.image = [UIImage imageNamed:@"list_icon_name"];
        _nameView.contentField.delegate = self;
        _nameView.contentField.placeholder = @"请输入真实姓名";
        [_nameView.contentField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _nameView;
}

- (UCFMicroBankOpenAccountDepositCellView *)idView
{
    if (nil == _idView) {
        _idView = [[UCFMicroBankOpenAccountDepositCellView alloc] initWithFrame:CGRectMake(0, 0, PGScreenWidth, 50)];
        _idView.topPos.equalTo(self.nameView.bottomPos);
        _idView.myLeft = 0;
        _idView.titleImageView.image = [UIImage imageNamed:@"list_icon_id"];
        _idView.contentField.delegate = self;
        _idView.contentField.placeholder = @"请输入身份证号";
        [_idView.contentField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _idView;
}

- (UCFMicroBankOpenAccountDepositCellView *)bankNumView
{
    if (nil == _bankNumView) {
        _bankNumView = [[UCFMicroBankOpenAccountDepositCellView alloc] initWithFrame:CGRectMake(0, 0, PGScreenWidth, 50)];
        _bankNumView.topPos.equalTo(self.selectBankView.bottomPos);
        _bankNumView.myLeft = 0;
        _bankNumView.titleImageView.image = [UIImage imageNamed:@"bank_card_icon"];
        _bankNumView.contentField.delegate = self;
        _bankNumView.contentField.placeholder = @"请输入银行卡号";
        [_bankNumView.contentField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _bankNumView;
}

- (UCFMicroBankOpenAccountDepositSMSCodeCellView *)smsView
{
    if (nil == _smsView) {
        _smsView = [[UCFMicroBankOpenAccountDepositSMSCodeCellView alloc] initWithFrame:CGRectMake(0, 0, PGScreenWidth, 50)];
        _smsView.topPos.equalTo(self.bankNumView.bottomPos);
        _smsView.myLeft = 0;
        _smsView.contentField.delegate = self;
        @PGWeakObj(self);
        _smsView.backBlock = ^(void) {
            [selfWeak statVerifyCodeRequest:@"SMS"];
        };
        [_smsView.contentField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _smsView;
}

- (void)textFieldEditChanged:(UITextField *)textField
{
    [self inspectTextField];
}
- (UCFMicroBankOpenAccountDepositBankListCellView *)selectBankView
{
    if (nil == _selectBankView) {
        _selectBankView = [[UCFMicroBankOpenAccountDepositBankListCellView alloc] initWithFrame:CGRectMake(0, 0, PGScreenWidth, 50)];
        _selectBankView.topPos.equalTo(self.selectBankView.bottomPos);
        _selectBankView.myLeft = 0;
        _selectBankView.titleImageView.image = [UIImage imageNamed:@"list_icon_bank"];
        _selectBankView.tag = 1001;
        _selectBankView.itemLineView.hidden = NO;
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushBankListViewController)];
        [_selectBankView addGestureRecognizer:tapGesturRecognizer];
    }
    return _selectBankView;
}

- (void)pushBankListViewController
{
    UCFHuiShangChooseBankViewController *vc = [[UCFHuiShangChooseBankViewController alloc] initWithNibName:@"UCFHuiShangChooseBankViewController" bundle:nil];
    vc.bankDelegate = self;
    //        vc.site = _site;
    vc.accoutType = self.accoutType;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)chooseBankData:(NSDictionary *)data {
    //开户行名称
    self.bankId = data[@"bankName"];
    self.selectBankView.oaContentLabel.text = data[@"bankName"];
    [self.selectBankView sizeToFit];
    //银行logo
    NSURL *url = [NSURL URLWithString:data[@"logoUrl"]];
    [self.selectBankView.bankImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"bank_default"]];
    
    //开户行id
    //    _bankId = [NSString stringWithFormat:@"%@",data[@"bankId"]];
    
    //是否支持快捷支付
    //    _isQuick = [data[@"isQuick"]boolValue];
    
}
- (UIButton*)enterButton
{
    
    if(nil == _enterButton)
    {
        _enterButton = [UIButton buttonWithType:0];
        _enterButton.topPos.equalTo(self.smsView.bottomPos).offset(20);
        _enterButton.rightPos.equalTo(@25);
        _enterButton.leftPos.equalTo(@25);
        _enterButton.heightSize.equalTo(@40);
        [_enterButton setTitle:@"立即开通" forState:UIControlStateNormal];
        _enterButton.titleLabel.font= [Color gc_Font:15.0];
        [_enterButton setBackgroundImage:[Image createImageWithColor:[Color color:PGColorOptionButtonBackgroundColorGray] withCGRect:CGRectMake(0, 0, PGScreenWidth - 50, 40)] forState:UIControlStateNormal];
        _enterButton.userInteractionEnabled = NO;
        [_enterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_enterButton addTarget:self action:@selector(enterButtoClick) forControlEvents:UIControlEventTouchUpInside];
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

- (void)enterButtoClick
{
    UCFMicroBankOpenAccountZXGetOpenAccountInfoAPI * request = [[UCFMicroBankOpenAccountZXGetOpenAccountInfoAPI alloc] initWithRealName:self.nameView.contentField.text idCardNo:self.idView.contentField.text bankCardNo:self.bankNumView.contentField.text bankNo:self.bankId openStatus:self.GetOpenAccountModel.data.openStatus validateCode:self.smsView.contentField.text AccoutType:SelectAccoutTypeP2P];
    request.animatingView = self.view;
    //    request.tag =tag;
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        // 你可以直接在这里使用 self
        DDLogDebug(@"---------%@",request.responseJSONModel);
        UCFMicroBankOpenAccountZXGetOpenAccountInfoModel *model = [request.responseJSONModel copy];
        if (model.ret == YES)
        {
            SingleUserInfo.loginData.userInfo.openStatus = @"3";
            SingleUserInfo.loginData.userInfo.realName = self.nameView.contentField.text;
            [SingleUserInfo setUserData:SingleUserInfo.loginData];
            
            //提交信息成功之后，显示开户成功页面
            [self.view endEditing:YES];
            
            CGFloat viewHeight = PGStatusBarHeight + self.navigationController.navigationBar.frame.size.height+60;
            UCFMicroBankOpenAccountDepositWhiteListAndZXSucceedView *wzSucceedView = [[UCFMicroBankOpenAccountDepositWhiteListAndZXSucceedView alloc] initWithFrame:CGRectMake(0, 0, PGScreenWidth, PGScreenHeight - viewHeight)];
            wzSucceedView.useFrame = YES;
            wzSucceedView.myTop = 0;
            wzSucceedView.myLeft = 0;
            [wzSucceedView setUserSelectAccoutType:SelectAccoutTypeP2P];
            [wzSucceedView.settingTransactionPasswordButton addTarget:self action:@selector(changeTransactionPassword) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollLayout addSubview:wzSucceedView];
            
        }
        else
        {
            ShowMessage(model.message);
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        // 你可以直接在这里使用 self

    }];
}
- (void)changeTransactionPassword
{
    for (UCFMicroBankOpenAccountViewController *vc in self.rt_navigationController.rt_viewControllers) {
        if ([vc isKindOfClass:[UCFMicroBankOpenAccountViewController class]]) {
            vc.openAccountSucceed = YES;
        }
    }
}
- (NZLabel *)agreementLabel
{
    if (nil == _agreementLabel) {
        _agreementLabel = [NZLabel new];
        _agreementLabel.centerXPos.equalTo(self.enterButton.centerXPos);
        _agreementLabel.myWidth = PGScreenWidth - 50;
        _agreementLabel.topPos.equalTo(self.enterButton.bottomPos).offset(15);
        _agreementLabel.textAlignment = NSTextAlignmentLeft;
        _agreementLabel.font = [Color gc_Font:13.0];
        _agreementLabel.textColor = [Color color:PGColorOptionTitleGray];
        //自动折行设置
        _agreementLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _agreementLabel.numberOfLines = 0;
        _agreementLabel.userInteractionEnabled = YES;
        
    }
    return _agreementLabel;
}
- (NZLabel *)smsLabel
{
    if (nil == _smsLabel) {
        _smsLabel = [NZLabel new];
        _smsLabel.centerXPos.equalTo(self.agreementLabel.centerXPos);
        _smsLabel.myWidth = PGScreenWidth - 50;
        _smsLabel.topPos.equalTo(self.agreementLabel.bottomPos).offset(2);
        _smsLabel.textAlignment = NSTextAlignmentLeft;
        _smsLabel.font = [Color gc_Font:13.0];
        _smsLabel.textColor = [Color color:PGColorOptionTitleGray];
        //自动折行设置
        _smsLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _smsLabel.numberOfLines = 0;
        _smsLabel.userInteractionEnabled = YES;
        
    }
    return _smsLabel;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //身份证号
    if (textField == self.idView.contentField)
    {
        if (textField.text.length >= 18 && ![string isEqualToString:@""]) {
            if (range.location == 17 && range.length == 1) {
                return YES;
            }
            return NO;
        }
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789xX\b"];
        if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
            return NO;
        }
        return YES;
    }
    else if (textField == self.bankNumView.contentField)
    {
        // 4位分隔银行卡卡号
        NSString *text = [textField text];
        
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
            return NO;
        }
        
        text = [text stringByReplacingCharactersInRange:range withString:string];
        text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        NSString *newString = @"";
        while (text.length > 0) {
            NSString *subString = [text substringToIndex:MIN(text.length, 4)];
            newString = [newString stringByAppendingString:subString];
            if (subString.length == 4) {
                newString = [newString stringByAppendingString:@" "];
            }
            text = [text substringFromIndex:MIN(text.length, 4)];
        }
        
        newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
        
        if ([newString stringByReplacingOccurrencesOfString:@" " withString:@""].length >= 20) {
            return NO;
        }
        
        [textField setText:newString];
        return NO;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.nameView.contentField && [self.nameView.contentField.text isEqualToString:@""] ) {//&& ![Common isChinese:_textField1.text]
        [AuxiliaryFunc showToastMessage:@"请输入正确的姓名" withView:self.view];
        return;
    }else if (textField == self.idView.contentField && ![Common isIdentityCard:self.idView.contentField.text]){
        [AuxiliaryFunc showToastMessage:@"请输入正确的身份证号码" withView:self.view];
        return;
    }
    else if (textField == self.bankNumView.contentField && ![Common isValidCardNumber:self.bankNumView.contentField.text]){
        [AuxiliaryFunc showToastMessage:@"请输入正确的银行卡号" withView:self.view];
        return;
    }
    else if (textField == self.smsView.contentField && [self.smsView.contentField.text isEqualToString:@""]){
        [AuxiliaryFunc showToastMessage:@"请输入正确的短信验证码" withView:self.view];
        return;
    }

    
}

- (void)inspectTextField
{
    if ([self inspectNameViewInPut] && [self inspectIdViewInPut] && [self inspectSelectBankView] && [self inspectSmsView] && [self inspectSelectBankView]) {
        //输入正常,按钮可点击
        self.enterButton.userInteractionEnabled = YES;
        [self.enterButton setBackgroundImage:[Image gradientImageWithBounds:CGRectMake(0, 0, PGScreenWidth - 50, 40) andColors:@[(id)UIColorWithRGB(0xFF4133),(id)UIColorWithRGB(0xFF7F40)] andGradientType:1] forState:UIControlStateNormal];
    }
    else
    {
        //输入非正常,按钮不可点击
        [self.enterButton setBackgroundImage:[Image createImageWithColor:[Color color:PGColorOptionButtonBackgroundColorGray] withCGRect:CGRectMake(0, 0, PGScreenWidth - 50, 40)] forState:UIControlStateNormal];
        self.enterButton.userInteractionEnabled = NO;
    }
}
- (BOOL)inspectNameViewInPut
{
    if (![self.nameView.contentField.text isEqualToString:@""] && self.nameView.contentField.text.length > 0) {
        return YES;
    }
    else
    {
        return NO;
    }
}
- (BOOL)inspectIdViewInPut
{
    if (![self.idView.contentField.text isEqualToString:@""] && [Common isIdentityCard:self.idView.contentField.text]) {
        return YES;
    }
    else
    {
        return NO;
    }
}
- (BOOL)inspectSelectBankView
{
    if (self.selectBankView.oaContentLabel.text.length >0 && ![self.selectBankView.oaContentLabel.text isEqualToString:@""] && ![self.bankId isEqualToString:@""]) {
        return YES;
    }
    else
    {
        return NO;
    }
}
- (BOOL)inspectBankNumView
{
    if (self.bankNumView.contentField.text.length >0 && ![self.bankNumView.contentField.text isEqualToString:@""] && [Common isValidCardNumber:self.bankNumView.contentField.text]) {
        return YES;
    }
    else
    {
        return NO;
    }
}
- (BOOL)inspectSmsView
{
    if (self.smsView.contentField.text.length >0 && ![self.smsView.contentField.text isEqualToString:@""] ) {
        return YES;
    }
    else
    {
        return NO;
    }
}
- (void)queryUserData
{
    UCFMicroBankOpenAccountGetOpenAccountInfoAPI * request = [[UCFMicroBankOpenAccountGetOpenAccountInfoAPI alloc] initWithAccoutType:SelectAccoutTypeP2P];
    request.animatingView = self.view;
    //    request.tag =tag;
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        // 你可以直接在这里使用 self
        DDLogDebug(@"---------%@",request.responseJSONModel);
        self.GetOpenAccountModel = [request.responseJSONModel copy];
        if (self.GetOpenAccountModel.ret == YES)
        {
            //获取徽商开户页面信息
            
            //设置用户协议
            if(![self.GetOpenAccountModel.data.cfcaContractName isEqualToString:@""])
//            if([self.GetOpenAccountModel.data.cfcaContractName isEqualToString:@""])
            {
                self.agreementLabel.text = @"开通即视为本人已阅读并同意《CFCA数字证书服务协议》";
                [self.agreementLabel sizeToFit];
                __weak typeof(self) weakSelf = self;
                [self.agreementLabel setFontColor:UIColorWithRGB(0x4aa1f9) string:@"《CFCA数字证书服务协议》"];
                [self.agreementLabel addLinkString:@"《CFCA数字证书服务协议》" block:^(ZBLinkLabelModel *linkModel) {
                    FullWebViewController *webController = [[FullWebViewController alloc] initWithWebUrl:weakSelf.GetOpenAccountModel.data.cfcaContractUrl title:@"CFCA数字证书服务协议"];
                    webController.baseTitleType = @"specialUser";
                    [weakSelf.rt_navigationController pushViewController:webController animated:YES];
                }];
            }
            SingleUserInfo.loginData.userInfo.openStatus = self.GetOpenAccountModel.data.openStatus;
            //            _nameView.contentField.enabled=NO;
            if (self.GetOpenAccountModel.data.userInfo.realName.length > 0)
            {
                //                用户P2P开户状态 1：未开户 2：已开户 3：已绑卡 4：已设交易密码 5：特殊用户
                self.nameView.contentField.text = self.GetOpenAccountModel.data.userInfo.realName;
                SingleUserInfo.loginData.userInfo.realName = self.GetOpenAccountModel.data.userInfo.realName;
            }
            if (self.GetOpenAccountModel.data.userInfo.idCardNo.length > 0)
            {
                //                NSString *asteriskIdCardNo = [NSString replaceStringWithAsterisk:self.GetOpenAccountModel.data.userInfo.idCardNo startLocation:3 lenght:self.GetOpenAccountModel.data.userInfo.idCardNo.length -7];
                //                self.idView.contentField.text   = asteriskIdCardNo;
                self.idView.contentField.text   = self.GetOpenAccountModel.data.userInfo.idCardNo;
            }
            if (self.GetOpenAccountModel.data.userInfo.bankCard.length > 0) {
                //将银行卡（textField3）要显示的文字四位分隔
                self.bankNumView.contentField.text  = [NSString bankIdSeparate:self.GetOpenAccountModel.data.userInfo.bankCard];
            }
            
            //银行logo
            if (self.GetOpenAccountModel.data.userInfo.bankName.length > 0)
            {//如果有银行名称，就显示名称，否则显示“请选择”
                self.selectBankView.oaContentLabel.text = self.GetOpenAccountModel.data.userInfo.bankName;
                
            }
            
            if (self.GetOpenAccountModel.data.userInfo.bankLogo.length > 0) {
                [self.selectBankView.bankImageView sd_setImageWithURL:[NSURL URLWithString:self.GetOpenAccountModel.data.userInfo.bankLogo] placeholderImage:[UIImage imageNamed:@"bank_default"]];
            }
            if (self.GetOpenAccountModel.data.userInfo.bankId.length > 0) {
                self.bankId = self.GetOpenAccountModel.data.userInfo.bankId;
            }
            
            
            if (self.GetOpenAccountModel.data.userInfo.notSupportDes.length > 0)
            {
                BlockUIAlertView *alert = [[BlockUIAlertView alloc]initWithTitle:@"提示" message:self.GetOpenAccountModel.data.userInfo.notSupportDes cancelButtonTitle:nil clickButton:^(NSInteger index) {} otherButtonTitles:@"确定"];
                [alert show];
            }
            [SingleUserInfo setUserData:SingleUserInfo.loginData];
            [self inspectTextField];//查询是否全部都已经填写
        }
        else
        {
            ShowMessage(self.GetOpenAccountModel.message);
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        // 你可以直接在这里使用 self
        
    }];
}
- (void)statVerifyCodeRequest:(NSString *)isVms
{
    NSString *isVmsNew = isVms;//SMS："普通短信渠道"；VMS："验证码语音渠道"
    UCFMicroBankIdentifysendCodeInfoAPI * request = [[UCFMicroBankIdentifysendCodeInfoAPI alloc] initWithDestPhoneNo:self.GetOpenAccountModel.data.userInfo.phoneNum isVms:isVmsNew type:@"6" AccoutType:SelectAccoutTypeP2P];
    request.animatingView = self.view;
    //    request.tag =tag;
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        // 你可以直接在这里使用 self
        DDLogDebug(@"---------%@",request.responseJSONModel);
        UCFMicroBankIdentifysendCodeInfoModel *model = [request.responseJSONModel copy];
        if (model.ret == YES)
        {
            [self.smsView.verifyCodeButton startCountDown];
            __weak typeof(self) weakSelf = self;
            
            NSString *replaceStr = [NSString replaceStringWithAsterisk:self.GetOpenAccountModel.data.userInfo.phoneNum startLocation:3 lenght:self.GetOpenAccountModel.data.userInfo.phoneNum.length -7];
            self.smsLabel.text = [NSString stringWithFormat:@"已向手机%@发送短信验证码，若收不到，请点击这里获取语音验证码。",replaceStr];
            [self.smsLabel sizeToFit];
            [self.smsLabel setFontColor:UIColorWithRGB(0x4aa1f9) string:@"点击这里"];
            [self.smsLabel addLinkString:@"点击这里" block:^(ZBLinkLabelModel *linkModel) {
                if (![weakSelf.smsView.verifyCodeButton getIsCountDown]) {
                    [weakSelf statVerifyCodeRequest:@"VMS"];
                }
                
            }];
            if ([isVmsNew isEqualToString:@"VMS"]) {
                [AuxiliaryFunc showToastMessage:@"系统正在准备外呼，请保持手机信号畅通" withView:self.view];
            }
        }
        else
        {
            ShowMessage(model.message);
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        // 你可以直接在这里使用 self
        
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}
@end
