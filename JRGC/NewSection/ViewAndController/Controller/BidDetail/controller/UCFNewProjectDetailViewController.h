//
//  UCFNewProjectDetailViewController.h
//  JRGC
//
//  Created by zrc on 2019/1/24.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewBaseViewController.h"
#import "UCFBidDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UCFNewProjectDetailViewController : UCFNewBaseViewController
@property(nonatomic, strong)UCFBidDetailModel *model;
@property(nonatomic,assign) PROJECTDETAILTYPE detailType;

/**
 1 普通标进入的详情 2我投资的标进来的详情
 */
@property(nonatomic, copy) NSString *sourceType;
@end

NS_ASSUME_NONNULL_END
