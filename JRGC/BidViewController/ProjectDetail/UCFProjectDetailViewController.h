//
//  UCFProjectDetailViewController.h
//  JRGC
//
//  Created by HeJing on 15/4/10.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//  标详情页面

#import "UCFBaseViewController.h"
#import "UCFNormalNewMarkView.h"
#import "UCFNormalNewMarkView.h"
#import "UCFRightInterestNewView.h"
#import "UCFMarkOfBondsRransferNewView.h"

@interface UCFProjectDetailViewController : UCFBaseViewController<UCFNormalNewMarkViewDelegate,UCFRightInterestNewViewDelegate,UCFMarkOfBondsRransferNewViewDelegate>


@property(nonatomic,assign) PROJECTDETAILTYPE detailType;
@property(nonatomic,strong) NSString *sourceVc;

- (id)initWithDataDic:(NSDictionary *)dic isTransfer:(BOOL)isTransfer withLabelList:(NSArray*)labelList;

@end
