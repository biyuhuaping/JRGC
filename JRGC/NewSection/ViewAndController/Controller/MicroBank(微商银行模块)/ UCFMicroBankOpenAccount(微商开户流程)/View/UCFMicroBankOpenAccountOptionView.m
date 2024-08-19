//
//  UCFMicroBankOpenAccountOptionView.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/1.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFMicroBankOpenAccountOptionView.h"
#import "NZLabel.h"

@interface UCFMicroBankOpenAccountOptionView()

@property (nonatomic, strong) MyRelativeLayout *bkLayout;//背景

@property (nonatomic, strong) MyRelativeLayout *firstLayout;//第一步

@property (nonatomic, strong) UIImageView *firstStepImageView;

@property (nonatomic, strong) UIImageView *cuttingLineImageView;

@property (nonatomic, strong) MyRelativeLayout *secondLayout;//第二步

@property (nonatomic, strong) UIImageView *secondStepImageView;

@property (nonatomic, strong) NZLabel     *secondStepLabel;

@property (nonatomic, strong) NZLabel     *firstStepLabel;

@property (nonatomic, strong) UIView       *lineView;

@end
@implementation UCFMicroBankOpenAccountOptionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];// 先调用父类的initWithFrame方法
    if (self) {
        
        self.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
        [self.rootLayout addSubview:self.bkLayout];
        [self.rootLayout addSubview:self.firstLayout];
        [self.firstLayout addSubview:self.firstStepImageView];
        [self.firstLayout addSubview:self.firstStepLabel];
        
        [self.rootLayout addSubview:self.cuttingLineImageView];
        
        [self.rootLayout addSubview:self.secondLayout];
        [self.secondLayout addSubview:self.secondStepImageView];
        [self.secondLayout addSubview:self.secondStepLabel];
        
        [self.rootLayout addSubview:self.lineView];
    }
    return self;
}
- (UIView *)lineView
{
    if (nil == _lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
        _lineView.myTop = 0;
        _lineView.myHeight = 0.5;
        _lineView.widthSize.equalTo(self.rootLayout.widthSize);
        _lineView.myLeft = 0;
    }
    return _lineView;
}
- (MyRelativeLayout *)bkLayout
{
    if (nil == _bkLayout) {
        _bkLayout = [MyRelativeLayout new];
        _bkLayout.backgroundColor = [Color color:PGColorOptionThemeWhite];
        _bkLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
        _bkLayout.widthSize.equalTo(self.rootLayout.widthSize);
        _bkLayout.myTop = 0;
        _bkLayout.myBottom = 10;
        _bkLayout.centerXPos.equalTo(self.rootLayout.centerXPos);
        //        CGFloat left = ((PGScreenWidth-44/2) -80)/2
        //        _firstLayout.myLeft = PGScreenWidth/4;
    }
    return _bkLayout;
}
- (MyRelativeLayout *)firstLayout
{
    if (nil == _firstLayout) {
        _firstLayout = [MyRelativeLayout new];
        _firstLayout.backgroundColor = [Color color:PGColorOptionThemeWhite];
        _firstLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
        _firstLayout.myWidth = 80;
        _firstLayout.myTop = 0;
        _firstLayout.myBottom = 10;
        _firstLayout.centerXPos.equalTo(self.rootLayout.centerXPos).offset(-PGScreenWidth/4);
//        CGFloat left = ((PGScreenWidth-44/2) -80)/2
//        _firstLayout.myLeft = PGScreenWidth/4;
    }
    return _firstLayout;
}
- (UIImageView *)firstStepImageView
{
    if (nil == _firstStepImageView) {
        _firstStepImageView = [[UIImageView alloc] init];
        _firstStepImageView.centerYPos.equalTo(self.firstLayout.centerYPos);
        _firstStepImageView.myLeft = 0;
        _firstStepImageView.myWidth = 16;
        _firstStepImageView.myHeight = 16;
        _firstStepImageView.image = [UIImage imageNamed:@"ic_step_one"];
    }
    return _firstStepImageView;
}

- (NZLabel *)firstStepLabel
{
    if (nil == _firstStepLabel) {
        _firstStepLabel = [NZLabel new];
        _firstStepLabel.centerYPos.equalTo(self.firstLayout.centerYPos);
        _firstStepLabel.leftPos.equalTo(self.firstStepImageView.rightPos).offset(4);
        _firstStepLabel.textAlignment = NSTextAlignmentLeft;
        _firstStepLabel.font = [Color gc_Font:15.0];
        _firstStepLabel.text = @"徽商存管";
        [_firstStepLabel sizeToFit];
        
    }
    return _firstStepLabel;
}

- (UIImageView *)cuttingLineImageView
{
    if (nil == _cuttingLineImageView) {
        _cuttingLineImageView = [[UIImageView alloc] init];
        _cuttingLineImageView.myTop = 0;
        _cuttingLineImageView.centerXPos.equalTo(self.rootLayout.centerXPos);
        _cuttingLineImageView.myWidth = 13;
        _cuttingLineImageView.myHeight = 50;
        _cuttingLineImageView.image = [UIImage imageNamed:@"step_arrow_transparent"];
    }
    return _cuttingLineImageView;
}

- (MyRelativeLayout *)secondLayout
{
    if (nil == _secondLayout) {
        _secondLayout = [MyRelativeLayout new];
        _secondLayout.backgroundColor = [Color color:PGColorOptionThemeWhite];
        _secondLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
        _secondLayout.myWidth = 80;
        _secondLayout.myTop = 0;
        _secondLayout.myBottom = 10;
        _secondLayout.centerXPos.equalTo(self.rootLayout.centerXPos).offset(PGScreenWidth/4);
    }
    return _secondLayout;
}
- (UIImageView *)secondStepImageView
{
    if (nil == _secondStepImageView) {
        _secondStepImageView = [[UIImageView alloc] init];
        _secondStepImageView.centerYPos.equalTo(self.secondLayout.centerYPos);
        _secondStepImageView.myLeft = 0;
        _secondStepImageView.myWidth = 16;
        _secondStepImageView.myHeight = 16;
        _secondStepImageView.image = [UIImage imageNamed:@"ic_step_2_gray"]; //ic_step_2_gray,ic_step_2_normal
    }
    return _secondStepImageView;
}
- (NZLabel *)secondStepLabel
{
    if (nil == _secondStepLabel) {
        _secondStepLabel = [NZLabel new];
        _secondStepLabel.centerYPos.equalTo(self.secondLayout.centerYPos);
        _secondStepLabel.leftPos.equalTo(self.secondStepImageView.rightPos).offset(4);
        _secondStepLabel.textAlignment = NSTextAlignmentLeft;
        _secondStepLabel.font = [Color gc_Font:15.0];
        _secondStepLabel.textColor = [Color color:PGColorOptionTitleGray];
        _secondStepLabel.text = @"交易密码";
        [_secondStepLabel sizeToFit];
        
    }
    return _secondStepLabel;
}

- (void)selectStep:(OpenAccoutStep)step
{
//    OpenAccoutMicroBank = 1, //存管开户
//    OpenAccoutPassWord , //选择交易密码
    switch (step) {
        case OpenAccoutMicroBank:
            {
                self.firstStepImageView.image = [UIImage imageNamed:@"step_icon_1_blue"];
                self.firstStepLabel.textColor = [Color color:PGColorOptionCellContentBlue];
                self.secondStepImageView.image = [UIImage imageNamed:@"ic_step_2_gray"];
                self.secondStepLabel.textColor = [Color color:PGColorOptionInputDefaultBlackGray];
    
               
            }
            break;
        case OpenAccoutPassWord:
            {
                self.firstStepImageView.image = [UIImage imageNamed:@"step_icon_1_gray"];
                self.firstStepLabel.textColor = [Color color:PGColorOptionInputDefaultBlackGray];
                self.secondStepImageView.image = [UIImage imageNamed:@"ic_step_2_normal"];
                self.secondStepLabel.textColor = [Color color:PGColorOptionCellContentBlue];
            }
            break;
        default:
            break;
    }
}
@end
