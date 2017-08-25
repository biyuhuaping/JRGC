//
//  UCFFloatDetailView.h
//  JRGC
//
//  Created by njw on 2017/8/25.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UCFFloatDetailViewDelegate <NSObject>
- (void)curentViewTipViewDidClickedCloseButton:(UIButton *)button;
@end

@interface UCFFloatDetailView : UIView
@property (weak, nonatomic) id<UCFFloatDetailViewDelegate> delegate;
@end
