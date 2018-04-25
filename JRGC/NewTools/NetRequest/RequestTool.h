//
//  RequestTool.h
//  JRGC
//
//  Created by zrc on 2018/4/25.
//  Copyright © 2018年 JRGC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RequestTool;

typedef void(^RequestFinishedBlock)(id<NetworkModuleDelegate> owner,kSXTag kSXTag, id respose, NSError *error);

@interface RequestTool : NSObject

@property(nonatomic, assign)kSXTag kSXTag;
@property(nonatomic, strong)NSDictionary    *parmDict;
@property(nonatomic, weak)id<NetworkModuleDelegate>owner;
@property(nonatomic, copy)RequestFinishedBlock  requetBlock;
@property(nonatomic, copy)NSString  *url;

- (instancetype)initWithURL:(NSString *)url pramDict:(NSDictionary *)dict Owmer:(id<NetworkModuleDelegate>)owner Tag:(kSXTag)tag FinishedBlock:(RequestFinishedBlock)block;

- (void)startPostRequest;

@end



