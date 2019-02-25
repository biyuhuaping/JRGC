//
//  UCFTransPureBidApi.m
//  JRGC
//
//  Created by zrc on 2019/2/20.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFTransPureBidApi.h"
@interface UCFTransPureBidApi()
@property(nonatomic, copy)NSString *apptzticket;
@property(nonatomic, copy)NSString *investAmt;
@property(nonatomic, copy)NSString *prdTransferId;

@end
@implementation UCFTransPureBidApi
- (id)initWithApptzticket:(NSString *)apptzticket prdTransferId:(NSString *)prdTransferId InvestAmt:(NSString *)investAmt
{
    self = [super init];
    if (self) {
        self.apptzticket = apptzticket;
        self.investAmt = investAmt;
        self.prdTransferId = prdTransferId;
    }
    return self;
}
- (NSString *)requestUrl
{
    return @"api/investTraClaims/v2/submit.json";
}
- (id)requestArgument {
    return @{@"investTranTicket":self.apptzticket,@"fromSite":@"1",@"investAmt":self.investAmt,@"prdTransferId":self.prdTransferId};
}
- (NSString *)modelClass
{
//    添加新model
    return @"UCFBidModel";
}
@end
