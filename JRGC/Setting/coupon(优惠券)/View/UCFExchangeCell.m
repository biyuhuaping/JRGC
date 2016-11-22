//
//  UCFExchangeCell.m
//  JRGC
//
//  Created by biyuhuaping on 16/4/25.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFExchangeCell.h"
#import "PrintView.h"
#import "NZLabel.h"

@interface UCFExchangeCell ()

@property (nonatomic, weak) PrintView *printView;
@property (strong, nonatomic) IBOutlet UIImageView *bgImgeView; //cell的背景
@property (strong, nonatomic) IBOutlet UILabel *prdNameLab;     //商品名称
@property (strong, nonatomic) IBOutlet UILabel *remarksLab;     //备注
@property (strong, nonatomic) IBOutlet UILabel *validityDateLab;//有效期
@property (strong, nonatomic) NSString *prdState;    //商品状态

@end

@implementation UCFExchangeCell

+ (instancetype)cellWithTableView:(UITableView *)tableview
{
    static NSString *Id = @"Coupon";
    UCFExchangeCell *cell = [tableview dequeueReusableCellWithIdentifier:Id];
    if (!cell) {
        cell = [[UCFExchangeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.signForOverDue.angleString = @"即将过期";
//        cell.signForOverDue.angleStatus = @"2";
//        cell.signForOverDue.hidden = YES;
    }
    return cell;
}

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
        self = [[[NSBundle mainBundle] loadNibNamed:@"UCFExchangeCell" owner:self options:nil] lastObject];
        PrintView *printView = [[PrintView alloc] initWithFrame:self.bgImgeView.bounds andTime:@"xxxx-xx-xx"];
        [printView setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:printView];
        self.printView = printView;
        printView.translatesAutoresizingMaskIntoConstraints = NO;
        NSArray *constraints1H=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[printView]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(printView)];
        NSArray *constraints1V=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[printView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(printView)];
        [self.contentView addConstraints:constraints1H];
        [self.contentView addConstraints:constraints1V];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UIImage *image;
    switch (self.exchangeModel.state) {//1：未使用 2：已使用 3：已过期 4：已赠送
        case 1: {//未使用
            [self.printView removeFromSuperview];
            image = [UIImage imageNamed:@"coupon_bg_exchange"];
            self.printView = nil;
            _validityDateLab.textColor = UIColorWithRGB(0xc57400);
        }
            break;
            
        case 2: {//已使用
            image = [UIImage imageNamed:@"coupon_bg_exchange_un"];
            self.printView.useTime = self.exchangeModel.usedTime;
//            _validityDateLab.textColor = UIColorWithRGB(0x999999);
        }
            break;
            
        case 3: {//已过期
            image = [UIImage imageNamed:@"coupon_bg_exchange_un"];
            self.printView.conponType = 2;
//            _validityDateLab.textColor = UIColorWithRGB(0x999999);
        }
            break;
    }
    
    _bgImgeView.image = [image stretchableImageWithLeftCapWidth:20 topCapHeight:0];
    _prdNameLab.text = _exchangeModel.prdName;          //商品名称
    _remarksLab.text = [NSString stringWithFormat:@"备注：%@",_exchangeModel.remarks];             //备注
    _validityDateLab.text = [NSString stringWithFormat:@"有效期 %@",_exchangeModel.validityDate];  //有效期
}

@end
