//
//  UCFPureTransPageViewModel.h
//  JRGC
//
//  Created by zrc on 2019/2/19.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseViewModel.h"
#import "UCFPureTransBidRootModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UCFPureTransPageViewModel : BaseViewModel
- (void)setDataModel:(UCFPureTransBidRootModel *)model;

@property(nonatomic, copy) NSString     *prdName;
@end

NS_ASSUME_NONNULL_END
