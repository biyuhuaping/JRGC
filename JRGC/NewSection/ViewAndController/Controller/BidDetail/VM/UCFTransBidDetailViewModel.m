//
//  UCFTransBidDetailViewModel.m
//  JRGC
//
//  Created by zrc on 2019/2/14.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFTransBidDetailViewModel.h"
#import "NSString+Tool.h"
@interface UCFTransBidDetailViewModel()
@property(nonatomic, strong)UCFTransBidInfoModel *model;
@end


@implementation UCFTransBidDetailViewModel
- (void)blindModel:(BaseModel *)model
{
    self.model = (UCFTransBidInfoModel *)model;
    //处理头信息
    [self dealNavData];
    //处理标头
    [self dealBidInfo];
}
- (void)dealNavData
{
    NSString *prdName = self.model.prdTransferFore.name;
    self.prdName = prdName;
}
- (void)dealBidInfo
{
    double borrowAmount = [self.model.prdTransferFore.realtranMoney doubleValue];
        
    NSString *remainMon = [NSString stringWithFormat:@"%@",self.model.prdTransferFore.cantranMoney];
    self.remainMoney =  [NSString stringWithFormat:@"¥%@",[NSString AddComma:remainMon]];
    
    NSString *borrowAm = [NSString stringWithFormat:@"%.2f",borrowAmount];
    self.borrowAmount = [NSString stringWithFormat:@"¥%@",[NSString AddComma:borrowAm]];
    
    //年化收益
    NSString *annualRate = self.model.prdTransferFore.transfereeYearRate;;
    self.annualRate = [NSString stringWithFormat:@"%@%%",annualRate];
    
    NSString *markTimeStr= [NSString stringWithFormat:@"%@天",self.model.prdTransferFore.lastDays];
    //扫描字符串中的数字
    NSScanner *aScanner = [NSScanner scannerWithString:markTimeStr];
    int anInteger;
    [aScanner scanInt:&anInteger];
    NSString *dateString;
    if ([aScanner scanString:@"天" intoString:NULL]) {
        dateString = @"天";
    } else {
        dateString = @"个月";
    }
    NSString *holdTime = self.model.prdTransferFore.holdTime;
    if ([holdTime length] > 0) {
        holdTime = [NSString stringWithFormat:@"%@~%d",holdTime,anInteger];
    }else{
        holdTime = [NSString stringWithFormat:@"%d",anInteger];
        if ([markTimeStr isEqualToString:@""]) { //如果repayPeriodText为空情况下
            holdTime =  self.model.prdTransferFore.repayPeriod;
        }
    }
    markTimeStr = [holdTime stringByAppendingString:dateString];
    
    self.markTimeStr = markTimeStr;
    
    
    
    int completeRate = [self.model.prdTransferFore.completeRate intValue];
    CGFloat curProgress = [self.model.prdTransferFore.completeRate doubleValue]/100;
    //进度条中间的百分比label
    if (curProgress > 0 && curProgress < 0.01) {
        completeRate = 1;
    }
    NSString *rateStr = [NSString stringWithFormat:@"%d",completeRate];
    
    self.percentage = rateStr;
}
@end
