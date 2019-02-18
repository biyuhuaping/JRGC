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
#import "UCFInvestmentCouponController.h"
#import "BaseTableView.h"
#import "UCFNoDataView.h"
#import "UCFInvestmentCouponInstructionsView.h"

@interface UCFInvestmentCouponCashTicketController ()<UITableViewDelegate, UITableViewDataSource,BaseTableViewDelegate>

@property (nonatomic, strong) MyRelativeLayout *rootLayout;

@property (nonatomic, strong) BaseTableView *tableView;

@property (nonatomic, strong) UCFInvestmentCouponInstructionsView *instructionsView;//说明

@property (nonatomic, strong) BaseBottomButtonView *useEnterBtn;//确认使用

@property (nonatomic, strong) UIImageView *shadowView; //阴影

@property (nonatomic, strong) NSMutableArray *arryData;

@end

@implementation UCFInvestmentCouponCashTicketController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.rootLayout = [MyRelativeLayout new];
    self.rootLayout.backgroundColor = [UIColor whiteColor];
    self.rootLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
    self.view = self.rootLayout;

    [self.rootLayout addSubview:self.tableView];
    [self.rootLayout addSubview:self.instructionsView];
    [self.rootLayout addSubview:self.useEnterBtn];
    [self.rootLayout addSubview:self.shadowView];
    [self.tableView beginRefresh];
}
- (void)request
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *userId = SingleUserInfo.loginData.userInfo.userId;
    if (![userId isEqualToString:@""] && userId != nil) {
        [[NetworkModule sharedNetworkModule] newPostReq:@{@"userId":userId,
                                                          @"prdclaimid":self.db.prdclaimid,
                                                          @"investAmt":self.db.investAmt,
                                                          @"couponType":@"0"}//0：返现券  1：返息券
                                                    tag:kSXTagInvestCashTicktList owner:self signature:YES Type:SelectAccoutTypeP2P];
        
    }
}
- (void)refreshTableViewHeader{
    
    [self request];
    
}

-(void)beginPost:(kSXTag)tag
{
    
}

- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    if ([tag intValue] == kSXTagInvestCashTicktList)
    {
        NSMutableDictionary *dic = [result objectFromJSONString];
        [self starCouponPopup:dic];
    }
    [self.tableView endRefresh];
    [self.tableView cyl_reloadData];
}
- (void)errorPost:(NSError *)err tag:(NSNumber *)tag
{
    [self.tableView endRefresh];
    [self.tableView cyl_reloadData];
}
-(void)starCouponPopup:(NSDictionary *)dic
{
    UCFInvestmentCouponModel *model = [ModelTransition TransitionModelClassName:[UCFInvestmentCouponModel class] dataGenre:dic];
    
    NSMutableArray *overdueArray = [NSMutableArray array];
    NSMutableArray *noOverdueArray = [NSMutableArray array];
    self.arryData = [NSMutableArray array];
    
    
    [model.data.couponList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        InvestmentCouponCouponlist *newObj = obj;
        //判断投资界面带回来的值,在列表页面勾选
        [self.db.cashSelectArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            InvestmentCouponCouponlist *cashObj = obj;
            if ( cashObj.couponId ==  newObj.couponId) {
                newObj.isCheck = YES;
            }
        }];
        //把可用券和不可用券拆分成两个数组
        if (newObj.isCanUse)
        {
            [overdueArray addObject:obj];
        }
        else
        {
            [noOverdueArray addObject:obj];
        }
    }];
    
    [self.arryData addObject:overdueArray];
    [self.arryData addObject:noOverdueArray];
    
}

- (BaseTableView *)tableView
{
    if (nil == _tableView) {
        _tableView = [[BaseTableView alloc]init];
        _tableView.backgroundColor = UIColorWithRGB(0xebebee);
        _tableView.delegate = self;
        _tableView.dataSource =self;
        _tableView.tableRefreshDelegate= self;
        _tableView.enableRefreshFooter = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.topPos.equalTo(@0);
        _tableView.leftPos.equalTo(@0);
        _tableView.rightPos.equalTo(@0);
        _tableView.bottomPos.equalTo(self.instructionsView.topPos);
        
    }
    return _tableView;
}
- (UIImageView *)shadowView
{
    if (nil == _shadowView) {
        UIImageView *shadowView = [[UIImageView alloc] init];
        shadowView.topPos.equalTo(self.instructionsView.topPos).offset(-2);
        shadowView.leftPos.equalTo(self.instructionsView.leftPos);
        shadowView.rightPos.equalTo(self.instructionsView.rightPos);
        shadowView.myHeight = 2;
        UIImage *tabImag = [UIImage imageNamed:@"tabbar_shadow.png"];
        shadowView.image = [tabImag resizableImageWithCapInsets:UIEdgeInsetsMake(2, 1, 2, 1) resizingMode:UIImageResizingModeStretch];
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
        _useEnterBtn= [[BaseBottomButtonView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 57)];
        [_useEnterBtn.enterButton addTarget:self action:@selector(useEnterBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _useEnterBtn.bottomPos.equalTo(@0);
        _useEnterBtn.widthSize.equalTo(self.rootLayout.widthSize);
        _useEnterBtn.heightSize.equalTo(@57);
        _useEnterBtn.leftPos.equalTo(self.rootLayout.leftPos);
        
        [_useEnterBtn setButtonTitleWithString:@"确认使用"];
        [_useEnterBtn setButtonTitleWithColor:[UIColor whiteColor]];
        [_useEnterBtn setViewBackgroundColor:[UIColor whiteColor]];
        [_useEnterBtn setButtonBackgroundColor:UIColorWithRGB(0xFD4D4C)];
        
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
            
            NSMutableArray *array = obj;
            
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                InvestmentCouponCouponlist *newObj = obj;
                //判断投资界面带回来的值,在列表页面勾选
                if (newObj.isCheck ) {
                    [selectArray addObject:newObj];
                }
                
            }];
        }];
        self.db.cashSelectArr = [selectArray mutableCopy];
    }
}
- (BOOL)calculateTheSelectedAmount
{
    //计算s每次勾选的金额相加是否大于投资金额,大于则不能勾选
    __block NSInteger moneyValue = 0;
    [self.arryData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSMutableArray *array = obj;
        
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            InvestmentCouponCouponlist *newObj = obj;
            //判断投资界面带回来的值,在列表页面勾选
            if (newObj.isCheck ) {
                moneyValue += newObj.investMultip;
            }
            
        }];
    }];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return self.arryData.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([[self.arryData objectAtIndex:indexPath.section] count] >0 ) {
        if ( indexPath.row == [[self.arryData objectAtIndex:indexPath.section] count] -1) {
            return 112;
        }
        else
        {
            return 97;
        }
    }
    else{
        return 97;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.arryData objectAtIndex:section] count];
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

    [cell refreshCellData:[[self.arryData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        [self alertUnableToUseCoupons];
    }else{
        UCFSelectionCouponsCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [self checkButtonClick: cell.selectCouponsBtn];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 47)];//创建一个视图
    headerView.backgroundColor = UIColorWithRGB(0xEBEBEE);

    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0,10,ScreenWidth,37);
    view.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1.0];
    [headerView addSubview:view];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 95, 37)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:13.0];
    headerLabel.textColor = UIColorWithRGB(0x555555);
    [view addSubview:headerLabel];
    
    if (section == 0) {
        headerLabel.text = @"可使用优惠券";
    }
    else
    {
        headerLabel.text = @"不可使用优惠券";
        UIButton *button = [UIButton buttonWithType:0];
        button.frame = CGRectMake(CGRectGetMaxX(headerLabel.frame), (headerLabel.frame.size.height -20)/2, 20, 20);
        [button setImage:[UIImage imageNamed:@"icon_question.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(moreConfusion) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
    }
    
    if ([[self.arryData objectAtIndex:section] count] == 0) {
        return nil;
    }else
    {
        return headerView;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([[self.arryData objectAtIndex:section] count] == 0) {
        return 0.01;
    }else
    {
        return 47;
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
//    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UCFSelectionCouponsCell *)btn.superview.superview];
    //获取cell在屏幕中位置
    //    CGRect rectInTableView = [_rightView rectForRowAtIndexPath:indexPath];//cell在tabview的尺寸
    //    CGRect rect = [_rightView convertRect:rectInTableView toView:[_rightView superview]];
    //    cellFrame=rect;
    CGPoint point = btn.center;
    point = [self.tableView convertPoint:point fromView:btn.superview];
    NSIndexPath* indexPath = [self.tableView indexPathForRowAtPoint:point];
    InvestmentCouponCouponlist *newObj = [[self.arryData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
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
        [btn setImage:[UIImage imageNamed:@"invest_btn_select_highlight"] forState:UIControlStateNormal];
    }
    else
    {
        newObj.isCheck = NO;
        [btn setImage:[UIImage imageNamed:@"invest_btn_select_normal"] forState:UIControlStateNormal];
    }
}

@end
