//
//  UCFGoldCashSucessController.m
//  JRGC
//
//  Created by njw on 2017/8/18.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldCashSucessController.h"
#import "CJLabel.h"
#import "UCFGoldBidSuccessHeaderView.h"
#import "AppDelegate.h"
#import "UCFInvestViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "UCFSettingItem.h"
#import "NSString+CJString.h"
@interface UCFGoldCashSucessController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic) NSArray *dataArray;
@end

@implementation UCFGoldCashSucessController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    //    if ([_sourceVc isEqualToString:@"collection"]) {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_interactivePopDisabled = YES;
    //    self.tableView.tableHeaderView = [self createHeaderView];
    //    self.tableView.tableFooterView = [self cretateFooterView];
    self.tableView.separatorColor = UIColorWithRGB(0xe3e5ea);
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    [self infoDataArray];
}
-(void)infoDataArray{
    
    NSString *liquidateGoldAmountStr = [NSString stringWithFormat:@"%@克",self.cashResuModel.liquidateGoldAmount];
    UCFSettingItem *item1 = [UCFSettingItem itemWithTitle:@"提取克重" withSubtitle:liquidateGoldAmountStr];
    NSString *dealGoldPriceStr = [NSString stringWithFormat:@"¥%@",self.cashResuModel.dealGoldPrice];
    UCFSettingItem *item2 = [UCFSettingItem itemWithTitle:@"变现金价(每克)" withSubtitle:dealGoldPriceStr];
    
    NSString *poundageStr = [NSString stringWithFormat:@"¥%@",self.cashResuModel.poundage];
    UCFSettingItem *item3 = [UCFSettingItem itemWithTitle:@"变现手续费" withSubtitle:poundageStr];
    
    NSString *liquidateMoneyStr =[NSString stringWithFormat:@"¥%@", self.cashResuModel.liquidateMoney];
    UCFSettingItem *item4 = [UCFSettingItem itemWithTitle:@"变现金额金额" withSubtitle:liquidateMoneyStr];
    if(_isPurchaseSuccess){
        self.dataArray = @[item1,item2,item3,item4];
    }
}
-(UIView *)createHeaderView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 247)];
    headView.backgroundColor = [UIColor clearColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth,237)];
    view.backgroundColor =  [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - 103) / 2, 25, 103, 103)];
    [view addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15,CGRectGetMaxY(imageView.frame)+15, ScreenWidth-30, 15)];
    titleLabel.textColor = UIColorWithRGB(0x555555);
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:titleLabel];

    NSString *messageStr = [NSString stringWithFormat:@"您的变现申请预计在1个工作日内处理变现金额将存放至您的余额账户中"];
    CGSize size =  [Common getStrHeightWithStr:messageStr AndStrFont:12 AndWidth:ScreenWidth - 30 AndlineSpacing:2];
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(titleLabel.frame) + 25, ScreenWidth-30, size.height)];
    textLabel.textColor = UIColorWithRGB(0x555555);
    textLabel.font = [UIFont systemFontOfSize:12];
    textLabel.tag = 100;
    textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    textLabel.textAlignment = NSTextAlignmentLeft;
    textLabel.numberOfLines = 0;
    NSDictionary *dic = [Common getParagraphStyleDictWithStrFont:12.0f WithlineSpacing:2.0];
    textLabel.attributedText = [NSString getNSAttributedString:messageStr labelDict:dic];
    
    [view addSubview:textLabel];
    
    if(_isPurchaseSuccess){
        imageView.image = [UIImage imageNamed:@"gold_SuccessfulPurchase_icon"];
        titleLabel.text = @"变现申请成功";
    }else{
        imageView.image = [UIImage imageNamed:@"gold_FailurePurchase_icon"];
        titleLabel.text = @"变现申请失败";
        textLabel.text = self.errorMessageStr;
    }
    headView.frame = CGRectMake(0, 0, ScreenWidth, CGRectGetMaxY(textLabel.frame)+25);
    [headView addSubview:view];
    
    [Common addLineViewColor:UIColorWithRGB(0xd8d8d8) With:view isTop:YES];
    [Common addLineViewColor:UIColorWithRGB(0xd8d8d8) With:view isTop:NO];
    
    return headView;
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
    
    NSString *buttonTitle = _isPurchaseSuccess ? @"完成" :@"重新提现";
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
    //    if(_isPurchaseSuccess){//购买成功返回主页面
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getPersonalCenterNetData" object:nil];
//    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController popToViewController:self.rootVc animated:YES];
    //    }
    //    else{//购买失败返回上一级页面
    //        [self.navigationController popViewControllerAnimated:YES];
    //    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self createHeaderView];
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [self cretateFooterView];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15+37;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 247;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_isPurchaseSuccess){
        return 44.0f;
    }else{
        CGSize size =  [Common getStrHeightWithStr:self.errorMessageStr AndStrFont:12 AndWidth:ScreenWidth - 30 AndlineSpacing:2];
        return size.height + 20;
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _isPurchaseSuccess ? self.dataArray.count : 0;
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
        CGSize size =  [Common getStrHeightWithStr:self.errorMessageStr AndStrFont:12 AndWidth:ScreenWidth - 30 AndlineSpacing:2];
        UILabel *errorLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, ScreenWidth-30, size.height)];
        errorLabel.textColor = UIColorWithRGB(0x555555);
        errorLabel.font = [UIFont systemFontOfSize:12];
        errorLabel.numberOfLines = 0;
        errorLabel.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:errorLabel];
        errorLabel.text = self.errorMessageStr;//购买错误信息
    }
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
