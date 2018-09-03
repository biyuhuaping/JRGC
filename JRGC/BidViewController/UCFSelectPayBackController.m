//
//  UCFSelectPayBackController.m
//  JRGC
//
//  Created by 金融工场 on 15/5/21.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFSelectPayBackController.h"
#import "CoupleHeadCell.h"
#import "SelectCoupleCell.h"
#import "AllSelectView.h"
#import "CoupleHeadView.h"
#import "UIScrollView+MJRefresh.h"
#import "UCFToolsMehod.h"
#import "Common.h"
#import "UCFTopUpViewController.h"
#import "UCFToolsMehod.h"
#import "MJRefreshLegendFooter.h"
#import "UCFNoDataView.h"

@interface UCFSelectPayBackController ()<UIScrollViewDelegate,SelectCoupleCellDelegate,AllSelectViewDelegate,CoupleHeadViewDelegate,UITextFieldDelegate>
{
    CoupleHeadView  *headView;
    AllSelectView   *slectView;
    CGFloat         _lastPosition;
    int             pageNum;
    int             beansPageNum;       //返息券当前分页
    int             totalPage;
    int             beansTotalPage;     //返息券所有的页数
    BOOL            isSelectedQuanXuan;
    double          annualRate;         //投资利率
    NSInteger          repayPeriodDay;  //投资期限
}
@property (nonatomic, strong)UISegmentedControl     *segmentedCtrl;
@property (nonatomic, strong)UIScrollView           *baseScrollView;

@end

@implementation UCFSelectPayBackController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self reloadView];
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
    NSString *isP2PTipStr =  self.accoutType == SelectAccoutTypeP2P  ? @"出借":@"投资";
    NSString *messageStr = [NSString stringWithFormat:@"1.返现券和返息券可在一笔%@中共用\n2.返现券可叠加使用\n3.返息券只能使用一张,不可叠加",isP2PTipStr];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:messageStr  delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
    [alert show];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton];
    [self addRightButtonWithImage:[UIImage imageNamed:@"icon_question.png"]];
    [self initData]; //初始化数据
    [self initWithTableView];
    [self addHeadView];
    [self addFootView];
    self.view.backgroundColor = UIColorWithRGB(0xebebee);

}
//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//
//}
- (void)initData
{

    self.selectedArray = [NSMutableArray arrayWithArray:self.tmpSelectCashArray];
    self.beansSelectArray = [NSMutableArray arrayWithArray:self.tmpSelectCounpArray];
    
    if (_backInterestRate) {
        annualRate = [_backInterestRate doubleValue];
    } else {
        annualRate = 0.0f;
    }
    //获取投资期限
    NSString *holdTime = [[self.bidDataDict objectForKey:@"data"] objectForKey:@"holdTime"];
    if (holdTime.length > 0) {
        repayPeriodDay = [holdTime integerValue];
    } else {
        repayPeriodDay = [[[self.bidDataDict objectForKey:@"data"] objectForKey:@"repayPeriodDay"] integerValue];
    }
}
- (void)segmentedValueChanged:(UISegmentedControl *)control
{
    [self performSelectorOnMainThread:@selector(beginUpdateGetNetData:) withObject: [NSNumber numberWithInteger:control.selectedSegmentIndex] waitUntilDone:NO];
}
- (void)beginUpdateGetNetData:(NSNumber *)type
{
    _listType = type.integerValue;
    [self changeFootViewShow];
    self.baseScrollView.contentOffset = CGPointMake(ScreenWidth * _listType, 0);
    if (_listType == 0 && self.youHuiArray.count == 0) {
        [self getNewData];
    } else if (_listType == 1 && self.beansArray.count == 0) {
        [self getNewData];
    }
}
- (void)addHeadView
{
    _segmentedCtrl = [[UISegmentedControl alloc]initWithItems:@[@"返现券",@"返息券"]];
    _segmentedCtrl.frame = CGRectMake(0, 0, ScreenWidth*5/8, 30);
    _segmentedCtrl.center = CGPointMake(ScreenWidth/2, 20);
    [_segmentedCtrl setTintColor:UIColorWithRGB(0x5b6993)];
//    [_segmentedCtrl setTitleTextAttributes:@{[UIFont systemFontOfSize:15]:NSFontAttributeName} forState:UIControlStateNormal];
    _segmentedCtrl.selectedSegmentIndex = _listType;
    [_segmentedCtrl addTarget:self action:@selector(segmentedValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _segmentedCtrl;
    
    headView = [[CoupleHeadView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 162.0f)];
    headView.accoutType = self.accoutType; 
    headView.backgroundColor = [UIColor whiteColor];
    headView.delegate = self;
    headView.inputMoneyTextFieldLable.delegate = self;
    NSString *needTouZi = [UCFToolsMehod AddComma:[NSString stringWithFormat:@"%.2f",_couponPrdaimSum]];
    headView.needsInvestLabel.text = [NSString stringWithFormat:@"¥%@",needTouZi];
    NSString *keyongString = [NSString stringWithFormat:@"%.2f",_keYongMoney];

    headView.canInvestLabel.text = [NSString stringWithFormat:@"¥%@",[UCFToolsMehod AddComma:[NSString stringWithFormat:@"%.2f",_keTouMoney]]];
    if (_keTouMoney >= _couponPrdaimSum) {
        headView.needsInvestLabel.textColor = [UIColor whiteColor];
    } else {
        headView.needsInvestLabel.textColor = UIColorWithRGB(0xf03b43);
    }
    headView.KeYongMoneyLabel.text = [NSString stringWithFormat:@"¥%@",[UCFToolsMehod AddComma:keyongString]];
    CGSize size = [Common getStrWitdth:headView.KeYongMoneyLabel.text TextFont:[UIFont boldSystemFontOfSize:17.0f]];
    headView.KeYongMoneyLabel.frame = CGRectMake(CGRectGetMinX(headView.KeYongMoneyLabel.frame), CGRectGetMinY(headView.KeYongMoneyLabel.frame), size.width , CGRectGetHeight(headView.KeYongMoneyLabel.frame));
    headView.totalKeYongTipLabel.frame = CGRectMake(CGRectGetMaxX(headView.KeYongMoneyLabel.frame) + 5, CGRectGetMaxY(headView.KeYongMoneyLabel.frame) - 12, 11 * 12, 12);
    headView.inputMoneyTextFieldLable.text = [NSString stringWithFormat:@"%.2f",self.touZiMoney];
    [self.view addSubview:headView];
    
    [Common addLineViewColor:UIColorWithRGB(0xd8d8d8) With:headView isTop:NO];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.touZiMoney = [headView.inputMoneyTextFieldLable.text doubleValue];
    double repayBeans = self.touZiMoney * annualRate/100.0f * (repayPeriodDay/360.0f) *self.occupyRate;
    self.interestSum = round(repayBeans * 100)/100.0f;
    [self checkIsLegal];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark CoupleHeadViewDelegate
- (void)allInvestOrGotoPay:(NSInteger)mark
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"RechargeStoryBorard" bundle:nil];
    UCFTopUpViewController *topUpView  = [storyboard instantiateViewControllerWithIdentifier:@"topup"];
    //topUpView.isGoBackShowNavBar = YES;
    topUpView.title = @"充值";
    topUpView.accoutType = self.accoutType;
    topUpView.uperViewController = self;
    [self.navigationController pushViewController:topUpView animated:YES];
}
- (void)addFootView
{
    
    slectView = [[AllSelectView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 95 - NavigationBarHeight1, ScreenWidth, 95)];
    slectView.backgroundColor = [UIColor whiteColor];
    slectView.delegate = self;
    UIImageView  *tabbarShadowView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, -10, ScreenWidth, 10)];
    UIImage *tabImag = [UIImage imageNamed:@"tabbar_shadow.png"];
    tabbarShadowView1.image = [tabImag resizableImageWithCapInsets:UIEdgeInsetsMake(2, 1, 2, 1) resizingMode:UIImageResizingModeStretch];
    [slectView addSubview:tabbarShadowView1];
    [self.view addSubview:slectView];
    [self changeFootViewShow];
}
/**
 *  更改足视图的提示文案
 */
- (void)changeFootViewShow
{
    if (self.listType == 1) {
        
        NSString *showStr = @"投资按月/季等额还款项目，最终返息获得工豆需要乘以0.56。0.56为借款方占用投资方自己的使用率";
        if (self.accoutType == SelectAccoutTypeP2P)
        {
            showStr = @"出借按月/季等额还款项目，最终返息获得工豆需要乘以0.56。0.56为借款方占用出借方自己的使用率";
        }
        CGSize size = [Common getStrHeightWithStr:showStr AndStrFont:13 AndWidth:ScreenWidth - 30];
        slectView.keYongBaseView.frame = CGRectMake(0, 0, ScreenWidth, 40 + size.height);
        self.beansTableView.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight - NavigationBarHeight1 - 162 - CGRectGetHeight(slectView.frame));
        [Common addLineViewColor:UIColorWithRGB(0xeff0f3) With:slectView.keYongBaseView isTop:NO];

        slectView.selectedBtn.hidden = YES;
        slectView.tipLabel.hidden = YES;
        slectView.showNumTipLab.hidden = NO;

        slectView.showNumSelectLabe.textAlignment = NSTextAlignmentLeft;
        slectView.showNumSelectLabe.frame = CGRectMake(15, 10, ScreenWidth - 30, 15);
        slectView.showNumSelectLabe.text =  self.accoutType == SelectAccoutTypeP2P ? @"出借¥0.00，可返息工豆¥0.00": @"投资¥0.00，可返息工豆¥0.00";
        slectView.showNumTipLab.frame = CGRectMake(15, CGRectGetMaxY(slectView.showNumSelectLabe.frame) + 5 , ScreenWidth - 30, size.height);
        slectView.showNumTipLab.text = showStr;
        slectView.sureBtn.frame = CGRectMake(15, CGRectGetMaxY(slectView.keYongBaseView.frame) + 10, ScreenWidth - 30, 37);
        slectView.frame = CGRectMake(0, ScreenHeight - 95 - size.height - NavigationBarHeight1, ScreenWidth, CGRectGetMaxY(slectView.sureBtn.frame) + 10);
        

    } else {
        slectView.frame = CGRectMake(0, ScreenHeight - 95 - NavigationBarHeight1, ScreenWidth, 95);
        slectView.keYongBaseView.frame = CGRectMake(0, 0, ScreenWidth, 37.5);
        slectView.sureBtn.frame = CGRectMake(15, CGRectGetMaxY(slectView.keYongBaseView.frame) + 10, ScreenWidth - 30, 37);
        
        slectView.selectedBtn.hidden = NO;
        slectView.tipLabel.hidden = NO;
        slectView.showNumTipLab.hidden = YES;
        
        slectView.tipLabel.frame = CGRectMake(CGRectGetMaxX(slectView.selectedBtn.frame) + 8,(37.5 - 13)/2, 30, 13);
        slectView.showNumSelectLabe.textAlignment = NSTextAlignmentRight;
        slectView.showNumSelectLabe.frame = CGRectMake(CGRectGetMaxX(slectView.tipLabel.frame) + 10, CGRectGetMinY(slectView.tipLabel.frame) - 2, ScreenWidth - CGRectGetMaxX(slectView.tipLabel.frame) - 10 - 15, 17);
    }
    [self checkIsLegal];
}
#pragma AllSelectViewDelegate
- (void)allSelectedViewBtnClicked:(UIButton*)btn
{
    if (btn.tag == 1000) {
//        if (self.beansSelectArray.count != 0) {
//            [self showAlertView];
//            return;
//        }
        btn.selected = !btn.selected;
        if (btn.selected) {
            NSString *strParameters = [NSString stringWithFormat:@"userId=%@&prdclaimid=%@",[[NSUserDefaults standardUserDefaults] valueForKey:UUID],_prdclaimid];
            [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXtagHuoQuAllYOUHuiQuan owner:self Type:self.accoutType];
        } else {
            self.couponSum = 0.0f;
            self.couponPrdaimSum = 0.0f;
            [self.selectedArray removeAllObjects];
            [self.youhuiTableView reloadData];
            [self checkIsLegal];
        }
    } else if (btn.tag == 2000) {
        if (self.selectedArray.count == 0 && self.beansSelectArray.count == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有选择任何优惠券,确认选择吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            alert.tag = 34522;
            [alert show];
            return;
        } else {
            [self backToUpdatePurBidViewController];
        }
     }
}
//返回到投标页面，把该页面数据传输到投标页
- (void)backToUpdatePurBidViewController
{
    NSMutableDictionary *discountDict = [NSMutableDictionary dictionaryWithCapacity:2];
    NSString *inputText = headView.inputMoneyTextFieldLable.text;
    //返息券数据源
    if (self.beansSelectArray.count != 0) {
        NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
        NSString *idStr = [NSString stringWithFormat:@"%@",[self.beansSelectArray objectAtIndex:0]];
        [dataDict setValue:@"1" forKey:@"rebackType"];
        [dataDict setValue:idStr forKey:@"idStr"];
        [dataDict setValue:self.backInterestRate forKey:@"backInterestRate"];
        [dataDict setValue:[NSString stringWithFormat:@"%ld",(unsigned long)[self.beansSelectArray count]]  forKey:@"youhuiNum"];
        [dataDict setValue:[NSString stringWithFormat:@"%.2f",self.interestSum] forKey:@"youhuiMoney"];
        [dataDict setValue:[NSString stringWithFormat:@"%.2f",self.interestPrdaimSum] forKey:@"manzuMoney"];
        [dataDict setValue:self.beansSelectArray forKey:@"selectArray"];
        if (inputText != nil) {
            [dataDict setValue:inputText forKey:@"coupMoney"];
        } else {
            [dataDict setValue:@"0.00" forKey:@"coupMoney"];
        }
        //选中返息券
        [discountDict setValue:dataDict forKey:@"coup"];
        
    } else {
        //没有选中返息券
        [discountDict setValue:[NSNull null] forKey:@"coup"];
    }
    
    //返现券数据源
    if (self.selectedArray.count != 0){
        NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
        NSString *idAllStr = @"";
        for (int i = 0;i<self.selectedArray.count;i++) {
            if (i != _selectedArray.count -1) {
                NSString *idStr = [NSString stringWithFormat:@"%@,",[self.selectedArray objectAtIndex:i]];
                idAllStr = [idAllStr stringByAppendingString:idStr];
            } else {
                NSString *idStr = [NSString stringWithFormat:@"%@",[self.selectedArray objectAtIndex:i]];
                idAllStr = [idAllStr stringByAppendingString:idStr];
            }
        }
        [dataDict setValue:@"0" forKey:@"rebackType"];
        [dataDict setValue:idAllStr forKey:@"idStr"];
        [dataDict setValue:[NSString stringWithFormat:@"%ld",(unsigned long)[self.selectedArray count]]  forKey:@"youhuiNum"];
        [dataDict setValue:[NSString stringWithFormat:@"%.2f",self.couponSum] forKey:@"youhuiMoney"];
        [dataDict setValue:[NSString stringWithFormat:@"%.2f",self.couponPrdaimSum] forKey:@"manzuMoney"];
        [dataDict setValue:self.selectedArray forKey:@"selectArray"];
        NSString *inputText = headView.inputMoneyTextFieldLable.text;
        if (inputText != nil) {
            [dataDict setValue:inputText forKey:@"coupMoney"];
        } else {
            [dataDict setValue:@"0.00" forKey:@"coupMoney"];
        }
        //选中返现券数据
        [discountDict setValue:dataDict forKey:@"cash"];
    } else {
        //没有选中返现券
        [discountDict setValue:[NSNull null] forKey:@"cash"];
    }
    if (self.selectedArray.count == 0 && self.beansSelectArray.count == 0) {
        NSString *inputText = headView.inputMoneyTextFieldLable.text;
        if (inputText != nil) {
            [discountDict setValue:inputText forKey:@"coupMoney"];
        } else {
            [discountDict setValue:@"0.00" forKey:@"coupMoney"];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateYouHuiQuanCell" object:discountDict];
    [self.navigationController popViewControllerAnimated:YES];

}
- (BOOL)checkIsLegal
{
    NSString *isP2PTipStr =  self.accoutType == SelectAccoutTypeP2P  ? @"出借":@"投资";
    if (self.listType == 1) {
        //投资金额
        NSString *couStr = [NSString stringWithFormat:@"%.2f",self.interestPrdaimSum];
        headView.needsInvestLabel.text = [NSString stringWithFormat:@"¥%@",[UCFToolsMehod AddComma:couStr]];
        NSString *keStr = [NSString stringWithFormat:@"%.2f",self.keTouMoney];
        headView.canInvestLabel.text = [NSString stringWithFormat:@"¥%@",[UCFToolsMehod AddComma:keStr]];
        int compar = [Common stringA:couStr ComparedStringB:keStr];
        if (compar == -1 || compar == 0) {
            headView.needsInvestLabel.textColor = [UIColor whiteColor];
            slectView.showNumSelectLabe.textColor = UIColorWithRGB(0x999999);
            NSString *returnMoney = (self.beansSelectArray.count == 0 ? @"0.00" : [NSString stringWithFormat:@"%.2lf",self.interestSum]);
            NSString *totalStr = [NSString stringWithFormat:@"%@ ¥%@,可返息工豆 ¥%@",isP2PTipStr,[UCFToolsMehod AddComma:[NSString stringWithFormat:@"%.2lf",self.touZiMoney]],[UCFToolsMehod AddComma:returnMoney]];
            slectView.showNumSelectLabe.text = totalStr;
            NSRange range1 = [totalStr rangeOfString:[NSString stringWithFormat:@"%@ ¥%@",isP2PTipStr,[UCFToolsMehod AddComma:[NSString stringWithFormat:@"%.2lf",self.touZiMoney]]]];
            range1.location +=3;
            range1.length -= 3;
            NSRange range2 = [totalStr rangeOfString:[NSString stringWithFormat:@"工豆 ¥%@",[UCFToolsMehod AddComma:returnMoney]]];
            range2.location += 3;
            range2.length -= 3;
            NSValue *value1 = [NSValue valueWithBytes:&range1 objCType:@encode(NSRange)];
            NSValue *value2 = [NSValue valueWithBytes:&range2 objCType:@encode(NSRange)];
            NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                           [UIFont boldSystemFontOfSize:14.0],NSFontAttributeName,
                                           UIColorWithRGB(0xf03b43),NSForegroundColorAttributeName,nil];
            slectView.showNumSelectLabe.attributedText = [Common twoSectionOfLabelShowDifferentAttribute:[NSArray arrayWithObjects:attributeDict,attributeDict, nil] WithTextLocations:[NSArray arrayWithObjects:value1,value2, nil] WithTotalString:totalStr];
            return YES;
        } else {
            headView.needsInvestLabel.textColor = UIColorWithRGB(0xf03b43);
            slectView.showNumSelectLabe.textColor = UIColorWithRGB(0xf03b43);
            slectView.showNumSelectLabe.text = [NSString stringWithFormat:@"需%@金额不能大于可投金额!",isP2PTipStr];
            return YES;
        }
    } else {
        NSString *couStr = [NSString stringWithFormat:@"%.2f",self.couponPrdaimSum];
        headView.needsInvestLabel.text = [NSString stringWithFormat:@"¥%@",[UCFToolsMehod AddComma:couStr]];
        NSString *keStr = [NSString stringWithFormat:@"%.2f",self.keTouMoney];
        headView.canInvestLabel.text = [NSString stringWithFormat:@"¥%@",[UCFToolsMehod AddComma:keStr]];
        int compar = [Common stringA:couStr ComparedStringB:keStr];
        if (compar == -1 || compar == 0) {
            headView.needsInvestLabel.textColor = [UIColor whiteColor];
            slectView.tipLabel.textColor = UIColorWithRGB(0x555555);
            slectView.showNumSelectLabe.textColor = UIColorWithRGB(0x555555);
            NSString *returnMoney = (self.selectedArray.count == 0 ? @"0.00" : [NSString stringWithFormat:@"%.2lf",self.couponSum]);

            NSString *totalStr = [NSString stringWithFormat:@"已选用 %lu 张，可返现 ¥%@",(unsigned long)self.selectedArray.count,[UCFToolsMehod AddComma:returnMoney]];
            slectView.showNumSelectLabe.text = totalStr;
            NSRange range1 = [totalStr rangeOfString:[NSString stringWithFormat:@"选用 %lu",(unsigned long)self.selectedArray.count]];
            range1.location += 3;
            range1.length -= 3;
            NSRange range2 = [totalStr rangeOfString:[NSString stringWithFormat:@"返现 ¥%@",[UCFToolsMehod AddComma:returnMoney]]];
            range2.location += 3;
            range2.length -= 3;
            
            NSValue *value1 = [NSValue valueWithBytes:&range1 objCType:@encode(NSRange)];
            NSValue *value2 = [NSValue valueWithBytes:&range2 objCType:@encode(NSRange)];
            UIColor *showColor = nil;
            showColor = (self.selectedArray.count == 0 ? UIColorWithRGB(0x333333) : UIColorWithRGB(0xf03b43));
            NSDictionary *attributeDict1 = [NSDictionary dictionaryWithObjectsAndKeys:
                                            [UIFont boldSystemFontOfSize:14.0],NSFontAttributeName,
                                            showColor,NSForegroundColorAttributeName,nil];

            NSDictionary *attributeDict2 = [NSDictionary dictionaryWithObjectsAndKeys:
                                            [UIFont boldSystemFontOfSize:14.0],NSFontAttributeName,
                                            UIColorWithRGB(0xf03b43),NSForegroundColorAttributeName,nil];
            slectView.showNumSelectLabe.attributedText = [Common twoSectionOfLabelShowDifferentAttribute:[NSArray arrayWithObjects:attributeDict1,attributeDict2, nil] WithTextLocations:[NSArray arrayWithObjects:value1,value2, nil] WithTotalString:totalStr];
            return YES;
        } else {
            headView.needsInvestLabel.textColor = UIColorWithRGB(0xf03b43);
            slectView.showNumSelectLabe.textColor = UIColorWithRGB(0xf03b43);
            slectView.showNumSelectLabe.text = [NSString stringWithFormat:@"需%@金额不能大于可投金额!",isP2PTipStr];
            return YES;
        }
    }
}
// 检查确认按钮是否可用
//- (void)checkSureButtonIsAvailable
//{
//    if ((_listType == 0 && self.selectedArray.count == 0) || (_listType == 1 && self.beansSelectArray.count == 0)) {
//        slectView.sureBtn.enabled = NO;
//        slectView.sureBtn.backgroundColor = UIColorWithRGB(0xd4d4d4);
//    } else {
//        slectView.sureBtn.enabled = YES;
//        slectView.sureBtn.backgroundColor = UIColorWithRGB(0xfd4d4c);
//    }
//}
- (void)reloadView
{
    if ([[NSUserDefaults standardUserDefaults] valueForKey:UUID]) {
        NSString *strParameters = [NSString stringWithFormat:@"userId=%@",[[NSUserDefaults standardUserDefaults] valueForKey:UUID]];
        [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagCheckMyMoney owner:self Type:self.accoutType];
    }
}
- (void)initWithTableView
{
    self.youHuiArray = [[NSMutableArray alloc] init];
    self.beansArray = [[NSMutableArray alloc] init];
    CGFloat navHeight = 44 + StatusBarHeight1;

    self.baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 162, ScreenWidth, ScreenHeight - navHeight - 162 - 95)];
    self.baseScrollView.pagingEnabled = YES;
    self.baseScrollView.delegate = self;
    self.baseScrollView.bounces = NO;
    self.baseScrollView.scrollEnabled = NO;
    self.baseScrollView.showsHorizontalScrollIndicator = NO;
    self.baseScrollView.contentSize = CGSizeMake(ScreenWidth * 2, ScreenHeight - navHeight -162 -101);
    [self.view addSubview:_baseScrollView];
    //如果指向的是返息券，默认scrollView偏移
    if (_listType == 1) {
        self.baseScrollView.contentOffset = CGPointMake(ScreenWidth, 0);
    }
    self.youhuiTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - navHeight - 162 - 95) style:UITableViewStylePlain];
    self.youhuiTableView.backgroundColor = [UIColor clearColor];
    [self.youhuiTableView setSeparatorColor:[UIColor clearColor]];
    self.youhuiTableView.delegate = self;
    self.youhuiTableView.dataSource = self;
    self.youhuiTableView.bounces = YES;
    self.youhuiTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_baseScrollView addSubview:self.youhuiTableView];
    
    self.beansTableView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight - navHeight - 162 - 95) style:UITableViewStylePlain];
    self.beansTableView.backgroundColor = [UIColor clearColor];
    [self.beansTableView setSeparatorColor:[UIColor clearColor]];
    self.beansTableView.delegate = self;
    self.beansTableView.dataSource = self;
    self.beansTableView.bounces = YES;
    self.beansTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_baseScrollView addSubview:self.beansTableView];
    
    __weak typeof(self) weakSelf = self;
    [self.youhuiTableView addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getNewData)];
    [self.beansTableView addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getNewData)];

    // 添加上拉加载更多
    [_youhuiTableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    [self.beansTableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    
    self.beansTableView.footer.hidden = YES;
    _youhuiTableView.footer.hidden = YES;
    
    [_youhuiTableView.footer setTitle:@"无更多数据了" forState:MJRefreshFooterStateNoMoreData];
    [_beansTableView.footer setTitle:@"无更多数据了" forState:MJRefreshFooterStateNoMoreData];
    
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    UITapGestureRecognizer *frade = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fadeKeyboard)];
    [_youhuiTableView addGestureRecognizer:frade];
    [_beansTableView addGestureRecognizer:frade];
    if (_listType == 0) {
        [_youhuiTableView.header beginRefreshing];
    } else {
         [_beansTableView.header beginRefreshing];
    }
   
}
- (void)fadeKeyboard
{
    [self.view endEditing:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.beansTableView) {
         return self.beansArray.count;
    } else {
         return self.youHuiArray.count;
    }
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 82.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.beansTableView) {
        static NSString *cellStr1 = @"beansBack";
        SelectCoupleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr1];
        if (cell == nil) {
            cell = [[SelectCoupleCell  alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr1];
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
        cell.accoutType = self.accoutType;
        cell.listType = 1;
        cell.selectedBtn.tag = indexPath.row;
        NSDictionary *dict = [self.beansArray objectAtIndex:indexPath.row];
        cell.dataDict = dict;
        cell.delegate = self;
        NSString * idMark = [NSString stringWithFormat:@"%ld",(long)[[dict objectForKey:@"id"] integerValue]];
        if ([self.beansSelectArray containsObject:idMark]) {
            NSLog(@"%@",idMark);
            cell.selectedBtn.selected = YES;
        } else {
            cell.selectedBtn.selected = NO;
        }
        cell.dataDict = [self.beansArray objectAtIndex:indexPath.row];
        return cell;
    } else {
        static NSString  *cellStr2 = @"cell02";
        SelectCoupleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr2];
        if (cell == nil) {
            cell = [[SelectCoupleCell  alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr2];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.accoutType = self.accoutType;
        cell.listType = 0;
        cell.selectedBtn.tag = indexPath.row;
        NSDictionary *dict = [self.youHuiArray objectAtIndex:indexPath.row];
        cell.dataDict = dict;
        cell.delegate = self;
        if (isSelectedQuanXuan) {
            NSString * idMark = [NSString stringWithFormat:@"%ld",(long)[[dict objectForKey:@"id"] integerValue]];
            if ([self.selectedArray containsObject:idMark]) {
                cell.selectedBtn.selected = YES;
            } else {
                cell.selectedBtn.selected = NO;
            }
        } else {
            NSString * idMark = [NSString stringWithFormat:@"%ld",(long)[[dict objectForKey:@"id"] integerValue]];
            if ([self.selectedArray containsObject:idMark]) {
                NSLog(@"%@",idMark);
                cell.selectedBtn.selected = YES;
            } else {
                cell.selectedBtn.selected = NO;
            }
        }
        cell.dataDict = [self.youHuiArray objectAtIndex:indexPath.row];
        return cell;
    }

}

- (void)getNewData
{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (_listType == 0) {
        pageNum = 1;
        NSString *strParameters = [NSString stringWithFormat:@"prdclaimid=%@&userId=%@&page=%d&&rows=10&investAmt=%.2f",self.prdclaimid,[[NSUserDefaults standardUserDefaults] valueForKey:UUID],pageNum,self.touZiMoney];
        [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXtagSelectBeanRecord owner:self Type:self.accoutType];
    } else if (_listType == 1) {
        beansPageNum = 1;
        NSString *strParameters = [NSString stringWithFormat:@"prdclaimid=%@&userId=%@&page=%d&&rows=10",self.prdclaimid,[[NSUserDefaults standardUserDefaults] valueForKey:UUID],beansPageNum];
        [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXtagSelectBeansInterest owner:self Type:self.accoutType];
    }

}
- (void)loadMoreData
{
    if (_listType == 0) {
        NSString *strParameters = [NSString stringWithFormat:@"prdclaimid=%@&userId=%@&page=%d&&rows=10&investAmt=%.2f",self.prdclaimid,[[NSUserDefaults standardUserDefaults] valueForKey:UUID],pageNum,self.touZiMoney];
        [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXtagSelectBeanRecord owner:self Type:self.accoutType];
    } else if (_listType == 1) {
        NSString *strParameters = [NSString stringWithFormat:@"prdclaimid=%@&userId=%@&page=%d&&rows=10",self.prdclaimid,[[NSUserDefaults standardUserDefaults] valueForKey:UUID],beansPageNum];
        [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXtagSelectBeansInterest owner:self Type:self.accoutType];
    }
}
-(void)beginPost:(kSXTag)tag
{
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if(tag.intValue == kSXtagSelectBeanRecord)
    {
        [self.youhuiTableView.header endRefreshing];
        [self.youhuiTableView.footer endRefreshing];
        NSString *Data = (NSString *)result;
        NSDictionary * dic = [Data objectFromJSONString];
        if([dic[@"status"] intValue] != 1) {

            [self.youHuiArray removeAllObjects];
            [self.youhuiTableView reloadData];

            [MBProgressHUD displayHudError:dic[@"statusdes"]];
        } else {
            totalPage = [[[dic[@"pageData"] objectForKey:@"pagination"] objectForKey:@"totalPage"] intValue];
            NSArray *tmpDataArr = [dic[@"pageData"] objectForKey:@"result"];
            if(pageNum == 1)
            {
                [self.youHuiArray removeAllObjects];
                if (tmpDataArr.count < 10) {
                    [self.youhuiTableView.footer noticeNoMoreData];
                }
            }
            if(pageNum <= totalPage)
            {
                pageNum++;
            }
            else
            {
                [self.youhuiTableView.footer noticeNoMoreData];
            }
   
            for (NSDictionary *dict in tmpDataArr) {
                [self.youHuiArray addObject:dict];
            }
            [self.youhuiTableView reloadData];
            UCFNoDataView  *noDataView = [_youhuiTableView viewWithTag:435901];
            if (noDataView) {
                [noDataView removeFromSuperview];
            }
            if (self.youHuiArray.count != 0) {
                _youhuiTableView.footer.hidden = NO;
            } else {
                noDataView = [[UCFNoDataView alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth(_youhuiTableView.frame), CGRectGetHeight(_youhuiTableView.frame)) errorTitle:@"暂无可用返现券"];
                noDataView.tag = 435901;
                [noDataView showInView:self.youhuiTableView];
            }
            
        }
    }
    else if (tag.intValue == kSXtagHuoQuAllYOUHuiQuan){

        NSString *Data = (NSString *)result;
        NSDictionary * dic = [Data objectFromJSONString];
        if([dic[@"status"] intValue] == 1){
            isSelectedQuanXuan = YES;
            //得到所有的数据的数值
            if ([UCFToolsMehod isNullOrNilWithString:dic[@"beanRecordids"]].length > 0) {
                NSString *bidsStr = dic[@"beanRecordids"];
                if (bidsStr.length > 1) {
                    bidsStr = [bidsStr substringToIndex:bidsStr.length -1];
                }
                // 提醒服务器把最后的逗号去掉
                NSArray  *tmpArray = [bidsStr componentsSeparatedByString:@","];
                [self.selectedArray removeAllObjects];
                for (id obj in tmpArray) {
                    [self.selectedArray addObject:obj];
                }
                self.couponSum = [dic[@"beanRecordsum"] doubleValue] / 100.0f;
                self.couponPrdaimSum = [dic[@"investMultip"] doubleValue];
                [self checkIsLegal];
                [self.youhuiTableView reloadData];
                
            }
        }
    } else if (tag.intValue == kSXTagCheckMyMoney) {
        NSString *Data = (NSString *)result;
        NSDictionary * dic = [Data objectFromJSONString];
        if ([dic[@"status"] intValue] == 1) {
            _onlyMoney = [[NSString stringWithFormat:@"%@",dic[@"cashBalance"]] doubleValue];
            _onlyMoney += _gongDouCount/100.0f;
            _keYongMoney = _onlyMoney;
            headView.KeYongMoneyLabel.text = [NSString stringWithFormat:@"¥%.2f",_keYongMoney];
            
            CGSize size = [Common getStrWitdth:headView.KeYongMoneyLabel.text TextFont:[UIFont boldSystemFontOfSize:17.0f]];
            headView.KeYongMoneyLabel.frame = CGRectMake(CGRectGetMinX(headView.KeYongMoneyLabel.frame), CGRectGetMinY(headView.KeYongMoneyLabel.frame), size.width , CGRectGetHeight(headView.KeYongMoneyLabel.frame));
            headView.totalKeYongTipLabel.frame = CGRectMake(CGRectGetMaxX(headView.KeYongMoneyLabel.frame) + 5, CGRectGetMaxY(headView.KeYongMoneyLabel.frame) - 12, 11 * 12, 12);
            headView.inputMoneyTextFieldLable.text = [NSString stringWithFormat:@"%.2f",self.touZiMoney];

            
        }
        [_superViewController reloadMainView];
    } else if (tag.intValue == kSXtagSelectBeansInterest) {
        [self.beansTableView.header endRefreshing];
        [self.beansTableView.footer endRefreshing];
        NSString *Data = (NSString *)result;
        NSDictionary * dic = [Data objectFromJSONString];
        if (!dic) {
            return;
        }
        if([dic[@"status"] intValue] != 1){
            
            [self.beansArray removeAllObjects];
            [self.beansTableView reloadData];
            
            [MBProgressHUD displayHudError:dic[@"statusdes"]];
        } else{
            beansTotalPage = [[[dic[@"pageData"] objectForKey:@"pagination"] objectForKey:@"totalPage"] intValue];
            NSArray *tmpDataArr = [dic[@"pageData"] objectForKey:@"result"];
            if(beansPageNum == 1)
            {
                [self.beansArray removeAllObjects];
                if (tmpDataArr.count < 10) {
                    [self.beansTableView.footer noticeNoMoreData];
                }
            }
            if(beansPageNum <= beansTotalPage)
            {
                beansPageNum++;
            }
            else
            {
                [self.beansTableView.footer noticeNoMoreData];
            }
            for (NSDictionary *dict in tmpDataArr) {
                [self.beansArray addObject:dict];
            }
            [self.beansTableView reloadData];
            
            UCFNoDataView  *noDataView = [_beansTableView viewWithTag:435900];
            if (noDataView) {
                [noDataView removeFromSuperview];
            }
            if (self.beansArray.count != 0) {
                _beansTableView.footer.hidden = NO;
            } else {
                noDataView = [[UCFNoDataView alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth(_beansTableView.frame), CGRectGetHeight(_beansTableView.frame)) errorTitle:@"暂无可用返息券"];
                noDataView.tag = 435900;
                [noDataView showInView:_beansTableView];
            }
        }
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
/**
 *  是否弹出警告框
 *
 *  @return YES OR NO YES 表示要弹框 NO 表示不需要弹框
 */
- (BOOL)isShowRemovePreSelectedAlert
{
    if (_listType == 1) {
        if (self.selectedArray.count == 0) {
            return NO;
        } else {
            return YES;
        }
    } else {
        if (self.beansSelectArray.count == 0) {
            return NO;
        } else {
            return YES;
        }
    }
}
- (void)showAlertView
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"返现券和返息券每次只能使用一种,请先清除之前的选择再操作" delegate:self cancelButtonTitle:@"稍后" otherButtonTitles:@"立即清除", nil];
    alert.tag = 34521;
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if (alertView.tag == 34521) {
            if (_listType == 1) {
                [self.selectedArray removeAllObjects];
                [self.youhuiTableView reloadData];
                if (isSelectedQuanXuan) {
                    slectView.selectedBtn.selected = NO;
                }
            } else {
                [self.beansSelectArray removeAllObjects];
                [self.beansTableView reloadData];
            }
            [self clearHeaderViewData];
        } else if (alertView.tag == 34522) {
            [self backToUpdatePurBidViewController];
        }
    }
}
- (void)clearHeaderViewData
{
    self.couponPrdaimSum = 0.0f;
    self.couponSum = 0.0f;
    [self checkIsLegal];
}
#pragma mark SelectCoupleCellDelegate
//选中按钮的点击事件
- (void)selctTheModelIndex:(UIButton *)button
{
    NSInteger index = button.tag;
    [self changeSelectStatue:index];
//    if ([self isShowRemovePreSelectedAlert]) {
//        [self showAlertView];
//    } else {
//        [self changeSelectStatue:index];
//    }
}
/**
 *  触发变化优惠券的选中状态的方法
 *
 *  @param index 点击索引
 */
- (void)changeSelectStatue:(NSInteger)index
{
    if (_listType == 1) {
        NSDictionary *dataDict = [self.beansArray objectAtIndex:index];
        NSString * idMark = [NSString stringWithFormat:@"%ld",(long)[[dataDict objectForKey:@"id"] integerValue]];
        DLog(@"idMark == %@",idMark);
        double xuYaoTouZiMoney = [[dataDict objectForKey:@"investMultip"] intValue];
        if ([self.beansSelectArray containsObject:idMark]) {
            [self.beansSelectArray removeAllObjects];
            annualRate = 0.0f;
            self.backInterestRate = @"0";
            xuYaoTouZiMoney = 0.00f;
        } else {
            [self.beansSelectArray removeAllObjects];
            [self.beansSelectArray addObject:idMark];
            annualRate = [[dataDict objectForKey:@"backInterestRate"] doubleValue];
            self.backInterestRate = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@"backInterestRate"]];
        }
        self.touZiMoney = [headView.inputMoneyTextFieldLable.text doubleValue];
        double repayBeans = self.touZiMoney * annualRate/100.0f * (repayPeriodDay/360.0f) * self.occupyRate;
        self.interestSum = round(repayBeans * 100)/100.0f;
        self.interestPrdaimSum = xuYaoTouZiMoney;
        [self.beansTableView reloadData];
    } else {
        NSDictionary *dataDict = [self.youHuiArray objectAtIndex:index];
        NSString * idMark = [NSString stringWithFormat:@"%ld",(long)[[dataDict objectForKey:@"id"] integerValue]];
        DLog(@"idMark == %@",idMark);
        double vaLueMoney = [[dataDict objectForKey:@"beanCount"] intValue]/100.0f;
        double xuYaoTouZiMoney = [[dataDict objectForKey:@"investMultip"] intValue];
        if ([self.selectedArray containsObject:idMark]) {
            [self.selectedArray removeObject:idMark];
            self.couponSum -= vaLueMoney;
            self.couponPrdaimSum -= xuYaoTouZiMoney;
            if (isSelectedQuanXuan == YES) {
                slectView.selectedBtn.selected = NO;
            }
        } else {
            [self.selectedArray  addObject:idMark];
            self.couponSum += vaLueMoney;
            self.couponPrdaimSum +=xuYaoTouZiMoney;
        }
        if (self.couponSum < 0.0f) {
            self.couponSum = 0.0f;
        }
        if (self.couponPrdaimSum < 0.0f) {
            self.couponPrdaimSum = 0.0f;
        }
        [self.youhuiTableView reloadData];
    }
    [self checkIsLegal];
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
