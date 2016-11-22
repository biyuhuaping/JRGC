//
//  UCFNormalNewMarkView.h
//  JRGC
//
//  Created by Qnwi on 15/12/7.
//  Copyright © 2015年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCFBidNewDetailView.h"

@protocol UCFNormalNewMarkViewDelegate <NSObject>

- (void)tableView:tableView didSelectNormalMarkRowAtIndexPath:indexPath;
- (void)investButtonClick:(id)sender;
- (void)toDownView;
- (void)toUpView;
- (void)styleGetToBack;

@end

@interface UCFNormalNewMarkView : UIView<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,BidNewDetailViewDelegate>

@property(nonatomic,weak) id<UCFNormalNewMarkViewDelegate>delegate;

- (id)initWithFrame:(CGRect)frame withDic:(NSDictionary*)dataDic prdList:(NSArray *)prdList contractMsg:(NSArray *)msgArr souceVc:(NSString*)source isP2P:(BOOL)isP2Ptype;
- (void)cretateInvestmentView;
- (void)setProcessViewProcess:(CGFloat)process;

@end
