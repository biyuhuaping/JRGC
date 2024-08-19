//
//  UCFAssetTipView.h
//  JRGC
//
//  Created by njw on 2017/7/20.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UCFAssetTipViewDelegate <NSObject>
- (void)assetTipViewDidClickedCloseButton:(UIButton *)button;
@end

@interface UCFAssetTipView : UIView
@property (weak, nonatomic) IBOutlet UILabel *assetLabel;
@property (weak, nonatomic) id<UCFAssetTipViewDelegate> delegate;
@end
