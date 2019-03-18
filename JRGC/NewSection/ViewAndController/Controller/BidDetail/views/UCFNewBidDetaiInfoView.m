//
//  UCFNewBidDetaiInfoView.m
//  JRGC
//
//  Created by zrc on 2019/1/25.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewBidDetaiInfoView.h"
#import "MDRadialProgressView.h"
#import "MDRadialProgressLabel.h"
#import "SDLoopProgressView.h"
#import "MDRadialProgressTheme.h"
#import "NSObject+Compression.h"
#import "UILabel+Misc.h"
@interface UCFNewBidDetaiInfoView()
@property(nonatomic, strong)MDRadialProgressView *circleProgress;
@property(nonatomic, strong)SDLoopProgressView *proressView;

@property(nonatomic, strong)UILabel *rateLab;      //利息
@property(nonatomic, strong)UILabel *availableMoneyLab;  //可投金额
@property(nonatomic, strong)UILabel *totalMoneyLab;//总借款额
@property(nonatomic, strong)UILabel *timeLimitLab;//期限


@end


@implementation UCFNewBidDetaiInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.rootLayout.useFrame = YES;
        
        UIImageView *baseimageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        baseimageView.userInteractionEnabled = YES;
        baseimageView.image = [UIImage gc_styleImageSize:CGSizeMake(frame.size.width, frame.size.height)];
        [self.rootLayout addSubview:baseimageView];
        
        CGFloat progressWidth = 90;
        
        _circleProgress = [[MDRadialProgressView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - progressWidth - 25,10, progressWidth, progressWidth)];
        _circleProgress.progressTotal = 100;
        _circleProgress.progressCounter = 10;
        _circleProgress.theme.sliceDividerHidden = YES;
        _circleProgress.theme.thickness = 13;
        _circleProgress.theme.centerColor = [UIColor clearColor];
        _circleProgress.theme.incompletedColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.3];
        _circleProgress.theme.completedColor =  [UIColor whiteColor];
        _circleProgress.theme.dropLabelShadow = NO;
        _circleProgress.label.hidden = NO;
        _circleProgress.label.textColor = [UIColor whiteColor];
        _circleProgress.label.font = [Color gc_ANC_font:23];
        _circleProgress.label.text = @"75%";
        [baseimageView addSubview:_circleProgress];
        
        _proressView = [[SDLoopProgressView alloc] initWithFrame:_circleProgress.frame];
        _proressView.center = _circleProgress.center;
        _proressView.completedColor = [UIColor whiteColor];
        _proressView.completedLineWidth = 4.5;
        [baseimageView addSubview:_proressView];
        
        UILabel *rateLab = [[UILabel alloc] init];
        rateLab.textColor = [Color color:PGColorOptionThemeWhite];
        rateLab.font = [Color gc_ANC_font:31.0f];
        rateLab.text = @"7.0%";
        [rateLab sizeToFit];
        rateLab.frame = CGRectMake(27, _circleProgress.center.y - rateLab.size.height/2, rateLab.width, rateLab.height);
        [baseimageView addSubview:rateLab];
        self.rateLab = rateLab;
        
        UILabel *rateTipLab = [[UILabel alloc] init];
        rateTipLab.textColor = [Color color:PGColorOpttonRateRedTextColor];
        rateTipLab.font = [Color gc_ANC_font:12.0f];
        rateTipLab.text = @"预期年化利率";
        [rateTipLab sizeToFit];
        rateTipLab.frame = CGRectMake(27, CGRectGetMaxY(rateLab.frame), rateTipLab.width, rateTipLab.height);
        
        [baseimageView addSubview:rateTipLab];
        
        
        UILabel *timeLimitLab = [[UILabel alloc] init];
        timeLimitLab.textColor = [Color color:PGColorOptionThemeWhite];
        timeLimitLab.font = [Color gc_ANC_font:31.0f];
        timeLimitLab.text = @"88天";
        [timeLimitLab sizeToFit];

        timeLimitLab.frame = CGRectMake(baseimageView.center.x - timeLimitLab.size.width/2, _circleProgress.center.y - timeLimitLab.size.height/2, rateLab.width + 5, rateLab.height);
        [baseimageView addSubview:timeLimitLab];
        self.timeLimitLab = timeLimitLab;
        
        UILabel *timeLimitTipLab = [[UILabel alloc] init];
        timeLimitTipLab.textColor = [Color color:PGColorOpttonRateRedTextColor];
        timeLimitTipLab.font = [Color gc_ANC_font:12.0f];
        timeLimitTipLab.text = @"债权期限";
        [timeLimitTipLab sizeToFit];
        timeLimitTipLab.frame = CGRectMake(CGRectGetMinX(timeLimitLab.frame), CGRectGetMaxY(timeLimitLab.frame), timeLimitTipLab.width, timeLimitTipLab.height);
        [baseimageView addSubview:timeLimitTipLab];
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(baseimageView.frame) - 35, CGRectGetWidth(baseimageView.frame), 35)];
        bottomView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
        [baseimageView addSubview:bottomView];
        
        UILabel *totalMoneyTipLab = [[UILabel alloc] init];
        totalMoneyTipLab.backgroundColor = [UIColor clearColor];
        totalMoneyTipLab.text = @"总计金额";
        totalMoneyTipLab.textColor = [Color color:PGColorOpttonRateRedTextColor];
        totalMoneyTipLab.font = [Color gc_Font:13.0f];
        [totalMoneyTipLab sizeToFit];
        totalMoneyTipLab.frame = CGRectMake(22, 0, totalMoneyTipLab.size.width, CGRectGetHeight(bottomView.frame));
        [bottomView addSubview:totalMoneyTipLab];
        
        UILabel *totalMoneyLab = [[UILabel alloc] init];
        totalMoneyLab.backgroundColor = [UIColor clearColor];
        totalMoneyLab.text = @"¥100,000.00";
        totalMoneyLab.textColor = [Color color:PGColorOptionThemeWhite];
        totalMoneyLab.font = [Color gc_ANC_font:13.0f];
        [totalMoneyLab sizeToFit];
        totalMoneyLab.frame = CGRectMake(CGRectGetMaxX(totalMoneyTipLab.frame) + 10, 0, totalMoneyLab.size.width, CGRectGetHeight(bottomView.frame));
        [bottomView addSubview:totalMoneyLab];
        self.totalMoneyLab = totalMoneyLab;
        
        UIView *sepView = [[UIView  alloc] init];
        sepView.frame = CGRectMake(bottomView.center.x, 8, 1, CGRectGetHeight(bottomView.frame) - 16);
        sepView.backgroundColor = [Color color:PGColorOpttonSeprateLineColor];
        [bottomView addSubview:sepView];
        
        UILabel *availableMoneyTipLab = [[UILabel alloc] init];
        availableMoneyTipLab.backgroundColor = [UIColor clearColor];
        availableMoneyTipLab.text = @"可投金额";
        availableMoneyTipLab.textColor = [Color color:PGColorOpttonRateRedTextColor];
        availableMoneyTipLab.font = [Color gc_Font:13.0f];
        [availableMoneyTipLab sizeToFit];
        availableMoneyTipLab.frame = CGRectMake(CGRectGetMaxX(sepView.frame) + 22, 0, availableMoneyTipLab.size.width, CGRectGetHeight(bottomView.frame));
        [bottomView addSubview:availableMoneyTipLab];
        
        UILabel *availableMoneyLab = [[UILabel alloc] init];
        availableMoneyLab.backgroundColor = [UIColor clearColor];
        availableMoneyLab.text = @"¥100,000.00";
        availableMoneyLab.textColor = [Color color:PGColorOptionThemeWhite];
        availableMoneyLab.font = [Color gc_ANC_font:13.0f];
        [availableMoneyLab sizeToFit];
        availableMoneyLab.frame = CGRectMake(CGRectGetMaxX(availableMoneyTipLab.frame) + 10, 0, availableMoneyLab.size.width, CGRectGetHeight(bottomView.frame));
        [bottomView addSubview:availableMoneyLab];
        self.availableMoneyLab = availableMoneyLab;

    }
    return self;
}
- (void)blindVM:(UVFBidDetailViewModel *)vm
{
    @PGWeakObj(self);
    [self.KVOController observe:vm keyPaths:@[@"borrowAmount",@"remainMoney",@"annualRate",@"markTimeStr",@"percentage",@"platformSubsidyExpense"] options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSString *keyPath = change[@"FBKVONotificationKeyPathKey"];
        if ([keyPath isEqualToString:@"borrowAmount"]) {
            NSString *borrowAmount = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if (borrowAmount.length > 0) {
                selfWeak.totalMoneyLab.text = borrowAmount;
                [selfWeak.totalMoneyLab sizeToFit];
                selfWeak.totalMoneyLab.centerY = selfWeak.totalMoneyLab.superview.size.height/2;
            }
        } else if ([keyPath isEqualToString:@"remainMoney"]) {
            NSString *remainMoney = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if (remainMoney.length > 0) {
                selfWeak.availableMoneyLab.text = remainMoney;
                [selfWeak.availableMoneyLab sizeToFit];
                selfWeak.availableMoneyLab.centerY = selfWeak.totalMoneyLab.superview.size.height/2;
            }
        } else if ([keyPath isEqualToString:@"annualRate"]) {
            NSString *annualRate = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if (annualRate.length > 0) {
                selfWeak.rateLab.text = annualRate;
                [selfWeak.rateLab sizeToFit];
                [selfWeak.rateLab setFont:[Color gc_Font:16] string:@"%"];
            }
          
        } else if ([keyPath isEqualToString:@"markTimeStr"]) {
            NSString *markTimeStr = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if (markTimeStr.length > 0) {
                selfWeak.timeLimitLab.text = markTimeStr;
                [selfWeak.timeLimitLab sizeToFit];
                if ([markTimeStr containsString:@"天"]) {
                    [selfWeak.timeLimitLab setFont:[Color gc_Font:16] string:@"天"];
                } else if ([markTimeStr containsString:@"个月"]) {
                    [selfWeak.timeLimitLab setFont:[Color gc_Font:16] string:@"个月"];
                }
            }
            
        }else if ([keyPath isEqualToString:@"percentage"]) {
            NSString *percentage = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if (percentage.length > 0) {
                selfWeak.circleProgress.label.text = [NSString stringWithFormat:@"%@%%",percentage];
                selfWeak.proressView.progress = [percentage floatValue]/100;

            }
            
        }else if ([keyPath isEqualToString:@"platformSubsidyExpense"]) {
            NSString *platformSubsidyExpense = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if (platformSubsidyExpense.length > 0) {
                
            }
        }
    }];
}


- (void)blindTransVM:(UCFTransBidDetailViewModel *)vm
{
    @PGWeakObj(self);
    [self.KVOController observe:vm keyPaths:@[@"borrowAmount",@"remainMoney",@"annualRate",@"markTimeStr",@"percentage"] options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSString *keyPath = change[@"FBKVONotificationKeyPathKey"];
        if ([keyPath isEqualToString:@"borrowAmount"]) {
            NSString *borrowAmount = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if (borrowAmount.length > 0) {
                selfWeak.totalMoneyLab.text = borrowAmount;
                [selfWeak.totalMoneyLab sizeToFit];
                selfWeak.totalMoneyLab.centerY = selfWeak.totalMoneyLab.superview.size.height/2;
                
            }
        } else if ([keyPath isEqualToString:@"remainMoney"]) {
            NSString *remainMoney = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if (remainMoney.length > 0) {
                selfWeak.availableMoneyLab.text = remainMoney;
                [selfWeak.availableMoneyLab sizeToFit];
                selfWeak.availableMoneyLab.centerY = selfWeak.totalMoneyLab.superview.size.height/2;
            }
        } else if ([keyPath isEqualToString:@"annualRate"]) {
            NSString *annualRate = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if (annualRate.length > 0) {
                selfWeak.rateLab.text = annualRate;
                [selfWeak.rateLab sizeToFit];
                [selfWeak.rateLab setFont:[Color gc_Font:16] string:@"%"];
            }
            
        } else if ([keyPath isEqualToString:@"markTimeStr"]) {
            NSString *markTimeStr = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if (markTimeStr.length > 0) {
                selfWeak.timeLimitLab.text = markTimeStr;
                [selfWeak.timeLimitLab sizeToFit];
                if ([markTimeStr containsString:@"天"]) {
                    [selfWeak.timeLimitLab setFont:[Color gc_Font:16] string:@"天"];
                } else if ([markTimeStr containsString:@"个月"]) {
                    [selfWeak.timeLimitLab setFont:[Color gc_Font:16] string:@"个月"];
                }
            }
            
        }else if ([keyPath isEqualToString:@"percentage"]) {
            NSString *percentage = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if (percentage.length > 0) {
                selfWeak.circleProgress.label.text = [NSString stringWithFormat:@"%@%%",percentage];
                selfWeak.proressView.progress = [percentage floatValue]/100;
                
            }
            
        }
    }];
}

- (void)blindCollectionVM:(BaseViewModel *)vm
{
    @PGWeakObj(self);
    [self.KVOController observe:vm keyPaths:@[@"projectNum",@"remainMoney",@"annualRate",@"markTimeStr",@"percentage"] options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSString *keyPath = change[@"FBKVONotificationKeyPathKey"];
        if ([keyPath isEqualToString:@"projectNum"]) { //项目个数
            NSString *projectNum = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if (projectNum.length > 0) {
                selfWeak.totalMoneyLab.text = projectNum;
                [selfWeak.totalMoneyLab sizeToFit];
                selfWeak.totalMoneyLab.centerY = selfWeak.totalMoneyLab.superview.size.height/2;
            }
        } else if ([keyPath isEqualToString:@"remainMoney"]) { //可投金额
            NSString *remainMoney = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if (remainMoney.length > 0) {
                selfWeak.availableMoneyLab.text = remainMoney;
                [selfWeak.availableMoneyLab sizeToFit];
                selfWeak.availableMoneyLab.centerY = selfWeak.totalMoneyLab.superview.size.height/2;
            }
        } else if ([keyPath isEqualToString:@"annualRate"]) { //利率
            NSString *annualRate = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if (annualRate.length > 0) {
                selfWeak.rateLab.text = annualRate;
                [selfWeak.rateLab sizeToFit];
                [selfWeak.rateLab setFont:[Color gc_Font:16] string:@"%"];
            }
            
        } else if ([keyPath isEqualToString:@"markTimeStr"]) { //期限
            NSString *markTimeStr = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if (markTimeStr.length > 0) {
                selfWeak.timeLimitLab.text = markTimeStr;
                [selfWeak.timeLimitLab sizeToFit];
                if ([markTimeStr containsString:@"天"]) {
                    [selfWeak.timeLimitLab setFont:[Color gc_Font:16] string:@"天"];
                } else if ([markTimeStr containsString:@"个月"]) {
                    [selfWeak.timeLimitLab setFont:[Color gc_Font:16] string:@"个月"];
                }
            }
            
        }else if ([keyPath isEqualToString:@"percentage"]) { //投资百分比
            NSString *percentage = [change objectSafeForKey:NSKeyValueChangeNewKey];
            if (percentage.length > 0) {
                selfWeak.circleProgress.label.text = [NSString stringWithFormat:@"%@%%",percentage];
                selfWeak.proressView.progress = [percentage floatValue]/100;
                
            }
            
        }
//        else if ([keyPath isEqualToString:@"platformSubsidyExpense"]) {
//            NSString *platformSubsidyExpense = [change objectSafeForKey:NSKeyValueChangeNewKey];
//            if (platformSubsidyExpense.length > 0) {
//
//            }
//        }
    }];
}

@end
