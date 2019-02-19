//
//  UCFNewTransProjectDetailViewController.h
//  JRGC
//
//  Created by zrc on 2019/2/14.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewBaseViewController.h"
#import "UCFTransBidInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UCFNewTransProjectDetailViewController : UCFNewBaseViewController
@property(nonatomic, strong)UCFTransBidInfoModel *model;
@property(nonatomic,assign) PROJECTDETAILTYPE detailType;
@end

NS_ASSUME_NONNULL_END
