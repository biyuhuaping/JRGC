//
//  UCFGoldRechargeHeaderView.h
//  JRGC
//
//  Created by njw on 2017/7/13.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UCFGoldRechargeHeaderView;
@protocol UCFGoldRechargeHeaderViewDelegate <NSObject>
- (void)goldRechargeHeader:(UCFGoldRechargeHeaderView *)goldHeader didClickedHandInButton:(UIButton *)handInButton withMoney:(NSString *)money;
- (void)goldRechargeHeader:(UCFGoldRechargeHeaderView *)goldHeader didClickedConstractWithId:(NSString *)constractId;
@end

@interface UCFGoldRechargeHeaderView : UIView
@property (weak, nonatomic) id<UCFGoldRechargeHeaderViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) NSArray *constracts;
@end
