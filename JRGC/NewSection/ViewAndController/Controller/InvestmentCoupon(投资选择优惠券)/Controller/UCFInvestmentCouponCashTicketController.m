//
//  UCFInvestmentCouponCashTicketController.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2018/12/19.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import "UCFInvestmentCouponCashTicketController.h"
#import "BaseBottomButtonView.h"
#import "UCFSelectionCouponsCell.h"
#import "UCFInvestmentCouponModel.h"
#import "BaseTableView.h"
#import "UCFInvestmentCouponInstructionsView.h"
#import "UIImage+Compression.h"
#import "UCFNewCashParentViewController.h"
@interface UCFInvestmentCouponCashTicketController ()<UITableViewDelegate, UITableViewDataSource,BaseTableViewDelegate>

@property (nonatomic, strong) MyRelativeLayout *rootLayout;

@property (nonatomic, strong) BaseTableView *tableView;

@property (nonatomic, strong) UCFInvestmentCouponInstructionsView *instructionsView;//说明

@property (nonatomic, strong) BaseBottomButtonView *useEnterBtn;//确认使用

@property (nonatomic, strong) UIImageView *shadowView; //阴影

@property (nonatomic, strong) NSMutableArray *arryData;

@property (nonatomic, strong) UCFNewCashParentViewController *db;

@property (nonatomic, strong) UIView *noDataView;

@property (nonatomic, strong) UIView *lineView;

@end

@implementation UCFInvestmentCouponCashTicketController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.db = (UCFNewCashParentViewController *)self.parentViewController;
    // Do any additional setup after loading the view.
    self.rootLayout = [MyRelativeLayout new];
    self.rootLayout.backgroundColor = [UIColor whiteColor];
    self.rootLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
    self.view = self.rootLayout;
    [self.rootLayout addSubview:self.tableView];
    [self.rootLayout addSubview:self.useEnterBtn];
    [self.rootLayout addSubview:self.shadowView];
    
    [self.rootLayout addSubview:self.lineView];
    
    [self starCouponPopup];
}
- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.leftPos.equalTo(@(0));
        _lineView.rightPos.equalTo(@(0));
        _lineView.heightSize.equalTo(@0.5);
        _lineView.topPos.equalTo(@(0));
        _lineView.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
    }
    return _lineView;
}

-(void)starCouponPopup
{
    self.arryData = [NSMutableArray arrayWithArray:self.cashArray];
    [self.arryData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        InvestmentCouponCouponlist *newObj = obj;
        //判断投资界面带回来的值,在列表页面勾选
        [self.db.cashSelectArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            InvestmentCouponCouponlist *cashObj = obj;
            if (cashObj.couponId ==  newObj.couponId) {
                newObj.isCheck = YES;
            }
        }];
    }];
    [self.tableView cyl_reloadData];
//    if (self.db.cashSelectArr.count == 0) {
//        self.useEnterBtn.enterButton.enabled = NO;
//    } else {
//        self.useEnterBtn.enterButton.enabled = YES;
//
//    }
}

- (BaseTableView *)tableView
{
    if (nil == _tableView) {
        _tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavigationBarHeight1 + 50)];
        _tableView.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
        _tableView.delegate = self;
        _tableView.dataSource =self;
        _tableView.tableRefreshDelegate = self;
        _tableView.enableRefreshHeader = NO;
        _tableView.enableRefreshFooter = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.topPos.equalTo(@0);
        _tableView.leftPos.equalTo(@0);
        _tableView.rightPos.equalTo(@0);
        _tableView.bottomPos.equalTo(self.useEnterBtn.topPos);
        _tableView.isShowDefaultPlaceHolder = YES;
        
    }
    return _tableView;
}
- (UIView *)setupPlaceHolder
{
    UIView *noDataView = [[UIView alloc] init];
    noDataView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavigationBarHeight1 - 50 - 89 );
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((ScreenWidth - (99 * WidthScale))/2, (ScreenHeight - NavigationBarHeight1 - 50 - 89 - (60 * WidthScale))/2 -30, 99 * WidthScale, 60 *WidthScale);
    [button setBackgroundImage:[UIImage imageNamed:@"coupon_default_icon"] forState:UIControlStateNormal];
    [noDataView addSubview:button];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(button.frame) + 10, ScreenWidth, 20)];
    label.textColor = [Color color:PGColorOptionTitleGray];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"暂无优惠券";
    label.font = [Color gc_Font:18 * HeightScale];
    [noDataView addSubview:label];
    
    return noDataView;
}
- (UIImageView *)shadowView
{
    if (nil == _shadowView) {
        UIImageView *shadowView = [[UIImageView alloc] init];
        shadowView.topPos.equalTo(self.useEnterBtn.topPos).offset(-10);
        shadowView.leftPos.equalTo(self.useEnterBtn.leftPos);
        shadowView.rightPos.equalTo(self.useEnterBtn.rightPos);
        shadowView.myHeight = 10;
        UIImage *tabImag = [UIImage imageNamed:@"tabbar_shadow.png"];
        shadowView.image = [tabImag resizableImageWithCapInsets:UIEdgeInsetsMake(2, 1, 2, 1) resizingMode:UIImageResizingModeStretch];
        _shadowView = shadowView;
    }
    return _shadowView;
}
- (UCFInvestmentCouponInstructionsView *)instructionsView
{
    if (nil == _instructionsView) {
        _instructionsView= [[UCFInvestmentCouponInstructionsView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 47)];
        _instructionsView.bottomPos.equalTo(self.useEnterBtn.topPos);
        _instructionsView.widthSize.equalTo(self.rootLayout.widthSize);
        _instructionsView.heightSize.equalTo(@47);
        _instructionsView.leftPos.equalTo(self.rootLayout.leftPos);
    }
    return _instructionsView;
}
- (BaseBottomButtonView *)useEnterBtn
{
    if (nil == _useEnterBtn) {
        _useEnterBtn= [[BaseBottomButtonView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
        [_useEnterBtn.enterButton addTarget:self action:@selector(useEnterBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _useEnterBtn.bottomPos.equalTo(@0);
        _useEnterBtn.widthSize.equalTo(self.rootLayout.widthSize);
        _useEnterBtn.heightSize.equalTo(@60);
        _useEnterBtn.leftPos.equalTo(self.rootLayout.leftPos);
        
        [_useEnterBtn setButtonTitleWithString:@"确认使用"];
        [_useEnterBtn setButtonTitleWithColor:[UIColor whiteColor]];
        [_useEnterBtn setViewBackgroundColor:[UIColor whiteColor]];
        
        UIImage *backImage = [UIImage  gc_styleImageSize:CGSizeMake(ScreenWidth - 50, 40)];
//        UIImage *backGrayImage = [UIImage  gc_styleGrayImageSize:CGSizeMake(ScreenWidth - 50, 40)];

        [_useEnterBtn setButtonBackgroundImage:backImage forState:UIControlStateNormal];
//        [_useEnterBtn setButtonBackgroundImage:backGrayImage forState:UIControlStateDisabled];

        
    }
    return _useEnterBtn;
}

- (void)useEnterBtnClick
{
    [self.db confirmTheCouponOfYourChoice];
}
- (void)couponOfChoice
{
    if (self.arryData.count > 0) {
        NSMutableArray *selectArray = [NSMutableArray array];
        [self.arryData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            InvestmentCouponCouponlist *newObj = obj;
            //判断投资界面带回来的值,在列表页面勾选
            if (newObj.isCheck) {
                [selectArray addObject:newObj];
            }
                
        }];
        self.db.cashSelectArr = [selectArray mutableCopy];
    }
}
- (BOOL)calculateTheSelectedAmount
{
    //计算s每次勾选的金额相加是否大于投资金额,大于则不能勾选
    __block NSInteger moneyValue = 0;
    [self.arryData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            InvestmentCouponCouponlist *newObj = obj;
            //判断投资界面带回来的值,在列表页面勾选
            if (newObj.isCheck) {
                moneyValue += newObj.investMultip;
            }

    }];
//    if (moneyValue < 1) {
//        _useEnterBtn.enterButton.enabled = NO;
//    } else {
//        _useEnterBtn.enterButton.enabled = YES;
//    }
    if (moneyValue > [self.db.investAmt integerValue]) {
        @PGWeakObj(self);
        BlockUIAlertView *alert = [[BlockUIAlertView alloc] initWithTitle:@"提示" message:@"优惠券使用条件不足,输入的出借金额小于优惠券的最低使用金额" cancelButtonTitle:@"重新输入金额" clickButton:^(NSInteger index){
            if (index == 0) {
                //重新输入金额
                [selfWeak.db backToTheInvestmentPage];
            }
        } otherButtonTitles:@"取消"];
        [alert show];
        return NO;//勾选优惠券的金额大于输入的金额
    }
    else{
        return YES;
    }
}
#pragma mark--tableView delegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 125;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arryData  count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Listcell_cell";
    //自定义cell类
    UCFSelectionCouponsCell *cell = (UCFSelectionCouponsCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UCFSelectionCouponsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell.selectCouponsBtn addTarget:self action:@selector(checkButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    [cell refreshCellData:[self.arryData  objectAtIndex:indexPath.row]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    InvestmentCouponCouponlist *newObj = self.cashArray[indexPath.row];
    if (newObj.isCanUse) {
        UCFSelectionCouponsCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [self checkButtonClick: cell.selectCouponsBtn];
    } else {
        [self alertUnableToUseCoupons];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;//设置尾视图高度为0.01
}

- (void)moreConfusion
{
    [self alertUnableToUseCoupons];
}
//无法使用的优惠券
- (void)alertUnableToUseCoupons
{
    @PGWeakObj(self);
    BlockUIAlertView *alert = [[BlockUIAlertView alloc] initWithTitle:@"提示" message:@"优惠券使用条件不足,输入的出借金额小于优惠券的最低使用金额" cancelButtonTitle:@"重新输入金额" clickButton:^(NSInteger index){
        if (index == 0) {
            //重新输入金额
            [selfWeak.db backToTheInvestmentPage];
        }
    } otherButtonTitles:@"取消"];
    [alert show];
}
-(void)checkButtonClick:(UIButton *)btn
{
    CGPoint point = btn.center;
    point = [self.tableView convertPoint:point fromView:btn.superview];
    NSIndexPath* indexPath = [self.tableView indexPathForRowAtPoint:point];
    InvestmentCouponCouponlist *newObj = [self.arryData objectAtIndex:indexPath.row];
    
    [self setButtonType:btn withData:newObj];
    if (![self calculateTheSelectedAmount]) {
        [self setButtonType:btn withData:newObj];
    }
}
-(void)setButtonType:(UIButton *)btn withData:(InvestmentCouponCouponlist *)newObj
{
    btn.selected = !btn.selected;
    if (btn.selected)
    {
        newObj.isCheck = YES;
    }
    else
    {
        newObj.isCheck = NO;
    }
}

@end
