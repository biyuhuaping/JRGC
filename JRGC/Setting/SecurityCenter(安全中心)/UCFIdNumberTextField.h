//
//  UCFIdNumberTextField.h
//  JRGC
//
//  Created by Qnwi on 16/2/24.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UCFIdNumberTextField : UIView<UITextFieldDelegate>


- (id)initWithFrame:(CGRect)frame withText:(NSString*)fldText;
- (NSString*)curText;

@end
