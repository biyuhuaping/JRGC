//
//  UCFHuiShangChooseBankViewController.m
//  JRGC
//
//  Created by 狂战之巅 on 16/8/15.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFHuiShangChooseBankViewController.h"
#import "UCFHuiShangChooseBankViewCell.h"
#import "DBCellConfig.h"
#import "UCFNoDataView.h"
#import "BlockUIAlertView.h"
@interface UCFHuiShangChooseBankViewController ()

@property (nonatomic, strong) NSMutableArray *bankList;

@property (nonatomic, strong) NSMutableArray *cellList;

@property (nonatomic, strong) UCFNoDataView *noDataView;

@property (nonatomic, strong) UIView *footView;
@property (nonatomic, strong) UILabel *footLabel;
@end

@implementation UCFHuiShangChooseBankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.bankList = [NSMutableArray array];
    self.cellList = [NSMutableArray array];
    baseTitleLabel.text = @"选择开户行";
    [self addLeftButton];
    self.noDataView = [[UCFNoDataView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) errorTitle:@"暂无数据"];
    [self request];//请求银行数据
    [self.tableView addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(request)];
}

- (void)setFootView
{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 86)];
    self.tableView.tableFooterView = footView;
    
    UIView *recView1 = [[UIView alloc] initWithFrame:CGRectMake(15, 20, 4, 4)];
    recView1.backgroundColor = [DBColor colorWithHexString:@"999999" andAlpha:1.0];
    recView1.layer.masksToBounds = YES;
    recView1.layer.cornerRadius = recView1.frame.size.width/2;
    recView1.tag = 200;
    [footView addSubview:recView1];
    
    UIView *recView2 = [[UIView alloc] initWithFrame:CGRectMake(15, 52, 4, 4)];
    recView2.backgroundColor = [DBColor colorWithHexString:@"999999" andAlpha:1.0];
    recView2.layer.masksToBounds = YES;
    recView2.layer.cornerRadius = recView1.frame.size.width/2;
    recView2.tag = 201;
    [footView addSubview:recView2];
    
    self.footLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 15, ScreenWidth - 25*2, 70)];
    self.footLabel.numberOfLines = 0;
    self.footLabel.font = [UIFont systemFontOfSize:13];
    self.footLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.footLabel.textAlignment = NSTextAlignmentLeft;
    self.footLabel.textColor = UIColorWithRGB(0x999999);
    self.footLabel.tag = 202;
    [footView addSubview:self.footLabel];
}

#pragma mark - 下拉处理
- (void)isHaseData:(BOOL)haseData
{
    if (haseData)
    {
        [self setFootView];
    }
    else
    {
        self.footView  = nil;
    }
}

- (void)beginRefresh
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)endRefresh
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

#pragma mark - 请求处理
- (void)request
{
    NSString *userId = [[NSUserDefaults standardUserDefaults] valueForKey:UUID];

    [[NetworkModule sharedNetworkModule] newPostReq:@{@"userId":userId} tag:kSXTagChooseBankList owner:self signature:YES Type:self.accoutType];
    [self beginRefresh];
}

- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [self.tableView.header endRefreshing];
    [self endRefresh];
    if ([tag intValue] == kSXTagChooseBankList)
    {
        NSMutableDictionary *dic = [result objectFromJSONString];
        BOOL ret = [dic[@"ret"] boolValue];
        if (ret)//&& [dic[@"data"][@"bankList"]count] > 0 && [dic[@"data"][@"quickBankList"]count] > 0
        {
            //请求成功
            [self.noDataView hide];
            [self isHaseData:YES];
            self.footLabel.text = dic[@"data"][@"description"];
            NSDictionary * dic2 = [NSDictionary dictionaryWithObjectsAndKeys:self.footLabel.font, NSFontAttributeName,nil];
            CGSize titleSize2 = [self.footLabel.text boundingRectWithSize:CGSizeMake(ScreenWidth - 25*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:dic2 context:nil].size;
            self.footLabel.frame = CGRectMake(25, 15, ScreenWidth - 25*2, titleSize2.height);
            [self selectBankList:dic];
            [self.tableView reloadData];
        }
        else
        {
            //失败
            [self isHaseData:NO];
            [self.noDataView showInView:self.tableView];
        }
    }
}

- (void)selectBankList:(NSDictionary *)data
{
    [self.cellList removeAllObjects];
    [self.bankList removeAllObjects];
    
    //[self.bankList addObjectsFromArray:[dic objectForKey:@"bankList"]];
    //[self.bankList addObjectsFromArray:[dic objectForKey:@"quickBankList"]];
    NSDictionary *dic = data[@"data"] ;
    if ([dic[@"quickBankList"] count] > 0)
    {
        NSMutableArray *dataAry = [NSMutableArray array];
        NSMutableArray *cellAry = [NSMutableArray array];
        
        for (int i = 0; i < [dic[@"quickBankList"] count]; i++)
        {
            NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:[dic objectForKey:@"quickBankList"][i]];
            [dataDic setObject:@"yes" forKey:@"isQuick"];
            DBCellConfig *cellConfig = [DBCellConfig cellConfigWithClassName:NSStringFromClass([UCFHuiShangChooseBankViewCell class]) title:@"quickBank" showInfoMethod:@selector(showInfo:) heightOfCell:56];
            
            [dataAry addObject:dataDic];
            [cellAry addObject:cellConfig];
        }
        [self.cellList addObject:cellAry];
        [self.bankList addObject:dataAry];
    }
    
    if ([dic[@"bankList"] count] > 0)
    {
        NSMutableArray *dataAry = [NSMutableArray array];
        NSMutableArray *cellAry = [NSMutableArray array];
        
        for (int i = 0; i < [dic[@"bankList"] count]; i++)
        {
            NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:[dic objectForKey:@"bankList"][i]];
            [dataDic setObject:@"no" forKey:@"isQuick"];
            DBCellConfig *cellConfig = [DBCellConfig cellConfigWithClassName:NSStringFromClass([UCFHuiShangChooseBankViewCell class]) title:@"bank" showInfoMethod:@selector(showInfo:) heightOfCell:54];
            
            [dataAry addObject:dataDic];
            [cellAry addObject:cellConfig];
        }
        
        [self.cellList addObject:cellAry];
        [self.bankList addObject:dataAry];
    }
    [self.tableView reloadData];
}


- (void)errorPost:(NSError *)err tag:(NSNumber *)tag
{
    [self.tableView.header endRefreshing];
    [self isHaseData:NO];
}


///*!
 //* @brief 把格式化的JSON格式的字符串转换成字典
 //* @param jsonString JSON格式的字符串
 //* @return 返回字典
 //*/
//- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    //if (jsonString == nil) {
        //return nil;
    //}
    
    //NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    //NSError *err;
    //NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        //options:NSJSONReadingMutableContainers
                                                          //error:&err];
    //if(err) {
        //NSLog(@"json解析失败：%@",err);
        //return nil;
    //}
    //return dic;
//}





#pragma mark - tableView的delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DBCellConfig *cellConfig = self.cellList[indexPath.section][indexPath.row];
    return cellConfig.heightOfCell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.bankList.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.bankDelegate && [self.bankDelegate respondsToSelector:@selector(chooseBankData:)])
    {
        if (![self.bankList[indexPath.section][indexPath.row][@"isQuick"] isEqualToString:@"yes"] )
        {
            //不支持快捷
            BlockUIAlertView *alert_bankbrach= [[BlockUIAlertView alloc]initWithTitle:@"提示" message:@"该银行不支持快捷充值，仅支持网银充值或转账的方式进行充值，确认绑定该银行卡吗？" cancelButtonTitle:@"我再想想" clickButton:^(NSInteger index) {
                if (index == 1) {
                    //支持快捷支付
                    [self.bankDelegate chooseBankData:self.bankList[indexPath.section][indexPath.row]];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            } otherButtonTitles:@"继续绑卡"];
            [alert_bankbrach show];

        }
        else
        {
            //支持快捷支付
            if (![self.bankList[indexPath.section][indexPath.row][@"isQuick"] boolValue])
            {
                //不是推荐的银行,需要进行提示
                BlockUIAlertView *alert_bankbrach= [[BlockUIAlertView alloc]initWithTitle:@"提示" message:@"该银行快捷充值的额度较低，确认绑定该银行卡吗？" cancelButtonTitle:@"我再想想" clickButton:^(NSInteger index) {
                    if (index == 1) {
                        //支持快捷支付
                        [self.bankDelegate chooseBankData:self.bankList[indexPath.section][indexPath.row]];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                } otherButtonTitles:@"继续绑卡"];
                [alert_bankbrach show];
            }
            [self.bankDelegate chooseBankData:self.bankList[indexPath.section][indexPath.row]];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.bankList[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DBCellConfig *cellConfig = self.cellList[indexPath.section][indexPath.row];
    
    // 拿到对应cell并根据模型显示
    NSDictionary *dic = self.bankList[indexPath.section][indexPath.row];
    UITableViewCell *cell = [cellConfig cellOfCellConfigWithTableView:tableView dataModel:dic isNib:YES];
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [tableView setSeparatorColor:UIColorWithRGB(0xe3e5ea)];

    ((UCFHuiShangChooseBankViewCell *)cell).db = self;
       return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    view.backgroundColor = [DBColor colorWithHexString:@"EBEBEE" andAlpha:1.0];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, view.frame.size.width, view.frame.size.height)];
    label.backgroundColor = [UIColor clearColor];
    label.text = section == 0 ?@"支持快捷支付":@"不支持快捷支付";
    label.font = [UIFont systemFontOfSize:12.0];
    label.textColor = [DBColor colorWithHexString:@"333333" andAlpha:1.0];
    [view addSubview:label];
    return view;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self endRefresh];
}


@end
