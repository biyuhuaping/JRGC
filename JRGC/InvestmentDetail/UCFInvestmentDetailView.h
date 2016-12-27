//
//  UCFInvestmentDetailView.h
//  JRGC
//
//  Created by HeJing on 15/4/15.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCFInvestDetailModel.h"

@class UCFInvestmentDetailView, UCFConstractModel;
@protocol InvestmentDetailDelegate <NSObject>
@optional
- (void)tableView:(UITableView *)tableView didSelectInvestmentDetailRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)investmentDetailView:(UCFInvestmentDetailView *)investmentDetailView didSelectConstractDetailWithModel:(UCFConstractModel *)constract;
- (void)headBtnClicked:(id)sender selectViewId:(NSString*)uuid state:(NSString*)state;

@end


@interface UCFInvestmentDetailView : UIView <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UCFInvestDetailModel *investDetailModel;
@property(nonatomic,retain) id<InvestmentDetailDelegate>delegate;

- (id) initWithFrame:(CGRect)frame detailType:(NSString*)tp;

@end
