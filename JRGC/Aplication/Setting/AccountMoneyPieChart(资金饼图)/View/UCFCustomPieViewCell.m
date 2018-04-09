//
//  UCFCustomPieViewCell.m
//  JRGC
//
//  Created by hanqiyuan on 2017/9/15.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFCustomPieViewCell.h"

#import "CustomPieView.h"
@interface UCFCustomPieViewCell()

@property(nonatomic,strong)IBOutlet CustomPieView *chartView;
@end
@implementation UCFCustomPieViewCell
-(void)setPieChartModel:(UCFCustomPieChartModel *)pieChartModel
{
    _pieChartModel = pieChartModel;
    

    //包含文本的视图frame
    _chartView = [[CustomPieView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth , 165)];
    //数据源
    _chartView.segmentDataArray = pieChartModel.pieChartDataArray;
    
    //颜色数组，若不传入，则为随即色
    _chartView.segmentColorArray = pieChartModel.pieChartColorArray;
    
    //标题，若不传入，则为“其他”
    _chartView.segmentTitleArray = pieChartModel.pieChartTitleArray;

    //饼图标题
    self.chartView.pieTitle = pieChartModel.pieChartTitle;
    //动画时间
    _chartView.animateTime = 1;
    
    //内圆的颜色
    _chartView.innerColor = [UIColor whiteColor];
    

    _chartView.pieTitleColor = UIColorWithRGB(0x555555);
    //内圆的半径
    _chartView.innerCircleR = 45/2;
    
    //大圆的半径
    _chartView.pieRadius = 110/2;
    
    //整体饼状图的背景色
    //    chartView.backgroundColor = RGBCOLOR(240, 241, 242, 1.0);
    _chartView.backgroundColor = [UIColor whiteColor];
    
    //圆心位置，此属性会被centerXPosition、centerYPosition覆盖，圆心优先使用centerXPosition、centerYPosition
    _chartView.centerType = PieCenterTypeMiddleRight;
    
    //是否动画
    _chartView.needAnimation = [self checkPieCharData:pieChartModel.pieChartDataArray];
    
    //动画类型，全部只有一个动画；各个部分都有动画
    _chartView.type = PieAnimationTypeOne;
    
    //圆心，相对于饼状图的位置
    _chartView.centerXPosition = ScreenWidth - 20 - 55;
    
    //右侧的文本颜色是否等同于模块的颜色
    _chartView.isSameColor = NO;
    
    //文本的行间距
    _chartView.textSpace = 7;
    
    //文本的字号
    _chartView.textFontSize = 11;
    
    //文本的高度
    _chartView.textHeight = 14;
    
    //文本前的颜色块的高度
    _chartView.colorHeight = 6;
    
    //文本前的颜色块是否为圆
    _chartView.isRound = YES;
    
    //文本距离右侧的间距
    _chartView.textRightSpace = ScreenWidth - 80;
    
    //支持点击事件
    _chartView.canClick = NO;
    
    //点击圆饼后的偏移量
    _chartView.clickOffsetSpace = 10;
    
    //不隐藏右侧的文本
    _chartView.hideText = NO;
    
    //点击触发的block，index与数据源对应
    [_chartView clickPieView:^(NSInteger index) {
        NSLog(@"Click Index:%ld",index);
    }];
    
    //添加到视图上
    [_chartView showCustomViewInSuperView:self.contentView];
    
    //设置默认选中的index，如不需要该属性，可注释
    //[chartView setSelectedIndex:2];
}
-(BOOL)checkPieCharData:(NSMutableArray *)array
{
    double total = 0;
    for (NSString *dataStr in array) {
        total += [dataStr doubleValue];
    }
    return total != 0;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
