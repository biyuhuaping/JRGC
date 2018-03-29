//
//  UCFGoldDetailHeaderView.m
//  JRGC
//
//  Created by hanqiyuan on 2017/7/4.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldDetailHeaderView.h"
#import "UILabel+Misc.h"
#import "ToolSingleTon.h"
#import "MDRadialProgressView.h"
#import "MDRadialProgressTheme.h"
#import "SDLoopProgressView.h"
#import "MDRadialProgressLabel.h"
@interface UCFGoldDetailHeaderView()
{
    SDLoopProgressView *_proressView;
}

@property (strong, nonatomic) IBOutlet UILabel *annualRateLabel;
@property (strong, nonatomic) IBOutlet UILabel *periodTermLabel;
@property (strong, nonatomic) IBOutlet UILabel *remainAmountLabel;
@property (strong, nonatomic) IBOutlet UILabel *realGoldPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *remainAmountLabelTitle;

@end
@implementation UCFGoldDetailHeaderView

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];

    if (self) {
        
        
        //进度条部分
        CGRect frame = CGRectMake(ScreenWidth - [Common calculateNewSizeBaseMachine:130],self.frame.size.height - [Common calculateNewSizeBaseMachine:130], [Common calculateNewSizeBaseMachine:115], [Common calculateNewSizeBaseMachine:115]);
        _circleProgress = [[MDRadialProgressView alloc] initWithFrame:frame];
        _circleProgress.progressTotal = 100;
        _circleProgress.progressCounter = 10;
        _circleProgress.theme.sliceDividerHidden = YES;
        _circleProgress.theme.thickness = 12;
        _circleProgress.theme.centerColor = UIColorWithRGB(0x28335c);
        _circleProgress.theme.incompletedColor = UIColorWithRGB(0x162138);
        _circleProgress.theme.completedColor = UIColorWithRGB(0xffc027); //
        _circleProgress.label.hidden = YES;
        [self addSubview:_circleProgress];
        
        _proressView = [[SDLoopProgressView alloc] initWithFrame:frame];
        _proressView.center = _circleProgress.center;
        _proressView.completedColor = UIColorWithRGB(0xffc027);
        _proressView.progress = 0;
        [self addSubview:_proressView];
        
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.remainAmountLabel.textColor = [UIColor whiteColor];
    self.remainAmountLabelTitle.textColor = [UIColor whiteColor];
}

-(void)setGoldModel:(UCFGoldModel *)goldModel
{
    _goldModel = goldModel;
    self.annualRateLabel.text = [NSString stringWithFormat:@"%@克/100克",goldModel.annualRate];
    [self.annualRateLabel setFont:[UIFont systemFontOfSize:15] string:@"克/100克"];
    self.periodTermLabel.text = [NSString stringWithFormat:@"%@",goldModel.periodTerm];
    [self.periodTermLabel setFont:[UIFont systemFontOfSize:15] string:@"天"];
    [self.periodTermLabel setFont:[UIFont systemFontOfSize:15] string:@"个月"];
    self.remainAmountLabel.text = [NSString stringWithFormat:@"%.3lf克",[goldModel.remainAmount doubleValue]];
    self.remainAmountLabel.textColor = [UIColor whiteColor];
    self.realGoldPriceLabel.text = [NSString stringWithFormat:@"实时金价(元/克)¥%.2lf",[ToolSingleTon  sharedManager].readTimePrice];
    
    float Progress = 1 - [goldModel.remainAmount doubleValue]/[goldModel.totalAmount floatValue];
    int progressInt = (int)(Progress *100);
    NSString* percentageStr =[NSString stringWithFormat:@"%d%%",progressInt];
    
    CGSize percentageStrSize = [percentageStr sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:30]}];
    UILabel* rateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0,percentageStrSize.width ,percentageStrSize.height)];
    rateLabel.text = percentageStr;
    rateLabel.center = _proressView.center;
    rateLabel.font = [UIFont systemFontOfSize:30];
    rateLabel.textColor = [UIColor whiteColor];
    rateLabel.textAlignment = NSTextAlignmentCenter;
    [rateLabel setFont: [UIFont systemFontOfSize:15] string:@"%"];
    [self addSubview:rateLabel];
}
- (void)setProcessViewProcess:(CGFloat)process
{
    _proressView.progress = process;
}
@end
@interface UCFGoldCurrentDetailHeaderView()

@property (strong, nonatomic) IBOutlet UILabel *annualRateLabel;

@property (strong, nonatomic) IBOutlet UILabel *minPurchaseAmountLabel;

@property (strong, nonatomic) IBOutlet UILabel *realGoldPriceLabel;
@end
@implementation UCFGoldCurrentDetailHeaderView

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.realGoldPriceLabel.text = [NSString stringWithFormat:@"%.2lf元/克",[ToolSingleTon  sharedManager].readTimePrice];
    self.annualRateLabel.text = [NSString stringWithFormat:@"%.2lf%%",[self.goldModel.annualRate floatValue]];
    [self.annualRateLabel setFont: [UIFont systemFontOfSize:22] string:@"%"];
}



@end
