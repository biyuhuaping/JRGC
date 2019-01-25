//
//  MinuteCountDownView.h
//  毫秒倒计时
//
//  Created by hanqiyuan on 17/3/10.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "MinuteCountDownView.h"
#import "HWWeakTimer.h"

@interface MinuteCountDownView (){
  NSInteger _passTime;
}

@property (strong, nonatomic) IBOutlet NZLabel *daysLabel;
@property(nonatomic, strong)IBOutlet NZLabel *hoursLabel;
@property(nonatomic, strong)IBOutlet NZLabel *minutesLabel;
@property(nonatomic, strong)IBOutlet NZLabel *secondsLabel;

@end

@implementation MinuteCountDownView

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    
//    if (self) {
//        self =  [[[NSBundle mainBundle] loadNibNamed:@"MinuteCountDownView" owner:nil options:nil] firstObject];
//        self.frame = frame;
//        _passTime=0.0;
//    }
//    return self;
//}
-(void)stopTimer{
    [self.timer setFireDate:[NSDate  distantFuture]];
    [self.timer invalidate];
    self.timer = nil;
    
}
-(void)startTimer{
    _passTime= 0;
//    [self.timer setFireDate:[NSDate distantPast]];
    //时间间隔是1秒
    _timer = [HWWeakTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
//    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:UITrackingRunLoopMode];
      [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}
//- (void)setTimeInterval:(double)timeInterval
//{
//    _timeInterval = timeInterval ;
//    if (_timeInterval!=0)
//    {
////        //时间间隔是1秒
////        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
////        
////        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:UITrackingRunLoopMode];
//    }else{
//        [self stopTimer];
//    }
//}

-(void)setSourceVC:(NSString *)sourceVC{
    _sourceVC = sourceVC;
//    if ([_sourceVC isEqualToString:@"UCFProjectDetailVC"]) {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopTimer) name:@"StopMinuteCountDownTimer1" object:nil];
//    }else{
//       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopTimer) name:@"StopMinuteCountDownTimer2" object:nil];
//    }
}
-(void)setIsStopStatus:(NSString *)isStopStatus{
    _isStopStatus = isStopStatus;
    if ([isStopStatus intValue] == 1) {
        for (UILabel *label in self.subviews) {
            if (label.tag == 101) {
                label.hidden = NO;
                label.textColor = UIColorWithRGB(0x999999);
            }else{
                label.hidden = YES;
            }
        }
    }else{
        for (UILabel *label in self.subviews) {
            if (label.tag == 101) {
                label.hidden = NO;
                label.textColor = UIColorWithRGB(0x333333);
            }else{
                label.hidden = NO;
            }
        }
    }
}
// 每间隔1000毫秒定时器触发执行该方法
- (void)timerAction
{
    [self getTimeFromTimeInterval:_timeInterval] ;
    
    // 当时间间隔为0时干掉定时器
    if (_timeInterval-_passTime == 0)
    {
        [_timer invalidate] ;
        _timer = nil ;
    }
}
// 通过时间间隔计算具体时间(小时,分,秒)
- (void)getTimeFromTimeInterval:(NSInteger)timeInterval
{
    //1s
    _passTime += 1000.f;//所以每次过去1秒
    //小时数
    NSString *hours = [NSString stringWithFormat:@"%ld", (NSInteger)((timeInterval-_passTime)/1000/60/60)];
    //分钟数
    NSString *minute = [NSString stringWithFormat:@"%ld", (NSInteger)((timeInterval-_passTime)/1000/60)%60];
    //秒数
    NSString *second = [NSString stringWithFormat:@"%ld", ((NSInteger)(timeInterval-_passTime)/1000)%60];
    
    //防止有乱数据
    hours = [self getCurrentStr:hours];
    minute = [self getCurrentStr:minute];
    second = [self getCurrentStr:second];
    self.daysLabel.text = [NSString stringWithFormat:@"%02d",[hours intValue]/24];
    self.hoursLabel.text = [NSString stringWithFormat:@"%02d",[hours intValue]%24];
    self.minutesLabel.text = [NSString stringWithFormat:@"%02d",[minute intValue]];
    self.secondsLabel.text = [NSString stringWithFormat:@"%02d",[second intValue]];
//    [self.daysLabel setFontColor:UIColorWithRGB(0x333333) string:@"天"];
//    [self.hoursLabel setFontColor:UIColorWithRGB(0x333333) string:@"时"];
//    [self.minutesLabel setFontColor:UIColorWithRGB(0x333333) string:@"分"];
//    [self.secondsLabel setFontColor:UIColorWithRGB(0x333333) string:@"秒"];
    
    DDLogDebug(@"距结束 %@天%@时%@分%@秒",self.daysLabel.text,
         self.hoursLabel.text,
         self.minutesLabel.text,
         self.secondsLabel.text );
    if (timeInterval - _passTime <= 0) {
        [self stopTimer];
    }
}
-(NSString *)getCurrentStr:(NSString *)str{
    if ([str floatValue] <= 0) {
        str = @"0";
    }
    return str;
}

- (void)blindVM:(UVFBidDetailViewModel *)vm
{
    @PGWeakObj(self);
   UCFBidDetailModel *model = [vm getDataModel];
    [self.KVOController observe:vm keyPaths:@[@"stopStatus"] options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSString *keyPath = change[@"FBKVONotificationKeyPathKey"];
        if ([keyPath isEqualToString:@"stopStatus"]) {
            NSString *stopStatus = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if ([stopStatus intValue] == 0) {
                selfWeak.timeInterval = model.data.intervalMilli;
                [selfWeak startTimer];
                selfWeak.tipLabel.text = @"剩余时间";//
            } else {
//                NSString *startTimeStr = [_dic objectSafeForKey:@"startTime"];
//                NSString *endTimeStr = [_dic objectSafeForKey:@"fullTime"];
//                if (_type == PROJECTDETAILTYPEBONDSRRANSFER){//债权转让
//                    startTimeStr = [_dic objectSafeForKey:@"putawaytime"];
//                    endTimeStr = [_dic objectSafeForKey:@"soldOutTime"];
//                    _minuteCountDownView.tipLabel.text = [NSString stringWithFormat:@"转让期: %@ 至 %@",startTimeStr,endTimeStr];
//                }else{
//                    _minuteCountDownView.tipLabel.text = [NSString stringWithFormat:@"筹标期: %@ 至 %@",startTimeStr,endTimeStr];
//                }
            }
        }
    }];
}
- (void)dealloc
{
    
}
@end

