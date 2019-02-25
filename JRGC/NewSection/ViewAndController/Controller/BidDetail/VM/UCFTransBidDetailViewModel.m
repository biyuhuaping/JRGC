//
//  UCFTransBidDetailViewModel.m
//  JRGC
//
//  Created by zrc on 2019/2/14.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFTransBidDetailViewModel.h"
#import "NSString+Tool.h"
#import "UCFSettingArrowItem.h"
#import "UCFTransInvestPageInfoApi.h"
#import "NetworkModule.h"
@interface UCFTransBidDetailViewModel()<NetworkModuleDelegate>
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
    //处理标签
    [self dealMarkView];
    
    //处理投标按钮状态
    [self invetsButtonState];
    
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
- (void)dealMarkView
{
    
    if (self.model.prdLabelsList.count > 0) {
        NSMutableArray *tmpArr = [NSMutableArray array];
        for (UCFTransPrdlabelslist *tmpModel in self.model.prdLabelsList) {
            NSInteger labelPriority = [tmpModel.labelPriority integerValue];
            if (labelPriority > 1) {
                if ([tmpModel.labelName rangeOfString:@"起投"].location == NSNotFound) {
                    [tmpArr addObject:tmpModel.labelName];
                }
            }
        }
        self.markList = tmpArr;
    }
}

- (void)invetsButtonState
{
    if ([self.model.prdTransferFore.type isEqualToString:@"1"]) {
        self.bidInvestText = @"立即出借";

    } else {
        self.bidInvestText = @"立即购买";
    }
}

- (void)dealClickAction:(NSString *)title
{

}


- (NSArray *)getTableViewData
{
    NSMutableArray *dataArr = [NSMutableArray arrayWithCapacity:4];
    NSMutableDictionary *parmDict1 = [NSMutableDictionary dictionaryWithCapacity:1];
    [parmDict1 setValue:self.model.prdTransferFore.repayModeText forKey:@"value"];
    [parmDict1 setValue:@"还款方式" forKey:@"title"];
    [dataArr addObject:parmDict1];
    
    NSMutableDictionary *parmDict2 = [NSMutableDictionary dictionaryWithCapacity:1];
    [parmDict2 setValue:[NSString stringWithFormat:@"¥%@起",self.model.prdTransferFore.investAmt] forKey:@"value"];
    [parmDict2 setValue:@"起投金额" forKey:@"title"];
    [dataArr addObject:parmDict2];
    
    //担保公司
//    NSString *guaranteeCompany = self.model.prdTransferFore.guaranteeCompany;
//    if (guaranteeCompany.length > 0) {
//        NSMutableDictionary *parmDict3 = [NSMutableDictionary dictionaryWithCapacity:1];
//        [parmDict3 setValue:guaranteeCompany forKey:@"value"];
//        [parmDict3 setValue:@"担保方" forKey:@"title"];
//        [dataArr addObject:parmDict3];
//    }
    return dataArr;
}
- (NSArray *)getTableViewData1
{
    NSMutableArray *sectionArr = [NSMutableArray arrayWithCapacity:3];
    UCFSettingItem *basicBetailItem = [UCFSettingArrowItem itemWithIcon:@"particular_icon_info" title:@"基础详情" destVcClass:nil];
    UCFSettingItem *safetyGuaranteeItem = [UCFSettingArrowItem itemWithIcon:@"particular_icon_security" title:@"安全保障" destVcClass:nil];
    UCFSettingItem *investmentecordItem = [UCFSettingArrowItem itemWithIcon:@"particular_icon_record" title:@"出借记录" destVcClass:nil];
    [sectionArr addObject:basicBetailItem];
    [sectionArr addObject:safetyGuaranteeItem];
    [sectionArr addObject:investmentecordItem];
    return sectionArr;
}

#pragma NetworkModuleDelegate
-(void)beginPost:(kSXTag)tag
{
    
}
-(void)endPost:(id)result tag:(NSNumber*)tag
{
    
}
-(void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    
}
@end
