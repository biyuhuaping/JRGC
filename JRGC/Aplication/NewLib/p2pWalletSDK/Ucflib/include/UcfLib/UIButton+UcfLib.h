//
//  UIButton+UcfLib.h
//  UcfLib
//
//  Created by 杨名宇 on 29/11/2016.
//  Copyright © 2016 Ucf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (UcfLib)

- (void)setButtonBlock:(void (^)(NSInteger tag))block;

@end
