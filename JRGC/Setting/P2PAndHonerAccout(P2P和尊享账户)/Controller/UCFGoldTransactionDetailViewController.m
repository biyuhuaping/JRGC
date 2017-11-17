//
//  UCFGoldTransactionDetailViewController.m
//  JRGC
//
//  Created by 张瑞超 on 2017/7/10.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldTransactionDetailViewController.h"
#import "UCFGoldTransCell.h"

@interface UCFGoldTransactionDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *tradeTypeNameLab;
@property (weak, nonatomic) IBOutlet UILabel *dealGoldNum;

@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (strong, nonatomic)UIView *section_view0;
@property (strong, nonatomic)UIView *section_view1;
@property (strong, nonatomic)UIView *section_view2;

@end

@implementation UCFGoldTransactionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton];
    baseTitleLabel.text = @"交易详情";
    self.baseView.width = ScreenWidth;
    [self initNewUI];

}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.section_view1.frame = CGRectMake(0, 136, ScreenWidth, 93);
    self.section_view2.frame = CGRectMake(0, CGRectGetMaxY(_section_view1.frame), ScreenWidth, 93);
    
}
- (void)initNewUI
{
    if ([_model.tradeTypeCode isEqualToString:@"98"] || [_model.tradeTypeCode isEqualToString:@"109"] || [_model.tradeTypeCode isEqualToString:@"100"] || [_model.tradeTypeCode isEqualToString:@"101"]) {
        if ([_model.tradeTypeCode isEqualToString:@"101"]) {
            self.tradeTypeNameLab.text = @"解冻克重";
        } else if ([_model.tradeTypeCode isEqualToString:@"122"]) {
            self.tradeTypeNameLab.text = @"失败解冻";
        } else {
            self.tradeTypeNameLab.text = @"冻结克重";
        }
        self.dealGoldNum.textColor = UIColorWithRGB(0x999999);
        NSString *totalStr =  [NSString stringWithFormat:@"%@克",_model.purchaseAmount];
        self.dealGoldNum.attributedText = [self changeLabelWithText:@"克" withTotalStr:totalStr];
        UIView *view2 = [[NSBundle mainBundle]loadNibNamed:@"ServiceChargeView" owner:nil options:nil][1];
        view2.frame = CGRectMake(0, 136, ScreenWidth, 93);
        [_baseView addSubview:view2];

        UILabel *lab1 = (UILabel *)[view2 viewWithTag:100];
        UILabel *lab2 = (UILabel *)[view2 viewWithTag:200];
        UILabel *lab3 = (UILabel *)[view2 viewWithTag:300];
        lab1.text = _model.tradeTypeName;
        lab2.text = _model.tradeTime;
        lab3.text = _model.tradeRemark;
    } else if ([_model.tradeTypeCode isEqualToString:@"112"] || [_model.tradeTypeCode isEqualToString:@"113"] || [_model.tradeTypeCode isEqualToString:@"122"]) {
        UIView *view0 = [[NSBundle mainBundle]loadNibNamed:@"ServiceChargeView" owner:nil options:nil][0];
        view0.frame = CGRectMake(0, 136, ScreenWidth, 37);
        UIView *view2 = [[NSBundle mainBundle]loadNibNamed:@"ServiceChargeView" owner:nil options:nil][1];
        view2.frame = CGRectMake(0, CGRectGetMaxY(view0.frame), ScreenWidth, 93);
        [_baseView addSubview:view0];
        [_baseView addSubview:view2];
        UILabel *lab0 = (UILabel *)[view0 viewWithTag:100];
        UILabel *lab1 = (UILabel *)[view2 viewWithTag:100];
        UILabel *lab2 = (UILabel *)[view2 viewWithTag:200];
        UILabel *lab3 = (UILabel *)[view2 viewWithTag:300];
        lab1.text = _model.tradeTypeName;
        lab2.text = _model.tradeTime;
        lab3.text = _model.tradeRemark;
        lab0.text = [NSString stringWithFormat:@"¥%@",_model.poundage];
        if ([_model.tradeTypeCode isEqualToString:@"112"]) {
            self.tradeTypeNameLab.text = @"提金克重";
        } else if ([_model.tradeTypeCode isEqualToString:@"122"]) {
            self.tradeTypeNameLab.text = @"失败解冻";
        } else {
            self.tradeTypeNameLab.text = @"冻结克重";
        }
        self.dealGoldNum.textColor = UIColorWithRGB(0x999999);
        NSString *totalStr =  [NSString stringWithFormat:@"%@克",_model.purchaseAmount];
        self.dealGoldNum.attributedText = [self changeLabelWithText:@"克" withTotalStr:totalStr];
    } else if([_model.tradeTypeCode isEqualToString:@"99"]){
        
        UIView *view1 = [[NSBundle mainBundle]loadNibNamed:@"ServiceChargeView1" owner:nil options:nil][0];
        view1.frame = CGRectMake(0, 136, ScreenWidth, 93);
        self.section_view1 = view1;
        UIView *view2 = [[NSBundle mainBundle]loadNibNamed:@"ServiceChargeView" owner:nil options:nil][1];
        view2.frame = CGRectMake(0, CGRectGetMaxY(view1.frame), ScreenWidth, 93);
        self.section_view2 = view2;

        self.tradeTypeNameLab.text = @"买金克重";
        self.dealGoldNum.textColor = UIColorWithRGB(0xfd4d4c);
        NSString *totalStr = [NSString stringWithFormat:@"%@克",_model.purchaseAmount];
        self.dealGoldNum.attributedText = [self changeLabelWithText:@"克" withTotalStr:totalStr];
        UILabel *lab1_1 = (UILabel *)[view1 viewWithTag:100];
        UILabel *lab1_2 = (UILabel *)[view1 viewWithTag:200];
        UILabel *lab1_3 = (UILabel *)[view1 viewWithTag:300];
        
        UILabel *lab2_1 = (UILabel *)[view2 viewWithTag:100];
        UILabel *lab2_2 = (UILabel *)[view2 viewWithTag:200];
        UILabel *lab2_3 = (UILabel *)[view2 viewWithTag:300];
        
        lab2_1.text = _model.tradeTypeName;
        lab2_2.text = _model.tradeTime;
        lab2_3.text = _model.tradeRemark;
        
        lab1_1.text = [NSString stringWithFormat:@"%@",_model.tradeMoney];
        lab1_1.textColor = UIColorWithRGB(0xfd4d4c);
        lab1_2.text = [NSString stringWithFormat:@"¥%@",_model.purchasePrice];
        lab1_3.text = [NSString stringWithFormat:@"¥%@",_model.poundage];;
        
        [_baseView addSubview:view1];
        [_baseView addSubview:view2];

    }
    else if ([_model.tradeTypeCode isEqualToString:@"110"]) {
        self.tradeTypeNameLab.text = @"变现克重";
        self.dealGoldNum.textColor = UIColorWithRGB(0x4db94f);
        NSString *totalStr = [NSString stringWithFormat:@"%@克",_model.purchaseAmount]; //变现克重
        self.dealGoldNum.attributedText = [self changeLabelWithText:@"克" withTotalStr:totalStr];

        UIView *view1 = [[NSBundle mainBundle]loadNibNamed:@"ServiceChargeView1" owner:nil options:nil][0];
        view1.frame = CGRectMake(0, 136, ScreenWidth, 93);
        UIView *view2 = [[NSBundle mainBundle]loadNibNamed:@"ServiceChargeView" owner:nil options:nil][1];
        view2.frame = CGRectMake(0, CGRectGetMaxY(view1.frame), ScreenWidth, 93);
        [_baseView addSubview:view1];
        [_baseView addSubview:view2];

        UILabel *lab1_1 = (UILabel *)[view1 viewWithTag:100];
        UILabel *lab1_2 = (UILabel *)[view1 viewWithTag:200];
        UILabel *lab1_3 = (UILabel *)[view1 viewWithTag:300];

        UILabel *lab2_1 = (UILabel *)[view2 viewWithTag:100];
        UILabel *lab2_2 = (UILabel *)[view2 viewWithTag:200];
        UILabel *lab2_3 = (UILabel *)[view2 viewWithTag:300];

        lab2_1.text = _model.tradeTypeName;
        lab2_2.text = _model.tradeTime;
        lab2_3.text = _model.tradeRemark;

        lab1_1.text = [NSString stringWithFormat:@"%@",_model.tradeMoney];
        lab1_1.textColor = UIColorWithRGB(0x4db94f);
        lab1_2.text = [NSString stringWithFormat:@"¥%@",_model.purchasePrice];
        lab1_3.text = [NSString stringWithFormat:@"¥%@",_model.poundage];;

    } else if ([_model.tradeTypeCode isEqualToString:@"111"]) {
        self.tradeTypeNameLab.text = @"收益克重";
        self.dealGoldNum.textColor = UIColorWithRGB(0xfd4d4c);
        NSString *totalStr =  [NSString stringWithFormat:@"%@克",_model.purchaseAmount];
        self.dealGoldNum.attributedText = [self changeLabelWithText:@"克" withTotalStr:totalStr];
        UIView *view2 = [[NSBundle mainBundle]loadNibNamed:@"ServiceChargeView" owner:self options:nil][1];
        view2.frame = CGRectMake(0, 136, ScreenWidth, 93);
        [_baseView addSubview:view2];

        UILabel *lab1 = (UILabel *)[view2 viewWithTag:100];
        UILabel *lab2 = (UILabel *)[view2 viewWithTag:200];
        UILabel *lab3 = (UILabel *)[view2 viewWithTag:300];
        lab1.text = _model.tradeTypeName;
        lab1.textColor = UIColorWithRGB(0xfd4d4c);
        lab2.text = _model.tradeTime;
        lab3.text = _model.tradeRemark;
    }
}
//- (void)initUI {
//    if ([_model.tradeTypeCode isEqualToString:@"98"] || [_model.tradeTypeCode isEqualToString:@"109"] || [_model.tradeTypeCode isEqualToString:@"113"]|| [_model.tradeTypeCode isEqualToString:@"100"] || [_model.tradeTypeCode isEqualToString:@"101"] || [_model.tradeTypeCode isEqualToString:@"112"] || [_model.tradeTypeCode isEqualToString:@"112"] || [_model.tradeTypeCode isEqualToString:@"122"]) {
//        self.dealType.text = _model.tradeTypeName;
//        self.middleBaseView.hidden = YES;
//        if ([_model.tradeTypeCode isEqualToString:@"101"]) {
//            self.tradeTypeNameLab.text = @"解冻克重";
//        } else if ([_model.tradeTypeCode isEqualToString:@"122"]) {
//            self.tradeTypeNameLab.text = @"失败解冻";
//        } else {
//            self.tradeTypeNameLab.text = @"冻结克重";
//        }
//        self.dealGoldNum.textColor = UIColorWithRGB(0x999999);
//        NSString *totalStr =  [NSString stringWithFormat:@"%@克",_model.purchaseAmount];
//        self.dealGoldNum.attributedText = [self changeLabelWithText:@"克" withTotalStr:totalStr];
//        self.dealTime.text = _model.tradeTime;
//        self.dealNO.text = _model.tradeRemark;
//
//    } else if([_model.tradeTypeCode isEqualToString:@"99"]){
//        self.tradeTypeNameLab.text = @"买金克重";
//        self.dealGoldNum.textColor = UIColorWithRGB(0xfd4d4c);
//        NSString *totalStr = [NSString stringWithFormat:@"%@克",_model.purchaseAmount];
//        self.dealGoldNum.attributedText = [self changeLabelWithText:@"克" withTotalStr:totalStr];
//        self.dealType.text = _model.tradeTypeName;
//        self.dealTime.text = _model.tradeTime;
//        self.dealNO.text = _model.tradeRemark;
//
//        self.dealMoneyLab.text = [NSString stringWithFormat:@"%@",_model.tradeMoney];
//        self.dealMoneyLab.textColor = UIColorWithRGB(0xfd4d4c);
//        self.dealGoldPrice.text = [NSString stringWithFormat:@"¥%@",_model.purchasePrice];
//        self.serviceChargeLab.text = [NSString stringWithFormat:@"¥%@",_model.poundage];;
//    } else if ([_model.tradeTypeCode isEqualToString:@"110"]) {
//        self.tradeTypeNameLab.text = @"变现克重";
//        self.dealGoldNum.textColor = UIColorWithRGB(0x4db94f);
//        NSString *totalStr = [NSString stringWithFormat:@"%@克",_model.purchaseAmount]; //变现克重
//        self.dealGoldNum.attributedText = [self changeLabelWithText:@"克" withTotalStr:totalStr];
//        self.dealType.text = _model.tradeTypeName;
//        self.dealTime.text = _model.tradeTime;
//        self.dealNO.text = _model.tradeRemark;
//
//        self.dealMoneyLab.text = [NSString stringWithFormat:@"%@",_model.tradeMoney];
//        self.dealMoneyLab.textColor = UIColorWithRGB(0x4db94f);
//        self.dealGoldPrice.text = [NSString stringWithFormat:@"¥%@",_model.purchasePrice];
//        self.serviceChargeLab.text = [NSString stringWithFormat:@"¥%@",_model.poundage];;
//
//    } else if ([_model.tradeTypeCode isEqualToString:@"111"]) {
//        self.dealType.text = _model.tradeTypeName;
//        self.dealType.textColor = UIColorWithRGB(0xfd4d4c);
//        self.middleBaseView.hidden = YES;
//        self.bottomViewSpace.constant = 0;
//        self.tradeTypeNameLab.text = @"收益克重";
//        self.dealGoldNum.textColor = UIColorWithRGB(0xfd4d4c);
//        NSString *totalStr =  [NSString stringWithFormat:@"%@克",_model.purchaseAmount];
//        self.dealGoldNum.attributedText = [self changeLabelWithText:@"克" withTotalStr:totalStr];
//        self.dealTime.text = _model.tradeTime;
//        self.dealNO.text = _model.tradeRemark;
//
//
//    }
//}
-(NSMutableAttributedString*) changeLabelWithText:(NSString*)needText withTotalStr:(NSString *)totalStr
{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:totalStr];
    UIFont *font = [UIFont systemFontOfSize:14];
    [attrString addAttribute:NSFontAttributeName value:font range:[totalStr rangeOfString:needText]];
    return attrString;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
