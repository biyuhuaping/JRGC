//
//  CircleProgressView.m
//  CircularProgressControl
//
//  Created by Carlos Eduardo Arantes Ferreira on 22/11/14.
//  Copyright (c) 2014 Mobistart. All rights reserved.
//

#import "CircleProgressView.h"
#import "CircleShapeLayer.h"

@interface CircleProgressView()

@property (strong, nonatomic) CircleShapeLayer *progressLayer;


@end

@implementation CircleProgressView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupViews];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.progressLayer.frame = self.bounds;
    
    [self.progressLabel sizeToFit];
    self.progressLabel.center = CGPointMake(self.center.x - self.frame.origin.x, self.center.y- self.frame.origin.y);
}

//- (void)updateConstraints {
//    [super updateConstraints];
//}

- (UILabel *)progressLabel
{
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _progressLabel.numberOfLines = 0;
        _progressLabel.textAlignment = NSTextAlignmentCenter;
        _progressLabel.backgroundColor = [UIColor clearColor];
//        _progressLabel.textColor = [UIColor blueColor];
        _progressLabel.font = [UIFont boldSystemFontOfSize:14];
        _progressLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_progressLabel];
    }
    _progressLabel.text = _textStr;
    return _progressLabel;
}

- (double)percent {
    return self.progressLayer.percent;
}

- (NSTimeInterval)timeLimit {
    return self.progressLayer.timeLimit;
}

//设置时间限制
- (void)setTimeLimit:(NSTimeInterval)timeLimit {
    self.progressLayer.timeLimit = timeLimit;
    self.progressLayer.isAnim = _isAnim;
}

//设置运行时间
- (void)setElapsedTime:(NSTimeInterval)elapsedTime {
//    DBLOG(@"elapsedTime:%f",elapsedTime);
    if (elapsedTime < 0 && elapsedTime <= 100) {
        elapsedTime += 20;
    }
    else if (elapsedTime > 100 && elapsedTime != 1000) {
        elapsedTime -= 20;
    }
    _elapsedTime = elapsedTime;
    self.progressLayer.elapsedTime = elapsedTime;
//    self.progressLabel.attributedText = @"投资";//[self formatProgressStringFromTimeInterval:elapsedTime];
}

#pragma mark - Private Methods

- (void)setupViews {
    self.clipsToBounds = false;
    
    //add Progress layer
    if (!self.progressLayer) {
        self.progressLayer = [[CircleShapeLayer alloc] init];
        self.progressLayer.frame = self.bounds;
//        self.progressLayer.backgroundColor = [UIColor blueColor].CGColor;
        [self.layer addSublayer:self.progressLayer];
    }
}

- (void)setTintColor:(UIColor *)tintColor {
    self.progressLayer.progressColor = tintColor;
    self.progressLabel.textColor = tintColor;
}

//- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval shortDate:(BOOL)shortDate {
//    NSInteger ti = (NSInteger)interval;
//    NSInteger seconds = ti % 60;
//    NSInteger minutes = (ti / 60) % 60;
//    NSInteger hours = (ti / 3600);
//    
//    if (shortDate) {
//        return [NSString stringWithFormat:@"%02ld:%02ld", (long)hours, (long)minutes];
//    }
//    else {
//        return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds];
//    }
//}

//- (NSAttributedString *)formatProgressStringFromTimeInterval:(NSTimeInterval)interval {
//    NSString *progressString = @"投资";//[self stringFromTimeInterval:interval shortDate:false];
//    NSMutableAttributedString *attributedString;
//    
//    if (_status.length > 0) {
//        attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@", progressString, _status]];
//        [attributedString addAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Bold" size:40]} range:NSMakeRange(0, progressString.length)];
//        [attributedString addAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-thin" size:18]} range:NSMakeRange(progressString.length+1, _status.length)];
//    }
//    else {
//        attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",progressString]];
//        [attributedString addAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Bold" size:18]} range:NSMakeRange(0, progressString.length)];
//    }
//    
//    return attributedString;
//}


@end
