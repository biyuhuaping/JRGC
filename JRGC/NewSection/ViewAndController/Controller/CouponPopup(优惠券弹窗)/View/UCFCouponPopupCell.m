//
//  UCFCouponPopupCell.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2018/12/12.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import "UCFCouponPopupCell.h"
#import "UCFCouponPopupModel.h"
@implementation UCFCouponPopupCell

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
        [self.couponTypeLayout addSubview:self.immediateUseBtn];
        [self.couponTypeLayout addSubview:self.remarkLabel];
        [self.couponTypeLayout addSubview:self.overdueTimeLabel];
        
        [self.rootLayout addSubview:self.couponDateLayout];
        
        [self.couponDateLayout addSubview:self.investMultipLabel];
        [self.couponDateLayout addSubview:self.inverstPeriodLabel];
        
    }
    return self;
}


//@property (nonatomic, strong) MyRelativeLayout *couponTypeLayout;
//@property (nonatomic, strong) YYLabel     *couponAmounLabel;//券面值
//@property (nonatomic, strong) UIButton    *immediateUseBtn; //立即使用
//@property (nonatomic, strong) YYLabel     *remarkLabel; //券名称
//@property (nonatomic, strong) YYLabel     *overdueTimeLabel;//过期时间
//
//@property (nonatomic, strong) MyRelativeLayout *couponDateLayout;
//@property (nonatomic, strong) YYLabel     *investMultipLabel;//投资限额
//@property (nonatomic, strong) YYLabel     *inverstPeriodLabel;//投资期限

- (MyRelativeLayout *)couponTypeLayout
{
    if (nil == _couponTypeLayout) {
        _couponTypeLayout = [MyRelativeLayout new];
        _couponTypeLayout.topPos.equalTo(@10);
        _couponTypeLayout.leftPos.equalTo(@15);
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


- (NZLabel *)couponAmounLabel
{
    if (nil == _couponAmounLabel) {
        _couponAmounLabel = [NZLabel new];
        _couponAmounLabel.topPos.equalTo(@5);
        _couponAmounLabel.leftPos.equalTo(@10);
        _couponAmounLabel.textAlignment = NSTextAlignmentLeft;
        _couponAmounLabel.font = [UIFont systemFontOfSize:30.0];
        _couponAmounLabel.textColor = [UIColor whiteColor];
        //        [_titleLabel sizeToFit];
    }
    return _couponAmounLabel;
}

- (UIButton*)immediateUseBtn{
    
    if(_immediateUseBtn==nil)
    {
        _immediateUseBtn = [UIButton buttonWithType:0];
        [_immediateUseBtn setTitle:@"立即使用" forState:UIControlStateNormal];
        [_immediateUseBtn setBackgroundColor:[UIColor whiteColor]];
        _immediateUseBtn.titleLabel.font = [UIFont systemFontOfSize: 12.0];
        _immediateUseBtn.topPos.equalTo(@15);
        _immediateUseBtn.rightPos.equalTo(@10);
        _immediateUseBtn.widthSize.equalTo(@60);
        _immediateUseBtn.heightSize.equalTo(@22);
        [_immediateUseBtn.layer setMasksToBounds:YES];
        _immediateUseBtn.layer.cornerRadius = 2.0;//2.0是圆角的弧度，根据需求自己更改
        
    }
    return _immediateUseBtn;
}


- (UILabel *)remarkLabel
{
    if (nil == _remarkLabel) {
        _remarkLabel = [UILabel new];
        _remarkLabel.bottomPos.equalTo(@5);
        _remarkLabel.leftPos.equalTo(self.couponAmounLabel.leftPos);
        _remarkLabel.textAlignment = NSTextAlignmentLeft;
        _remarkLabel.font = [UIFont systemFontOfSize:10.0];
        _remarkLabel.textColor = [UIColor whiteColor];
        //        [_titleLabel sizeToFit];
    }
    return _remarkLabel;
}
- (UILabel *)overdueTimeLabel
{
    if (nil == _overdueTimeLabel) {
        _overdueTimeLabel = [UILabel new];
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
- (UILabel *)investMultipLabel
{
    if (nil == _investMultipLabel) {
        _investMultipLabel = [UILabel new];
        _investMultipLabel.centerYPos.equalTo(@0);
        _investMultipLabel.leftPos.equalTo(@10);
//        _investMultipLabel.myLeft = 10;
        _investMultipLabel.myHeight = 20;
//        _investMultipLabel.myTop = 0;
        _investMultipLabel.textAlignment = NSTextAlignmentLeft;
        _investMultipLabel.font = [UIFont systemFontOfSize:10.0];
        _investMultipLabel.textColor = UIColorWithRGB(0x999999);
        //        [_titleLabel sizeToFit];
    }
    return _investMultipLabel;
}
- (UILabel *)inverstPeriodLabel
{
    if (nil == _inverstPeriodLabel) {
        _inverstPeriodLabel = [UILabel new];
        _inverstPeriodLabel.centerYPos.equalTo(@0);
        _inverstPeriodLabel.rightPos.equalTo(@10);
        _inverstPeriodLabel.myHeight = 20;
//        _inverstPeriodLabel.myTop = 0;
//        _inverstPeriodLabel.myLeft = 10;
        _inverstPeriodLabel.textAlignment = NSTextAlignmentRight;
        _inverstPeriodLabel.font = [UIFont systemFontOfSize:10.0];
        _inverstPeriodLabel.textColor = UIColorWithRGB(0x999999);
//        [_inverstPeriodLabel sizeToFit];
    }
    return _inverstPeriodLabel;
}

- (void)refreshCellData:(id)data
{
    [super refreshCellData:data];
    UCFCouponPopupCouponlist *cpData = data;
    
    NSString *couponAmount = cpData.couponAmount;
    if ([cpData.couponType isEqualToString:@"0"]) {
//        0返现券 1返息券
        self.couponTypeLayout.backgroundColor = UIColorWithRGB(0x70CBF4);
        self.couponAmounLabel.text = [NSString stringWithFormat:@"￥%@",couponAmount];
        [self.couponAmounLabel setFont:[UIFont systemFontOfSize:13.0] string:@"￥"];
        [self.immediateUseBtn setTitleColor:UIColorWithRGB(0x70CBF4)  forState:UIControlStateNormal];
    }else{
        [self.immediateUseBtn setTitleColor:UIColorWithRGB(0xFD4D4C)  forState:UIControlStateNormal];
        self.couponTypeLayout.backgroundColor = UIColorWithRGB(0xFD4D4C);
        self.couponAmounLabel.text = [NSString stringWithFormat:@"%@%%",couponAmount];
        [self.couponAmounLabel setFont:[UIFont systemFontOfSize:13.0] string:@"%"];
    }
    
    [self.couponAmounLabel sizeToFit];
    self.remarkLabel.text = cpData.remark;
    [self.remarkLabel sizeToFit];
    NSString *string = [NSString stringWithFormat:@"有效期至%@",cpData.overdueTime];
    if (string.length > 14) {
        string =  [string substringToIndex:14];
    }
    self.overdueTimeLabel.text = string;//截取掉下标5之前的字符串
    [self.overdueTimeLabel sizeToFit];
    self.investMultipLabel.text = [NSString stringWithFormat:@"投资金额≥%ld元可用",(long)cpData.investMultip] ;
    [self.investMultipLabel sizeToFit];
    self.inverstPeriodLabel.text = [NSString stringWithFormat:@"投资期限≥%ld天可用",(long)cpData.inverstPeriod];
    [self.inverstPeriodLabel sizeToFit];
    
}
@end
