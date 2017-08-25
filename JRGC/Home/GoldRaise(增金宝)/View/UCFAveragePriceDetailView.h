//
//  UCFAveragePriceDetailView.h
//  JRGC
//
//  Created by njw on 2017/8/25.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UCFAveragePriceDetailViewDelegate <NSObject>
- (void)averageDetaiViewTipViewDidClickedCloseButton:(UIButton *)button;
@end

@interface UCFAveragePriceDetailView : UIView
@property (weak, nonatomic) id<UCFAveragePriceDetailViewDelegate> delegate;
@end
