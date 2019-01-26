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
@end

NS_ASSUME_NONNULL_END
