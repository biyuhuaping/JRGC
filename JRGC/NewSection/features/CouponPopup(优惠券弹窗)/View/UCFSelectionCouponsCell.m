//
//  UCFSelectionCouponsCell.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2018/12/12.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import "UCFSelectionCouponsCell.h"
#import "UCFCouponPopupModel.h"
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
        self.rootLayout.backgroundColor = [UIColor clearColor];
        [self.rootLayout addSubview:self.couponTypeLayout];
        
        [self.couponTypeLayout addSubview:self.couponAmounLabel];
        [self.couponTypeLayout addSubview:self.remarkLabel];
        [self.couponTypeLayout addSubview:self.overdueTimeLabel];
        [self.rootLayout addSubview:self.willExpireLayout];
        
        [self.rootLayout addSubview:self.couponDateLayout];
        
        [self.couponDateLayout addSubview:self.investMultipLabel];
        [self.couponDateLayout addSubview:self.inverstPeriodLabel];
        
       
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
        _couponTypeLayout.leftPos.equalTo(self.selectCouponsBtn.rightPos).offset(13);
        _couponTypeLayout.rightPos.equalTo(@15);
        _couponTypeLayout.heightSize.equalTo(@62);
        _couponTypeLayout.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *sbv)
        { //viewLayoutCompleteBlock是在1.2.3中添加的新功能，目的是给完成了布局的子视图一个机会进行一些特殊的处理，viewLayoutCompleteBlock只会在子视图布局完成后调用一次.其中的sbv就是子视图自己，而layout则是父布局视图。因为这个block是完成布局后执行的。所以这时候子视图的frame值已经被计算出来，因此您可以在这里设置一些和frame关联的属性。
            //2.将指定的几个角切为圆角
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:sbv.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = sbv.bounds;
            maskLayer.path = maskPath.CGPath;
            sbv.layer.mask = maskLayer;
        };
    }
    return _couponTypeLayout;
}


- (YYLabel *)couponAmounLabel
{
    if (nil == _couponAmounLabel) {
        _couponAmounLabel = [YYLabel new];
        _couponAmounLabel.topPos.equalTo(@5);
        _couponAmounLabel.leftPos.equalTo(@10);
        _couponAmounLabel.textAlignment = NSTextAlignmentLeft;
        _couponAmounLabel.font = [UIFont systemFontOfSize:30.0];
        _couponAmounLabel.textColor = [UIColor whiteColor];
        //        [_titleLabel sizeToFit];
    }
    return _couponAmounLabel;
}

- (UIButton*)selectCouponsBtn{
    
    if(_selectCouponsBtn==nil)
    {
        _selectCouponsBtn = [UIButton buttonWithType:0];
        _selectCouponsBtn.centerYPos.equalTo(self.rootLayout.centerYPos);
        _selectCouponsBtn.leftPos.equalTo(@14);
        _selectCouponsBtn.widthSize.equalTo(@25);
        _selectCouponsBtn.heightSize.equalTo(@25);
        
    }
    return _selectCouponsBtn;
}
- (MyRelativeLayout *)willExpireLayout
{
    if (nil == _willExpireLayout) {
        _willExpireLayout = [MyRelativeLayout new];
        _willExpireLayout.topPos.equalTo(self.couponTypeLayout.topPos).offset(-3);
        _willExpireLayout.rightPos.equalTo(self.couponTypeLayout.rightPos).offset(2);
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
        _willExpireLayout.hidden = YES;
        
    }
    return _willExpireLayout;
}

- (YYLabel *)remarkLabel
{
    if (nil == _remarkLabel) {
        _remarkLabel = [YYLabel new];
        _remarkLabel.bottomPos.equalTo(@5);
        _remarkLabel.leftPos.equalTo(self.couponAmounLabel.leftPos);
        _remarkLabel.textAlignment = NSTextAlignmentLeft;
        _remarkLabel.font = [UIFont systemFontOfSize:10.0];
        _remarkLabel.textColor = [UIColor whiteColor];
        //        [_titleLabel sizeToFit];
    }
    return _remarkLabel;
}
- (YYLabel *)overdueTimeLabel
{
    if (nil == _overdueTimeLabel) {
        _overdueTimeLabel = [YYLabel new];
        _overdueTimeLabel.centerYPos.equalTo(self.remarkLabel.centerYPos);
        _overdueTimeLabel.rightPos.equalTo(@10);
        _overdueTimeLabel.leftPos.equalTo(self.remarkLabel.rightPos);
        _overdueTimeLabel.textAlignment = NSTextAlignmentRight;
        _overdueTimeLabel.font = self.remarkLabel.font;
        _overdueTimeLabel.textColor = self.remarkLabel.textColor;
        //        [_titleLabel sizeToFit];
    }
    return _overdueTimeLabel;
}

- (MyRelativeLayout *)couponDateLayout
{
    if (nil == _couponDateLayout) {
        _couponDateLayout = [MyRelativeLayout new];
        _couponDateLayout.topPos.equalTo(self.couponTypeLayout.bottomPos);
        _couponDateLayout.leftPos.equalTo(self.couponTypeLayout.leftPos);
        _couponDateLayout.rightPos.equalTo(self.couponTypeLayout.rightPos);
        _couponDateLayout.heightSize.equalTo(@20);
        //        _couponDateLayout.layer.borderColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1.0].CGColor;
        //        _couponDateLayout.layer.borderWidth = 0.5;
        _couponDateLayout.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *sbv)
        { //viewLayoutCompleteBlock是在1.2.3中添加的新功能，目的是给完成了布局的子视图一个机会进行一些特殊的处理，viewLayoutCompleteBlock只会在子视图布局完成后调用一次.其中的sbv就是子视图自己，而layout则是父布局视图。因为这个block是完成布局后执行的。所以这时候子视图的frame值已经被计算出来，因此您可以在这里设置一些和frame关联的属性。
            //2.将指定的几个角切为圆角
            
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:sbv.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
            CAShapeLayer *temp = [CAShapeLayer layer];
            temp.lineWidth = 0.5;
            temp.fillColor = [UIColor clearColor].CGColor;
            temp.strokeColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1.0].CGColor;
            temp.frame = sbv.bounds;
            temp.path = maskPath.CGPath;
            [sbv.layer addSublayer:temp];
            
            CAShapeLayer *mask = [[CAShapeLayer alloc]initWithLayer:temp];
            mask.path = maskPath.CGPath;
            sbv.layer.mask = mask;
        };
    }
    return _couponDateLayout;
}

//@property (nonatomic, strong) YYLabel     *inverstPeriodLabel;//投资期限
- (YYLabel *)investMultipLabel
{
    if (nil == _investMultipLabel) {
        _investMultipLabel = [YYLabel new];
        _investMultipLabel.centerYPos.equalTo(self.couponDateLayout.centerYPos);
        _investMultipLabel.leftPos.equalTo(@10);
        _investMultipLabel.textAlignment = NSTextAlignmentLeft;
        _investMultipLabel.font = self.remarkLabel.font;
        _investMultipLabel.textColor = UIColorWithRGB(0x999999);
        //        [_titleLabel sizeToFit];
    }
    return _investMultipLabel;
}
- (YYLabel *)inverstPeriodLabel
{
    if (nil == _inverstPeriodLabel) {
        _inverstPeriodLabel = [YYLabel new];
        _inverstPeriodLabel.centerYPos.equalTo(self.investMultipLabel.centerYPos);
        _inverstPeriodLabel.rightPos.equalTo(@10);
        _inverstPeriodLabel.textAlignment = NSTextAlignmentRight;
        _inverstPeriodLabel.font = self.remarkLabel.font;
        _inverstPeriodLabel.textColor = self.investMultipLabel.textColor;
        //        [_titleLabel sizeToFit];
    }
    return _inverstPeriodLabel;
}

- (void)refreshCellData:(id)data
{
    [super refreshCellData:data];
    
    UCFCouponPopupCouponlist *cpData = data;
    
    if (YES) {
        self.willExpireLayout.hidden = NO;
    }
    //优惠券是否可用
    if (NO) {
        if ([cpData.couponType isEqualToString:@"0"]) {
            //        0返现券 1返息券
            
            self.couponTypeLayout.backgroundColor = UIColorWithRGB(0x70CBF4);
        }else{
            self.couponTypeLayout.backgroundColor = UIColorWithRGB(0xFD4D4C);
        }
        [self.selectCouponsBtn setImage:[UIImage imageNamed:@"invest_btn_select_normal"] forState:UIControlStateNormal];
        
    }else
    {
        self.couponTypeLayout.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0];
        UIImage *image = [self createImageWithColor:[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0]];
        [self.selectCouponsBtn setImage:image forState:UIControlStateNormal];
        self.selectCouponsBtn.userInteractionEnabled = NO;
    }
    self.couponAmounLabel.text = cpData.couponAmount;
    [self.couponAmounLabel sizeToFit];
    self.remarkLabel.text = cpData.remark;
    [self.remarkLabel sizeToFit];
    self.overdueTimeLabel.text = [NSString stringWithFormat:@"有效期至%@",cpData.overdueTime];
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
