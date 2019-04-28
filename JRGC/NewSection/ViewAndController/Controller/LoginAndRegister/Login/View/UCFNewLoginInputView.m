//
//  UCFNewLoginInputView.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/1/25.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewLoginInputView.h"
@interface UCFNewLoginInputView ()

@property (nonatomic, strong) UIView *underline; //下划线

@property (nonatomic, strong) UIView *halvingLine;

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation UCFNewLoginInputView

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
        
        self.backgroundColor = [Color color:PGColorOptionThemeWhite];
        [self.rootLayout addSubview:self.personalBtn];
        [self.rootLayout addSubview:self.enterpriseBtn];
         [self.rootLayout addSubview:self.underline];
         [self.rootLayout addSubview:self.halvingLine];
        [self.rootLayout addSubview:self.scrollView];
    }
    return self;
}

- (UIButton*)personalBtn{
    
    if(nil == _personalBtn)
    {
        _personalBtn = [UIButton buttonWithType:0];
        _personalBtn.myTop = 18;
        _personalBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _personalBtn.leftPos.equalTo(@25);
        _personalBtn.widthSize.equalTo(@60);
        _personalBtn.heightSize.equalTo(@40);
        [_personalBtn setTitle:@"个人登录" forState:UIControlStateNormal];
        [_personalBtn setTitleColor:[Color color:PGColorOptionTitleLoginRead] forState: UIControlStateNormal];
        _personalBtn.titleLabel.font = [Color gc_Font:15.0];
        _personalBtn.tag = 1000;
        [_personalBtn addTarget:self action:@selector(setSelectedButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _personalBtn;
}
- (UIButton*)enterpriseBtn{
    
    if(nil == _enterpriseBtn)
    {
        _enterpriseBtn = [UIButton buttonWithType:0];
        _enterpriseBtn.centerYPos.equalTo(self.personalBtn.centerYPos);
        _enterpriseBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _enterpriseBtn.leftPos.equalTo(self.personalBtn.rightPos).offset(35);
        _enterpriseBtn.widthSize.equalTo(self.personalBtn.widthSize);
        _enterpriseBtn.heightSize.equalTo(@40);
        [_enterpriseBtn setTitle:@"企业登录" forState:UIControlStateNormal];
        [_enterpriseBtn setTitleColor:[Color color:PGColorOptionTitleBlack] forState: UIControlStateNormal];
        _enterpriseBtn.titleLabel.font = [Color gc_Font:15.0];
        _enterpriseBtn.tag = 1001;
        [_enterpriseBtn addTarget:self action:@selector(setSelectedButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterpriseBtn;
}

- (void)setSelectedButton:(UIButton *)btn
{
    if (btn.tag == 1000) {
        [self.personalBtn setTitleColor:[Color color:PGColorOptionTitleLoginRead] forState: UIControlStateNormal];
        [self.enterpriseBtn setTitleColor:[Color color:PGColorOptionTitleBlack] forState: UIControlStateNormal];
        [UIView animateWithDuration:0.1 delay:0.2 usingSpringWithDamping:0.2 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.halvingLine.centerXPos.equalTo(self.personalBtn.centerXPos);
        } completion:^(BOOL finished) {
            
        }];
       [self.scrollView setContentOffset:CGPointMake(0,0) animated:YES];
        
    }
    else
    {
        [self.personalBtn setTitleColor:[Color color:PGColorOptionTitleBlack] forState: UIControlStateNormal];
        [self.enterpriseBtn setTitleColor:[Color color:PGColorOptionTitleLoginRead] forState: UIControlStateNormal];
        [UIView animateWithDuration:0.1 delay:0.2 usingSpringWithDamping:0.2 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.halvingLine.centerXPos.equalTo(self.enterpriseBtn.centerXPos);
        } completion:^(BOOL finished) {
            
        }];
        [self.scrollView setContentOffset:CGPointMake(PGScreenWidth,0) animated:YES];
    }
}

- (UIView *)underline
{
    if (nil == _underline) {
        _underline = [UIView new];
        _underline.topPos.equalTo(self.personalBtn.bottomPos);
        _underline.myHeight = 0.5;
        _underline.myLeft = 0;
        _underline.myRight = 0;
        _underline.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
        //
    }
    return _underline;
}

- (UIView *)halvingLine
{
    if (nil == _halvingLine) {
//        _halvingLine = [[UIView alloc] initWithFrame:CGRectMake(45, 36, 24, 3)]; //123
        _halvingLine = [UIView new];
        _halvingLine.centerXPos.equalTo(self.personalBtn.centerXPos);
        _halvingLine.myWidth= 24;
        _halvingLine.myHeight = 3;
        _halvingLine.topPos.equalTo(self.underline.topPos).offset(-5);
        _halvingLine.backgroundColor = [Color color:PGColorOptionTitleLoginRead];
        _halvingLine.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *sbv)
        { //viewLayoutCompleteBlock是在1.2.3中添加的新功能，目的是给完成了布局的子视图一个机会进行一些特殊的处理，viewLayoutCompleteBlock只会在子视图布局完成后调用一次.其中的sbv就是子视图自己，而layout则是父布局视图。因为这个block是完成布局后执行的。所以这时候子视图的frame值已经被计算出来，因此您可以在这里设置一些和frame关联的属性。
            //设置圆角的半径
            sbv.layer.cornerRadius = 1.5;
            //切割超出圆角范围的子视图
            sbv.layer.masksToBounds = YES;
        };
    }
    return _halvingLine;
}

-(UIScrollView *)scrollView
{
    if (nil == _scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.backgroundColor = [Color color:PGColorOptionThemeWhite];
        _scrollView.contentSize = CGSizeMake(PGScreenWidth*2, 260);
        // 10. showsHorizontalScrollIndicator 是否显示水平滚动指示器
        _scrollView.showsHorizontalScrollIndicator = NO;
        // 8. pagingEnabled 按页滚动
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollEnabled = NO;
        _scrollView.topPos.equalTo(self.underline.bottomPos);
        _scrollView.widthSize.equalTo(self.rootLayout.widthSize);
        _scrollView.myLeft = 0;
        _scrollView.myHeight = 260;
        [_scrollView addSubview:self.personalInput];
        [_scrollView addSubview:self.enterpriseInput];
    }
    return _scrollView;
}

- (UCFNewLoginInputNameAndPassWordView *)personalInput //个人用户界面
{
    if (nil == _personalInput) {
        _personalInput = [[UCFNewLoginInputNameAndPassWordView alloc] initWithFrame:CGRectMake(0, 0, PGScreenWidth, 260) withUserType:@"个人"];
        
    }
    return _personalInput;
}

- (UCFNewLoginInputNameAndPassWordView *)enterpriseInput //企业用户界面
{
    if (nil == _enterpriseInput) {
        _enterpriseInput = [[UCFNewLoginInputNameAndPassWordView alloc] initWithFrame:CGRectMake(PGScreenWidth, 0, PGScreenWidth, 260) withUserType:@"企业"];
    }
    return _enterpriseInput;
}








// UIButton *button = [[UIButtonalloc] initWithFrame:CGRectMake(100,100, 100,50)];
//
//    button.backgroundColor = [UIColorredColor];
//
//    [self.viewaddSubview:button];
//
//
//
//
//   [UIViewanimateWithDuration:1delay:0.5usingSpringWithDamping:0.3initialSpringVelocity:0.6options:UIViewAnimationOptionCurveEaseInOutanimations:^{
//
//          button.frame =CGRectMake(100,400, 100,50);
//
//       } completion:^(BOOL finished) {
//
//           }];

@end
