//
//  UCFGetUserPhoneNumRequest.m
//  JRGC
//
//  Created by 金融工场 on 2019/5/24.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFGetUserPhoneNumRequest.h"

@implementation UCFGetUserPhoneNumRequest
- (id)init
{
    if (self = [super init]) {
    }
    return self;
}
- (NSString *)requestUrl {
    return @"api/userInfoMess/v2/queryUserMobile.json";
}
- (id)requestArgument {
    return @{};
}
//- (NSString *)modelClass
//{
//    return @"UCFHomeMallDataModel";
//}
@end
