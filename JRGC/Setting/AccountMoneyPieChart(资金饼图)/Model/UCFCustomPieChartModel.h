//
//  UCFCustomPieChartModel.h
//  JRGC
//
//  Created by hanqiyuan on 2017/9/15.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCFCustomPieChartModel : NSObject

@property (nonatomic ,assign)NSInteger pieChartWidth;

@property (nonatomic ,assign)NSInteger pieChartHeight;

@property (nonatomic ,strong)NSString *pieChartTitle;

@property (nonatomic,strong) NSMutableArray *pieChartDataArray;

@property (nonatomic,strong) NSMutableArray *pieChartTitleArray;

@property (nonatomic,strong) NSMutableArray *pieChartColorArray;

@end
