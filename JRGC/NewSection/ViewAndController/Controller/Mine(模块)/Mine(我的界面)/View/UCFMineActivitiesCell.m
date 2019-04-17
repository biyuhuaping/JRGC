//
//  UCFMineActivitiesCell.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/1/15.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFMineActivitiesCell.h"
#import "NZLabel.h"
#import "UCFMineMySimpleInfoModel.h"
#import "UCFNewMineViewController.h"

@interface UCFMineActivitiesCell()
@property (nonatomic, strong) MyRelativeLayout *signInLayout;// 签到

@property (nonatomic, strong) UIImageView *signInImageView;//图片

@property (nonatomic, strong) NZLabel     *signInTitleLabel;//标题

@property (nonatomic, strong) NZLabel     *signInContentLabel;//内容


@property (nonatomic, strong) MyRelativeLayout *cowryLayout;// 工贝

@property (nonatomic, strong) UIImageView *cowryImageView;//图片

@property (nonatomic, strong) NZLabel     *cowryTitleLabel;//标题

@property (nonatomic, strong) NZLabel     *cowryContentLabel;//内容


@property (nonatomic, strong) MyRelativeLayout *beanLayout;// 工豆

@property (nonatomic, strong) UIImageView *beanImageView;//图片

@property (nonatomic, strong) NZLabel     *beanTitleLabel;//标题

@property (nonatomic, strong) NZLabel     *beanContentLabel;//内容


@property (nonatomic, strong) MyRelativeLayout *couponLayout;// 优惠券

@property (nonatomic, strong) UIImageView *couponImageView;//图片

@property (nonatomic, strong) NZLabel     *couponTitleLabel;//标题

@property (nonatomic, strong) NZLabel     *couponContentLabel;//内容


@property (nonatomic, strong) MyRelativeLayout *inviteLayout;// 邀请返利

@property (nonatomic, strong) UIImageView *inviteImageView;//图片

@property (nonatomic, strong) NZLabel     *inviteTitleLabel;//标题

@property (nonatomic, strong) NZLabel     *inviteContentLabel;//内容

@property (nonatomic, assign) CGFloat titleTop;

@property (nonatomic, assign) CGFloat contentTop;

@property (nonatomic, assign) CGFloat imageTop;
@end
@implementation UCFMineActivitiesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 初始化视图对象
        
        self.titleTop = 10;
        self.contentTop = 3;
        self.imageTop = 5;
        self.rootLayout.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
     
        [self.rootLayout addSubview:self.signInLayout];// 签到
        [self.signInLayout addSubview:self.signInImageView];
        [self.signInLayout addSubview:self.signInTitleLabel];
        [self.signInLayout addSubview:self.signInContentLabel];
        
        [self.rootLayout addSubview:self.cowryLayout];//工贝
        [self.cowryLayout addSubview:self.cowryImageView];
        [self.cowryLayout addSubview:self.cowryTitleLabel];
        [self.cowryLayout addSubview:self.cowryContentLabel];
        
        [self.rootLayout addSubview:self.beanLayout];// 工豆
        [self.beanLayout addSubview:self.beanImageView];
        [self.beanLayout addSubview:self.beanTitleLabel];
        [self.beanLayout addSubview:self.beanContentLabel];
        
        [self.rootLayout addSubview:self.couponLayout];// 优惠券
        [self.couponLayout addSubview:self.couponImageView];
        [self.couponLayout addSubview:self.couponTitleLabel];
        [self.couponLayout addSubview:self.couponContentLabel];
        
        [self.rootLayout addSubview:self.inviteLayout];// 邀请返利
        [self.inviteLayout addSubview:self.inviteImageView];
        [self.inviteLayout addSubview:self.inviteTitleLabel];
        [self.inviteLayout addSubview:self.inviteContentLabel];
        
        self.signInLayout.widthSize.equalTo(@[self.cowryLayout.widthSize, self.beanLayout.widthSize,self.couponLayout.widthSize,self.inviteLayout.widthSize]);//等宽分
    }
    return self;
}
- (MyRelativeLayout *)signInLayout
{
    if (nil == _signInLayout) {
        _signInLayout = [MyRelativeLayout new];
        _signInLayout.backgroundColor = [Color color:PGColorOptionThemeWhite];
        _signInLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
        _signInLayout.myHeight = 85;
        _signInLayout.myTop = 10;
        _signInLayout.myLeft = 0;
        _signInLayout.tag = 1001;
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(layoutClick:)];
        [_signInLayout addGestureRecognizer:tapGesturRecognizer];
    }
    return _signInLayout;
}
- (UIImageView *)signInImageView
{
    if (nil == _signInImageView) {
        _signInImageView = [[UIImageView alloc] init];
        _signInImageView.centerXPos.equalTo(self.signInLayout.centerXPos);
        _signInImageView.myTop = self.imageTop;
        _signInImageView.myWidth = 30;
        _signInImageView.myHeight = 30;
        _signInImageView.image = [UIImage imageNamed:@"mine_icon_sign.png"];
    }
    return _signInImageView;
}
- (NZLabel *)signInTitleLabel
{
    if (nil == _signInTitleLabel) {
        _signInTitleLabel = [NZLabel new];
        _signInTitleLabel.centerXPos.equalTo(self.signInImageView.centerXPos);
        _signInTitleLabel.topPos.equalTo(self.signInImageView.bottomPos).offset(self.titleTop);
        _signInTitleLabel.textAlignment = NSTextAlignmentCenter;
        _signInTitleLabel.font = [Color gc_Font:12.0];
        _signInTitleLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _signInTitleLabel.text = @"每日签到";
        [_signInTitleLabel sizeToFit];
        
    }
    return _signInTitleLabel;
}
- (NZLabel *)signInContentLabel
{
    if (nil == _signInContentLabel) {
        _signInContentLabel = [NZLabel new];
        _signInContentLabel.centerXPos.equalTo(self.signInImageView.centerXPos);
        _signInContentLabel.topPos.equalTo(self.signInTitleLabel.bottomPos).offset(self.contentTop);
        _signInContentLabel.textAlignment = NSTextAlignmentCenter;
        _signInContentLabel.font = [Color gc_Font:11.0];
        _signInContentLabel.textColor = [Color color:PGColorOptionTitleOrange];
        _signInContentLabel.text = @"送工力";
        [_signInContentLabel sizeToFit];
        
    }
    return _signInContentLabel;
}


- (MyRelativeLayout *)cowryLayout
{
    if (nil == _cowryLayout) {
        _cowryLayout = [MyRelativeLayout new];
        _cowryLayout.backgroundColor = [Color color:PGColorOptionThemeWhite];
        _cowryLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
        _cowryLayout.heightSize.equalTo(self.signInLayout.heightSize);
        _cowryLayout.topPos.equalTo(self.signInLayout.topPos);
        _cowryLayout.leftPos.equalTo(self.signInLayout.rightPos);
        _cowryLayout.tag = 1002;
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(layoutClick:)];
        [_cowryLayout addGestureRecognizer:tapGesturRecognizer];
    }
    return _cowryLayout;
}

- (UIImageView *)cowryImageView
{
    if (nil == _cowryImageView) {
        _cowryImageView = [[UIImageView alloc] init];
        _cowryImageView.centerXPos.equalTo(self.cowryLayout.centerXPos);
        _cowryImageView.myTop = self.imageTop;
        _cowryImageView.heightSize.equalTo(self.signInImageView.heightSize);
        _cowryImageView.widthSize.equalTo(self.signInImageView.widthSize);
        _cowryImageView.image = [UIImage imageNamed:@"mine_icon_shell.png"];
    }
    return _cowryImageView;
}
- (NZLabel *)cowryTitleLabel
{
    if (nil == _cowryTitleLabel) {
        _cowryTitleLabel = [NZLabel new];
        _cowryTitleLabel.centerXPos.equalTo(self.cowryImageView.centerXPos);
        _cowryTitleLabel.topPos.equalTo(self.cowryImageView.bottomPos).offset(self.titleTop);
        _cowryTitleLabel.textAlignment = NSTextAlignmentCenter;
        _cowryTitleLabel.font = self.signInTitleLabel.font;
        _cowryTitleLabel.textColor = self.signInTitleLabel.textColor;
        _cowryTitleLabel.text = @"我的工贝";
        [_cowryTitleLabel sizeToFit];
        
    }
    return _cowryTitleLabel;
}
- (NZLabel *)cowryContentLabel
{
    if (nil == _cowryContentLabel) {
        _cowryContentLabel = [NZLabel new];
        _cowryContentLabel.centerXPos.equalTo(self.cowryImageView.centerXPos);
        _cowryContentLabel.topPos.equalTo(self.cowryTitleLabel.bottomPos).offset(self.contentTop);
        _cowryContentLabel.textAlignment = NSTextAlignmentCenter;
        _cowryContentLabel.font = self.signInContentLabel.font;
        _cowryContentLabel.textColor = self.signInContentLabel.textColor;
        _cowryContentLabel.text = @"0.00";
        _cowryContentLabel.adjustsFontSizeToFitWidth = YES;
        [_cowryContentLabel sizeToFit];
        
    }
    return _cowryContentLabel;
}
- (MyRelativeLayout *)beanLayout
{
    if (nil == _beanLayout) {
        _beanLayout = [MyRelativeLayout new];
        _beanLayout.backgroundColor = [Color color:PGColorOptionThemeWhite];
        _beanLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
        _beanLayout.heightSize.equalTo(self.signInLayout.heightSize);
        _beanLayout.topPos.equalTo(self.signInLayout.topPos);
        _beanLayout.leftPos.equalTo(self.cowryLayout.rightPos);
        _beanLayout.tag = 1003;
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(layoutClick:)];
        [_beanLayout addGestureRecognizer:tapGesturRecognizer];
    }
    return _beanLayout;
}
- (UIImageView *)beanImageView
{
    if (nil == _beanImageView) {
        _beanImageView = [[UIImageView alloc] init];
        _beanImageView.centerXPos.equalTo(self.beanLayout.centerXPos);
        _beanImageView.myTop = self.imageTop;
        _beanImageView.heightSize.equalTo(self.signInImageView.heightSize);
        _beanImageView.widthSize.equalTo(self.signInImageView.widthSize);
        _beanImageView.image = [UIImage imageNamed:@"mine_icon_been.png"];
    }
    return _beanImageView;
}
- (NZLabel *)beanTitleLabel
{
    if (nil == _beanTitleLabel) {
        _beanTitleLabel = [NZLabel new];
        _beanTitleLabel.centerXPos.equalTo(self.beanImageView.centerXPos);
        _beanTitleLabel.topPos.equalTo(self.beanImageView.bottomPos).offset(self.titleTop);
        _beanTitleLabel.textAlignment = NSTextAlignmentCenter;
        _beanTitleLabel.font = self.signInTitleLabel.font;
        _beanTitleLabel.textColor = self.signInTitleLabel.textColor;
        _beanTitleLabel.text = @"我的工豆";
        [_beanTitleLabel sizeToFit];
        
    }
    return _beanTitleLabel;
}
- (NZLabel *)beanContentLabel
{
    if (nil == _beanContentLabel) {
        _beanContentLabel = [NZLabel new];
        _beanContentLabel.centerXPos.equalTo(self.beanImageView.centerXPos);
        _beanContentLabel.topPos.equalTo(self.beanTitleLabel.bottomPos).offset(self.contentTop);
        _beanContentLabel.textAlignment = NSTextAlignmentCenter;
        _beanContentLabel.font = self.signInContentLabel.font;
        _beanContentLabel.textColor = self.signInContentLabel.textColor;
        _beanContentLabel.text = @"¥0.00";
        _beanContentLabel.adjustsFontSizeToFitWidth = YES;
        [_beanContentLabel sizeToFit];
        
    }
    return _beanContentLabel;
}
- (MyRelativeLayout *)couponLayout
{
    if (nil == _couponLayout) {
        _couponLayout = [MyRelativeLayout new];
        _couponLayout.backgroundColor = [Color color:PGColorOptionThemeWhite];
        _couponLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
        _couponLayout.heightSize.equalTo(self.signInLayout.heightSize);
        _couponLayout.topPos.equalTo(self.signInLayout.topPos);
        _couponLayout.leftPos.equalTo(self.beanLayout.rightPos);
        _couponLayout.tag = 1004;
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(layoutClick:)];
        [_couponLayout addGestureRecognizer:tapGesturRecognizer];
        
    }
    return _couponLayout;
}
- (UIImageView *)couponImageView
{
    if (nil == _couponImageView) {
        _couponImageView = [[UIImageView alloc] init];
        _couponImageView.centerXPos.equalTo(self.couponLayout.centerXPos);
        _couponImageView.myTop = self.imageTop;
        _couponImageView.heightSize.equalTo(self.signInImageView.heightSize);
        _couponImageView.widthSize.equalTo(self.signInImageView.widthSize);
        _couponImageView.image = [UIImage imageNamed:@"mine_icon_coupon.png"];
    }
    return _couponImageView;
}
- (NZLabel *)couponTitleLabel
{
    if (nil == _couponTitleLabel) {
        _couponTitleLabel = [NZLabel new];
        _couponTitleLabel.centerXPos.equalTo(self.couponImageView.centerXPos);
        _couponTitleLabel.topPos.equalTo(self.couponImageView.bottomPos).offset(self.titleTop);
        _couponTitleLabel.textAlignment = NSTextAlignmentCenter;
        _couponTitleLabel.font = self.signInTitleLabel.font;
        _couponTitleLabel.textColor = self.signInTitleLabel.textColor;
        _couponTitleLabel.text = @"优惠券";
        [_couponTitleLabel sizeToFit];
        
    }
    return _couponTitleLabel;
}
- (NZLabel *)couponContentLabel
{
    if (nil == _couponContentLabel) {
        _couponContentLabel = [NZLabel new];
        _couponContentLabel.centerXPos.equalTo(self.couponImageView.centerXPos);
        _couponContentLabel.topPos.equalTo(self.couponTitleLabel.bottomPos).offset(self.contentTop);
        _couponContentLabel.textAlignment = NSTextAlignmentCenter;
        _couponContentLabel.font = self.signInContentLabel.font;
        _couponContentLabel.textColor = self.signInContentLabel.textColor;
        _couponContentLabel.text = @"张可用";
        [_couponContentLabel sizeToFit];
        
    }
    return _couponContentLabel;
}
- (MyRelativeLayout *)inviteLayout
{
    if (nil == _inviteLayout) {
        _inviteLayout = [MyRelativeLayout new];
        _inviteLayout.backgroundColor = [Color color:PGColorOptionThemeWhite];
        _inviteLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
        _inviteLayout.heightSize.equalTo(self.signInLayout.heightSize);
        _inviteLayout.topPos.equalTo(self.signInLayout.topPos);
        _inviteLayout.leftPos.equalTo(self.couponLayout.rightPos);
        _inviteLayout.tag = 1005;
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(layoutClick:)];
        [_inviteLayout addGestureRecognizer:tapGesturRecognizer];
        
    }
    return _inviteLayout;
}
- (UIImageView *)inviteImageView
{
    if (nil == _inviteImageView) {
        _inviteImageView = [[UIImageView alloc] init];
        _inviteImageView.centerXPos.equalTo(self.inviteLayout.centerXPos);
        _inviteImageView.myTop = self.imageTop;
        _inviteImageView.heightSize.equalTo(self.signInImageView.heightSize);
        _inviteImageView.widthSize.equalTo(self.signInImageView.widthSize);
        _inviteImageView.image = [UIImage imageNamed:@"mine_icon_rebate.png"];
    }
    return _inviteImageView;
}
- (NZLabel *)inviteTitleLabel
{
    if (nil == _inviteTitleLabel) {
        _inviteTitleLabel = [NZLabel new];
        _inviteTitleLabel.centerXPos.equalTo(self.inviteImageView.centerXPos);
        _inviteTitleLabel.topPos.equalTo(self.inviteImageView.bottomPos).offset(self.titleTop);
        _inviteTitleLabel.textAlignment = NSTextAlignmentCenter;
        _inviteTitleLabel.font = self.signInTitleLabel.font;
        _inviteTitleLabel.textColor = self.signInTitleLabel.textColor;
        _inviteTitleLabel.text = @"邀请返利";
        [_inviteTitleLabel sizeToFit];
        
    }
    return _inviteTitleLabel;
}
- (NZLabel *)inviteContentLabel
{
    if (nil == _inviteContentLabel) {
        _inviteContentLabel = [NZLabel new];
        _inviteContentLabel.centerXPos.equalTo(self.inviteImageView.centerXPos);
        _inviteContentLabel.topPos.equalTo(self.inviteTitleLabel.bottomPos).offset(self.contentTop);
        _inviteContentLabel.textAlignment = NSTextAlignmentCenter;
        _inviteContentLabel.font = self.signInContentLabel.font;
        _inviteContentLabel.textColor = self.signInContentLabel.textColor;
    }
    return _inviteContentLabel;
}
#pragma mark - 数据重新加载
- (void)showInfo:(id)model
{
    UCFMineMySimpleInfoModel *myModel = model;
    if (myModel != nil && [myModel isKindOfClass:[UCFMineMySimpleInfoModel class]] && myModel.ret) {
        
        
        self.cowryContentLabel.text = [NSString stringWithFormat:@"%.2f",myModel.data.coinNum];//工贝
        self.beanContentLabel.text = [NSString stringWithFormat:@"¥%@",myModel.data.beanAmount];// 工豆
        self.couponContentLabel.text = [NSString stringWithFormat:@"%zd",myModel.data.couponNumber];// 优惠券
        self.inviteContentLabel.text = myModel.data.promotionCode; // 邀请返利
    }
    else
    {
        self.cowryContentLabel.text = @"0.00";//工贝
        self.beanContentLabel.text = @"¥0.00";// 工豆
        self.couponContentLabel.text = @"0";// 优惠券
        self.inviteContentLabel.text = @""; // 邀请返利
    }
    [self.cowryContentLabel sizeToFit];
    [self.beanContentLabel sizeToFit];
    [self.couponContentLabel sizeToFit];
    [self.inviteContentLabel sizeToFit];
}
-(void)layoutClick:(UIGestureRecognizer *)sender
{
    if ([self.bc isKindOfClass:[UCFNewMineViewController class]]) {
        [(UCFNewMineViewController *)self.bc signInButtonClick:sender.view.tag];
    }
}
@end
