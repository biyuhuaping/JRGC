//
//  ASIHTTPRequest+Owner.h
//  JRGC
//
//  Created by zrc on 2018/3/22.
//  Copyright © 2018年 JRGC. All rights reserved.
//

#import "ASIHTTPRequest.h"

@interface ASIHTTPRequest (Owner)
@property(nonatomic, weak)id<NetworkModuleDelegate> owner;
@end
