//
//  CircleMapView.h
//  CircleConstructionMAP
//
//  Created by 余晋龙 on 16/8/20.
//  Copyright © 2016年 余晋龙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCFDataStaticsModel.h"

@interface CircleMapView : UIView
@property(nonatomic , assign) CGRect fFrame;
@property(nonatomic , strong) UCFDataStaticsModel *model; //数据数组
@property(nonatomic , assign) CGFloat circleRadius;//半径

@end
