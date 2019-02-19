//
//  UCFPureTransPageViewModel.m
//  JRGC
//
//  Created by zrc on 2019/2/19.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFPureTransPageViewModel.h"

@interface UCFPureTransPageViewModel ()
@property(nonatomic, strong)UCFPureTransBidRootModel *model;
@end

@implementation UCFPureTransPageViewModel
- (void)setDataModel:(UCFPureTransBidRootModel *)model
{
    self.model = model;
    [self dealBidMessage];
}
- (void)dealBidMessage
{
    //标头
    [self dealBidHeader];
//    //标信息
//    [self dealBidInfo];
//    //二级标签
//    [self dealMarkView];
//    //我的资金
//    [self dealMyFunds];
//    //我的优惠券
//    [self dealMycoupon];
//
//    [self dealMyRecommend];
//    //我的合同
//    [self dealMyContract];
//
//    [self requestCoupnData];
}
- (void)dealBidHeader
{
    self.prdName = self.model.data.name;

}
@end
