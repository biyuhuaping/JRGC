//
//  UCFDrawGoldHeaderView.h
//  JRGC
//
//  Created by hanqiyuan on 2017/11/10.
//  Copyright © 2017年 JRGC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILabel+Misc.h"
@protocol UCFDrawGoldHeaderViewDelegate <NSObject>
- (void)clickGoldGoodsDetail;
@end

@interface UCFDrawGoldHeaderView : UIView
@property (strong, nonatomic)IBOutlet UILabel *goldAmountLabel;
@property (assign,nonatomic) id<UCFDrawGoldHeaderViewDelegate> delegate;
@end
