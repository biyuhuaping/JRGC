//
//  UCFCollectionChildCell.m
//  JRGC
//
//  Created by zrc on 2019/3/14.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFCollectionChildCell.h"
#import "UIImage+Compression.h"
@interface UCFCollectionChildCell()

/**
 标题
 */
@property(nonatomic, strong)UILabel     *titleLab;

/**
 借款额
 */
@property(nonatomic, strong)UILabel     *loanValueLab;
/**
 可投金额
 */
@property(nonatomic, strong)UILabel     *canInvestValueLab;



@property(nonatomic, strong)UIButton    *investButton;

@end

@implementation UCFCollectionChildCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.rootLayout.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
       
        MyRelativeLayout *whitBaseView = [MyRelativeLayout new];
        whitBaseView.leftPos.equalTo(@15);
        whitBaseView.rightPos.equalTo(@15);
        whitBaseView.topPos.equalTo(@15);
        whitBaseView.bottomPos.equalTo(@0);
        whitBaseView.backgroundColor = [UIColor whiteColor];
        whitBaseView.layer.cornerRadius = 5.0f;
        [self.rootLayout addSubview:whitBaseView];
        
        UIImageView *iconView = [[UIImageView alloc] init];
        iconView.myHeight = 18;
        iconView.myWidth = 3;
        iconView.leftPos.equalTo(@15);
        iconView.myTop = 20;
        iconView.backgroundColor = UIColorWithRGB(0xFF4133);
        iconView.clipsToBounds = YES;
        iconView.layer.cornerRadius = 2;
        [whitBaseView addSubview:iconView];
        
        UILabel *label = [[UILabel alloc] init];
        label.leftPos.equalTo(iconView.rightPos).offset(8);
        label.centerYPos.equalTo(iconView.centerYPos);
        label.text = @"新手专享";
        [whitBaseView addSubview:label];
        [label sizeToFit];
        self.titleLab = label;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"出借" forState:UIControlStateNormal];
        [button setTitleColor:[Color color:PGColorOptionThemeWhite] forState:UIControlStateNormal];
        button.bottomPos.equalTo(@20);
        button.widthSize.equalTo(@70);
        button.heightSize.equalTo(@35);
        button.rightPos.equalTo(@15);
        self.investButton = button;
        button.titleLabel.font = [Color gc_Font:16];
        [button setViewLayoutCompleteBlock:^(MyBaseLayout *layout, UIView *v) {
            v.clipsToBounds = YES;
            v.layer.cornerRadius = v.frame.size.height/2;
        }];
        [button addTarget:self action:@selector(investButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [whitBaseView addSubview:button];
        
        UILabel *loanMarkLab = [[UILabel alloc] init];
        loanMarkLab.text = @"借款额";
        loanMarkLab.textColor = [Color color:PGColorOptionTitleGray];
        loanMarkLab.font = [Color gc_Font:13];
        loanMarkLab.topPos.equalTo(button.centerYPos);
        loanMarkLab.leftPos.equalTo(@15);
        [whitBaseView addSubview:loanMarkLab];
        [loanMarkLab sizeToFit];
        
        UILabel *loanValueLab = [[UILabel alloc] init];
        loanValueLab.text = @"¥10000";
        loanValueLab.textColor = [Color color:PGColorOptionTitleBlack];
        loanValueLab.font = [Color gc_Font:13];
        loanValueLab.bottomPos.equalTo(button.centerYPos);
        loanValueLab.leftPos.equalTo(@15);
        [whitBaseView addSubview:loanValueLab];
        self.loanValueLab = loanValueLab;
        [loanValueLab sizeToFit];

        
        UILabel *canInvestMarkLab = [[UILabel alloc] init];
        canInvestMarkLab.text = @"可投金额";
        canInvestMarkLab.textColor = [Color color:PGColorOptionTitleGray];
        canInvestMarkLab.font = [Color gc_Font:13];
        canInvestMarkLab.centerYPos.equalTo(loanMarkLab.centerYPos);
        canInvestMarkLab.centerXPos.equalTo(whitBaseView.centerXPos);
        [whitBaseView addSubview:canInvestMarkLab];
        [canInvestMarkLab sizeToFit];
        
        UILabel *canInvestnValueLab = [[UILabel alloc] init];
        canInvestnValueLab.text = @"¥10000";
        canInvestnValueLab.textColor = [Color color:PGColorOptionTitleBlack];
        canInvestnValueLab.font = [Color gc_Font:13];
        canInvestnValueLab.centerYPos.equalTo(loanValueLab.centerYPos);
        canInvestnValueLab.leftPos.equalTo(canInvestMarkLab.leftPos);
        [whitBaseView addSubview:canInvestnValueLab];
        self.canInvestValueLab = canInvestnValueLab;
        [canInvestnValueLab sizeToFit];

    }
    return self;
}
- (void)setDataModel:(UCFCollcetionResult *)dataModel
{
    _dataModel = dataModel;
    
    self.titleLab.text = dataModel.childPrdClaimName;
    self.loanValueLab.text = [NSString stringWithFormat:@"¥%.2f",dataModel.totalAmt];
    self.canInvestValueLab.text = [NSString stringWithFormat:@"¥%.2f",dataModel.canBuyAmt];

    [self.canInvestValueLab sizeToFit];
    [self.loanValueLab sizeToFit];
    [self.titleLab sizeToFit];

    if ([dataModel.status intValue] == 2) { //可投
        [self.investButton setBackgroundImage:[UIImage gc_styleImageSize:CGSizeMake(70, 35)] forState:UIControlStateNormal];
        self.investButton.userInteractionEnabled = YES;
    } else {
        [self.investButton setBackgroundColor:[Color color:PGColorOpttonBtnBackgroundColor]];
        [self.investButton setTitle:@"已售罄" forState:UIControlStateNormal];
        self.investButton.userInteractionEnabled = NO;
    }
}
- (void)investButtonClick:(UIButton *)button
{
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
