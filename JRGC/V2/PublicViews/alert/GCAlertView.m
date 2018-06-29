//
//  GCAlertView.m
//  JRGC
//
//  Created by zrc on 2018/5/16.
//  Copyright © 2018年 JRGC. All rights reserved.
//

#import "GCAlertView.h"
#define CancleTag 0
#define SureTag 1
@interface GCAlertView()
@property(strong, nonatomic)NSMutableArray  *otherButtonTitleArr;
@property(strong, nonatomic)NSString         *titleStr;
@property(copy, nonatomic)NSString          *message;
@property(copy, nonatomic)NSString          *cancleBtnStr;
@property(strong, nonatomic)UIView          *alertView;
@end

@implementation GCAlertView


- (instancetype)initUpdateViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)firstButtonTitles, ...
{
    self = [super init];
    if (self) {
        
        self.frame = [[UIScreen mainScreen] bounds];
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        id eachObject;
        va_list argumentList;
        if (firstButtonTitles) {
            [self.otherButtonTitleArr addObject:firstButtonTitles];
            va_start(argumentList, firstButtonTitles);
            while (eachObject = va_arg(argumentList, id)) {
                [self.otherButtonTitleArr addObject: eachObject];
                va_end(argumentList);
            }
        }
    }
    self.titleStr = title;
    self.message = message;
    self.cancleBtnStr = cancelButtonTitle;
    [self initUI];
    return self;
}


- (void)initUI
{
    
    
    CGFloat offY = 0;
    CGFloat showWidth = [[UIScreen mainScreen] bounds].size.width * 0.66;
    _alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, showWidth, offY)];
    _alertView.backgroundColor = [UIColor whiteColor];
    _alertView.layer.cornerRadius = 5.0f;

    [self addSubview:_alertView];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.frame = CGRectMake(0, 10, showWidth, 30);
    titleLabel.text = _titleStr;
    [_alertView addSubview:titleLabel];
    
    
    CGFloat msgFont = 12.0f;
    
    offY += CGRectGetMaxY(titleLabel.frame);
    offY += 10;
    
    if ([_message rangeOfString:@"\n"].location != NSNotFound) {
        NSArray *msgArr = [_message componentsSeparatedByString:@"\n"];
        for (NSString *str in msgArr) {
            
            NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:msgFont]};
            CGSize strSize = [str boundingRectWithSize:CGSizeMake(showWidth - 30 , MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
            
            UILabel *msgLab = [[UILabel alloc] init];
            msgLab.frame = CGRectMake(15, offY, showWidth - 30, strSize.height);
            msgLab.numberOfLines = 0;
            msgLab.textColor = [UIColor blackColor];
            msgLab.text = str;
            msgLab.font = [UIFont systemFontOfSize:msgFont];
            [_alertView addSubview:msgLab];
            
            offY += strSize.height;
            offY += 5;
        }
    } else {
        NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:msgFont]};
        CGSize strSize = [_message boundingRectWithSize:CGSizeMake(showWidth - 30 , MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
        UILabel *msgLab = [[UILabel alloc] init];
        msgLab.frame = CGRectMake(15, offY, showWidth - 30, strSize.height);
        msgLab.numberOfLines = 0;
        msgLab.font = [UIFont systemFontOfSize:msgFont];
        msgLab.text = _message;
        [_alertView addSubview:msgLab];
        
        offY += strSize.height;
        offY += 5;
    }
    offY += 10;
    if (_otherButtonTitleArr.count == 1 && _cancleBtnStr) {
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(15, offY, showWidth/2 - 30, 40);
        [cancelBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        cancelBtn.backgroundColor = [UIColor whiteColor];
        [cancelBtn setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
        cancelBtn.backgroundColor = [UIColor blueColor];
        [cancelBtn setTitle:_cancleBtnStr forState:UIControlStateNormal];
        cancelBtn.tag = CancleTag;
        [_alertView addSubview:cancelBtn];
        
        UIButton *otherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        otherBtn.frame = CGRectMake(showWidth/2 + 15, offY, showWidth/2 - 30, 40);
        [otherBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        otherBtn.backgroundColor = [UIColor redColor];
        otherBtn.tag = SureTag;

        [otherBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [otherBtn setTitle:_otherButtonTitleArr[0] forState:UIControlStateNormal];
        [_alertView addSubview:otherBtn];
        offY += 40;
        offY += 10;
    } else if (_cancleBtnStr.length > 0 && _otherButtonTitleArr.count == 0) {
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(15, offY, showWidth - 30, 40);
        [cancelBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        cancelBtn.backgroundColor = [UIColor whiteColor];
        cancelBtn.tag = CancleTag;

        [cancelBtn setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
        [cancelBtn setTitle:_cancleBtnStr forState:UIControlStateNormal];
        [_alertView addSubview:cancelBtn];
        offY += 40;
        offY += 10;
    } else if (_cancleBtnStr.length == 0 && _otherButtonTitleArr.count == 1) {
        UIButton *otherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        otherBtn.frame = CGRectMake(showWidth/2 + 15, offY, showWidth/2 - 30, 40);
        [otherBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        otherBtn.backgroundColor = [UIColor redColor];
        [otherBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [otherBtn setTitle:_otherButtonTitleArr[0] forState:UIControlStateNormal];
        [_alertView addSubview:otherBtn];
        otherBtn.tag = SureTag;
        offY += 40;
        offY += 10;
    }
    CGFloat showHeight = offY;
    _alertView.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width - showWidth)/2, 0, showWidth, showHeight);
}
- (void)buttonClick:(UIButton *)button
{
    if (self.resultIndex) {
        self.resultIndex(button.tag);
    }
    [self removeFromSuperview];
}
- (void)show
{
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    [self creatShowAnimation];
}
- (void)creatShowAnimation
{
    self.alertView.layer.position = self.center;
    self.alertView.transform = CGAffineTransformMakeScale(0.90, 0.90);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.alertView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
    }];
}


- (NSMutableArray *)otherButtonTitleArr
{
    if (nil == _otherButtonTitleArr) {
        _otherButtonTitleArr = [NSMutableArray arrayWithCapacity:4];
    }
    return _otherButtonTitleArr;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
