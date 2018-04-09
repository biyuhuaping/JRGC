//
//  JRGCViewForCWRresult.h
//  JRGC
//
//  Created by 秦 on 16/3/22.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JRGCViewForCWRresult : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imageCenter;
@property (weak, nonatomic) IBOutlet UILabel *lable_wrong_1;
@property (weak, nonatomic) IBOutlet UILabel *lable_wrong_2;
@property (weak, nonatomic) IBOutlet UILabel *lable_wrong_3;
@property (weak, nonatomic) IBOutlet UIButton *but_Left;
@property (weak, nonatomic) IBOutlet UIButton *but_right;
@property (weak, nonatomic) IBOutlet UILabel *lable_showuse;
@property (weak, nonatomic) IBOutlet UIButton *but_start;

@end
