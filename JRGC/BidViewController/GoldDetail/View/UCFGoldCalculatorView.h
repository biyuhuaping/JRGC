//
//  UCFGoldCalculatorView.h
//  JRGC
//
//  Created by hanqiyuan on 2017/7/12.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UCFGoldCalculatorView : UIView
@property (nonatomic,strong)NSString *nmTypeIdStr;
@property (strong, nonatomic) IBOutlet UITextField *goldMoneyTextField;
- (IBAction)closeView:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *calculatorView;

@end
