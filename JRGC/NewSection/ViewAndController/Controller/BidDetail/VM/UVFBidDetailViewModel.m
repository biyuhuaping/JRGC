//
//  UVFBidDetailViewModel.m
//  JRGC
//
//  Created by zrc on 2019/1/24.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UVFBidDetailViewModel.h"
#import "NSString+Tool.h"
#import "NSDateManager.h"
#import "UCFSettingArrowItem.h"
@interface UVFBidDetailViewModel()
@property(nonatomic, weak)UCFBidDetailModel *model;
@end
@implementation UVFBidDetailViewModel



- (void)blindModel:(UCFBidDetailModel *)model
{
    self.model = model;
    //处理头信息
    [self dealNavData];
    //处理标头
    [self dealBidInfo];
    //处理标签
    [self dealMarkInfo];
    //处理倒计时
    [self dealMinuteCountDownData];
}
- (UCFBidDetailModel *)getDataModel
{
    return self.model;
}
- (void)dealNavData
{
    NSString *prdName = self.model.data.prdName;
    self.prdName = prdName;
    if (self.model.data.prdLabelsList.count > 0) {
        for (DetailPrdlabelslist *prdLabModel in self.model.data.prdLabelsList) {
            if ([prdLabModel.labelPriority isEqualToString:@"1"]) {
                self.childName = prdLabModel.labelName;
            }
        }
    }
    self.navFinish = @"1";
}
- (void)dealBidInfo
{
    double borrowAmount = self.model.data.borrowAmount;
    double completeLoan = self.model.data.completeLoan;

    //可投额度和总额度
    double dbreCount = borrowAmount - completeLoan;
    
    NSString *remainMon = [NSString stringWithFormat:@"%.2f",dbreCount];
    self.remainMoney =  [NSString stringWithFormat:@"¥%@",[NSString AddComma:remainMon]];

    NSString *borrowAm = [NSString stringWithFormat:@"%.2f",borrowAmount];
    self.borrowAmount = [NSString stringWithFormat:@"¥%@",[NSString AddComma:borrowAm]];

    //年化收益
    NSString *annualRate = self.model.data.annualRate;;
    self.annualRate = [NSString stringWithFormat:@"%@%%",annualRate];

     
    //平台补贴利息
    NSString *butieTitle = @"";
    NSString *platformSubsidyExpense = self.model.data.platformSubsidyExpense;
    platformSubsidyExpense = @"5.0";
    if (!platformSubsidyExpense || [platformSubsidyExpense isEqualToString:@""] || [platformSubsidyExpense isEqualToString:@"0.0"]) {
        butieTitle = @"";
    } else {
        butieTitle = [NSString stringWithFormat:@" (平台补贴利息占%@%%)",platformSubsidyExpense];
    }
    self.platformSubsidyExpense = butieTitle;

    
    NSString *markTimeStr= self.model.data.repayPeriodtext;
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
    NSString *holdTime = self.model.data.holdTime;
    if ([holdTime length] > 0) {
        holdTime = [NSString stringWithFormat:@"%@~%d",holdTime,anInteger];
    }else{
        holdTime = [NSString stringWithFormat:@"%d",anInteger];
        if ([markTimeStr isEqualToString:@""]) { //如果repayPeriodText为空情况下
            holdTime =  self.model.data.repayPeriod;
        }
    }
    markTimeStr = [holdTime stringByAppendingString:dateString];
    
    self.markTimeStr = markTimeStr;
    

    
    int completeRate = (completeLoan / borrowAmount) * 100;
    CGFloat curProgress = completeLoan / borrowAmount;
    //进度条中间的百分比label
    if (curProgress > 0 && curProgress < 0.01) {
        completeRate = 1;
    }
    NSString *rateStr = [NSString stringWithFormat:@"%d",completeRate];
    
    self.percentage = rateStr;
    
}
- (void)dealMarkInfo
{
    //标签数组
    NSArray *prdLabelsList = self.model.data.prdLabelsList;
    NSMutableArray *labelPriorityArr = [NSMutableArray arrayWithCapacity:4];
    if (![prdLabelsList isEqual:[NSNull null]]) {
        for (DetailPrdlabelslist *tmpModel in prdLabelsList) {
            
            NSInteger labelPriority = [tmpModel.labelPriority integerValue];
            if (labelPriority > 1) {
                if ([tmpModel.labelName rangeOfString:@"起投"].location == NSNotFound) {
                    [labelPriorityArr addObject:tmpModel.labelName];
                }
            }
        }
    }
    self.markList = [NSArray arrayWithArray:labelPriorityArr];
}
- (void)dealMinuteCountDownData
{
    NSString *stopStatusStr = self.model.data.stopStatus;// 0投标中,1满标
    self.stopStatus = stopStatusStr;
}












#pragma mark ListView
- (NSArray *)getTableViewData
{
    _isP2P = YES;
    NSString *fixUpdate = @"";
    NSString *guaranteeCompanyNameStr  = @"";

    guaranteeCompanyNameStr = self.model.data.guaranteeCompanyName;
    fixUpdate = self.model.data.fixedDate;
    NSMutableArray *dataArr = [NSMutableArray arrayWithCapacity:4];
    //如果没有固定起息日
    if ([fixUpdate isEqual:[NSNull null]] || [fixUpdate isEqualToString:@""] || !fixUpdate) {

        NSMutableDictionary *parmDict1 = [NSMutableDictionary dictionaryWithCapacity:1];
        [parmDict1 setValue:@"一次还清" forKey:@"value"];
        [parmDict1 setValue:@"还款方式" forKey:@"title"];
        [dataArr addObject:parmDict1];
        if (!_isP2P  && [self.model.data.status intValue] !=  2) {
            NSMutableDictionary *parmDict2 = [NSMutableDictionary dictionaryWithCapacity:1];
            [parmDict2 setValue:@"担保方" forKey:@"title"];
            [parmDict2 setValue:guaranteeCompanyNameStr forKey:@"value"];
            [dataArr addObject:parmDict2];

        } else {
            NSMutableDictionary *parmDict3 = [NSMutableDictionary dictionaryWithCapacity:1];
            [parmDict3 setValue:@"100元起" forKey:@"value"];
            [parmDict3 setValue:@"起投金额" forKey:@"title"];
            [dataArr addObject:parmDict3];

            
            NSMutableDictionary *parmDict4 = [NSMutableDictionary dictionaryWithCapacity:1];
            [parmDict4 setValue:@"担保方" forKey:@"title"];
            [parmDict4 setValue:guaranteeCompanyNameStr forKey:@"value"];
            [dataArr addObject:parmDict4];
        }
    } else {
        NSString *fixUpdate = self.model.data.fixedDate;
        NSString *guTitle;
        NSDate *fixDate = [NSDateManager getDateWithDateDes:fixUpdate dateFormatterStr:@"yyyy-MM-dd"];
        guTitle = [NSString stringWithFormat:@"%@",[NSDateManager getDateDesWithDate:fixDate dateFormatterStr:@"yyyy-MM-dd"]];
        
        NSMutableDictionary *parmDict1 = [NSMutableDictionary dictionaryWithCapacity:1];
        [parmDict1 setValue:guTitle forKey:@"value"];
        [parmDict1 setValue:@"固定起息日" forKey:@"title"];
        [dataArr addObject:parmDict1];
        
        NSMutableDictionary *parmDict2 = [NSMutableDictionary dictionaryWithCapacity:1];
        [parmDict2 setValue:@"一次还清" forKey:@"value"];
        [parmDict2 setValue:@"还款方式" forKey:@"title"];
        [dataArr addObject:parmDict2];
        
        if (!_isP2P && [self.model.data.status integerValue] != 2) {
            NSMutableDictionary *parmDict3 = [NSMutableDictionary dictionaryWithCapacity:1];
            [parmDict3 setValue:@"担保方" forKey:@"title"];
            [parmDict3 setValue:guaranteeCompanyNameStr forKey:@"value"];
            [dataArr addObject:parmDict3];
        } else {
            NSMutableDictionary *parmDict4 = [NSMutableDictionary dictionaryWithCapacity:1];
            [parmDict4 setValue:@"100元起" forKey:@"value"];
            [parmDict4 setValue:@"起投金额" forKey:@"title"];
            [dataArr addObject:parmDict4];
            
            NSMutableDictionary *parmDict5 = [NSMutableDictionary dictionaryWithCapacity:1];
            [parmDict5 setValue:@"担保方" forKey:@"title"];
            [parmDict5 setValue:guaranteeCompanyNameStr forKey:@"value"];
            [dataArr addObject:parmDict5];
        }

    }
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
@end
