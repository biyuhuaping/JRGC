//
//  UCFBackMoneyController.m
//  Test01
//
//  Created by NJW on 16/10/20.
//  Copyright © 2016年 NJW. All rights reserved.
//

#import "UCFBackMoneyController.h"
#import "UCFBackMoneyRowCell.h"
#import "UCFNetwork.h"
#import "UCFAccount.h"
#import "UCFAccountTool.h"
#import "CommonSetting.h"
@interface UCFBackMoneyController ()

@property (strong, nonatomic) IBOutlet WKInterfaceTable *backMoneyTableview;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *tipGroup;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *loadingGroup;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceImage *noDataImage;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *dataStatusLabel;

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *netStatusLabel;
@end
@implementation UCFBackMoneyController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    //请求数据前 加载loading
    [self.tipGroup setHidden:NO];
    [self.backMoneyTableview setHidden:YES];
    [self.dataStatusLabel setHidden:YES];
    [self.noDataImage setHidden:YES];
    [self.loadingGroup setHidden:NO];
    [self.loadingGroup startAnimating];
    [self.loadingGroup setBackgroundImageNamed:@"loading"];
    [self.loadingGroup startAnimatingWithImagesInRange:NSMakeRange(0, 10) duration:1 repeatCount:0];
    //请求回款数据
    [self getBackMoneyHttpRequest];
}

#pragma mark -获取回款的数据网络请求
-(void)getBackMoneyHttpRequest{
//    status = 0 为未回款
    
    __weak typeof(self) weakself = self;
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_IP, REDUNDLIST];
    UCFAccount *account = [UCFAccountTool account];
    [UCFNetwork POSTWithUrl:url parameters:@{@"userId":account.userId, @"page":@"1", @"rows":@"10",@"status":@"0"} isNew:NO success:^(id json) {
//        NSLog(@"succ: %@", json);
         //正式请求
        NSString *rstcode = json[@"status"];
//        NSString *rsttext = json[@"statusdes"];
//        NSLog(@"回款明细页：%@",json);
        NSArray *tempArr = json[@"pageData"][@"result"];
        if ([rstcode integerValue]== 1) {
            [weakself refreshTableViewData:tempArr];
        }
    } fail:^(id json){
        
        [weakself.loadingGroup stopAnimating];
        [weakself.loadingGroup setHidden:YES];
        [weakself.tipGroup setHidden:NO];
        [weakself.netStatusLabel setHidden:NO];
        [weakself.netStatusLabel setText:@"您似乎与互联网失去连接"];
        [weakself.backMoneyTableview setHidden:YES];
        [weakself.dataStatusLabel setHidden:YES];
        [weakself.noDataImage setHidden:YES];
        
//        NSLog(@"failed: %@", ditc);
    }];
}
-(void)refreshTableViewData:(NSArray *)dataArray{
    //停止动画 隐藏loading视图
    [self.loadingGroup stopAnimating];
    [self.loadingGroup setHidden:YES];
    [self.tipGroup setHidden:YES];
    [self.backMoneyTableview setHidden:NO];
    [self.dataStatusLabel setHidden:NO];
    
    if (dataArray.count == 0) { //数据为空时
        [self.backMoneyTableview setHidden:YES];
        [self.noDataImage setHidden:NO];
        [self.dataStatusLabel setText:@"暂无任何待回款明细"];
    }else {
        
        [self.backMoneyTableview setHidden:NO];
        [self.noDataImage setHidden:YES];
        [self.dataStatusLabel setText:@"仅显示最新10条回款记录"];
       
        for ( int index = 0 ; index < [dataArray count];index++ ) 
        {
            NSDictionary * dict = [dataArray objectAtIndex:index];
            [self.backMoneyTableview insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:index] withRowType:@"BackMoneyCell"];
            UCFBackMoneyRowCell *row = [self.backMoneyTableview rowControllerAtIndex:index];
            NSString *princAndIntestStr = [NSString stringWithFormat:@"¥%@",[dict objectForKey:@"princAndIntest"]];
            [row.money setText:princAndIntestStr];//总计金额
            NSString *repayPerDateStr = [dict objectForKey:@"repayPerDate"];
            [row.moneyDate setText:[repayPerDateStr substringFromIndex:5]];//计划回款日期
            [row.moneySouce setText:@"计划回款日期:"];
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



