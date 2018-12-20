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

@interface UCFInvestmentCouponCashTicketController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) MyRelativeLayout *rootLayout;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) BaseBottomButtonView *useEnterBtn;//确认使用

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
    [self.rootLayout addSubview:self.useEnterBtn];
    
    
}
- (void)request
{
    NSString *userId = [[NSUserDefaults standardUserDefaults] valueForKey:UUID];
    if (![userId isEqualToString:@""] && userId != nil) {
        [[NetworkModule sharedNetworkModule] newPostReq:@{@"userId":userId,
                                                          @"fromSite":self.fromSite,
                                                          @"prdclaimid":self.prdclaimid,
                                                          @"investAmt":self.investAmt,
                                                          @"couponType":@"0"}//0：返现券  1：返息券
                                                    tag:kSXTagShowCouponTips owner:self signature:YES Type:SelectAccoutDefault];
        
    }
    
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    
}
-(void)beginPost:(kSXTag)tag
{
    
}

- (void)endPost:(id)result tag:(NSNumber *)tag
{
    if ([tag intValue] == kSXTagShowCouponTips)
    {
        NSMutableDictionary *dic = [result objectFromJSONString];
        [self starCouponPopup:dic];
    }
}
-(void)starCouponPopup:(NSDictionary *)dic
{
    UCFInvestmentCouponModel *model = [ModelTransition TransitionModelClassName:[UCFInvestmentCouponModel class] dataGenre:dic];
    
    NSMutableArray *overdueArray = [NSMutableArray array];
    NSMutableArray *noOverdueArray = [NSMutableArray array];
    
    
    
    [model.data.couponList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        InvestmentCouponCouponlist *newObj = obj;
        //判断投资界面带回来的值,在列表页面勾选
        if ([self.selectArray containsObject: [NSNumber numberWithInteger:newObj.couponId ]]) {
            newObj.isCheck = YES;
        }
        
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
- (UITableView *)tableView
{
    if (nil == _tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource =self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.topPos.equalTo(@0);
        _tableView.leftPos.equalTo(@0);
        _tableView.rightPos.equalTo(@0);
        _tableView.bottomPos.equalTo(self.useEnterBtn.topPos);
        
    }
    return _tableView;
}

- (BaseBottomButtonView *)useEnterBtn
{
    if (nil == _useEnterBtn) {
        _useEnterBtn= [[BaseBottomButtonView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth*0.8, 57)];
        [_useEnterBtn.enterButton addTarget:self action:@selector(useEnterBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _useEnterBtn.bottomPos.equalTo(@57);
        _useEnterBtn.widthSize.equalTo(self.rootLayout.widthSize);
        _useEnterBtn.heightSize.equalTo(@57);
        _useEnterBtn.leftPos.equalTo(self.rootLayout.leftPos);
        
        [_useEnterBtn setButtonTitleWithString:@"确认使用"];
        [_useEnterBtn setButtonTitleWithColor:[UIColor colorWithRed:219/255.0 green:81/255.0 blue:39/255.0 alpha:1.0]];
        [_useEnterBtn setViewBackgroundColor:[UIColor colorWithRed:253/255.0 green:76/255.0 blue:69/255.0 alpha:1.0]];
        [_useEnterBtn setButtonBackgroundColor:[UIColor whiteColor]];
        
    }
    return _useEnterBtn;
}

- (void)useEnterBtnClick
{
    
}
#pragma mark--tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return self.arryData.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 102;
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
