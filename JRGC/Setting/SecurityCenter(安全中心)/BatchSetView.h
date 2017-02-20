//
//  BatchSetView.h
//  JRGC
//
//  Created by 金融工场 on 2017/2/16.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BatchSetView : UIView
@property (nonatomic,copy) NSString *iconName;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *des;
+ (instancetype)viewFromNIB;
@end
