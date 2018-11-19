//
//  UCFHuiShangChooseBankViewCell.m
//  JRGC
//
//  Created by 狂战之巅 on 16/8/15.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFHuiShangChooseBankViewCell.h"
#import "UIColor+Hex.h"
@implementation UCFHuiShangChooseBankViewCell

- (void)awakeFromNib {
    // Initialization code
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)showInfo:(id)data
{
    

    NSDictionary *dic = (NSDictionary *)data;
    
    //设置边线是在顶部还是底部
    if (![dic isKindOfClass:[NSDictionary class]])
    {
        return;
    }
    self.bankName.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"bankName"]];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"logoUrl"]]] placeholderImage:[UIImage imageNamed:@"bank_default"]];
    
    //支持快捷支付银行卡列表
    if ([[dic objectForKey:@"isQuick"] isEqualToString:@"yes"])
    {
        //是否推荐绑卡显示
        if ([[dic allKeys] containsObject:@"isRecommend"] &&  [[dic objectForKey:@"isRecommend"] boolValue])
        {
            self.isQuick.hidden = NO;
            
        }
        else
        {
            self.isQuick.hidden = YES;
        }
        NSString *limitOneTime = [self thousandsIntoThousands:[dic objectForKey:@"limitOneTime"]] ;
        NSString *limitOneDay  = [self thousandsIntoThousands:[dic objectForKey:@"limitOneDay"]];
        self.contentNote.text = [NSString stringWithFormat:@"单笔充值限额%@元，单日充值限额%@元",limitOneTime,limitOneDay];
        [self.contentNote setMoreColor:[UIColor colorWithHexString:@"4AA1F9"] string:limitOneTime];
        [self.contentNote setMoreColor:[UIColor colorWithHexString:@"4AA1F9"] string:limitOneDay];
    }
    else
    {
        //不支持快捷支付银行卡列表
        self.isQuick.hidden = YES;
        self.contentNote.text =[dic objectForKey:@"cozyTips"];
    }
}

- (NSString *)thousandsIntoThousands:(NSString *)thousands
{
    NSInteger money = [thousands integerValue];
    if (money >= 10000)
    {
        money = money / 10000;
        return [NSString stringWithFormat:@"%zd万",money];
    }
    else
    {
        return [NSString stringWithFormat:@"%zd",money];
    }
}

//-(NSRange)rangeOfString:(NSString*)subString inString:(NSString*)string
//{
//    int currentOccurrence = 0;
//    NSInteger occurrence = [self theNumberOfStringElementsThatAppear:string withStringElements:subString];
//    NSRange    rangeToSearchWithin = NSMakeRange(0, [string length]);
//
//    while (YES)
//    {
//        currentOccurrence++;
//        NSRange searchResult = [string rangeOfString:subString options:NULL range:rangeToSearchWithin];
//
//        if (searchResult.location == NSNotFound)
//        {
//            return searchResult;
//        }
//        if (currentOccurrence == occurrence)
//        {
//            return searchResult;
//        }
//
//        NSInteger newLocationToStartAt = searchResult.location + searchResult.length;
//        rangeToSearchWithin = NSMakeRange(newLocationToStartAt, string.length - newLocationToStartAt);
//    }
//}
//- (NSInteger)theNumberOfStringElementsThatAppear:(NSString *)numString withStringElements:(NSString *)elementsString{
//    NSString *string = numString;
//    NSString *subString = elementsString;
//    if (numString!=NULL && ![numString isKindOfClass:[NSString class]] &&elementsString!=NULL && ![elementsString isKindOfClass:[NSString class]]) {
//        NSArray *array = [string componentsSeparatedByString:subString];
//        NSInteger count = [array count] - 1;
//        return count;
//    }else
//    {
//        return 0;
//    }
//
//}
@end
