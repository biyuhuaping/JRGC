//
//  UCFMineServiceHeadView.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/18.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFMineServiceHeadView.h"
#import "NZLabel.h"

@interface UCFMineServiceHeadView()

@property (nonatomic, strong) NZLabel     *titleLabel;//标题

@property (nonatomic, strong) NZLabel     *versionsLabel;//版本号

@property (nonatomic, strong) UIImageView *titleImageView;//箭头

@property (nonatomic, strong) UIView *verticalLineView;//垂直分割线线

@property (nonatomic, strong) UIView *horizontalLineView;//水平分割线线
@end

@implementation UCFMineServiceHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.rootLayout.backgroundColor = [Color color:PGColorOptionThemeWhite];
        // 初始化视图对象
        [self.rootLayout addSubview:self.titleLabel];
        [self.rootLayout addSubview:self.versionsLabel];
        [self.rootLayout addSubview:self.titleImageView];
        [self.rootLayout addSubview:self.praiseBtn];
        [self.rootLayout addSubview:self.proposalBtn];
        [self.rootLayout addSubview:self.verticalLineView];
        [self.rootLayout addSubview:self.horizontalLineView];
    }
    return self;
}
- (UIImageView *)titleImageView
{
    if (nil == _titleImageView) {
        _titleImageView = [[UIImageView alloc] init];
        _titleImageView.centerXPos.equalTo(self.rootLayout.centerXPos);
        _titleImageView.myTop = 50;
        _titleImageView.myWidth = 80;
        _titleImageView.myHeight = 80;
        _titleImageView.image = [UIImage imageNamed:@"jrgc_icon_logo"];
    }
    return _titleImageView;
}
- (NZLabel *)titleLabel
{
    if (nil == _titleLabel) {
        _titleLabel = [NZLabel new];
        _titleLabel.topPos.equalTo(self.titleImageView.bottomPos).offset(15);
        _titleLabel.centerXPos.equalTo(self.rootLayout.centerXPos);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [Color gc_Font:16.0];
        _titleLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _titleLabel.text = @"享财富  享生活  享未来";
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (NZLabel *)versionsLabel
{
    if (nil == _versionsLabel) {
        _versionsLabel = [NZLabel new];
        _versionsLabel.topPos.equalTo(self.titleLabel.bottomPos).offset(8);
        _versionsLabel.centerXPos.equalTo(self.rootLayout.centerXPos);
        _versionsLabel.textAlignment = NSTextAlignmentCenter;
        _versionsLabel.font = [Color gc_Font:14.0];
        _versionsLabel.textColor = [Color color:PGColorOptionTitleGray];
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        NSString *currentVersion = infoDic[@"CFBundleShortVersionString"];
        _versionsLabel.text =  [NSString stringWithFormat:@"当前版本V%@",currentVersion];
        [_versionsLabel sizeToFit];
    }
    return _versionsLabel;
}

- (UIView *)horizontalLineView
{
    if (nil == _horizontalLineView) {
        _horizontalLineView = [UIView new];
        _horizontalLineView.myBottom = 50;
        _horizontalLineView.myHeight = 0.5;
        _horizontalLineView.myRight = 0;
        _horizontalLineView.myLeft = 0;
        _horizontalLineView.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
        //
        
    }
    return _horizontalLineView;
}
- (UIView *)verticalLineView
{
    if (nil == _verticalLineView) {
        _verticalLineView = [UIView new];
        _verticalLineView.myBottom = 10;
        _verticalLineView.myWidth = 0.5;
        _verticalLineView.myHeight = 30;
        _verticalLineView.centerXPos.equalTo(self.rootLayout.centerXPos);
        _verticalLineView.myRight = 0;
        _verticalLineView.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
        //
    }
    return _verticalLineView;
}
- (UIButton *)praiseBtn
{
    if (nil == _praiseBtn) {
        _praiseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _praiseBtn.myLeft = 0;
        _praiseBtn.rightPos.equalTo(self.verticalLineView.leftPos);
        _praiseBtn.topPos.equalTo(self.horizontalLineView.bottomPos);
        _praiseBtn.myBottom = 0;
        [_praiseBtn setImage:[UIImage imageNamed:@"more_icon_praise"] forState:UIControlStateNormal];
        [_praiseBtn setTitle:@"点个赞" forState:UIControlStateNormal];
        [_praiseBtn setTitleColor:[Color color:PGColorOptionTitleBlack] forState:UIControlStateNormal];
        [_praiseBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -10, 0.0, 0.0)];
        _praiseBtn.titleLabel.font = [Color gc_Font:15.0];
    }
    return _praiseBtn;
}

- (UIButton *)proposalBtn
{
    if (nil == _proposalBtn) {
        _proposalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _proposalBtn.centerYPos.equalTo(self.praiseBtn.centerYPos);
        _proposalBtn.leftPos.equalTo(self.verticalLineView.rightPos);
        _proposalBtn.heightSize.equalTo(self.praiseBtn.heightSize);
        _proposalBtn.widthSize.equalTo(self.praiseBtn.widthSize);
        [_proposalBtn setImage:[UIImage imageNamed:@"more_icon_proposal"] forState:UIControlStateNormal];
        [_proposalBtn setTitle:@"吐个槽" forState:UIControlStateNormal];
        [_proposalBtn setTitleColor:[Color color:PGColorOptionTitleBlack] forState:UIControlStateNormal];
        [_proposalBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -10, 0.0, 0.0)];
        _proposalBtn.titleLabel.font = [Color gc_Font:15.0];
    }
    return _proposalBtn;
}

@end
