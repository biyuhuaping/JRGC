//
//  UCFCellStyleModel.m
//  JRGC
//
//  Created by 张瑞超 on 2017/7/6.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFCellStyleModel.h"

@implementation UCFCellStyleModel
- (instancetype) initWithCellStyle:(CellStyle)style WithLeftTitle:(NSString *)title WithRightImage:(UIImage *)image WithTargetClassName:(NSString *)name WithCellHeight:(CGFloat)height WithDelegate:(id)delegate
{
    self.cellStyle = style;
    self.leftTitle = title;
    self.rightImage = image;
    self.targetClass = name;
    self.cellHeight = height;
    return self;
}
@end
