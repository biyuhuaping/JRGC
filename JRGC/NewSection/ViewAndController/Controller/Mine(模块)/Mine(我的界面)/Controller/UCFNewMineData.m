//
//  UCFNewMineData.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/1/18.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewMineData.h"

@implementation UCFNewMineData

- (NSArray *)getEarningsList
{
    //我的工贝,工力
    //回款日历,优质债权,商城订单
    NSMutableArray *array = [NSMutableArray array];
    
    NSDictionary *sign = [NSDictionary dictionaryWithObjectsAndKeys:@"mine_icon_sign.png",@"img",@"每日签到",@"tit", nil];
    [array addObject:sign];
    
    NSDictionary *shell = [NSDictionary dictionaryWithObjectsAndKeys:@"mine_icon_shell.png",@"img",@"我的工贝",@"tit", nil];
    [array addObject:shell];
    
    NSDictionary *been = [NSDictionary dictionaryWithObjectsAndKeys:@"mine_icon_been.png",@"img",@"我的工豆",@"tit", nil];
    [array addObject:been];
    
    NSDictionary *coupon = [NSDictionary dictionaryWithObjectsAndKeys:@"mine_icon_coupon.png",@"img",@"优惠券",@"tit", nil];
    [array addObject:coupon];
    
    NSDictionary *rebate = [NSDictionary dictionaryWithObjectsAndKeys:@"mine_icon_rebate.png",@"img",@"邀请返利",@"tit", nil];
    [array addObject:rebate];

    return [array copy];
}
- (NSArray *)getProjectList
{
    //回款日历,优质债权,商城订单
    NSMutableArray *array = [NSMutableArray array];
    
    NSDictionary *calendar = [NSDictionary dictionaryWithObjectsAndKeys:@"mine_icon_calendar.png",@"img",@"回款日历",@"tit", nil];
    [array addObject:calendar];
    
    NSDictionary *project = [NSDictionary dictionaryWithObjectsAndKeys:@"mine_icon_project.png",@"img",@"债权出借",@"tit", nil];
    [array addObject:project];
    
    NSDictionary *intelligent = [NSDictionary dictionaryWithObjectsAndKeys:@"mine_icon_intelligent.png",@"img",@"智能出借",@"tit", nil];
    [array addObject:intelligent];
    
    NSDictionary *respect = [NSDictionary dictionaryWithObjectsAndKeys:@"mine_icon_respect.png",@"img",@"尊享项目",@"tit", nil];
    [array addObject:respect];
    
    NSDictionary *gold = [NSDictionary dictionaryWithObjectsAndKeys:@"mine_icon_gold.png",@"img",@"持有黄金",@"tit", nil];
    [array addObject:gold];
    
    NSDictionary *shoplist = [NSDictionary dictionaryWithObjectsAndKeys:@"mine_icon_shoplist.png",@"img",@"商城订单",@"tit", nil];
    [array addObject:shoplist];

    
    return [array copy];
    
}
- (NSArray *)getAssistList
{
    //g服务中心,客服热线
    NSMutableArray *array = [NSMutableArray array];
    
    NSDictionary *service = [NSDictionary dictionaryWithObjectsAndKeys:@"mine_icon_service.png",@"img",@"服务中心",@"tit", nil];
    [array addObject:service];
    
    NSDictionary *noble = [NSDictionary dictionaryWithObjectsAndKeys:@"mine_icon_noble.png",@"img",@"客服热线",@"tit", nil];
    [array addObject:noble];
    
    return [array copy];
}
@end
