//
//  ModelTransition.m
//  GeneralProject
//
//  Created by kuangzhanzhidian on 2018/5/4.
//  Copyright © 2018年 kuangzhanzhidian. All rights reserved.
//

#import "ModelTransition.h"
#import "YYModel.h"

@implementation ModelTransition

+ (id)TransitionModelClassName:(Class)className dataGenre:(NSDictionary* )dataDic
{
    if (dataDic != nil && [dataDic isKindOfClass:[NSDictionary class]] && dataDic.count > 0 && [dataDic objectForKey:@"data"] )
    {
//        if ([[dataDic objectForKey:@"data"] isKindOfClass:[NSString class]])
//        {
//            NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:dataDic];
//            NSString *tempDataStr = [dataDic objectForKey:@"data"];
//            //先把嵌套的json字符串转成字典
//            NSDictionary *tempDataDic = [Data dictionaryWithJsonString:tempDataStr];
//            if ([tempDic objectForKey:@"data"]) {
//                [tempDic removeObjectForKey:@"data"];
//                [tempDic setValue:tempDataDic forKey:@"data"];
//            }
//            return [className yy_modelWithJSON:tempDic];
        
//        }
        if ([[dataDic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
        {
            return [className yy_modelWithJSON:dataDic];
        }
        
    }
    return [className yy_modelWithJSON:dataDic];
}

@end
