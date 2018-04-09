//
//  MaskView.h
//  印章demo
//
//  Created by NJW on 15/4/22.
//  Copyright (c) 2015年 NJW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrintView : UIView
@property (nonatomic, assign) NSInteger conponType;
@property (nonatomic, copy) NSString *useTime;

- (instancetype)initWithFrame:(CGRect)frame andTime:(NSString *)time;
@end
