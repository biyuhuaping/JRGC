//
//  UcfCardBINModel.h
//  UcfPaySDK
//
//  Created by vinn on 5/23/14.
//  Copyright (c) 2014 UCF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UcfCardBINModel : NSObject

@property(nonatomic, copy) NSString *type;
@property(nonatomic, copy) NSString *sname;
@property(nonatomic, copy) NSString *bin;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, assign) NSInteger length;

@end
