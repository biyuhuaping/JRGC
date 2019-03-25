//
//  UCFMicroBankNewOpenAccountDepositViewController.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/20.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFMicroBankNewOpenAccountDepositViewController.h"
#import "BaseScrollview.h"
#import "NZLabel.h"
#import "NSString+Misc.h"
#import "UCFMicroBankOpenAccountDepositCellView.h"
#import "UCFMicroBankOpenAccountDepositBankListCellView.h"
#import "UCFHuiShangChooseBankViewController.h"
#import "UCFMicroBankOpenAccountGetOpenAccountInfoAPI.h"
#import "UCFMicroBankOpenAccountGetOpenAccountInfoModel.h"
#import "FullWebViewController.h"
#import "AccountWebView.h"

@interface UCFMicroBankNewOpenAccountDepositViewController ()<UIScrollViewDelegate,UITextFieldDelegate,UCFHuiShangChooseBankViewControllerDelegate>

@property (nonatomic, strong) MyRelativeLayout *rootLayout;

@property (nonatomic, strong) MyLinearLayout *scrollLayout;

@property (nonatomic, strong) BaseScrollview *scrollView;

@property (nonatomic, strong) UCFMicroBankOpenAccountDepositCellView *nameView; //姓名

@property (nonatomic, strong) UCFMicroBankOpenAccountDepositCellView *phoneView; //身份证

@property (nonatomic, strong) UCFMicroBankOpenAccountDepositBankListCellView *selectBankView;// 选择银行卡

@property (nonatomic, strong) UIButton *enterButton; //确认按钮

@property (nonatomic, strong) NZLabel *agreementLabel; //协议

@property (nonatomic, strong) NZLabel *attentionsLabel; //协议

@property (nonatomic, copy)   NSString *bankId;

@property (nonatomic, strong) UCFMicroBankOpenAccountGetOpenAccountInfoModel *GetOpenAccountModel;
@end

@implementation UCFMicroBankNewOpenAccountDepositViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.rootLayout = [MyRelativeLayout new];
    self.rootLayout.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
    self.rootLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
    self.view = self.rootLayout;
    [self.rootLayout addSubview: self.scrollView];
    [self.scrollView addSubview:self.scrollLayout];
    [self loadLayoutView];
    [self queryUserData];
}
- (void)loadLayoutView{
    [self.scrollLayout addSubview:self.nameView];
    [self.scrollLayout addSubview:self.selectBankView];
    [self.scrollLayout addSubview:self.phoneView];
    [self.scrollLayout addSubview:self.attentionsLabel];
    [self.scrollLayout addSubview:self.enterButton];
    [self.scrollLayout addSubview:self.agreementLabel];
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
- (UCFMicroBankOpenAccountDepositBankListCellView *)selectBankView
{
    if (nil == _selectBankView) {
        _selectBankView = [[UCFMicroBankOpenAccountDepositBankListCellView alloc] initWithFrame:CGRectMake(0, 0, PGScreenWidth, 50)];
        _selectBankView.topPos.equalTo(self.nameView.bottomPos);
        _selectBankView.myLeft = 0;
        _selectBankView.titleImageView.image = [UIImage imageNamed:@"list_icon_bank"];
        _selectBankView.tag = 1001;
        _selectBankView.itemLineView.hidden = NO;
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushBankListViewController)];
        [_selectBankView addGestureRecognizer:tapGesturRecognizer];
    }
    return _selectBankView;
}
- (UCFMicroBankOpenAccountDepositCellView *)phoneView
{
    if (nil == _phoneView) {
        _phoneView = [[UCFMicroBankOpenAccountDepositCellView alloc] initWithFrame:CGRectMake(0, 0, PGScreenWidth, 50)];
        _phoneView.topPos.equalTo(self.selectBankView.bottomPos);
        _phoneView.myLeft = 0;
        _phoneView.titleImageView.image = [UIImage imageNamed:@"list_icon_phone"];
        _phoneView.contentField.delegate = self;
        _phoneView.contentField.placeholder = @"请输入手机号码";
//        _phoneView.contentField.enabled = NO;
        _phoneView.itemLineView.hidden = YES;
        [_phoneView.contentField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _phoneView;
}
- (NZLabel *)attentionsLabel
{
    if (nil == _attentionsLabel) {
        _attentionsLabel = [NZLabel new];
        _attentionsLabel.myLeft = 15;
        _attentionsLabel.topPos.equalTo(self.phoneView.bottomPos).offset(15);
        _attentionsLabel.textAlignment = NSTextAlignmentLeft;
        _attentionsLabel.font = [Color gc_Font:13.0];
        _attentionsLabel.textColor = [Color color:PGColorOptionTitleGray];
        _attentionsLabel.text = @"手机号需与所绑银行卡预留手机号一致";
        [_attentionsLabel sizeToFit];
    }
    return _attentionsLabel;
}
- (UIButton*)enterButton
{
    if(nil == _enterButton)
    {
        _enterButton = [UIButton buttonWithType:0];
        _enterButton.topPos.equalTo(self.attentionsLabel.bottomPos).offset(20);
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
    }
    return _agreementLabel;
}

#pragma mark - textField delegate
- (void)textFieldEditChanged:(UITextField *)textField
{
    [self inspectTextField];
}
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    //身份证号
//    if (textField == self.idView.contentField) {
//        if (textField.text.length >= 18 && ![string isEqualToString:@""]) {
//            if (range.location == 17 && range.length == 1) {
//                return YES;
//            }
//            return NO;
//        }
//        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789xX\b"];
//        if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
//            return NO;
//        }
//        return YES;
//    }
//    return YES;
//}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.nameView.contentField && [self.nameView.contentField.text isEqualToString:@""] ) {//&& ![Common isChinese:_textField1.text]
        [AuxiliaryFunc showToastMessage:@"请输入正确的姓名" withView:self.view];
        return;
    }else if(textField == self.phoneView.contentField && ![self inspectPhoneView]){
        [AuxiliaryFunc showToastMessage:@"请输入正确的手机号码" withView:self.view];
        return;
    }
    
}

- (void)inspectTextField
{
    if ([self inspectNameViewInPut] && [self inspectPhoneView] && [self inspectSelectBankView]) {
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
- (BOOL)inspectPhoneView
{
    if (self.phoneView.contentField.text.length == 11 && [Common isOnlyNumber:self.phoneView.contentField.text] ) {
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
#pragma mark - ChooseBankView
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
}

- (void)enterButtoClick
{
//    UCFMicroBankOpenAccountOpenAccountIntoBankInfoAPI * request = [[UCFMicroBankOpenAccountOpenAccountIntoBankInfoAPI alloc] initWithRealName:self.nameView.contentField.text idCardNo:self.idView.contentField.text bankNo:self.bankId openStatus:self.GetOpenAccountModel.data.openStatus AccoutType:SelectAccoutTypeP2P];
//    request.animatingView = self.view;
//    //    request.tag =tag;
//    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
//        // 你可以直接在这里使用 self
//        DDLogDebug(@"---------%@",request.responseJSONModel);
//        UCFMicroBankOpenAccountOpenAccountIntoBankInfoModel *model = [request.responseJSONModel copy];
//        if (model.ret == YES)
//        {
//            SingleUserInfo.loginData.userInfo.realName = self.nameView.contentField.text;
//            [SingleUserInfo setUserData:SingleUserInfo.loginData];
//            AccountWebView *webView = [[AccountWebView alloc] initWithNibName:@"AccountWebView" bundle:nil];
//            webView.title = @"即将跳转";
//            //            webView.isPresentViewController = self.db.isPresentViewController;
//            webView.rootVc = @"UpgradeAccountVC";
//            webView.url = model.data.url;
//            NSString *SIGNStr = model.data.tradeReq.SIGN;
//            NSMutableDictionary *data =  [[NSMutableDictionary alloc]initWithDictionary:@{}];
//            [data setValue: model.data.tradeReq.PARAMS  forKey:@"PARAMS"];
//            [data setValue:[NSString  urlEncodeStr:SIGNStr] forKey:@"SIGN"];
//            webView.webDataDic = data;
//            //            if(self.db){
//            //                [self.db.navigationController pushViewController:webView animated:YES];
//            //            }else{
//            [self.rt_navigationController pushViewController:webView animated:YES];
//            //            }
//        }
//        else
//        {
//            ShowMessage(model.message);
//        }
//    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
//        // 你可以直接在这里使用 self
//
//    }];
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
            {
                
                self.agreementLabel.text = @"开通即视为本人已阅读并同意《CFCA数字证书服务协议》";
                [self.agreementLabel sizeToFit];
                __weak typeof(self) weakSelf = self;
                [self.agreementLabel setFontColor:UIColorWithRGB(0x4aa1f9) string:@"《CFCA数字证书服务协议》"];
                [self.agreementLabel addLinkString:@"《CFCA数字证书服务协议》" block:^(ZBLinkLabelModel *linkModel) {
                    FullWebViewController *webController = [[FullWebViewController alloc] initWithWebUrl:weakSelf.GetOpenAccountModel.data.cfcaContractUrl title:@"CFCA数字证书服务协议"];
                    webController.baseTitleType = @"specialUser";
                    [weakSelf.navigationController pushViewController:webController animated:YES];
                }];
            }
            
            SingleUserInfo.loginData.userInfo.openStatus = self.GetOpenAccountModel.data.openStatus;
            if (self.GetOpenAccountModel.data.userInfo.realName.length > 0)
            {
                //                用户P2P开户状态 1：未开户 2：已开户 3：已绑卡 4：已设交易密码  
                self.nameView.contentField.text = self.GetOpenAccountModel.data.userInfo.realName;
                SingleUserInfo.loginData.userInfo.realName = self.GetOpenAccountModel.data.userInfo.realName;
            }
            if (self.GetOpenAccountModel.data.userInfo.phoneNum.length > 0)
            {
        
                self.phoneView.contentField.text   = self.GetOpenAccountModel.data.userInfo.phoneNum;
            }
            if (self.GetOpenAccountModel.data.userInfo.bankCard.length > 0) {
                //将银行卡（textField3）要显示的文字四位分隔
                self.selectBankView.oaContentLabel.text = [NSString bankIdSeparate:self.GetOpenAccountModel.data.userInfo.bankCard];
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
@end
