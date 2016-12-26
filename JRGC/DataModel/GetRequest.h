//
//  GetRequest.h
//  JRGC
//
//  Created by 金融工场 on 15/1/22.
//  Copyright (c) 2015年 www.ucfgroup.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "NetworkModule.h"

@interface GetRequest : NSObject
{
    ASIHTTPRequest* _request;
    id<NetworkModuleDelegate> owner;
}
@property(nonatomic,assign)id<NetworkModuleDelegate> owner;
@property (assign) kSXTag sxTag;
- (void)getData:(NSString *)data delegate:(id)delegate;
- (void)cancel;
@end
