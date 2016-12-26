//
//  UCFCashAndTopUp.h
//  JRGC
//
//  Created by NJW on 16/4/20.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UCFCashAndTopUp;
@protocol UCFCashAndTopUpDelegate <NSObject>

- (void)cashAndTopUp:(UCFCashAndTopUp *)cashAndTopUp didClickedCashButton:(UIButton *)cashButton;
- (void)cashAndTopUp:(UCFCashAndTopUp *)cashAndTopUp didClickedTopUpButton:(UIButton *)topUpButton;

@end

@interface UCFCashAndTopUp : UIView
@property (nonatomic, weak) id<UCFCashAndTopUpDelegate> delegate;
@end
