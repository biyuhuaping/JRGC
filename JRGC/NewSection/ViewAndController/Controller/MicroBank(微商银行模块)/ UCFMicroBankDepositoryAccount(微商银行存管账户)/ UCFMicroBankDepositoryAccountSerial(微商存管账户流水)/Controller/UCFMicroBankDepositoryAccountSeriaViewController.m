//
//  UCFMicroBankDepositoryAccountSeriaViewController.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/2/26.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFMicroBankDepositoryAccountSeriaViewController.h"
#import "BaseTableView.h"
#import "UCFMicroBankDepositoryAccountSeriaCell.h"
#import "UCFMicroBankDepositoryGetHSAccountInfoBillModel.h"
#import "UCFMicroBankDepositoryGetHSAccountInfoBillApi.h"
#import "FullWebViewController.h"
@interface UCFMicroBankDepositoryAccountSeriaViewController ()<UITableViewDelegate, UITableViewDataSource,BaseTableViewDelegate>

@property (nonatomic, strong) MyRelativeLayout *rootLayout;

@property (nonatomic, strong) BaseTableView *tableView;

@property (nonatomic, strong) NSMutableArray *arryData;

@property (nonatomic, assign) NSInteger page;
@end

@implementation UCFMicroBankDepositoryAccountSeriaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.rootLayout = [MyRelativeLayout new];
    self.rootLayout.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
    self.rootLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
    self.view = self.rootLayout;
    [self.rootLayout addSubview:self.tableView];
    [self addLeftButton];
    [self addRightButtonWithImage:[UIImage imageNamed:@"question_icon"]];
    self.page = 1;
    if (self.accoutType == SelectAccoutTypeHoner ) {
        baseTitleLabel.text = @"尊享徽商资金流水";
    }else{
        baseTitleLabel.text = @"微金徽商资金流水";
    }
    [self.tableView beginRefresh];
}
- (void)getToBack
{
    [self.rt_navigationController popViewControllerAnimated:YES];
}
- (void)clickRightBtn
{
    NSString *urlStr = self.accoutType == SelectAccoutTypeP2P ? P2PHSAccountIllustrationURL:HSAccountIllustrationURL;
    FullWebViewController *webController = [[FullWebViewController alloc] initWithWebUrl:urlStr title:@"说明"];
    webController.sourceVc = @"huishangAccout";
    webController.baseTitleType = @"specialUser";
    [self.navigationController pushViewController:webController animated:YES];
}
- (BaseTableView *)tableView
{
    if (nil == _tableView) {
        _tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0, 0, PGScreenWidth, 0) style:UITableViewStylePlain];
        _tableView.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
        _tableView.delegate = self;
        _tableView.dataSource =self;
        _tableView.tableRefreshDelegate= self;
//        _tableView.enableRefreshFooter = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.topPos.equalTo(@10);
        _tableView.leftPos.equalTo(@0);
        _tableView.rightPos.equalTo(@0);
        _tableView.bottomPos.equalTo(@0);
        
    }
    return _tableView;
}
#pragma mark--tableView delegate
//第section分区一共有多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.arryData.count;
}
// 一共有多少个分区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//
////第section分区的头部标题
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//
//    return @"";
//}
//某一行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 65;
}
//第section分区头部的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

//第section分区尾部的高度
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section

//第section分区头部显示的视图
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section

//第section分区尾部显示的视图
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section

//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return [[self.arryData objectAtIndex:section] count];
//}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UCFMicroBankDepositoryAccountSeriaCell";
    //自定义cell类
    UCFMicroBankDepositoryAccountSeriaCell *cell = (UCFMicroBankDepositoryAccountSeriaCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UCFMicroBankDepositoryAccountSeriaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.lastRowInSection = (self.arryData.count - 1 == indexPath.row);
    [cell showInfo:[self.arryData objectAtIndex:indexPath.row]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}
/**
 *  下拉刷新的回调
 *
 */
- (void)refreshTableViewHeader
{
    self.page = 1;
    self.arryData = [NSMutableArray arrayWithCapacity:20];
    [self requestPage:self.page];

}

/**
 *  上提刷新的回调
 *
 */
- (void)refreshTableViewFooter
{
    [self requestPage:self.page];
}

- (void)requestPage:(NSInteger )page
{

    UCFMicroBankDepositoryGetHSAccountInfoBillApi * request = [[UCFMicroBankDepositoryGetHSAccountInfoBillApi alloc] initWithPage:page pageSize:20 accoutType:self.accoutType];
    
        request.animatingView = self.view;
    //    request.tag =tag;
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        // 你可以直接在这里使用 self
        UCFMicroBankDepositoryGetHSAccountInfoBillModel *model = [request.responseJSONModel copy];
        DDLogDebug(@"---------%@",model);
        if (model.ret == YES) {
            
            [self.arryData addObjectsFromArray:model.data.pageData.result];
            if ([model.data.pageData.pagination.hasNextPage isEqualToString:@"false"]) {
                //没有下一页数据后,隐藏上拉加载,
                self.tableView.enableRefreshFooter = NO;
                self.page = [model.data.pageData.pagination.pageNo integerValue];
            }
            else
            {
                self.page = [model.data.pageData.pagination.pageNo integerValue]+ 1;
                self.tableView.enableRefreshFooter = YES;
            }
        }
        else{
            ShowMessage(model.message);
        }
         [self endRefreshAndReloadData];
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        // 你可以直接在这里使用 self
        [self endRefreshAndReloadData];
    }];
}

- (void)endRefreshAndReloadData
{
    [self.tableView endRefresh];
    [self.tableView cyl_reloadData];
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
