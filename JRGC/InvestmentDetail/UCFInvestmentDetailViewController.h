//
//  UCFInvestmentDetailViewController.h
//  JRGC
//
//  Created by HeJing on 15/4/10.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFBaseViewController.h"
#import "UCFInvestmentDetailView.h"
#import "UCF404ErrorView.h"
@interface UCFInvestmentDetailViewController : UCFBaseViewController<InvestmentDetailDelegate,FourOFourViewDelegate>


@property (nonatomic, copy) NSString *billId;
@property BOOL flagGoRoot;//***是否退回到跟视图
@property (nonatomic, strong) NSString *detailType;//1普通投资详情 2 债权投资详情

@end
