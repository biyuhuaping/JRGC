//
//  UCFNewUserBidCell.m
//  JRGC
//
//  Created by zrc on 2019/1/14.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewUserBidCell.h"
#import "UIButton+Gradient.h"
@implementation UCFNewUserBidCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.rootLayout.backgroundColor = UIColorWithRGB(0xebebee);
        
        MyRelativeLayout *whitBaseView = [MyRelativeLayout new];
        whitBaseView.leftPos.equalTo(@15);
        whitBaseView.rightPos.equalTo(@15);
        whitBaseView.topPos.equalTo(@0);
        whitBaseView.bottomPos.equalTo(@0);
        whitBaseView.backgroundColor = [UIColor whiteColor];
        whitBaseView.layer.cornerRadius = 5.0f;
        [self.rootLayout addSubview:whitBaseView];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.leftPos.equalTo(@45);
        button.rightPos.equalTo(@45);
        button.bottomPos.equalTo(@21);
        button.heightSize.equalTo(@40);
        [button setBackgroundColor:[UIColor blueColor]];
        button.clipsToBounds = YES;
        [self.rootLayout addSubview:button];
        [button setTitle:@"立即出借" forState:UIControlStateNormal];
        button.titleLabel.font = [Color gc_Font:16];
        [button setViewLayoutCompleteBlock:^(MyBaseLayout *layout, UIView *v) {
            v.layer.cornerRadius = CGRectGetHeight(v.frame)/2;
            NSArray *colorArray = [NSArray arrayWithObjects:UIColorWithRGB(0xFF4133),UIColorWithRGB(0xFF7F40), nil];
            UIImage *image = [(UIButton *)v buttonImageFromColors:colorArray ByGradientType:leftToRight];
            [(UIButton *)v setBackgroundImage:image forState:UIControlStateNormal];
        }];
        
        UILabel *termMarkLab = [[UILabel alloc] init];
        termMarkLab.text = @"出借期限";
        termMarkLab.font = [Color gc_Font:12];
        termMarkLab.textColor = UIColorWithRGB(0xB1B5C2);
        [termMarkLab sizeToFit];
        termMarkLab.leftPos.equalTo(button.leftPos);
        termMarkLab.bottomPos.equalTo(button.topPos).offset(20);
        [self.rootLayout addSubview:termMarkLab];
        
        UILabel *termValueLab = [[UILabel alloc] init];
        termValueLab.text = @"30天";
        termValueLab.bottomPos.equalTo(termMarkLab.topPos).offset(3);
        termValueLab.centerXPos.equalTo(termMarkLab.centerXPos);
        termValueLab.font = [Color gc_Font:18.0f];
        [self.rootLayout addSubview:termValueLab];
        [termValueLab sizeToFit];

        UILabel *rateMarkLab = [[UILabel alloc] init];
        rateMarkLab.text = @"预期年化利率";
        rateMarkLab.font = [Color gc_Font:12];
        rateMarkLab.textColor = UIColorWithRGB(0xB1B5C2);
        [rateMarkLab sizeToFit];
        rateMarkLab.centerXPos.equalTo(button.centerXPos);
        rateMarkLab.bottomPos.equalTo(button.topPos).offset(20);
        [self.rootLayout addSubview:rateMarkLab];
        
        UILabel *rateValueLab = [[UILabel alloc] init];
        rateValueLab.text = @"9.5%";
        rateValueLab.bottomPos.equalTo(rateMarkLab.topPos).offset(3);
        rateValueLab.centerXPos.equalTo(rateMarkLab.centerXPos);
        rateValueLab.font = [Color gc_Font:23.0f];
        [self.rootLayout addSubview:rateValueLab];
        [rateValueLab sizeToFit];
        
        
        UILabel *repayModelMarkLab = [[UILabel alloc] init];
        repayModelMarkLab.text = @"还款方式";
        repayModelMarkLab.font = [Color gc_Font:12];
        repayModelMarkLab.textColor = UIColorWithRGB(0xB1B5C2);
        [repayModelMarkLab sizeToFit];
        repayModelMarkLab.rightPos.equalTo(button.rightPos);
        repayModelMarkLab.bottomPos.equalTo(button.topPos).offset(20);
        [self.rootLayout addSubview:repayModelMarkLab];
        
        UILabel *repayModelValueLab = [[UILabel alloc] init];
        repayModelValueLab.text = @"一次结清";
        repayModelValueLab.font = [Color gc_Font:18];
        repayModelValueLab.textColor = [UIColor blackColor];
        [repayModelValueLab sizeToFit];
        repayModelValueLab.centerXPos.equalTo(repayModelMarkLab.centerXPos);
        repayModelValueLab.bottomPos.equalTo(repayModelMarkLab.topPos).offset(3);
        [self.rootLayout addSubview:repayModelValueLab];
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
