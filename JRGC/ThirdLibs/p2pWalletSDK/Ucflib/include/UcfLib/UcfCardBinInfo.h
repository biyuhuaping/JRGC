//
//  UcfCardBinInfo.h
//  UcfPaySDK
//
//  Created by vinn on 9/24/14.
//  Copyright (c) 2014 UCF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Macro.h"

@interface UcfCardBinInfo : NSObject

UCF_AS_SINGLETON(UcfCardBinInfo)

- (BOOL)isCreditCard:(NSString *)cardNo;
- (void)clear;
- (NSString *)getBankCardNameFromCardBin:(NSString *)cardBin withReqBankCodeStr:(NSString *)bankCodeStr;
@end
