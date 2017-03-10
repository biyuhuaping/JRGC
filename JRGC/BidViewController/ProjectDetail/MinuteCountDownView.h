//
//  MinuteCountDownView.h
//  毫秒倒计时
//
//  Created by hanqiyuan on 17/3/10.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NZLabel.h"
@interface MinuteCountDownView : UIView
@property(nonatomic, strong) IBOutlet UILabel *tipLabel;
@property(nonatomic, assign)double timeInterval;
@property(nonatomic, strong)NSTimer *timer ; //定时器
@property(nonatomic, strong)NSString *isStop ; //该标是否结束
-(void)stopTimer;
-(void)startTimer;
@end
