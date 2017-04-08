//
//  UCFRedEnvelopeViewController.m
//  JRGC
//
//  Created by NJW on 15/4/17.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFRedEnvelopeViewController.h"
#import "UCFRedEnvelopeTableViewCell.h"
#import "UCFNormalRedEnvelopeTableViewCell.h"
#import "UCFRedEnvelopeModel.h"
#import <UShareUI/UShareUI.h>

//#import "UMSocialSnsService.h"
#import "WXApi.h"
#import "MBProgressHUD+HJ.h"
#import "UCFNoDataView.h"

@interface UCFRedEnvelopeViewController () <UCFRedEnvelopeTableViewCellDelegate>

// 送出的红包
@property (weak, nonatomic) IBOutlet UITableView *sentRedEnvelopeTableView;

// 送出的红包的当前页
@property (nonatomic, assign) NSUInteger currentPageForSentRedEnvelope;

// 送出红包的数据源
@property (nonatomic, strong) NSMutableArray *dataSourceForSentRedEnvelope;

// 已选中状态存储数组
@property (nonatomic, strong) NSMutableArray *selectedStateArray;
// 发红包链接
@property (nonatomic, copy) NSString *sendRedBagUrl;
@property (nonatomic, copy) NSString *redQuanPackageUrl;
// 发红包的标题
@property (nonatomic, copy) NSString *sendRedBagTitle;
// 发红包的内容
@property (nonatomic, copy) NSString *sendRedBagContext;
// 发红包的图片
@property (nonatomic, strong) UIImage *sendRedBagImage;
// 正在发送的红包
@property (nonatomic, strong) UCFRedEnvelopeModel *sendingRedEnvelope;

@property (nonatomic, copy) NSString *desvalue;
// 无数据界面
@property (nonatomic, strong) UCFNoDataView *noDataViewOne;

@end

@implementation UCFRedEnvelopeViewController

// 已选中状态存储数组
- (NSMutableArray *)selectedStateArray
{
    if (_selectedStateArray == nil) {
        _selectedStateArray = [[NSMutableArray alloc] init];
    }
    return _selectedStateArray;
}

- (NSMutableArray *)dataSourceForSentRedEnvelope
{
    if (nil == _dataSourceForSentRedEnvelope) {
        _dataSourceForSentRedEnvelope = [[NSMutableArray alloc] init];
    }
    return _dataSourceForSentRedEnvelope;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.selectedStateArray addObject:@(0)];
    [self createUI];
    [self getAppSetting];
}

// 初始化ui
- (void)createUI
{
//    [self.rightButton removeFromSuperview];
//    self.rightButton = nil;
    self.currentPageForSentRedEnvelope = 1;
    
    _sentRedEnvelopeTableView.backgroundColor = UIColorWithRGB(0xebebee);
    _sentRedEnvelopeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _noDataViewOne = [[UCFNoDataView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) errorTitle:@"暂无数据"];
    
    baseTitleLabel.text = @"我的红包";
    [self addLeftButton];

    //=========  下拉刷新、上拉加载更多  =========
    __weak typeof(self) weakSelf = self;
    // 添加传统的下拉刷新
    [_sentRedEnvelopeTableView addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getSentRedEnvelopNetworkDataWithPageNo:)];
    
    // 添加上拉加载更多
    [_sentRedEnvelopeTableView addLegendFooterWithRefreshingBlock:^{
        weakSelf.currentPageForSentRedEnvelope++;
        [weakSelf getSentRedEnvelopNetworkDataWithPageNo:weakSelf.currentPageForSentRedEnvelope];
    }];
    
    [self.sentRedEnvelopeTableView.header beginRefreshing];
}

// 请求红包网络数据
- (void)getSentRedEnvelopNetworkDataWithPageNo:(NSUInteger)currentPageNo
{
    if ([self.sentRedEnvelopeTableView.header isRefreshing]) {
        self.sentRedEnvelopeTableView.footer.hidden = YES;
        self.currentPageForSentRedEnvelope = 1;
        currentPageNo = 1;
    }
    NSString *strParameters = [NSString stringWithFormat:@"userId=%@&page=%lu&rows=%@", [[NSUserDefaults standardUserDefaults] valueForKey:UUID], (unsigned long)currentPageNo, PAGESIZE];
    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSxTagMyRedPackage owner:self Type:SelectAccoutDefault];
}

//    //获取分享各种信息
- (void)getAppSetting{
//    NSString *strParameters = [NSString stringWithFormat:@"gcm=%@",_gcmLab.text];//5644
    [[NetworkModule sharedNetworkModule] postReq:nil tag:kSXTagGetAppSetting owner:self Type:SelectAccoutDefault];
}

//开始请求
- (void)beginPost:(kSXTag)tag
{
    if (tag != kSXTagGetAppSetting) {
//        [MBProgressHUD showHUDAddedTo:self.settingBaseBgView animated:YES];
    }
}

//请求成功及结果
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSString *data = (NSString *)result;
    DBLog(@"首页获取最新项目列表：%@",data);
    NSMutableDictionary *dic = [data objectFromJSONString];
    NSString *rstcode = dic[@"status"];
    NSString *rsttext = dic[@"statusdes"];

    if (tag.intValue == kSxTagMyRedPackage) {
        NSInteger sign = [rstcode integerValue];
        BOOL hasNextPage = [[[dic[@"pageData"] objectForKey:@"pagination"] valueForKey:@"hasNextPage"] boolValue];
        if (sign == 1) {
            if ([self.sentRedEnvelopeTableView.header isRefreshing]) {
                [self.dataSourceForSentRedEnvelope removeAllObjects];
            }
            NSArray *result = [dic[@"pageData"] objectForKey:@"result"];
            NSMutableArray *temp = [NSMutableArray array];
            for (NSDictionary *dict in result) {
                UCFRedEnvelopeModel *redEnvelope = [UCFRedEnvelopeModel redEnvelopeWithDict:dict];
                redEnvelope.redEnvelopeType = UCFRedEnvelopeStateSent;
                [temp addObject:redEnvelope];
            }
            [self.dataSourceForSentRedEnvelope addObjectsFromArray:temp];
            if ([self.sentRedEnvelopeTableView.header isRefreshing]) {
                if (self.dataSourceForSentRedEnvelope.count > 0) {
                    [self.noDataViewOne hide];
                    if (!hasNextPage) {
                        [self.sentRedEnvelopeTableView.footer noticeNoMoreData];
                    }
                    else
                        [self.sentRedEnvelopeTableView.footer resetNoMoreData];
                }
                else {
                    [self.noDataViewOne showInView:self.sentRedEnvelopeTableView];
                    [self.sentRedEnvelopeTableView.footer noticeNoMoreData];
                }
            }
            else if ([self.sentRedEnvelopeTableView.footer isRefreshing])
            {
                if (temp.count==0) {
                    [self.sentRedEnvelopeTableView.footer noticeNoMoreData];
                }
            }
            [self.sentRedEnvelopeTableView reloadData];
            [[NSNotificationCenter defaultCenter]postNotificationName:REDALERTISHIDE object:@"3"];
        }
        else {
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
        }
        if ([self.sentRedEnvelopeTableView.header isRefreshing]) {
            [self.sentRedEnvelopeTableView.header endRefreshing];
            self.sentRedEnvelopeTableView.footer.hidden = NO;
        }
        if ([self.sentRedEnvelopeTableView.footer isRefreshing]) {
            [self.sentRedEnvelopeTableView.footer endRefreshing];
        }
     
    }
    else if (tag.intValue == kSXTagGetAppSetting) {
        NSInteger sign = [rstcode integerValue];
        if (sign == 1) {
            self.sendRedBagUrl = dic[@"redDouPackageUrl"];
            self.redQuanPackageUrl = dic[@"redQuanPackageUrl"];
            NSArray *result = dic[@"result"];
            for (NSDictionary *dict in result) {
                NSInteger rank = [dict[@"rank"] integerValue];
                switch (rank) {
                    case 1: {
                        UIImage *image = [Common getImageFromURL:dict[@"desvalue"]];
                        if (image) {
                            self.sendRedBagImage = image;//分享内嵌图片
                        }else
                            self.sendRedBagImage = [UIImage imageNamed:@"default"];
                    }
                        break;
                        
                    case 2: {
                        self.sendRedBagContext = dict[@"desvalue"];
                    }
                        break;
                    
                    case 5:
                        self.sendRedBagTitle = dict[@"desvalue"];
                        break;
                }
            }
        }
        else
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
    }
}

//请求失败
- (void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    if (tag.intValue == kSxTagMyRedPackage || tag.intValue == kSXTagGetAppSetting) {
        [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
    }
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (tag.intValue == kSxTagMyRedPackage) {
        [self.sentRedEnvelopeTableView.header endRefreshing];
        self.sentRedEnvelopeTableView.footer.hidden = NO;
        [self.sentRedEnvelopeTableView.footer endRefreshing];
        if (self.dataSourceForSentRedEnvelope.count == 0) {
            [self.noDataViewOne showInView:self.sentRedEnvelopeTableView];
            [self.sentRedEnvelopeTableView.footer noticeNoMoreData];
        }
    }
}

// tableview的数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceForSentRedEnvelope.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.sentRedEnvelopeTableView) {
        UCFRedEnvelopeModel *redEnvelope = self.dataSourceForSentRedEnvelope[indexPath.row];
//        DLog(@"=========>%@", redEnvelope.status);
        
        switch ([redEnvelope.status intValue]) {
            case 1:
            {
                UCFRedEnvelopeTableViewCell *cell = [UCFRedEnvelopeTableViewCell cellWithTableView:tableView];
                cell.delegate = self;
                cell.redEnvelope = redEnvelope;
                return cell;
            }
                break;
                
            case 0:
            case 2:
            case 3: {
                UCFNormalRedEnvelopeTableViewCell *cell = [UCFNormalRedEnvelopeTableViewCell cellWithTableView:tableView];
                cell.redEnvelope = redEnvelope;
                return cell;
            }
                break;
        }
        
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.sentRedEnvelopeTableView) {
        UCFRedEnvelopeModel *redEnvelope = self.dataSourceForSentRedEnvelope[indexPath.row];
        switch ([redEnvelope.status intValue]) {
            case 1:
                return 119;
                
            case 0:
            case 3:
            case 2:
                return 82;
        }

    }
    return 82;

}

// 发送红包代理
- (void)redEnvelopeTableViewCell:(UCFRedEnvelopeTableViewCell *)redEnvelopeTableViewCell sendRedEnvelope:(UCFRedEnvelopeModel *)redenvelopeModel
{
    self.sendingRedEnvelope = redenvelopeModel;
    if ([redenvelopeModel.cardType isEqualToString:@"1"] && self.sendRedBagUrl) {
        //工豆红包
        [self sendRedBagWithId:redenvelopeModel.cardId andAddress:self.sendRedBagUrl];
    } else if(self.redQuanPackageUrl && [redenvelopeModel.cardType isEqualToString:@"2"]){
        //返现券红包
        [self sendRedBagWithId:redenvelopeModel.cardId andAddress:self.redQuanPackageUrl];
    } else {
        [AuxiliaryFunc showToastMessage:@"红包分享失败!" withView:self.view];
    }
}

//  发送红包
- (void)sendRedBagWithId:(NSString *)redBagId andAddress:(NSString *)address
{
    // 分享红包
    if (![WXApi isWXAppInstalled]) {
        [MBProgressHUD displayHudError:@"对不起，你尚未安装微信客户端"];
        return;
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", address,redBagId];
    NSString *title = @"";
    if (self.sendRedBagTitle) {
        title = self.sendRedBagTitle;
    }
    NSString *shareText = @"";
    //    NSString *shareText = [NSString stringWithFormat:@"金融工场,圆你财富梦想\n%@",urlStr];             //分享内嵌文字
    if (self.sendRedBagContext) {
        shareText = self.sendRedBagContext;
    }
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:shareText thumImage:self.sendRedBagImage];
    [shareObject setWebpageUrl:urlStr];
    messageObject.shareObject = shareObject;
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine)]];
    __weak typeof(self) weakSelf = self;

    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        [weakSelf shareDataWithPlatform:platformType withObject:messageObject];

    }];
    
//    //显示分享面板 （自定义UI可以忽略）
//    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMShareMenuSelectionView *shareSelectionView,UMSocialPlatformType platformType) {
//        if (platformType == UMSocialPlatformType_WechatSession || platformType == UMSocialPlatformType_WechatTimeLine || platformType ==UMSocialPlatformType_WechatFavorite) {
//            [weakSelf shareDataWithPlatform:platformType withObject:messageObject];
//        } else {
//            [MBProgressHUD displayHudError:@"红包暂不支持该平台"];
//        }
//    }];
}
//直接分享
- (void)shareDataWithPlatform:(UMSocialPlatformType)platformType withObject:(UMSocialMessageObject *)object
{
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:object currentViewController:self completion:^(id data, NSError *error) {
        NSString *message = nil;
        if (!error) {
            message = [NSString stringWithFormat:@"分享成功"];
            [MBProgressHUD displayHudError:message];

        }
        else{
            [MBProgressHUD displayHudError:@"分享失败"];

            if (error) {
                message = [NSString stringWithFormat:@"失败原因Code: %d\n",(int)error.code];
            }
            else{
                message = [NSString stringWithFormat:@"分享失败"];
            }
        }
    }];
}

@end
