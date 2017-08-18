//
//  UCFGoldRaiseView.h
//  JRGC
//
//  Created by njw on 2017/8/14.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UCFGoldRaiseView : UIView
@property (weak, nonatomic) IBOutlet UILabel *goldIncreaseAmount;
@property (weak, nonatomic) IBOutlet UILabel *addedProfitLabel;
@property (weak, nonatomic) IBOutlet UILabel *floatProfitLabel;
@property (weak, nonatomic) IBOutlet UILabel *averagePriceLabel;

+ (CGFloat)viewHeight;
@end
