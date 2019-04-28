//
//  UCFInvestmentCouponInterestTicketController.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2018/12/19.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import "UCFInvestmentCouponInterestTicketController.h"
#import "BaseBottomButtonView.h"
#import "UCFSelectionCouponsCell.h"
#import "UCFInvestmentCouponModel.h"
#import "BaseTableView.h"
#import "UCFInvestmentCouponInstructionsView.h"
#import "UIImage+Compression.h"
#import "UCFNewCouponParentViewController.h"
@interface UCFInvestmentCouponInterestTicketController ()<UITableViewDelegate, UITableViewDataSource,BaseTableViewDelegate>

@property (nonatomic, strong) MyRelativeLayout *rootLayout;

@property (nonatomic, strong) BaseTableView *tableView;

@property (nonatomic, strong) UCFInvestmentCouponInstructionsView *instructionsView;//说明

@property (nonatomic, strong) BaseBottomButtonView *useEnterBtn;//确认使用

@property (nonatomic, strong) UIImageView *shadowView; //阴影

@property (nonatomic, strong) NSMutableArray *arryData;

@property (nonatomic, strong) NSIndexPath *oldIndexPath;//记录上一次的选择

@property (nonatomic, strong)UCFNewCouponParentViewController *db;
@end

@implementation UCFInvestmentCouponInterestTicketController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.db = (UCFNewCouponParentViewController *)self.parentViewController;


    self.rootLayout = [MyRelativeLayout new];
    self.rootLayout.backgroundColor = [UIColor whiteColor];
    self.rootLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
    self.view = self.rootLayout;
    
    [self.rootLayout addSubview:self.tableView];
    [self.rootLayout addSubview:self.instructionsView];
    [self.rootLayout addSubview:self.useEnterBtn];
    [self.rootLayout addSubview:self.shadowView];
    
    [self starCouponPopup];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

-(void)starCouponPopup
{
    self.arryData = [NSMutableArray arrayWithArray:self.couponArray];
    [self.arryData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        InvestmentCouponCouponlist *newObj = obj;
        //判断投资界面带回来的值,在列表页面勾选
        [self.db.couponSelectArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            InvestmentCouponCouponlist *cashObj = obj;
            if (cashObj.couponId ==  newObj.couponId) {
                newObj.isCheck = YES;
            }
        }];
    }];
    if (self.db.couponSelectArr.count == 0) {
        _useEnterBtn.enterButton.enabled = NO;
    } else {
        _useEnterBtn.enterButton.enabled = YES;
    }
    [self.tableView cyl_reloadData];
}

- (BaseTableView *)tableView
{
    if (nil == _tableView) {
        _tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, TableViewHeight)];
        _tableView.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
        _tableView.delegate = self;
        _tableView.dataSource =self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.enableRefreshHeader = NO;
        _tableView.enableRefreshFooter = NO;
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
        _instructionsView= [[UCFInvestmentCouponInstructionsView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        _instructionsView.bottomPos.equalTo(self.useEnterBtn.topPos);
        _instructionsView.widthSize.equalTo(self.rootLayout.widthSize);
        _instructionsView.heightSize.equalTo(@40);
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
        UIImage *backGrayImage = [UIImage  gc_styleGrayImageSize:CGSizeMake(ScreenWidth - 50, 40)];
        
        [_useEnterBtn setButtonBackgroundImage:backImage forState:UIControlStateNormal];
        [_useEnterBtn setButtonBackgroundImage:backGrayImage forState:UIControlStateDisabled];
    }
    return _useEnterBtn;
}

- (void)useEnterBtnClick
{
    [self.db confirmTheCouponOfYourChoice];
    
}
- (void)couponOfChoic
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
        self.db.couponSelectArr = [selectArray mutableCopy];
    }
}
#pragma mark--tableView delegate



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arryData count];
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
    
    [cell refreshCellData:[self.arryData objectAtIndex:indexPath.row]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    InvestmentCouponCouponlist *newObj = self.couponArray[indexPath.row];
    
    if (newObj.isCanUse) {
        UCFSelectionCouponsCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [self checkButtonClick: cell.selectCouponsBtn];
    } else {
        [self alertUnableToUseCoupons];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
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
    
    btn.selected = !btn.selected;
    if (btn.selected)
    {
        newObj.isCheck = YES;
    }
    else
    {
        newObj.isCheck = NO;
    }
    
    
    if (self.oldIndexPath == nil)
    {
        //没有勾选,但是投资页面传来的需要勾选
        if (self.db.couponSelectArr != nil && self.db.couponSelectArr.count != 0) {
            
            [self.db.couponSelectArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                InvestmentCouponCouponlist *newObj = obj;
                //判断投资界面带回来的值,在列表页面勾选
                [self.arryData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    InvestmentCouponCouponlist *cashObj = obj;
                    if ( cashObj.couponId ==  newObj.couponId) {
                        cashObj.isCheck = NO;
                        *stop = YES;
                        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:idx inSection:0];
                        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                    }
                }];
                
            }];
        }
    }
    else
    {
        //上次的勾选有记录,由于是单选,所以点击新的cell,需要把老的cell的按钮取消勾选
        if (self.oldIndexPath == indexPath) {
            //点击的是同一个cell上的勾选
            
        }
        else
        {
            //点击的不是同一个cell上的勾选,需要把上一次的取消掉
            InvestmentCouponCouponlist *lastObj = [self.arryData objectAtIndex:self.oldIndexPath.row];
            lastObj.isCheck = NO;
            NSIndexPath *newIndexPath=[NSIndexPath indexPathForRow:self.oldIndexPath.row inSection:0];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:newIndexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            
        }
    }
    self.oldIndexPath = indexPath;
    if (newObj.isCheck) {
        _useEnterBtn.enterButton.enabled = YES;
    } else {
        _useEnterBtn.enterButton.enabled = NO;
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

@end
