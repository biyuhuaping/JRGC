//
//  UCFLoginShaowView.h
//  JRGC
//
//  Created by Qnwi on 15/12/4.
//  Copyright © 2015年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginShadowDelegate <NSObject>

- (void)btnShadowClicked:(id)sender;
- (void)regBtnclicked:(id)sender;
- (void)moreBtnclicked:(id)sender;

@end

@interface UCFLoginShaowView : UIView



@property(nonatomic,weak) id<LoginShadowDelegate>delegate;

@end
