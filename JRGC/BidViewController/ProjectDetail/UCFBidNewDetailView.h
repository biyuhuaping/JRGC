//
//  UCFBidNewDetailView.h
//  JRGC
//
//  Created by Qnwi on 15/12/7.
//  Copyright © 2015年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BidNewDetailViewDelegate <NSObject>

- (void)bottomBtnClicked:(id)sender;
- (void)styleGetToBack;
-(void)stopMinuteCountDownViewTimer:(NSTimer *)timer;

@end

@interface UCFBidNewDetailView : UIView


@property(nonatomic,weak) id<BidNewDetailViewDelegate>delegate;

- (id)initWithFrame:(CGRect)frame WithProjectType:(PROJECTDETAILTYPE)type prdList:(NSArray *)prdList dataDic:(NSDictionary*)dic  isP2P:(BOOL)isP2P;
- (void)setProcessViewProcess:(CGFloat)process;

@end
