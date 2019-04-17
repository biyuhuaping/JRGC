//
//  UCFMicroBankDepositoryAccountHomeViewController.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/2/21.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFMicroBankDepositoryAccountHomeViewController.h"
#import "BaseTableView.h"
#import "UCFMicroBankDepositoryAccountHomeHeadView.h"
#import "BaseScrollview.h"
#import "UCFMicroBankDepositoryAccountHomeCellView.h"
#import "UCFMicroBankDepositoryAccountSeriaViewController.h"
#import "RiskAssessmentViewController.h"
#import "UCFMicroBankDepositoryChangeBankCardViewController.h"
#import "AccountWebView.h"
#import "UCFMicroBankChangeTradersPasswordViewController.h"
#import "UCFBankCardInfoViewController.h"
#import "UCFBatchInvestmentViewController.h"

#import "UCFMicroBankUserAccountInfoAPI.h"
#import "UCFMicroBankGetHSAccountInfoAPI.h"
#import "UCFMicroBankUserAccountInfoModel.h"
#import "UCFMicroBankGetHSAccountInfoModel.h"
#import "UCFWJSetAndRestHsPwdApi.h"
#import "UCFWJSetAndRestHsPwdModel.h"

@interface UCFMicroBankDepositoryAccountHomeViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) MyLinearLayout *scrollLayout;

@property (nonatomic, strong) BaseScrollview *scrollView;

@property (nonatomic, strong) MyRelativeLayout *rootLayout;

@property (nonatomic, strong) UCFMicroBankDepositoryAccountHomeHeadView *tableHead;

@property (nonatomic, strong) UCFMicroBankDepositoryAccountHomeCellView *accountSerial; //账户流水
@property (nonatomic, strong) UCFMicroBankDepositoryAccountHomeCellView *modifyBankCard; //修改银行卡
@property (nonatomic, strong) UCFMicroBankDepositoryAccountHomeCellView *changePassword; //修改交易密码
@property (nonatomic, strong) UCFMicroBankDepositoryAccountHomeCellView *riskTolerance; //微金风险承担能力
@property (nonatomic, strong) UCFMicroBankDepositoryAccountHomeCellView *batchLend; //批量出借
@property (nonatomic, assign) NSInteger otherNum;
@end

@implementation UCFMicroBankDepositoryAccountHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view =  self.scrollView ;
    [self.scrollView addSubview:self.scrollLayout];
    [self.scrollLayout addSubview:self.tableHead];
    [self.scrollLayout addSubview:self.accountSerial];
    [self.scrollLayout addSubview:self.modifyBankCard];
    [self.scrollLayout addSubview:self.changePassword];
    [self.scrollLayout addSubview:self.riskTolerance];
    
    if (self.accoutType == SelectAccoutTypeP2P) {
        [self.scrollLayout addSubview:self.batchLend];
    }
    
    [self reuqestCell];
    [self reuqestHead];
    [self addLeftButton];
    if (self.accoutType == SelectAccoutTypeP2P) {
        baseTitleLabel.text = @"微金徽商银行存管账户";
    }
    else
    {
        baseTitleLabel.text = @"尊享徽商银行存管账户";
    }
}
- (BaseScrollview *)scrollView
{
    if (nil == _scrollView) {
        _scrollView = [BaseScrollview new];
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [Color color:PGColorOptionGrayBackgroundColor];
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
        _scrollLayout.backgroundColor = [Color color:PGColorOptionGrayBackgroundColor];
        _scrollLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
        _scrollLayout.myHorzMargin = 0;                          //同时指定左右边距为0表示宽度和父视图一样宽
        _scrollLayout.heightSize.lBound(self.scrollView.heightSize, 10, 1); //高度虽然是wrapContentHeight的。但是最小的高度不能低于父视图的高度加10.
        
    }
    return _scrollLayout;
}
- (UCFMicroBankDepositoryAccountHomeHeadView *)tableHead
{
    if (nil == _tableHead) {
        _tableHead = [[UCFMicroBankDepositoryAccountHomeHeadView alloc] initWithFrame:CGRectMake(0, 0, PGScreenWidth, PGScreenWidth *0.573)];
        _tableHead.myTop = 0;
        _tableHead.myLeft = 0;
    }
    return _tableHead;
}

- (UCFMicroBankDepositoryAccountHomeCellView *)accountSerial
{
    if (nil == _accountSerial) {
        _accountSerial = [[UCFMicroBankDepositoryAccountHomeCellView alloc] initWithFrame:CGRectMake(0, 0, PGScreenWidth, 50)];
        _accountSerial.topPos.equalTo(self.tableHead.bottomPos);
        _accountSerial.myLeft = 0;
        _accountSerial.microBankTitleLabel.text = @"账户流水";
        [_accountSerial.microBankTitleLabel sizeToFit];
        
        _accountSerial.microBankSubtitleLabel.text = @"";
        [_accountSerial.microBankSubtitleLabel sizeToFit];
        
        _accountSerial.microBankContentLabel.text = @"";
        [_accountSerial.microBankContentLabel sizeToFit];
        
        _accountSerial.tag = 1001;
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(layoutClick:)];
        [_accountSerial addGestureRecognizer:tapGesturRecognizer];
    }
    return _accountSerial;
}

- (UCFMicroBankDepositoryAccountHomeCellView *)modifyBankCard
{
    if (nil == _modifyBankCard) {
        _modifyBankCard = [[UCFMicroBankDepositoryAccountHomeCellView alloc] initWithFrame:CGRectMake(0, 0, PGScreenWidth, 50)];
        _modifyBankCard.topPos.equalTo(self.accountSerial.bottomPos);
        _modifyBankCard.myLeft = 0;
        _modifyBankCard.microBankTitleLabel.text = @"修改银行卡";
        [_modifyBankCard.microBankTitleLabel sizeToFit];
        
        _modifyBankCard.microBankSubtitleLabel.text = @"";
        [_modifyBankCard.microBankSubtitleLabel sizeToFit];
        
        _modifyBankCard.microBankContentLabel.text = @"";
        [_modifyBankCard.microBankContentLabel sizeToFit];
        
        _modifyBankCard.tag = 1002;
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(layoutClick:)];
        [_modifyBankCard addGestureRecognizer:tapGesturRecognizer];
    }
    return _modifyBankCard;
}

- (UCFMicroBankDepositoryAccountHomeCellView *)changePassword
{
    if (nil == _changePassword) {
        _changePassword = [[UCFMicroBankDepositoryAccountHomeCellView alloc] initWithFrame:CGRectMake(0, 0, PGScreenWidth, 50)];
        _changePassword.topPos.equalTo(self.modifyBankCard.bottomPos);
        _changePassword.myLeft = 0;
        _changePassword.microBankTitleLabel.text = @"修改交易密码";
        [_changePassword.microBankTitleLabel sizeToFit];
        
        _changePassword.microBankSubtitleLabel.text = @"";
        [_changePassword.microBankSubtitleLabel sizeToFit];
        
        _changePassword.microBankContentLabel.text = @"";
        [_changePassword.microBankContentLabel sizeToFit];
        
        _changePassword.tag = 1003;
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(layoutClick:)];
        [_changePassword addGestureRecognizer:tapGesturRecognizer];
    }
    return _changePassword;
}

- (UCFMicroBankDepositoryAccountHomeCellView *)riskTolerance
{
    if (nil == _riskTolerance) {
        _riskTolerance = [[UCFMicroBankDepositoryAccountHomeCellView alloc] initWithFrame:CGRectMake(0, 0, PGScreenWidth, 50)];
        _riskTolerance.topPos.equalTo(self.changePassword.bottomPos);
        _riskTolerance.myLeft = 0;
        _riskTolerance.microBankTitleLabel.text = @"微金风险承担能力";
        [_riskTolerance.microBankTitleLabel sizeToFit];
        
        _riskTolerance.microBankSubtitleLabel.text = @"";
        [_riskTolerance.microBankSubtitleLabel sizeToFit];
        
        _riskTolerance.microBankContentLabel.text = @"";
        [_riskTolerance.microBankContentLabel sizeToFit];
        _riskTolerance.tag = 1004;
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(layoutClick:)];
        [_riskTolerance addGestureRecognizer:tapGesturRecognizer];
    }
    return _riskTolerance;
}

- (UCFMicroBankDepositoryAccountHomeCellView *)batchLend
{
    if (nil == _batchLend) {
        _batchLend = [[UCFMicroBankDepositoryAccountHomeCellView alloc] initWithFrame:CGRectMake(0, 0, PGScreenWidth, 50)];
        _batchLend.topPos.equalTo(self.riskTolerance.bottomPos);
        _batchLend.myLeft = 0;
        _batchLend.microBankTitleLabel.text = @"批量出借";
        [_batchLend.microBankTitleLabel sizeToFit];
        
        _batchLend.microBankSubtitleLabel.text = @"";
        [_batchLend.microBankSubtitleLabel sizeToFit];
        
        _batchLend.microBankContentLabel.text = @"";
        [_batchLend.microBankContentLabel sizeToFit];
        
        _batchLend.itemLineView.myVisibility = MyVisibility_Invisible;
        
        _batchLend.tag = 1005;
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(layoutClick:)];
        [_batchLend addGestureRecognizer:tapGesturRecognizer];
    }
    return _batchLend;
}

//SelectAccoutDefault = 0,
//SelectAccoutTypeP2P = 1, //P2P账户 默认是P2P账户
//SelectAccoutTypeHoner, //尊享账户
//SelectAccoutTypeGold,//黄金账户

- (void)reuqestHead
{
    UCFMicroBankGetHSAccountInfoAPI * request = [[UCFMicroBankGetHSAccountInfoAPI alloc] initWithAccoutType:self.accoutType];
    request.animatingView = self.view;
    //    request.tag =tag;
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        // 你可以直接在这里使用 self
        UCFMicroBankGetHSAccountInfoModel *model = [request.responseJSONModel copy];
        DDLogDebug(@"---------%@",model);
        if (model.ret == YES) {

            self.tableHead.bankDepositNameLabel.text = model.data.hsAccountInfo.bankBranch;
            self.tableHead.bankCardNumberLabel.text = [NSString dealWithString:model.data.hsAccountInfo.bankCardNo];
            self.tableHead.openAccountNameLabel.text =  model.data.hsAccountInfo.accountName;
            
            [self.tableHead.bankDepositNameLabel sizeToFit];
            [self.tableHead.bankCardNumberLabel sizeToFit];
            [self.tableHead.openAccountNameLabel sizeToFit];
        }
        else{
            ShowMessage(model.message);
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        // 你可以直接在这里使用 self
        
    }];
}
- (void)reuqestCell
{
    UCFMicroBankUserAccountInfoAPI * request = [[UCFMicroBankUserAccountInfoAPI alloc] initWithAccoutType:self.accoutType];
    request.animatingView = self.view;
    //    request.tag =tag;
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        // 你可以直接在这里使用 self
        UCFMicroBankUserAccountInfoModel *model = [request.responseJSONModel copy];
        DDLogDebug(@"---------%@",model);
        if (model.ret == YES) {
            
            //修改银行卡
            self.modifyBankCard.microBankContentLabel.text = model.data.bankCardNum;
            [self.modifyBankCard.microBankContentLabel sizeToFit];
            //微金风险承担能力
            self.otherNum = model.data.otherNum;
            if (!model.data.riskLevel || [model.data.riskLevel isEqualToString:@""]) {
                self.riskTolerance.microBankSubtitleLabel.text = @"";
                self.riskTolerance.microBankContentLabel.text = @"未评估";
            }
            else{
                self.riskTolerance.microBankContentLabel.text = model.data.riskLevel;
                self.riskTolerance.microBankSubtitleLabel.text = [NSString stringWithFormat:@"(剩%ld次)",(long)model.data.otherNum];
            }
            [self.riskTolerance.microBankSubtitleLabel sizeToFit];
            [self.riskTolerance.microBankContentLabel sizeToFit];
            
            //批量出借
            if (self.accoutType == SelectAccoutTypeP2P)
            {
                //只有微金账户才有批量投标,尊享没有批量投标
                if (model.data.batchMaximum.length == 0) {
                    self.batchLend.microBankSubtitleLabel.text = @"批量出借(开通后一次可投多个项目)";
                    [self.batchLend.microBankSubtitleLabel sizeToFit];
                    self.batchLend.microBankContentLabel.text =  @"未开启";
                }
                else
                {
                    self.batchLend.microBankContentLabel.text = model.data.batchMaximum;
                }
                [self.batchLend.microBankContentLabel sizeToFit];
            }
        }
        else{
            ShowMessage(model.message);
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        // 你可以直接在这里使用 self
        
    }];
}
-(void)layoutClick:(UIGestureRecognizer *)sender
{
    if (sender.view.tag == 1001)
    {
        UCFMicroBankDepositoryAccountSeriaViewController *vc = [[UCFMicroBankDepositoryAccountSeriaViewController alloc] init];
        vc.accoutType = self.accoutType;
        [self.rt_navigationController pushViewController:vc animated:YES];
    }
    else if (sender.view.tag == 1002)
    {
//        修改银行卡
//        UCFMicroBankDepositoryChangeBankCardViewController *vc = [[UCFMicroBankDepositoryChangeBankCardViewController alloc] init];
//        [self.rt_navigationController pushViewController:vc animated:YES];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SecuirtyCenter" bundle:nil];
        UCFBankCardInfoViewController *bankCardInfoVC = [storyboard instantiateViewControllerWithIdentifier:@"bankcardinfo"];
        bankCardInfoVC.accoutType = self.accoutType;
        [self.rt_navigationController pushViewController:bankCardInfoVC animated:YES];
    }
    else if (sender.view.tag == 1003)
    {
//        修改交易密码
        if (self.accoutType != SelectAccoutTypeP2P) {

            UCFWJSetAndRestHsPwdApi * request = [[UCFWJSetAndRestHsPwdApi alloc] init];
            request.animatingView = self.view;
            //    request.tag =tag;
            [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                // 你可以直接在这里使用 self
                UCFWJSetAndRestHsPwdModel *model = [request.responseJSONModel copy];
                DDLogDebug(@"---------%@",model);
                if (model.ret == YES) {
                    
                    AccountWebView *webView = [[AccountWebView alloc] initWithNibName:@"AccountWebView" bundle:nil];
                    webView.title = @"即将跳转";
                    webView.url =model.data.url;
                    NSDictionary *dic = request.responseObject;
                    webView.webDataDic = dic[@"data"][@"tradeReq"];
                    [self.navigationController pushViewController:webView animated:YES];
                }
                else{
                    ShowMessage(model.message);
                }
            } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                // 你可以直接在这里使用 self
                
            }];
//            
        }
        else
        {
            //修改交易密码
            UCFMicroBankChangeTradersPasswordViewController *tradePasswordVC = [[UCFMicroBankChangeTradersPasswordViewController alloc] init];
            tradePasswordVC.accoutType = self.accoutType;
            [self.rt_navigationController pushViewController:tradePasswordVC  animated:YES];
        }
    }
    else if (sender.view.tag == 1004){
//        微金风险承担能力
        if (self.otherNum <= 0) { //风险承担能力评估剩余次数
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的评估次数已用完" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }else{
            RiskAssessmentViewController *riskAssessmentVC = [[RiskAssessmentViewController alloc] initWithNibName:@"RiskAssessmentViewController" bundle:nil];
            riskAssessmentVC.title = @"风险承担能力";
            riskAssessmentVC.accoutType = self.accoutType;
            riskAssessmentVC.sourceVC = @"P2POrHonerAccoutVC";
            [self.rt_navigationController pushViewController:riskAssessmentVC  animated:YES];
        }
    }
    else if (sender.view.tag == 1005){
        //        批量出借
        UCFBatchInvestmentViewController *batchInvestment = [[UCFBatchInvestmentViewController alloc] init];
        if ([self.batchLend.microBankContentLabel.text isEqualToString: @"未开启"]) {
            batchInvestment.isStep = 1;
        }
        else
        {
            batchInvestment.isStep = 2;
        }
        batchInvestment.accoutType = SelectAccoutTypeP2P;
        batchInvestment.hidesBottomBarWhenPushed = YES;
        [self.rt_navigationController pushViewController:batchInvestment animated:YES];
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
- (void)refresh
{
    [self reuqestCell];
    [self reuqestHead];
}



@end
