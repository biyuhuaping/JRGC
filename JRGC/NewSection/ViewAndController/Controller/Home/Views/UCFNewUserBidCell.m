//
//  UCFNewUserBidCell.m
//  JRGC
//
//  Created by zrc on 2019/1/14.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewUserBidCell.h"
//#import "UIButton+Gradient.h"
#import "UCFNewHomeListModel.h"
#import "UIImage+Compression.h"
#import "UILabel+Misc.h"
@interface UCFNewUserBidCell()

@property(nonatomic, strong)UILabel *termValueLab;
@property(nonatomic, strong)UILabel *rateValueLab;
@property(nonatomic, strong)UILabel *repayModelValueLab;
@property(nonatomic, weak)  UCFNewHomeListPrdlist *dataModel;
@property(nonatomic, strong)UIButton    *bidBtn;
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
        button.leftPos.equalTo(@30);
        button.rightPos.equalTo(@30);
        button.bottomPos.equalTo(@23);
        button.heightSize.equalTo(@40);
        [button setBackgroundColor:[UIColor blueColor]];
        button.clipsToBounds = YES;
        [whitBaseView addSubview:button];
        [button setTitle:@"立即出借" forState:UIControlStateNormal];
        [button setTitle:@"已满标" forState:UIControlStateDisabled];

        button.titleLabel.font = [Color gc_Font:16];
        [button setViewLayoutCompleteBlock:^(MyBaseLayout *layout, UIView *v) {
            v.layer.cornerRadius = CGRectGetHeight(v.frame)/2;
            
            [(UIButton *)v setBackgroundImage:[UIImage gc_styleImageSize:CGSizeMake(v.frame.size.width, v.frame.size.height)] forState:UIControlStateNormal];
            [(UIButton *)v setBackgroundImage:[UIImage gc_styleGrayImageSize:CGSizeMake(v.frame.size.width, v.frame.size.height)] forState:UIControlStateDisabled];
        }];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        self.bidBtn = button;
        
        UILabel *termMarkLab = [[UILabel alloc] init];
        termMarkLab.text = @"出借期限";
        termMarkLab.font = [Color gc_Font:11];
        termMarkLab.textColor = UIColorWithRGB(0xB1B5C2);
        [termMarkLab sizeToFit];
        termMarkLab.leftPos.equalTo(button.leftPos);
        termMarkLab.bottomPos.equalTo(button.topPos).offset(18);
        [whitBaseView addSubview:termMarkLab];
        
        UILabel *termValueLab = [[UILabel alloc] init];
        termValueLab.text = @"30天";
        termValueLab.bottomPos.equalTo(termMarkLab.topPos).offset(-1);
        termValueLab.centerXPos.equalTo(termMarkLab.centerXPos);
        termValueLab.font = [Color gc_ANC_font:23.0f];
        [whitBaseView addSubview:termValueLab];
        [termValueLab sizeToFit];
        self.termValueLab = termValueLab;

        UILabel *rateMarkLab = [[UILabel alloc] init];
        rateMarkLab.text = @"预期年化利率";
        rateMarkLab.font = [Color gc_Font:11];
        rateMarkLab.textColor = UIColorWithRGB(0xB1B5C2);
        [rateMarkLab sizeToFit];
        rateMarkLab.centerXPos.equalTo(button.centerXPos);
        rateMarkLab.bottomPos.equalTo(button.topPos).offset(18);
        [whitBaseView addSubview:rateMarkLab];
        
        UILabel *rateValueLab = [[UILabel alloc] init];
        rateValueLab.text = @"9.5%";
        rateValueLab.bottomPos.equalTo(rateMarkLab.topPos).offset(-5);
        rateValueLab.centerXPos.equalTo(rateMarkLab.centerXPos);
        rateValueLab.font = [Color gc_ANC_font:32.0f];
        rateValueLab.textColor = [Color color:PGColorOpttonTextRedColor];
        [whitBaseView addSubview:rateValueLab];
        [rateValueLab sizeToFit];
        self.rateValueLab = rateValueLab;
        
        
        UILabel *repayModelMarkLab = [[UILabel alloc] init];
        repayModelMarkLab.text = @"还款方式";
        repayModelMarkLab.font = [Color gc_Font:11];
        repayModelMarkLab.textColor = UIColorWithRGB(0xB1B5C2);
        [repayModelMarkLab sizeToFit];
        repayModelMarkLab.rightPos.equalTo(button.rightPos);
        repayModelMarkLab.bottomPos.equalTo(button.topPos).offset(18);
        [whitBaseView addSubview:repayModelMarkLab];
        
        UILabel *repayModelValueLab = [[UILabel alloc] init];
        repayModelValueLab.text = @"一次结清";
        repayModelValueLab.font = [Color gc_Font:15];
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
    [self.rateValueLab setFont:[Color gc_ANC_font:21] string:@"%"];
    [self.rateValueLab sizeToFit];
    self.repayModelValueLab.text = self.dataModel .repayModeText;
    [self.repayModelValueLab sizeToFit];
    if ([self.dataModel.status isEqualToString:@"2"]) {
        self.bidBtn.enabled = YES;
    } else {
        self.bidBtn.enabled = NO;
    }
    if ([self.termValueLab.text containsString:@"天"]) {
        [self.termValueLab setFont:[Color gc_ANC_font:15] string:@"天"];
    } else if ([self.termValueLab.text containsString:@"个月"]){
        [self.termValueLab setFont:[Color gc_ANC_font:15] string:@"个月"];
    }
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
