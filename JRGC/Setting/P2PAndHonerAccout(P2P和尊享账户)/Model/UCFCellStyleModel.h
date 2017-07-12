//
//  UCFCellStyleModel.h
//  JRGC
//
//  Created by 张瑞超 on 2017/7/6.
//  Copyright © 2017年 qinwei. All rights reserved.
//
typedef enum : NSUInteger {
    CellStyleDefault,
    CellSepLine,
    CellCustom,
} CellStyle;
#import <Foundation/Foundation.h>

@interface UCFCellStyleModel : NSObject
@property (nonatomic, assign) CellStyle cellStyle;
@property (nonatomic, copy) NSString *leftTitle;
@property (nonatomic, copy) UIImage *rightImage;
@property (nonatomic, copy) NSString *targetClass;
@property (nonatomic) UIColor *sepLineColor;
@property (nonatomic, assign)CGRect sepLineFrame;
@property (nonatomic, assign)CGFloat cellHeight;



- (instancetype) initWithCellStyle:(CellStyle)style WithLeftTitle:(NSString *)title WithRightImage:(UIImage *)image WithTargetClassName:(NSString *)name WithCellHeight:(CGFloat)height WithDelegate:(id)delegate;
@end
