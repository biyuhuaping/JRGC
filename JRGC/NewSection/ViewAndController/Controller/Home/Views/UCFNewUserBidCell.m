//
//  UCFNewUserBidCell.m
//  JRGC
//
//  Created by zrc on 2019/1/14.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewUserBidCell.h"
#import "UIButton+Gradient.h"
#import "UCFNewHomeListModel.h"
@interface UCFNewUserBidCell()

@property(nonatomic, strong)UILabel *termValueLab;
@property(nonatomic, strong)UILabel *rateValueLab;
@property(nonatomic, strong)UILabel *repayModelValueLab;
@property(nonatomic, weak)  UCFNewHomeListPrdlist *dataModel;
@end

@implementation UCFNewUserBidCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.rootLayout.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
        
        MyRelativeLayout *whitBaseView = [MyRelativeLayout new];
        whitBaseView.leftPos.equalTo(@15);
        whitBaseView.rightPos.equalTo(@15);
        whitBaseView.topPos.equalTo(@0);
        whitBaseView.bottomPos.equalTo(@15);
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
        [whitBaseView addSubview:button];
        [button setTitle:@"立即出借" forState:UIControlStateNormal];
        button.titleLabel.font = [Color gc_Font:16];
        [button setViewLayoutCompleteBlock:^(MyBaseLayout *layout, UIView *v) {
            v.layer.cornerRadius = CGRectGetHeight(v.frame)/2;
            NSArray *colorArray = [NSArray arrayWithObjects:UIColorWithRGB(0xFF4133),UIColorWithRGB(0xFF7F40), nil];
            UIImage *image = [(UIButton *)v buttonImageFromColors:colorArray ByGradientType:leftToRight];
            [(UIButton *)v setBackgroundImage:image forState:UIControlStateNormal];
        }];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *termMarkLab = [[UILabel alloc] init];
        termMarkLab.text = @"出借期限";
        termMarkLab.font = [Color gc_Font:12];
        termMarkLab.textColor = UIColorWithRGB(0xB1B5C2);
        [termMarkLab sizeToFit];
        termMarkLab.leftPos.equalTo(button.leftPos);
        termMarkLab.bottomPos.equalTo(button.topPos).offset(20);
        [whitBaseView addSubview:termMarkLab];
        
        UILabel *termValueLab = [[UILabel alloc] init];
        termValueLab.text = @"30天";
        termValueLab.bottomPos.equalTo(termMarkLab.topPos).offset(3);
        termValueLab.centerXPos.equalTo(termMarkLab.centerXPos);
        termValueLab.font = [Color gc_Font:18.0f];
        [whitBaseView addSubview:termValueLab];
        [termValueLab sizeToFit];
        self.termValueLab = termValueLab;

        UILabel *rateMarkLab = [[UILabel alloc] init];
        rateMarkLab.text = @"预期年化利率";
        rateMarkLab.font = [Color gc_Font:12];
        rateMarkLab.textColor = UIColorWithRGB(0xB1B5C2);
        [rateMarkLab sizeToFit];
        rateMarkLab.centerXPos.equalTo(button.centerXPos);
        rateMarkLab.bottomPos.equalTo(button.topPos).offset(20);
        [whitBaseView addSubview:rateMarkLab];
        
        UILabel *rateValueLab = [[UILabel alloc] init];
        rateValueLab.text = @"9.5%";
        rateValueLab.bottomPos.equalTo(rateMarkLab.topPos).offset(3);
        rateValueLab.centerXPos.equalTo(rateMarkLab.centerXPos);
        rateValueLab.font = [Color gc_ANC_font:23.0f];
        rateValueLab.textColor = [Color color:PGColorOpttonTextRedColor];
        [whitBaseView addSubview:rateValueLab];
        [rateValueLab sizeToFit];
        self.rateValueLab = rateValueLab;
        
        
        UILabel *repayModelMarkLab = [[UILabel alloc] init];
        repayModelMarkLab.text = @"还款方式";
        repayModelMarkLab.font = [Color gc_Font:12];
        repayModelMarkLab.textColor = UIColorWithRGB(0xB1B5C2);
        [repayModelMarkLab sizeToFit];
        repayModelMarkLab.rightPos.equalTo(button.rightPos);
        repayModelMarkLab.bottomPos.equalTo(button.topPos).offset(20);
        [whitBaseView addSubview:repayModelMarkLab];
        
        UILabel *repayModelValueLab = [[UILabel alloc] init];
        repayModelValueLab.text = @"一次结清";
        repayModelValueLab.font = [Color gc_Font:18];
        repayModelValueLab.textColor = [UIColor blackColor];
        [repayModelValueLab sizeToFit];
        repayModelValueLab.centerXPos.equalTo(repayModelMarkLab.centerXPos);
        repayModelValueLab.bottomPos.equalTo(repayModelMarkLab.topPos).offset(3);
        [whitBaseView addSubview:repayModelValueLab];
        self.repayModelValueLab = repayModelValueLab;
    }
    return self;
}

- (void)reflectDataModel:(id)model
{
    self.dataModel = (UCFNewHomeListPrdlist *)model;
    self.termValueLab.text = self.dataModel .repayPeriodtext;
    [self.termValueLab sizeToFit];
    self.rateValueLab.text = [NSString stringWithFormat:@"%@%%",self.dataModel .annualRate];
    [self.rateValueLab sizeToFit];
    self.repayModelValueLab.text = self.dataModel .repayModeText;
    [self.repayModelValueLab sizeToFit];
}
- (void)buttonClick:(UIButton *)button
{
    if (self.deleage && [self.deleage respondsToSelector:@selector(baseTableViewCell:buttonClick:withModel:)]) {
        [self.deleage baseTableViewCell:self buttonClick:button withModel:self.dataModel];
    }
//    self.bc 
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
