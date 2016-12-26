//
//  UCFMarkOfBondsRransferNewView.h
//  JRGC
//
//  Created by Qnwi on 15/12/15.
//  Copyright © 2015年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCFBidNewDetailView.h"

@protocol UCFMarkOfBondsRransferNewViewDelegate <NSObject>

- (void)tableView:tableView didSelectMarkOfBondsRransferViewRowAtIndexPath:indexPath;
- (void)investButtonClick:(id)sender;
- (void)toDownView;
- (void)toUpView;
- (void)styleGetToBack;

@end

@interface UCFMarkOfBondsRransferNewView : UIView<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,BidNewDetailViewDelegate>


@property(nonatomic,weak) id<UCFMarkOfBondsRransferNewViewDelegate>delegate;

- (id)initWithFrame:(CGRect)frame withDic:(NSDictionary*)dataDic prdList:(NSArray *)prdList contractMsg:(NSArray *)msgArr souceVc:(NSString *)source type:(NSString *)type isP2P:(BOOL)isP2PType;
-(void)cretateInvestmentView;
- (void)setProcessViewProcess:(CGFloat)process;

@end
