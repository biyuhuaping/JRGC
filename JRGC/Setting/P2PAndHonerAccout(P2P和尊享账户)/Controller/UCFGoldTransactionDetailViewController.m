//
//  UCFGoldTransactionDetailViewController.m
//  JRGC
//
//  Created by 张瑞超 on 2017/7/10.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldTransactionDetailViewController.h"

@interface UCFGoldTransactionDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *tradeTypeNameLab;
@property (weak, nonatomic) IBOutlet UILabel *dealGoldNum;
@property (weak, nonatomic) IBOutlet UIView *middleBaseView;
@property (weak, nonatomic) IBOutlet UIView *bottomBaseView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewSpace;
@property (weak, nonatomic) IBOutlet UILabel *dealMoneyLab;
@property (weak, nonatomic) IBOutlet UILabel *dealGoldPrice;
@property (weak, nonatomic) IBOutlet UILabel *serviceChargeLab;

@property (weak, nonatomic) IBOutlet UILabel *dealType;
@property (weak, nonatomic) IBOutlet UILabel *dealTime;
@property (weak, nonatomic) IBOutlet UILabel *dealNO;
@end

@implementation UCFGoldTransactionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton];
    baseTitleLabel.text = @"交易详情";
    
    [self initUI];
}
- (void)initUI {
    if ([_model.tradeTypeName isEqualToString:@"冻结"]) {
        self.dealType.text = @"冻结";
        self.middleBaseView.hidden = YES;
        self.bottomViewSpace.constant = 0;
        self.tradeTypeNameLab.text = @"冻结克重";
        self.dealGoldNum.textColor = UIColorWithRGB(0x999999);
        self.dealGoldNum.text = [NSString stringWithFormat:@"%@克",_model.frozenMoney];
        self.dealTime.text = _model.tradeTime;
        self.dealNO.text = _model.tradeRemark;
    } else if([_model.tradeTypeName isEqualToString:@"买金"]){
        self.tradeTypeNameLab.text = @"买金克重";
        self.dealGoldNum.textColor = UIColorWithRGB(0xfd4d4c);
        self.dealGoldNum.text = [NSString stringWithFormat:@"%@克",_model.purchaseAmount];
        self.dealType.text = @"买金";
        self.dealTime.text = _model.tradeTime;
        self.dealNO.text = _model.tradeRemark;
        
        self.dealMoneyLab.text = [NSString stringWithFormat:@"￥%@",_model.tradeMoney];
        self.dealMoneyLab.textColor = UIColorWithRGB(0xfd4d4c);
        self.dealGoldPrice.text = [NSString stringWithFormat:@"￥%@",_model.purchasePrice];
        self.serviceChargeLab.text = @"手续费";
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
