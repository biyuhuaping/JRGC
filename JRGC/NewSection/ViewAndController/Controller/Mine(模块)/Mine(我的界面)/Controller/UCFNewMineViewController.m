//
//  UCFNewMineViewController.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/1/14.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewMineViewController.h"
#import "BaseTableView.h"

#import "UCFMineMyReceiptApi.h"
#import "UCFMineMyReceiptModel.h"
#import "UCFMineMySimpleInfoModel.h"
#import "UCFMineMySimpleInfoApi.h"
#import "UCFMineNewSignModel.h"
#import "UCFMineNewSignApi.h"
#import "UCFMineIntoCoinPageModel.h"
#import "UCFMineIntoCoinPageApi.h"



@interface UCFNewMineViewController ()<UITableViewDelegate, UITableViewDataSource,BaseTableViewDelegate>

@property (nonatomic, strong) MyRelativeLayout *rootLayout;

@property (nonatomic, strong) BaseTableView *tableView;

@property (nonatomic, strong) NSMutableArray *arryData;


@property (nonatomic, strong) UCFMineMyReceiptModel *myReceiptModel;
@end

@implementation UCFNewMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.rootLayout = [MyRelativeLayout new];
    self.rootLayout.backgroundColor = [UIColor whiteColor];
    self.rootLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
    self.view = self.rootLayout;
    
    [self.rootLayout addSubview:self.tableView];
    
    
    
    
}
- (BaseTableView *)tableView
{
    if (nil == _tableView) {
        _tableView = [[BaseTableView alloc]init];
        _tableView.backgroundColor = [Color color:PGColorOptionGrayBackgroundColor];
        _tableView.delegate = self;
        _tableView.dataSource =self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableRefreshDelegate= self;
        _tableView.enableRefreshFooter = NO;
        _tableView.topPos.equalTo(@0);
        _tableView.leftPos.equalTo(@0);
        _tableView.rightPos.equalTo(@0);
        _tableView.bottomPos.equalTo(@0);
        
    }
    return _tableView;
}
#pragma mark ---tableviewdelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 97;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.arryData objectAtIndex:section] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 0.01;
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;//设置尾视图高度为0.01
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)headCellButtonClick:(UIButton *)btn
{
    if (btn.tag == 10001) {
        //个人账户信息
    }
    else if (btn.tag == 10002){
        //信息中心
    }
    else if (btn.tag == 10003){
        //是否展示用户资金,关闭都是*****
    }
    else if (btn.tag == 10004){
        //只进入微金的充值
    }
    else if (btn.tag == 10005){
        //各个账户的充值与提现,尊享、黄金账户已经不允许充值,只能提现
    }
}
- (void)requestMyReceipt//请求总资产信息
{
    UCFMineMyReceiptApi * request = [[UCFMineMyReceiptApi alloc] init];
    
//    request.animatingView = self.view;
//    request.tag =tag;
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        // 你可以直接在这里使用 self
        self.myReceiptModel = [request.responseJSONModel copy];
        DDLogDebug(@"---------%@",self.myReceiptModel);
        if (self.myReceiptModel.ret == YES) {
           
        }
        else{
            ShowMessage(self.myReceiptModel.message);
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        // 你可以直接在这里使用 self
        
    }];
    
}
@end
