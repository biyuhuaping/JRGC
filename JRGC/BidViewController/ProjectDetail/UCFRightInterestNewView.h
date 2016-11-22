//
//  UCFRightInterestNewView.h
//  JRGC
//
//  Created by Qnwi on 15/12/9.
//  Copyright © 2015年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCFBidNewDetailView.h"

@protocol UCFRightInterestNewViewDelegate <NSObject>

- (void)tableView:tableView didSelectNormalMarkOfRightRowAtIndexPath:indexPath;
- (void)investButtonClick:(id)sender;
- (void)toDownView;
- (void)toUpView;
- (void)styleGetToBack;

@end

@interface UCFRightInterestNewView : UIView<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,BidNewDetailViewDelegate>

@property(nonatomic,weak) id<UCFRightInterestNewViewDelegate>delegate;

- (id)initWithFrame:(CGRect)frame withDic:(NSDictionary*)dataDic prdList:(NSArray *)prdList contractMsg:(NSArray *)msgArr souceVc:(NSString*)source isP2P:(BOOL)isP2PType;
-(void)cretateInvestmentView;
- (void)setProcessViewProcess:(CGFloat)process;

@end
