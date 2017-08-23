//
//  UCFAddedProfitView.h
//  JRGC
//
//  Created by njw on 2017/8/17.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UCFAddedProfitViewDelegate <NSObject>
- (void)addedProfitTipViewDidClickedCloseButton:(UIButton *)button;
@end
@interface UCFAddedProfitView : UIView
@property (weak, nonatomic) IBOutlet UILabel *profitDetailLabel;
@property (weak, nonatomic) id<UCFAddedProfitViewDelegate> delegate;
@end
