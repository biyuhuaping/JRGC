//
//  UCFCollectionPureRequest.m
//  JRGC
//
//  Created by zrc on 2019/3/18.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFCollectionPureRequest.h"
//#import "UCFBatchRootModel.h"
@interface UCFCollectionPureRequest()
@property(nonatomic, strong)NSDictionary *parmDict;
@end
@implementation UCFCollectionPureRequest

- (instancetype)initWithParmDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.parmDict = dict;
    }
    return self;
}
- (NSString *)requestUrl
{
    return @"api/invest/v2/batchInvest.json";
}
- (id)requestArgument {
    return self.parmDict;
}
- (NSString *)modelClass
{
    //    添加新model
    return @"UCFCollectRootModel";
}

@end
