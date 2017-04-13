//
//  BeanTableViewCell.m
//  JRGC
//
//  Created by NJW on 15/4/21.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "BeanTableViewCell.h"
#import "UCFAngleView.h"
#import "UCFFacBeanModel.h"

@interface BeanTableViewCell ()
// 工豆个数的背景视图
@property (weak, nonatomic) IBOutlet UIView *beanNumBgView;
// 工豆信息的背景视图
@property (weak, nonatomic) IBOutlet UIView *beanContentBgView;
// 是否即将到期的标识视图
@property (weak, nonatomic) IBOutlet UCFAngleView *signView;
// 工豆个数
@property (weak, nonatomic) IBOutlet UILabel *beanNumLabel;
// 工豆信息
@property (weak, nonatomic) IBOutlet UILabel *beanInfoLabel;
// 工豆有效期
@property (weak, nonatomic) IBOutlet UILabel *expireTimeLabel;
// 分割线高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *segLineHeight;

@end

@implementation BeanTableViewCell

+(BeanTableViewCell *)cellWithTableView:(UITableView *)tableview
{
    static NSString *ID = @"beancell";
    BeanTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:ID];
    if (nil == cell) {
        cell = [[BeanTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.signView.angleString = @"即将过期";
        cell.signView.angleStatus = @"2";
        cell.signView.hidden = YES;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"BeanTableViewCell" owner:self options:nil] lastObject];
        UIView *linetop = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 0.5)];
        linetop.backgroundColor = UIColorWithRGB(0xd8d8d8);
        [self.contentView insertSubview:linetop belowSubview:self.signView];
        
        UIView *linebottom = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-0.5, ScreenWidth, 0.5)];
        linebottom.backgroundColor = UIColorWithRGB(0xd8d8d8);
        [self addSubview:linebottom];
    }
    return self;
}

- (void)setFacBean:(UCFFacBeanModel *)facBean
{
    _facBean = facBean;
    if (facBean.state == UCFMyFacBeanStateOverduing) {
        if (facBean.flag.intValue ==1) {
            self.signView.hidden = NO;
            self.signView.alpha = 1;
        }
        else {
            self.signView.hidden = YES;
            self.signView.alpha = 0;
        }
        
    }
    if (facBean.state == UCFMyFacBeanStateUsed) {
        self.beanNumLabel.text = [NSString stringWithFormat:@"%@", facBean.useInvest];
    }
    else self.beanNumLabel.text = [NSString stringWithFormat:@"+%@", facBean.useInvest];

//    if (facBean.state != UCFMyFacBeanStateUnused) {
//        self.signView.alpha = 0;
//    }
    self.beanInfoLabel.text = facBean.remark;
    if (facBean.state == UCFMyFacBeanStateOverdue || facBean.state == UCFMyFacBeanStateUsed) {
        self.beanNumLabel.textColor = UIColorWithRGB(0x999999);
    }else{
        self.beanNumLabel.textColor = UIColorWithRGB(0xfd4d4c);
    }
//    self.beanNumLabel.textColor = facBean.state == 2 ? UIColorWithRGB(0x999999) : UIColorWithRGB(0xfd4d4c);
    if (facBean.state == UCFMyFacBeanStateUnused) {
        self.expireTimeLabel.text = [NSString stringWithFormat:@"获得时间 %@", facBean.issue_time];
    }
    else if (facBean.state == UCFMyFacBeanStateOverdue || facBean.state == UCFMyFacBeanStateOverduing) {
        self.expireTimeLabel.text = [NSString stringWithFormat:@"有效期 %@", facBean.overdueTime];
    }
    else if (facBean.state == UCFMyFacBeanStateUsed) {
        self.expireTimeLabel.text = [NSString stringWithFormat:@"使用日期 %@", facBean.useTime];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.segLineHeight.constant = 0.5;
}

@end
