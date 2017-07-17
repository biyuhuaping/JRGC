//
//  UCFGoldBidSuccessViewController.m
//  JRGC
//
//  Created by hanqiyuan on 2017/7/12.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldBidSuccessViewController.h"
#import "UCFGoldBidSuccessHeaderView.h"
#import "AppDelegate.h"
#import "UCFInvestViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "UCFSettingItem.h"
@interface UCFGoldBidSuccessViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign ,nonatomic) BOOL isPurchaseSuccess;//是否购买成功
@property (strong,nonatomic) NSArray *dataArray;
@end

@implementation UCFGoldBidSuccessViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    //    if ([_sourceVc isEqualToString:@"collection"]) {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    //    } else {
    //        [self.navigationController setNavigationBarHidden:YES animated:animated];
    //    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.fd_interactivePopDisabled = YES;
    self.isPurchaseSuccess = YES;
    self.tableView.tableHeaderView = [self createHeaderView];
    self.tableView.tableFooterView = [self cretateFooterView];
    self.tableView.separatorColor = UIColorWithRGB(0xe3e5ea);
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    [self infoDataArray];
}
-(void)infoDataArray{
    
    NSString *nmPrdClaimNameStr = [_dataDict objectSafeForKey:@"nmPrdClaimName"];
    UCFSettingItem *item1 = [UCFSettingItem itemWithTitle:@"项目名称" withSubtitle:nmPrdClaimNameStr];
    NSString *purchaseGoldAmountStr = [NSString stringWithFormat:@"%@克",[_dataDict objectSafeForKey:@"purchaseGoldAmount"]];
    UCFSettingItem *item2 = [UCFSettingItem itemWithTitle:@"买入克重" withSubtitle:purchaseGoldAmountStr];
     NSString *dealGoldPriceStr = [NSString stringWithFormat:@"¥%@",[_dataDict objectSafeForKey:@"dealGoldPrice"]];
    UCFSettingItem *item3 = [UCFSettingItem itemWithTitle:@"成交金价" withSubtitle:dealGoldPriceStr];
     NSString *poundageStr =[NSString stringWithFormat:@"¥%@", [_dataDict objectSafeForKey:@"poundage"]];
    UCFSettingItem *item4 = [UCFSettingItem itemWithTitle:@"手续费" withSubtitle:poundageStr];
     NSString *purchaseMoneyStr = [NSString stringWithFormat:@"¥%@",[_dataDict objectSafeForKey:@"purchaseMoney"]];
    UCFSettingItem *item5 = [UCFSettingItem itemWithTitle:@"支付金额" withSubtitle:purchaseMoneyStr];
    
    self.dataArray = @[item1,item2,item3,item4,item5];
}
-(UIView *)createHeaderView{
    UCFGoldBidSuccessHeaderView *headerView = [[[NSBundle mainBundle]loadNibNamed:@"UCFGoldBidSuccessHeaderView" owner:nil options:nil]firstObject];
    headerView.frame =  CGRectMake(0, 0, ScreenWidth, 207.5);
    headerView.backgroundColor = [UIColor clearColor];
    
    if(_isPurchaseSuccess){
        headerView.headerImageView.image = [UIImage imageNamed:@"gold_SuccessfulPurchase_icon"];
        headerView.headerTitleLabel.text = @"购买成功";
    }else{
        headerView.headerImageView.image = [UIImage imageNamed:@"gold_FailurePurchase_icon"];
        headerView.headerTitleLabel.text = @"购买失败";
    }
   
    return headerView;
}
- (UIView *)cretateFooterView
{
    UIView *investBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 15+37)];
    investBaseView.backgroundColor = [UIColor clearColor];
    investBaseView.tag = 9000;
    
    [Common addLineViewColor:UIColorWithRGB(0xd8d8d8) With:investBaseView isTop:YES];
    UIButton *investmentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    investmentButton.frame = CGRectMake(XPOS, 15,ScreenWidth - XPOS*2, 37);
    investmentButton.titleLabel.font = [UIFont systemFontOfSize:16];
    investmentButton.backgroundColor = UIColorWithRGB(0xffc027);
    investmentButton.layer.cornerRadius = 2.0;
    investmentButton.layer.masksToBounds = YES;
    
    NSString *buttonTitle = _isPurchaseSuccess ? @"完成" :@"重新购买";
    [investmentButton setTitle:buttonTitle forState:UIControlStateNormal];
    [investmentButton addTarget:self action:@selector(gotoMainView) forControlEvents:UIControlEventTouchUpInside];
    [investBaseView addSubview:investmentButton];
    
    return investBaseView;
//    UIImageView *shadowView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, 10)];
//    UIImage *tabImag = [UIImage imageNamed:@"tabbar_shadow.png"];
//    shadowView.image = [tabImag resizableImageWithCapInsets:UIEdgeInsetsMake(2, 1, 2, 1) resizingMode:UIImageResizingModeStretch];
//    [investBaseView addSubview:shadowView];
}
-(void)gotoMainView{
    if(_isPurchaseSuccess){//购买成功返回主页面
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{//购买失败返回上一级页面
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44.0f;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _isPurchaseSuccess ? self.dataArray.count : 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellindifier = @"secondIndexPath";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellindifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellindifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = UIColorWithRGB(0x555555);
        cell.detailTextLabel.textColor = UIColorWithRGB(0x555555);
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    }
    if (_isPurchaseSuccess) {
     
        if (indexPath.row < self.dataArray.count) {
            UCFSettingItem *item = self.dataArray[indexPath.row];
            cell.textLabel.text = item.title;
            cell.detailTextLabel.text = item.subtitle;
        }
    }else{
        UILabel *errorLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
        errorLabel.textColor = UIColorWithRGB(0x555555);
        errorLabel.font = [UIFont systemFontOfSize:14];
        errorLabel.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:errorLabel];
        errorLabel.text = @"银行卡余额不足";//购买错误信息
    }

    return cell;
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

@end
