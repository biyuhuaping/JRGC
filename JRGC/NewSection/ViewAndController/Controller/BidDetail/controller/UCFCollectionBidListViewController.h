//
//  UCFCollectionBidListViewController.h
//  JRGC
//
//  Created by zrc on 2019/3/14.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UCFCollectionBidListViewController : UCFNewBaseViewController
@property(nonatomic, copy)NSString     *colPrdClaimId;
@property(nonatomic, copy) NSString *listType; //0 代表可投项目 1代表已满项目
@property(nonatomic, copy)NSString *prdClaimsOrderStr;

- (void)refreshDataWithOrderStr:(NSString *)prdClaimsOrderStr andListType:(NSString *)listType;
@end

NS_ASSUME_NONNULL_END
