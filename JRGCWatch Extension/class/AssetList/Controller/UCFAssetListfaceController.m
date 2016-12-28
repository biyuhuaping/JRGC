//
//  UCFAssetListfaceController.m
//  Test01
//
//  Created by NJW on 2016/10/26.
//  Copyright © 2016年 NJW. All rights reserved.
//

#import "UCFAssetListfaceController.h"
#import "UCFAssetListRowCell.h"
#import "UCFNetwork.h"
#import "CommonSetting.h"
#import "UCFAccountTool.h"
#import "UCFAccount.h"
@interface UCFAssetListfaceController ()

@property (strong, nonatomic) IBOutlet WKInterfaceTable *AssetListTableView;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *tipGroup;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *loadingGroup;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *netStatusLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceImage *noDataImage;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *dataStatusLabel;

@end

@implementation UCFAssetListfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    
    //请求数据前 加载loading
    [self.tipGroup setHidden:NO];
    [self.AssetListTableView setHidden:YES];
    [self.dataStatusLabel setHidden:YES];
    [self.noDataImage setHidden:YES];
    [self.loadingGroup setHidden:NO];
    [self.loadingGroup startAnimating];
    [self.loadingGroup setBackgroundImageNamed:@"loading"];
    [self.loadingGroup startAnimatingWithImagesInRange:NSMakeRange(0, 10) duration:1 repeatCount:0];
    //请求回款数据
    [self getAseetLisDataHttpRequest];
}
#pragma mark -获取资金流水的数据网络请求
-(void)getAseetLisDataHttpRequest{
    
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_IP, GETHSACCOUNTLIST];
    UCFAccount *account = [UCFAccountTool account];
//    WEAKSELF(UCFAssetListfaceController);
    __weak typeof(self) weakself = self;
    [UCFNetwork POSTWithUrl:url parameters:@{@"userId":account.userId, @"page":@"1", @"pageSize":@"10"} isNew:YES success:^(id json) {
//        NSLog(@"succ: %@", json);
        //正式网络请求的数据
        NSDictionary *dataDic  = json[@"data"];
        NSArray *resultListArr = dataDic[@"pageData"][@"result"];
        [weakself refreshTableViewData:resultListArr];
    } fail:^(id json){
        [weakself.loadingGroup stopAnimating];
        [weakself.loadingGroup setHidden:YES];
        [weakself.tipGroup setHidden:NO];
        [weakself.netStatusLabel setHidden:NO];
        [weakself.netStatusLabel setText:@"您似乎与互联网失去连接"];
        [weakself.AssetListTableView setHidden:YES];
        [weakself.dataStatusLabel setHidden:YES];
        [weakself.noDataImage setHidden:YES];
    }];
}
-(void)refreshTableViewData:(NSArray *)dataArray{
    //停止动画 隐藏loading视图
    [self.loadingGroup stopAnimating];
    [self.loadingGroup setHidden:YES];
    [self.tipGroup setHidden:YES];
    [self.dataStatusLabel setHidden:NO];
    
    if (dataArray.count == 0) { //数据为空时
        [self.noDataImage setHidden:NO];
        [self.dataStatusLabel setText:@"暂无任何待回款明细"];
    }else {
        [self.AssetListTableView setHidden:NO];
        [self.noDataImage setHidden:YES];
        [self.dataStatusLabel setText:@"仅显示最新10条回款记录"];
        for ( int index = 0 ; index < [dataArray count];index++ )
        {
            NSDictionary * dict = [dataArray objectAtIndex:index];
            [self.AssetListTableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:index] withRowType:@"AssetListCell"];
            UCFAssetListRowCell *row = [self.AssetListTableView rowControllerAtIndex:index];
            NSString *amoutStr = [dict objectForKey:@"amount"];
             [row.money setText:amoutStr];
            if([amoutStr hasPrefix:@"-"]){
                [row.money setTextColor:UIColorWithRGB(0x28b736)];
            }else{
                [row.money setTextColor:UIColorWithRGB(0xfd4d4c)];
            }
            NSString * createDateStr = [dict objectForKey:@"createDate"];
            [row.moneyDate setText:[[createDateStr substringFromIndex:5] substringToIndex:11]];
            [row.moneySouce setText:[dict objectForKey:@"desc"]];
        }
    }
}
- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
    [self.loadingGroup stopAnimating];
    [self.loadingGroup setHidden:YES];
   
}

@end



