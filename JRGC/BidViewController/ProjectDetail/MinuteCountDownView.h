//
//  MinuteCountDownView.h
//  毫秒倒计时
//
//  Created by hanqiyuan on 17/3/10.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NZLabel.h"
#import "UVFBidDetailViewModel.h"
@interface MinuteCountDownView : UIView
@property(nonatomic, strong) IBOutlet UILabel *tipLabel;
@property(nonatomic, assign) NSInteger timeInterval;
@property(nonatomic, strong)NSTimer *timer ; //定时器
@property(nonatomic, strong)NSString *isStopStatus ; //该标是否结束

@property(nonatomic, strong)NSString *sourceVC ; //那个页面进来的
-(void)stopTimer;
-(void)startTimer;
- (void)blindVM:(UVFBidDetailViewModel *)vm;
@end
