//
//  UCFMicroBankDepositoryBankCardHomeViewController.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/5/6.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFMicroBankDepositoryBankCardHomeViewController.h"
#import "BaseScrollview.h"
#import "UCFNewBankCardView.h"
#import "UCFMicroBankDepositoryBankCardHomeView.h"
#import "UCFMicroBankDepositoryBankCardHomeTipView.h"
#import "UCFChoseBankViewController.h"
#import "UCFMicroBankDepositoryBankCardInfoApi.h"
#import "UCFMicroBankDepositoryBankCardInfoModel.h"
#import "NSString+Tool.h"
#import "UILabel+Misc.h"
#import "UCFMicroBankDepositoryChangeBankCardViewController.h"
#import "UCFMicroBankOpenAccountViewController.h"

@interface UCFMicroBankDepositoryBankCardHomeViewController ()<UCFChoseBankViewControllerDelegate>

@property (nonatomic, strong) MyRelativeLayout *rootLayout;

@property (nonatomic, strong) MyLinearLayout *scrollLayout;

@property (nonatomic, strong) BaseScrollview *scrollView;

@property (nonatomic, strong) UCFNewBankCardView *bankCard;

@property (nonatomic, strong) UCFMicroBankDepositoryBankCardHomeView *changeBankCard; //修改绑定银行卡

@property (nonatomic, strong) UCFMicroBankDepositoryBankCardHomeView *zoneBankCard; //开户支行

@property (nonatomic, strong) UCFMicroBankDepositoryBankCardHomeTipView *tipView; //提示

@property (nonatomic, strong) MyRelativeLayout *agreementLayout;

@property (nonatomic, copy)   NSString  *bankName;
@end

@implementation UCFMicroBankDepositoryBankCardHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.rootLayout = [MyRelativeLayout new];
    self.rootLayout.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
    self.rootLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
    self.view = self.rootLayout;
    [self.rootLayout addSubview: self.scrollView];
    [self.scrollView addSubview:self.scrollLayout];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(renewDataForPage) name:MODIBANKZONE_SUCCESSED object:nil];//***修改绑定银行卡成功后返回该页面需要刷新数据
    
    [self.scrollLayout addSubview:self.bankCard];
    [self.scrollLayout addSubview:self.tipView];
    [self.scrollLayout addSubview:self.changeBankCard];
    [self.scrollLayout addSubview:self.zoneBankCard];
    [self.scrollLayout addSubview:self.agreementLayout];
    
    [self addLeftButton];
    [self requestBankCardInfo];
}


- (BaseScrollview *)scrollView
{
    if (nil == _scrollView) {
        _scrollView = [BaseScrollview new];
        _scrollView.scrollEnabled = YES;
        _scrollView.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
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
        _scrollLayout.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
        _scrollLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
        _scrollLayout.myHorzMargin = 0;                          //同时指定左右边距为0表示宽度和父视图一样宽
        _scrollLayout.heightSize.lBound(self.scrollView.heightSize, 10, 1); //高度虽然是wrapContentHeight的。但是最小的高度不能低于父视图的高度加10.
        
    }
    return _scrollLayout;
}


- (UCFNewBankCardView *)bankCard
{
    if (nil == _bankCard) {
        CGFloat tableHeadHeight = PGScreenWidth *0.8267;
        _bankCard = [[UCFNewBankCardView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,tableHeadHeight)];
        _bankCard.myTop = 0;
        _bankCard.myLeft = 0;
    }
    return _bankCard;
}

- (UCFMicroBankDepositoryBankCardHomeTipView *)tipView
{
    if (nil == _tipView) {
        _tipView = [[UCFMicroBankDepositoryBankCardHomeTipView alloc] initWithFrame:CGRectMake(0, 0, PGScreenWidth, 50)];
        _tipView.topPos.equalTo(self.bankCard.bottomPos);
        _tipView.myLeft = 0;
        _tipView.myVisibility = MyVisibility_Gone;
        _tipView.tag = 1001;
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(layoutClick:)];
        [_tipView addGestureRecognizer:tapGesturRecognizer];
    }
    return _tipView;
}

- (UCFMicroBankDepositoryBankCardHomeView *)changeBankCard
{
    if (nil == _changeBankCard) {
        _changeBankCard = [[UCFMicroBankDepositoryBankCardHomeView alloc] initWithFrame:CGRectMake(0, 0, PGScreenWidth, 50)];
        _changeBankCard.itemTitleLabel.text = @"修改绑定银行卡";
        _changeBankCard.itemContentLabel.text = @"申请修改";
        [_changeBankCard.itemTitleLabel sizeToFit];
        [_changeBankCard.itemContentLabel sizeToFit];
        _changeBankCard.topPos.equalTo(self.tipView.bottomPos);
        _changeBankCard.myLeft = 0;
        _changeBankCard.myVisibility = MyVisibility_Gone;
        _changeBankCard.tag = 1002;
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(layoutClick:)];
        [_changeBankCard addGestureRecognizer:tapGesturRecognizer];
    }
    return _changeBankCard;
}
- (UCFMicroBankDepositoryBankCardHomeView *)zoneBankCard
{
    if (nil == _zoneBankCard) {
        _zoneBankCard = [[UCFMicroBankDepositoryBankCardHomeView alloc] initWithFrame:CGRectMake(0, 0, PGScreenWidth, 50)];
        _zoneBankCard.itemTitleLabel.text = @"开户支行";
        _zoneBankCard.itemContentLabel.text = @"请选择";
        [_zoneBankCard.itemTitleLabel sizeToFit];
        [_zoneBankCard.itemContentLabel sizeToFit];
        _zoneBankCard.topPos.equalTo(self.changeBankCard.bottomPos);
        _zoneBankCard.myLeft = 0;
        _zoneBankCard.itemLineView.hidden = YES;
        _zoneBankCard.tag = 1003;
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(layoutClick:)];
        [_zoneBankCard addGestureRecognizer:tapGesturRecognizer];
    }
    return _zoneBankCard;
}
-(void)layoutClick:(UIGestureRecognizer *)sender
{
    if (sender.view.tag == 1001)
    {
        UCFMicroBankOpenAccountViewController *vc = [[UCFMicroBankOpenAccountViewController alloc] init];
        [self.rt_navigationController pushViewController:vc animated:YES];
    }
    else if (sender.view.tag == 1002)
    {
        UCFMicroBankDepositoryChangeBankCardViewController *changeBank = [[UCFMicroBankDepositoryChangeBankCardViewController alloc] init];
        changeBank.accoutType = self.accoutType;
        [self.rt_navigationController pushViewController:changeBank animated:YES];
    }
    else
    {
        UCFChoseBankViewController *choseBankVC = [[UCFChoseBankViewController alloc]initWithNibName:@"UCFChoseBankViewController" bundle:nil];
        choseBankVC.delegate = self;
        choseBankVC.bankName = self.bankName;
        choseBankVC.accoutType = self.accoutType;
        [self.rt_navigationController pushViewController:choseBankVC animated:YES];
    }
}
- (MyRelativeLayout *)agreementLayout
{
    if (nil == _agreementLayout) {
        _agreementLayout = [MyRelativeLayout new];
        _agreementLayout.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
        _agreementLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
        _agreementLayout.topPos.equalTo(self.zoneBankCard.bottomPos);
        _agreementLayout.myLeft = 0;
        _agreementLayout.myRight = 0;
        
        UIView *agreementView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 117)];
        agreementView.useFrame = YES;
        CGFloat spacingHeight = 8;
        CGFloat spacingLabelHeight = 5;
        CGFloat spacingWidth = 4;
        CGFloat labelWidth = PGScreenWidth - 62;
        
        NZLabel *titleLabel = [[NZLabel alloc] initWithFrame:CGRectMake(25, 20, PGScreenWidth, 15)];
        titleLabel.font = [Color gc_Font:15];
        titleLabel.textColor = [Color color:PGColorOptionInputDefaultBlackGray];
        titleLabel.text = @"温馨提示";
        [agreementView addSubview:titleLabel];
        
        UIView *firstRound = [[UIView alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(titleLabel.frame) +15, 8, 8)];
        firstRound.backgroundColor = [Color color:PGColorOptionInputDefaultBlackGray];
        firstRound.layer.cornerRadius = 4;
        firstRound.layer.masksToBounds = YES;
        
        NZLabel *firstLabel = [[NZLabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(firstRound.frame) +spacingWidth, CGRectGetMinY(firstRound.frame) -spacingLabelHeight,labelWidth , 50)];
        firstLabel.font = [Color gc_Font:13];
        firstLabel.textColor = [Color color:PGColorOptionInputDefaultBlackGray];
        firstLabel.text = [NSString stringWithFormat:@"目前官网上可绑定的部分银行暂不支持手机快捷支付。"];
        [firstLabel setLineSpace:6 string:firstLabel.text];
        firstLabel.lineBreakMode = NSLineBreakByWordWrapping;
        firstLabel.numberOfLines = 0;
        firstLabel.preferredMaxLayoutWidth = labelWidth;
        [agreementView addSubview:firstRound];
        [agreementView addSubview:firstLabel];
        
        UIView *secondRound = [[UIView alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(firstLabel.frame) +spacingHeight, 8, 8)];
        secondRound.backgroundColor = [Color color:PGColorOptionInputDefaultBlackGray];
        secondRound.layer.cornerRadius = 4;
        secondRound.layer.masksToBounds = YES;
        
        NZLabel *secondLabel = [[NZLabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(secondRound.frame) +spacingWidth, CGRectGetMinY(secondRound.frame) -spacingLabelHeight,labelWidth , 50)];
        secondLabel.font = [Color gc_Font:13];
        secondLabel.textColor = [Color color:PGColorOptionInputDefaultBlackGray];
        secondLabel.text = [NSString stringWithFormat:@"若账户内有余额或待收不可修改绑定银行卡。"];
        [secondLabel setLineSpace:6 string:secondLabel.text];
        secondLabel.lineBreakMode = NSLineBreakByWordWrapping;
        secondLabel.numberOfLines = 0;
        secondLabel.preferredMaxLayoutWidth = labelWidth;
        [agreementView addSubview:secondRound];
        [agreementView addSubview:secondLabel];
        
        UIView *thirdRound = [[UIView alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(secondLabel.frame) +spacingHeight, 8, 8)];
        thirdRound.backgroundColor = [Color color:PGColorOptionInputDefaultBlackGray];
        thirdRound.layer.cornerRadius = 4;
        thirdRound.layer.masksToBounds = YES;
        
        NZLabel *thirdLabel = [[NZLabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(thirdRound.frame) +spacingWidth, CGRectGetMinY(thirdRound.frame) -spacingLabelHeight,labelWidth , 50)];
        thirdLabel.font = [Color gc_Font:13];
        thirdLabel.textColor = [Color color:PGColorOptionInputDefaultBlackGray];
        thirdLabel.text = [NSString stringWithFormat:@"开户行名称填写错误将无法提现，请拨打银行客服电话查询进行修改。"];
        thirdLabel.lineBreakMode = NSLineBreakByCharWrapping;
        thirdLabel.numberOfLines = 0;
        thirdLabel.preferredMaxLayoutWidth = labelWidth;
        [thirdLabel setLineSpace:6 string:thirdLabel.text];
        [agreementView addSubview:thirdRound];
        [agreementView addSubview:thirdLabel];
        
        agreementView.frame = CGRectMake(0, 0, agreementView.frame.size.width, CGRectGetMaxY(thirdLabel.frame)+50);
        
        [_agreementLayout addSubview:agreementView];
        _agreementLayout.myHeight = CGRectGetMaxY(thirdLabel.frame)+50;
        
    }
    return _agreementLayout;
}
- (void)addLeftButton
{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [leftButton setFrame:CGRectMake(0, 0, 25, 25)];
    [leftButton setBackgroundColor:[UIColor clearColor]];
    [leftButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.7] forState:UIControlStateHighlighted];
    //    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -15, 0.0, 0.0)];
    [leftButton setImage:[UIImage imageNamed:@"btn_whiteback.png"]forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_whiteback.png"]forState:UIControlStateHighlighted];
    //[leftButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(getToBack) forControlEvents:UIControlEventTouchUpInside];
    leftButton.myTop = 20 + StatusBarHeight1;
    leftButton.myLeft = 0;
    leftButton.myWidth = 41;
    leftButton.myHeight = 16;
    [self.rootLayout addSubview:leftButton];
    
    NZLabel *titleLabel = [NZLabel new];
    titleLabel.font = [Color gc_Font:18.0];
    //***设置导航title 1.p2p绑定银行卡 2.尊享绑定银行卡
    if(self.accoutType == SelectAccoutTypeP2P)
    {
        titleLabel.text =@"微金绑定银行卡";
    }else{
        titleLabel.text =@"尊享绑定银行卡";
    }
    titleLabel.textColor = [Color color:PGColorOptionThemeWhite];
    [titleLabel sizeToFit];
    titleLabel.myCenterX = 0;
    titleLabel.centerYPos.equalTo(leftButton.centerYPos);
    [self.rootLayout addSubview:titleLabel];
}
- (void)requestBankCardInfo//请求银行卡信息
{
    UCFMicroBankDepositoryBankCardInfoApi * request = [[UCFMicroBankDepositoryBankCardInfoApi alloc] initWithType:self.accoutType];
    request.animatingView = self.view;
    //    request.tag =tag;
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        // 你可以直接在这里使用 self
        UCFMicroBankDepositoryBankCardInfoModel *model = [request.responseJSONModel copy];
        DDLogDebug(@"---------%@",model);
        if (model.ret == YES) {
            
            if (model.data.bankInfoDetail.bankLogo != nil) {
                [self.bankCard.bankCardImageView sd_setImageWithURL:[NSURL URLWithString:model.data.bankInfoDetail.bankLogo] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
        
                }];
            }
            //        [view addSubview:bankCard];
            
            if (model.data.bankInfoDetail.bankName) {
                self.bankName = model.data.bankInfoDetail.bankName;
                self.bankCard.bankNameLabel.text = model.data.bankInfoDetail.bankName;
                [self.bankCard.bankNameLabel sizeToFit];
            }
            if (model.data.bankInfoDetail.realName) {
                self.bankCard.userNameLabel.text = model.data.bankInfoDetail.realName;
                [self.bankCard.userNameLabel sizeToFit];
            }
            if (model.data.bankInfoDetail.bankCard) {
                self.bankCard.cardNoLabel.text = [NSString bankIdSeparate:model.data.bankInfoDetail.bankCard];
                [self.bankCard.cardNoLabel sizeToFit];
            }
            
            if (model.data.bankInfoDetail.isShortcut) {
//                isShortcut;//是否支持快捷
                self.bankCard.quickPayImageView.myVisibility = MyVisibility_Visible ;
            }
            else
            {
                self.bankCard.quickPayImageView.myVisibility = MyVisibility_Gone;
            }
            
            if (![model.data.bankInfoDetail.tipDes isEqualToString:@""]) {
                self.tipView.myVisibility = MyVisibility_Visible;
                self.tipView.itemTitleLabel.text = model.data.bankInfoDetail.tipDes;
                [self.tipView.itemTitleLabel sizeToFit];
            }
            if ([model.data.isUpdateBank isEqualToString:@"1"]) {
                self.changeBankCard.myVisibility = MyVisibility_Visible;
            }
        }
        else{
            //            ShowMessage(model.message);
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        // 你可以直接在这里使用 self
    }];
    
}

#pragma mark -方法-修改绑定银行卡成功后返回该页面刷新数据同时提示修改开户支行
-(void)renewDataForPage
{
     [self changeBankBranch];
    [self requestBankCardInfo];
    
}
#pragma mark -方法-提示框弹出，提示修改开户行支行
-(void)changeBankBranch
{
    @PGWeakObj(self);
    BlockUIAlertView *alert_bankbrach= [[BlockUIAlertView alloc]initWithTitle:@"提示" message:@"是否需要修改开户支行" cancelButtonTitle:@"暂不" clickButton:^(NSInteger index) {
        if (index == 1) {
            //***选择更改支行信息
            UCFChoseBankViewController *choseBankVC = [[UCFChoseBankViewController alloc]initWithNibName:@"UCFChoseBankViewController" bundle:nil];
            choseBankVC.delegate = selfWeak;
            choseBankVC.bankName = selfWeak.bankName;
            choseBankVC.accoutType = selfWeak.accoutType;
            [selfWeak.rt_navigationController pushViewController:choseBankVC animated:YES];            }
    } otherButtonTitles:@"修改"];
    [alert_bankbrach show];
}

#pragma mark -请求-当选择支行信息后请求服务器修改
-(void)chosenBranchBank:(NSDictionary *)_dicBranchBank
{
    
    NSDictionary * dic = _dicBranchBank;
    NSDictionary *strParameters = [NSDictionary dictionaryWithObjectsAndKeys: SingleUserInfo.loginData.userInfo.userId,@"userId",[dic objectForKey:@"bankNo"] ,@"relevBankCard",nil];
    [[NetworkModule sharedNetworkModule] newPostReq:strParameters tag:kSXTagChosenBranchBank owner:self signature:YES Type:self.accoutType];
    self.zoneBankCard.itemTitleLabel.text = [dic objectSafeForKey:@"bankName"];
    [self.zoneBankCard.itemTitleLabel sizeToFit];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
//开始请求
- (void)beginPost:(kSXTag)tag
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

//请求成功及结果
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSString *data = (NSString *)result;
    //    DDLogDebug(@"首页获取最新项目列表：%@",data);
    
    //    bankCard        string    @mock=6210***********6236
    //    bankCardStatus        string    1：银行卡有效 0：银行卡失效
    //    bankId        string    @mock=6
    //    bankName        string    @mock=中国邮政储蓄银行
    //    bankzone        string    @mock=邮政储蓄银行
    //    cjflag        string    @mock=1
    //    isCompanyAgent        string    true: 是机构 false :非机构
    //    isUpdateBank        string    @mock=1
    //    isUpdateBankDeposit        string    @mock=0
    //    openStatus1：未开户 2：已开户 3：已邦卡 4：已设置交易密码
    //    realName        string    @mock=李奇迹
    //    status        string    @mock=1
    //    statusdes        string    @mock=充值查询银行卡信息成功
    //    tipsDes        string    提示信息
    //    url        string    @mock=http://10.10.100.42:8080/mpapp/staticRe/images/bankicons/6.png
    
    
    if(tag.integerValue == kSXTagChosenBranchBank){
        NSMutableDictionary *dic = [data objectFromJSONString];
        NSString *rstcode = dic[@"ret"];
        NSString *rsttext = dic[@"message"];
        if([rstcode intValue]==1)
        {
            [self requestBankCardInfo];
        }else{
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
        }
    }
}

//请求失败
- (void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    if (tag.intValue == kSXTagChosenBranchBank) {
        [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
    }
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    //    self.settingBaseBgView.hidden = YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MODIBANKZONE_SUCCESSED object:self];
}
@end
