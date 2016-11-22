//
//  UCFTool.h
//  Test01
//
//  Created by NJW on 16/10/19.
//  Copyright © 2016年 NJW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCFTool : NSObject
+ (NSString *) getSinatureWithPar:(NSString *) par;
+ (NSString *)AESWithKey2:(NSString *)key WithDic:(NSDictionary *)dic;
+ (NSString *)getDocumentsPath;
@end
