//
//  UCFMicroBankDepositoryChangeBankCardViewController.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/12.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFMicroBankDepositoryChangeBankCardViewController.h"
#import "BaseScrollview.h"
#import "UCFMicroBankDepositoryBankCardInfoView.h"
#import "UCFMicroBankDepositoryAccountHomeCellExpirationView.h"
#import "UCFMicroBankDepositoryBankCardCellView.h"

@interface UCFMicroBankDepositoryChangeBankCardViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) MyLinearLayout *scrollLayout;

@property (nonatomic, strong) BaseScrollview *scrollView;

@property (nonatomic, strong) MyRelativeLayout *rootLayout;

@property (nonatomic, strong) UCFMicroBankDepositoryBankCardInfoView *bankCardInfoView; //银行卡信息

@property (nonatomic, strong) UCFMicroBankDepositoryBankCardCellView *changeBankCardView;//修改银行卡

@property (nonatomic, strong) UCFMicroBankDepositoryBankCardCellView *openingBankView;//选择开户行

@property (nonatomic, strong) UCFMicroBankDepositoryAccountHomeCellExpirationView *expirationView;//银行卡过期
@end

@implementation UCFMicroBankDepositoryChangeBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.rootLayout = [MyRelativeLayout new];
    self.rootLayout.backgroundColor = [Color color:PGColorOptionThemeWhite];
    self.rootLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
    self.view = self.rootLayout;
//    self.view =  self.scrollView ;
    [self.rootLayout addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollLayout];
    
    [self.scrollLayout addSubview:self.bankCardInfoView];
    if(self.accoutType == SelectAccoutTypeP2P)
    {
        baseTitleLabel.text =@"微金绑定银行卡";
    }else{
        baseTitleLabel.text =@"尊享绑定银行卡";
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
- (UCFMicroBankDepositoryBankCardInfoView *)bankCardInfoView
{
    if (nil == _bankCardInfoView) {
        _bankCardInfoView = [[UCFMicroBankDepositoryBankCardInfoView alloc] initWithFrame:CGRectMake(0, 0, PGScreenWidth, PGScreenWidth *0.573)];
        _bankCardInfoView.myTop = 0;
        _bankCardInfoView.myLeft = 0;
    }
    return _bankCardInfoView;
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
