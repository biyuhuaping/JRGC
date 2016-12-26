//
//  RechargeFixedTelNumView.h
//  JRGC
//
//  Created by AppGroup on 16/9/28.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RechargeFixedTelNumView : UIView

//@property (weak, nonatomic) IBOutlet UIView *topLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIView *telBaseView;
@property (weak, nonatomic) IBOutlet UITextField *telTextField;
@property (weak, nonatomic) IBOutlet UIView *validCodeBaseView;
@property (weak, nonatomic) IBOutlet UITextField *validTextField;
@property (weak, nonatomic) IBOutlet UIButton *getValidCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@end
