//
//  UCFSelectionCouponsCell.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2018/12/12.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import "UCFSelectionCouponsCell.h"
#import "UCFInvestmentCouponModel.h"
@implementation UCFSelectionCouponsCell

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
        self.rootLayout.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
        
        [self.rootLayout addSubview:self.couponTypeLayout];
        self.couponTypeLayout.layer.cornerRadius = 5.0f;
        self.couponTypeLayout.clipsToBounds = YES;
        self.couponTypeLayout.layer.borderWidth = 0.5;
        self.couponTypeLayout.layer.borderColor = [Color color:PGColorOptionCellSeparatorGray].CGColor;
        
        [self.couponTypeLayout addSubview:self.separteImageView];
        
        UIView *leftCircleView = [[UIView alloc] init];
        leftCircleView.layer.cornerRadius = 5.0f;
        leftCircleView.clipsToBounds = YES;
        leftCircleView.layer.borderWidth = 0.5;
        leftCircleView.leftPos.equalTo(self.couponTypeLayout).offset(-5);
        leftCircleView.widthSize.equalTo(@10);
        leftCircleView.heightSize.equalTo(@10);
        leftCircleView.bottomPos.equalTo(@25);
        leftCircleView.layer.borderColor = [Color color:PGColorOptionCellSeparatorGray].CGColor;
        leftCircleView.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
        [self.rootLayout addSubview:leftCircleView];
        
        UIView *leftreactView = [[UIView alloc] init];
        leftreactView.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
        leftreactView.rightPos.equalTo(self.couponTypeLayout.leftPos);
        leftreactView.widthSize.equalTo(@10);
        leftreactView.heightSize.equalTo(@10);
        leftreactView.bottomPos.equalTo(@25);
        [self.rootLayout addSubview:leftreactView];
        
        UIView *rightCircleView = [[UIView alloc] init];
        rightCircleView.layer.cornerRadius = 5.0f;
        rightCircleView.clipsToBounds = YES;
        rightCircleView.layer.borderWidth = 0.5;
        rightCircleView.layer.borderColor = [Color color:PGColorOptionCellSeparatorGray].CGColor;
        rightCircleView.leftPos.equalTo(self.couponTypeLayout.rightPos).offset(-5);
        rightCircleView.widthSize.equalTo(@10);
        rightCircleView.heightSize.equalTo(@10);
        rightCircleView.bottomPos.equalTo(@25);
        rightCircleView.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
        [self.rootLayout addSubview:rightCircleView];
        
        UIView *rightreactView = [[UIView alloc] init];
        rightreactView.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
        rightreactView.leftPos.equalTo(self.couponTypeLayout.rightPos);
        rightreactView.widthSize.equalTo(@10);
        rightreactView.heightSize.equalTo(@10);
        rightreactView.bottomPos.equalTo(@25);
        [self.rootLayout addSubview:rightreactView];
        
        [self.couponTypeLayout addSubview:self.couponAmounLabel];
        [self.couponTypeLayout addSubview:self.remarkLabel];
        [self.couponTypeLayout addSubview:self.overdueTimeLabel];
//
        [self.couponTypeLayout addSubview:self.investMultipLabel];
        [self.couponTypeLayout addSubview:self.inverstPeriodLabel];
    
        [self.rootLayout addSubview:self.selectCouponsBtn];
    }
    return self;
}

- (MyRelativeLayout *)couponTypeLayout
{
    if (nil == _couponTypeLayout) {
        _couponTypeLayout = [MyRelativeLayout new];
        _couponTypeLayout.topPos.equalTo(@10);
        _couponTypeLayout.clipsToBounds = NO;
        _couponTypeLayout.leftPos.equalTo(self.selectCouponsBtn.rightPos).offset(0);
        _couponTypeLayout.rightPos.equalTo(@15);
        _couponTypeLayout.heightSize.equalTo(@115);
        _couponTypeLayout.backgroundColor = [Color color:PGColorOptionThemeWhite];

    }
    return _couponTypeLayout;
}

- (UIImageView *)separteImageView
{
    if (nil == _separteImageView) {
        _separteImageView = [[UIImageView alloc] init];
        _separteImageView.image = [UIImage imageNamed:@"cash_card_separte"];
        _separteImageView.rightPos.equalTo(@0);
        _separteImageView.leftPos.equalTo(@0);
        _separteImageView.heightSize.equalTo(@10);
        _separteImageView.bottomPos.equalTo(@25);
    }
    return _separteImageView;
}
- (NZLabel *)couponAmounLabel
{
    if (nil == _couponAmounLabel) {
        _couponAmounLabel = [NZLabel new];
        _couponAmounLabel.topPos.equalTo(@12);
        _couponAmounLabel.leftPos.equalTo(@15);
        _couponAmounLabel.rightPos.equalTo(@10);
        _couponAmounLabel.textAlignment = NSTextAlignmentLeft;
        _couponAmounLabel.font = [Color gc_ANC_font :32.0];
        _couponAmounLabel.textColor = [UIColor whiteColor];
    }
    return _couponAmounLabel;
}

- (UIButton*)selectCouponsBtn{
    
    if(_selectCouponsBtn==nil)
    {
        _selectCouponsBtn = [UIButton buttonWithType:0];
        _selectCouponsBtn.centerYPos.equalTo(self.couponTypeLayout.centerYPos);
        _selectCouponsBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _selectCouponsBtn.leftPos.equalTo(@0);
        _selectCouponsBtn.widthSize.equalTo(@50);
        _selectCouponsBtn.heightSize.equalTo(@50 );
        [_selectCouponsBtn setImage:[UIImage imageNamed:@"coupon_btn_selected"] forState:UIControlStateSelected];
        [_selectCouponsBtn setImage:[UIImage imageNamed:@"invest_btn_select_normal"] forState:UIControlStateNormal];
    }
    return _selectCouponsBtn;
}
- (MyRelativeLayout *)willExpireLayout
{
    if (nil == _willExpireLayout) {
        _willExpireLayout = [MyRelativeLayout new];
        _willExpireLayout.topPos.equalTo(self.couponTypeLayout.topPos).offset(-3);
        _willExpireLayout.rightPos.equalTo(self.couponTypeLayout.rightPos).offset(10);
        _willExpireLayout.widthSize.equalTo(@63);
        _willExpireLayout.heightSize.equalTo(@17);
        _willExpireLayout.clipsToBounds = NO;
        UIImageView *willExpireImageView = [[UIImageView alloc] init];
        // 加载图片
        UIImage *image = [UIImage imageNamed:@"invest_bg_label"];
        // 设置左边端盖宽度
        NSInteger leftCapWidth = image.size.width * 0.5;
        // 设置上边端盖高度
        NSInteger topCapHeight = image.size.height * 0.5;
        UIImage *newImage = [image stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
        willExpireImageView.image= newImage;
        willExpireImageView.topPos.equalTo(@0);
        willExpireImageView.rightPos.equalTo(@0);
        willExpireImageView.widthSize.equalTo(@63);
        willExpireImageView.heightSize.equalTo(@17);
        
        UILabel *label = [UILabel new];
        label.backgroundColor = [UIColor clearColor];
        label.topPos.equalTo(willExpireImageView.topPos).offset(3);
        label.bottomPos.equalTo(willExpireImageView.bottomPos).offset(3);
        label.leftPos.equalTo(willExpireImageView.leftPos).offset(5);
        label.rightPos.equalTo(willExpireImageView.rightPos).offset(5);
        label.font = [UIFont systemFontOfSize:10.0];
        label.textColor = [UIColor whiteColor];
        label.text = @"即将过期";
        label.textAlignment = NSTextAlignmentCenter;
        [_willExpireLayout addSubview:willExpireImageView];
        [_willExpireLayout addSubview:label];
        _willExpireLayout.myVisibility = MyVisibility_Gone;
        
    }
    return _willExpireLayout;
}

- (UILabel *)remarkLabel
{
    if (nil == _remarkLabel) {
        _remarkLabel = [UILabel new];
        _remarkLabel.centerYPos.equalTo(self.couponTypeLayout.centerYPos).offset(5);
        _remarkLabel.leftPos.equalTo(self.couponAmounLabel.leftPos);
        _remarkLabel.textAlignment = NSTextAlignmentLeft;
        _remarkLabel.font = [UIFont systemFontOfSize:12.0];
        _remarkLabel.textColor = [Color color:PGColorOptionTitleGray];
    }
    return _remarkLabel;
}
- (UILabel *)overdueTimeLabel
{
    if (nil == _overdueTimeLabel) {
        _overdueTimeLabel = [UILabel new];
        _overdueTimeLabel.centerYPos.equalTo(self.remarkLabel.centerYPos);
        _overdueTimeLabel.rightPos.equalTo(@15);
        _overdueTimeLabel.leftPos.equalTo(self.remarkLabel.rightPos);
        _overdueTimeLabel.textAlignment = NSTextAlignmentRight;
        _overdueTimeLabel.font = self.remarkLabel.font;
        _overdueTimeLabel.textColor = self.remarkLabel.textColor;
        //        [_titleLabel sizeToFit];
    }
    return _overdueTimeLabel;
}
//- (UILabel *)unUseReasonMarkLab
//{
//    if (nil == _unUseReasonMarkLab) {
//        _unUseReasonMarkLab = [UILabel new];
//        _unUseReasonMarkLab.bottomPos.equalTo(self.detailReasonLab.topPos).offset(5);
//        _unUseReasonMarkLab.rightPos.equalTo(@15);
//        _unUseReasonMarkLab.textAlignment = NSTextAlignmentRight;
//        _unUseReasonMarkLab.font = self.remarkLabel.font;
//        _unUseReasonMarkLab.textColor = self.remarkLabel.textColor;
//        _unUseReasonMarkLab.text = @"不可用原因";
//        [_unUseReasonMarkLab sizeToFit];
//    }
//    return _unUseReasonMarkLab;
//}
//- (UILabel *)detailReasonLab
//{
//    if (nil == _detailReasonLab) {
//        _detailReasonLab = [UILabel new];
//        _detailReasonLab.bottomPos.equalTo(self.overdueTimeLabel.topPos).offset(13);
//        _detailReasonLab.rightPos.equalTo(@15);
//        _detailReasonLab.textAlignment = NSTextAlignmentRight;
//        _detailReasonLab.font = self.remarkLabel.font;
//        _detailReasonLab.textColor = self.remarkLabel.textColor;
//        _detailReasonLab.text = @"出借金额小于优惠券的最低使用金额";
//        [_detailReasonLab sizeToFit];
//
//    }
//    return _detailReasonLab;
//}
//@property (nonatomic, strong) UILabel     *unUseReasonMarkLab;
//@property (nonatomic, strong) UILabel     *detailReasonLab;


//@property (nonatomic, strong) YYLabel     *inverstPeriodLabel;//投资期限
- (UILabel *)investMultipLabel
{
    if (nil == _investMultipLabel) {
        _investMultipLabel = [UILabel new];
        _investMultipLabel.bottomPos.equalTo(@9);
        _investMultipLabel.leftPos.equalTo(self.remarkLabel.leftPos);
        _investMultipLabel.font = self.remarkLabel.font;
        _investMultipLabel.textColor = [Color color:PGColorOptionTitleGray];
    }
    return _investMultipLabel;
}
- (UILabel *)inverstPeriodLabel
{
    if (nil == _inverstPeriodLabel) {
        _inverstPeriodLabel = [UILabel new];
        _inverstPeriodLabel.centerYPos.equalTo(self.investMultipLabel.centerYPos);
        _inverstPeriodLabel.rightPos.equalTo(@15);
        _inverstPeriodLabel.textAlignment = NSTextAlignmentRight;
        _inverstPeriodLabel.font = self.remarkLabel.font;
        _inverstPeriodLabel.textColor = self.investMultipLabel.textColor;
    }
    return _inverstPeriodLabel;
}

- (void)refreshCellData:(id)data
{

    [super refreshCellData:data];
    
    InvestmentCouponCouponlist *cpData = data;
    
    if ([cpData.overdueFlag isEqualToString:@"1"]) {//即将过期标识,再展示图标
        self.willExpireLayout.myVisibility = MyVisibility_Gone;
    }
    else
    {
        self.willExpireLayout.myVisibility = MyVisibility_Visible;
    }
    NSString *couponAmount = cpData.couponAmount;
    //        0返现券 1返息券
    if ([cpData.couponType isEqualToString:@"0"])
    {
        self.couponAmounLabel.text = [NSString stringWithFormat:@"¥%@",couponAmount];
        [self.couponAmounLabel setFont:[Color gc_ANC_font: 18.0] string:@"¥"];

    }
    else
    {
        [_selectCouponsBtn setImage:[UIImage imageNamed:@"coupon_btn_selected_blue"] forState:UIControlStateSelected];

        self.couponAmounLabel.text = [NSString stringWithFormat:@"%@%%",couponAmount];
        [self.couponAmounLabel setFont:[Color gc_ANC_font:18.0] string:@"%"];
    }
    //YES勾选,no正常模式
    if (cpData.isCheck)
    {
        self.selectCouponsBtn.selected = YES;
    }
    else
    {
        self.selectCouponsBtn.selected = NO;
    }
    
    //优惠券是否可用
    if (cpData.isCanUse)
    {
//        UIImage *image = [self createImageWithColor:UIColorWithRGB(0xdddddd)];
//        [self.selectCouponsBtn setImage:image forState:UIControlStateNormal];
        self.selectCouponsBtn.userInteractionEnabled = YES;
        if ([cpData.couponType isEqualToString:@"0"]) {
            self.couponAmounLabel.textColor = [Color color:PGColorOpttonRateNoramlTextColor];
        } else {
            self.couponAmounLabel.textColor = [Color color:PGColorOptionCellContentBlue]; 
        }
    } else {
        [self.selectCouponsBtn setImage:[UIImage imageNamed:@"coupon_btn_unavailable"] forState:UIControlStateNormal];
        self.selectCouponsBtn.userInteractionEnabled = NO;
        self.couponAmounLabel.textColor = [Color color:PGColorOptionInputDefaultBlackGray];
//        self.unUseReasonMarkLab.myVisibility = MyVisibility_Visible;
//        self.detailReasonLab.myVisibility = MyVisibility_Visible;
    }
    
    [self.couponAmounLabel sizeToFit];
    self.remarkLabel.text = cpData.remark;
    [self.remarkLabel sizeToFit];
    NSString *string = [NSString stringWithFormat:@"有效期至%@",cpData.overdueTime];
    self.overdueTimeLabel.text = [string substringToIndex:14];//截取掉下标5之前的字符串
    [self.overdueTimeLabel sizeToFit];
    self.investMultipLabel.text = [NSString stringWithFormat:@"投资金额≥%ld元可用",cpData.investMultip] ;
    [self.investMultipLabel sizeToFit];
    self.inverstPeriodLabel.text = [NSString stringWithFormat:@"投资期限≥%ld天可用",cpData.inverstPeriod];
    [self.inverstPeriodLabel sizeToFit];
    
}

// 根据颜色生成UIImage
- (UIImage*) createImageWithColor:(UIColor*) color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [self circleImage:image];
 
}

//图片切成q圆形
- (UIImage*)circleImage:(UIImage *) image{
    // 1.开启一个透明上下文
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    
    // 2.加入一个圆形路径到图形上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextAddEllipseInRect(ctx, rect);
    
    // 3.裁剪
    CGContextClip(ctx);
    
    // 4.绘制图像
    [image drawInRect:rect];
    
    // 4.取得图像
    UIImage* circleImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 5.关闭上下文
    UIGraphicsEndImageContext();
    
    return circleImage;
}
@end
