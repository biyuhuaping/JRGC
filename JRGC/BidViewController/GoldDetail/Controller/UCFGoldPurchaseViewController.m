//
//  UCFGoldPurchaseViewController.m
//  JRGC
//
//  Created by hanqiyuan on 2017/7/11.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldPurchaseViewController.h"
#import "UCFGoldMoneyBoadCell.h"
#import "NZLabel.h"
#import "UCFGoldBidSuccessViewController.h"
#import "UCFGoldCalculatorView.h"
#import "AppDelegate.h"
@interface UCFGoldPurchaseViewController ()<UITableViewDelegate,UITableViewDataSource,UCFGoldMoneyBoadCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)gotoGoldBidSuccessVC:(id)sender;

@end

@implementation UCFGoldPurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton];
    baseTitleLabel.text = @"购买";
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.tableFooterView = [self createFootView];
//    self.tableView.contentInset =  UIEdgeInsetsMake(10, 0, 0, 0);
    UITapGestureRecognizer *frade = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardDown)];
    [self.view addGestureRecognizer:frade];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section  == 2) {
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 47)];
        headerView.backgroundColor = UIColorWithRGB(0xf9f9f9);

        
        UIView *topView =[[UIView alloc] init];
        topView.backgroundColor = UIColorWithRGB(0xebebee);
        topView.frame = CGRectMake(0, 0, ScreenWidth, 10.0f);
        [Common addLineViewColor:UIColorWithRGB(0xd8d8d8) With:topView isTop:YES];
        [Common addLineViewColor:UIColorWithRGB(0xd8d8d8) With:topView isTop:NO];
        [headerView addSubview:topView];
        
        UIImageView * coupImage = [[UIImageView alloc] init];
        coupImage.image = [UIImage imageNamed:@"invest_icon_coupon.png"];
        coupImage.tag = 2999;
        coupImage.frame = CGRectMake(13, 10 + (37 - 25)/2.0f, 25, 25);
        [headerView addSubview:coupImage];
        
        UILabel *commendLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(coupImage.frame) + 7, 10 + (37 - 14)/2, 80, 14)];
        commendLabel.text = @"使用优惠券";
        commendLabel.font = [UIFont systemFontOfSize:14.0f];
        commendLabel.textColor = UIColorWithRGB(0x555555);
        [headerView addSubview:commendLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 47, ScreenWidth, 0.5)];
        lineView.backgroundColor = UIColorWithRGB(0xe3e5ea);
        [headerView addSubview:lineView];
        return headerView;
    }else{
        UIView *topView =[[UIView alloc] init];
        topView.backgroundColor = UIColorWithRGB(0xebebee);
        topView.frame = CGRectMake(0, 0, ScreenWidth, 10.0f);
//        [Common addLineViewColor:UIColorWithRGB(0xd8d8d8) With:topView isTop:YES];
//        [Common addLineViewColor:UIColorWithRGB(0xd8d8d8) With:topView isTop:NO];
        return topView;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return 274;
    }else {
        return 44;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        return 47;
    }
    return 10;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
        {
            return 1;
        }
            break;
        case 1:
        {
            return 1;
        }
            break;
        case 2:
        {
            return 1;
        }

        default:
            break;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:cellId];
    if (indexPath.section == 0) {
      
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        }
        cell.textLabel.text = @"投标页面";
         return cell;
    }else if (indexPath.section == 1){
        static NSString *cellId = @"UCFGoldMoneyBoadCell";
        UCFGoldMoneyBoadCell *cell = [tableView  dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"UCFGoldMoneyBoadCell" owner:nil options:nil] firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.delegate = self;
         return cell;
    }else if (indexPath.section == 2){
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        }
        cell.textLabel.text = @"优惠劵";
    }
    return cell;
}
#pragma 显示黄金协议
- (UIView *)createFootView
{
    UIView *footView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 98)];
//    footView.backgroundColor = UIColorWithRGB(0xebebee);
    footView.userInteractionEnabled = YES;
    __weak typeof(self) weakSelf = self;
    
    NSString * totalStr1 = @"黄金价格实时波动，在0.50元的波动范围内成交，成交瞬间系统价格不高于281.00元/克则立即为你买入";
    NZLabel *firstLabel = [[NZLabel alloc] init];
    firstLabel.font = [UIFont systemFontOfSize:13.0f];
    CGSize size1 = [Common getStrHeightWithStr:totalStr1 AndStrFont:13 AndWidth:ScreenWidth- 23 -15];
    firstLabel.numberOfLines = 0;
    firstLabel.frame = CGRectMake(23,8, ScreenWidth - 23 - 15, size1.height);
    firstLabel.text = totalStr1;
    firstLabel.userInteractionEnabled = YES;
    firstLabel.textColor = UIColorWithRGB(0x999999);
    
    [firstLabel setFontColor:UIColorWithRGB(0x666666) string:@"0.50元"];
    [firstLabel setFontColor:UIColorWithRGB(0x666666) string:@"281.00元/克"];
    [footView addSubview:firstLabel];
    
    UIImageView * imageView1 = [[UIImageView alloc] init];
    imageView1.frame = CGRectMake(CGRectGetMinX(firstLabel.frame) - 7, CGRectGetMinY(firstLabel.frame) + 6, 5, 5);
    imageView1.image = [UIImage imageNamed:@"point.png"];
    [footView addSubview:imageView1];
    
    NZLabel *riskProtocolLabel = [[NZLabel alloc] init];
    riskProtocolLabel.font = [UIFont systemFontOfSize:12.0f];
    
    CGSize size2 = [Common getStrHeightWithStr:@"本人同意签署《黄金产品买卖及委托管理服务协议》" AndStrFont:13 AndWidth:ScreenWidth- 23 -15];
    riskProtocolLabel.numberOfLines = 0;
    riskProtocolLabel.frame = CGRectMake(23,  CGRectGetMaxY(firstLabel.frame)+5, ScreenWidth- 23 -15, size2.height);
    riskProtocolLabel.text = @"本人同意签署《黄金产品买卖及委托管理服务协议》";
    riskProtocolLabel.userInteractionEnabled = YES;
    riskProtocolLabel.textColor = UIColorWithRGB(0x999999);
    
    [riskProtocolLabel addLinkString:@"《黄金产品买卖及委托管理服务协议》" block:^(ZBLinkLabelModel *linkModel) {
        [weakSelf showGoldDelegate:linkModel];
    }];
    [riskProtocolLabel setFontColor:UIColorWithRGB(0x4aa1f9) string:@"《黄金产品买卖及委托管理服务协议》"];
    
    UIImageView * imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(CGRectGetMinX(riskProtocolLabel.frame) - 7, CGRectGetMinY(riskProtocolLabel.frame) + size2.height/2, 5, 5);
    imageView.image = [UIImage imageNamed:@"point.png"];
    
    [footView addSubview:riskProtocolLabel];
    [footView addSubview:imageView];
    
    return footView;
}
#pragma 显示黄金协议
-(void)showGoldDelegate:(ZBLinkLabelModel *)linkModel{
    
    
}

#pragma mark - UCFGoldMoneyBoadCellDelegate
#pragma mark 显示计算器
-(void)showGoldCalculatorView
{
    [self.view endEditing:YES];
    UCFGoldMoneyBoadCell *cell = (UCFGoldMoneyBoadCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
//    NSString *investMoney = cell.inputMoneyTextFieldLable.text;
//    if (cell.inputMoneyTextFieldLable.text.length == 0 || [cell.inputMoneyTextFieldLable.text isEqualToString:@"0"] || [cell.inputMoneyTextFieldLable.text isEqualToString:@"0.0"] || [cell.inputMoneyTextFieldLable.text isEqualToString:@"0.00"]) {
//        [MBProgressHUD displayHudError:[NSString stringWithFormat:@"请输入%@金额",_wJOrZxStr]];
//        return;
//    }
    UCFGoldCalculatorView * view = [[[NSBundle mainBundle]loadNibNamed:@"UCFGoldCalculatorView" owner:nil options:nil] firstObject];
    view.tag = 173924;
    view.frame = CGRectMake(0, 0, ScreenWidth,ScreenHeight);
//    view.center = bgView.center;
//    view.accoutType = self.accoutType;
//    [view reloadViewWithData:_dataDict AndNowMoney:investMoney];
//    [bgView addSubview:view];
    
    AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    view.center = app.window.center;
    [app.window addSubview:view];
    
}
#pragma mark -黄金充值
-(void)gotoGoldRechargeVC{
    
}
#pragma mark -全投
-(void)clickAllInvestmentBtn{
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [self.tableView endEditing:YES];
}
-(void)keyboardDown{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)gotoGoldBidSuccessVC:(id)sender {
    
    UCFGoldBidSuccessViewController *goldAuthorizationVC = [[UCFGoldBidSuccessViewController alloc]initWithNibName:@"UCFGoldBidSuccessViewController" bundle:nil];
    [self.navigationController pushViewController:goldAuthorizationVC  animated:YES];

}
@end
