//
//  UCFInvestmentDetailView.m
//  JRGC
//
//  Created by HeJing on 15/4/15.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFInvestmentDetailView.h"
#import "UILabel+Misc.h"
#import "InvestmentDetailTableViewCell.h"
#import "NSDateManager.h"
#import "UCFToolsMehod.h"
#import "SharedSingleton.h"

#import "NewInvestmentDetailTableViewCell.h"
#import "NewInvestmentDetailTwoTableViewCell.h"
@interface UCFInvestmentDetailView ()
{
    NSDictionary *_dataDic;
    UITableView *_tableView;
    NSString *_detailType;
}
@end

@implementation UCFInvestmentDetailView

- (id) initWithFrame:(CGRect)frame detailType:(NSString *)tp
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorWithRGB(0xebebee);
        _detailType = tp;
        [self initTableView];
    }
    return self;
}

- (void)initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorColor = UIColorWithRGB(0xeff0f3);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //_tableView.bounces = NO;
    _tableView.showsVerticalScrollIndicator = NO;
//    if (kIS_IOS7) {
//        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    }else{
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    }
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self addSubview:_tableView];
    UIView *footerview = [[UIView alloc] init];
    footerview.frame = CGRectMake(0, 0, ScreenWidth, 0.5);
    [footerview setBackgroundColor:UIColorWithRGB(0xd8d8d8)];
    _tableView.tableFooterView = footerview;
    [_tableView setHidden:YES];
}

- (void)setInvestDetailModel:(UCFInvestDetailModel *)investDetailModel
{
    if (investDetailModel != _investDetailModel) {
        _investDetailModel = investDetailModel;
        [_tableView reloadData];
        [_tableView setHidden:NO];
    }
}

#pragma mark -tableview

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 48)];
        footerView.backgroundColor = UIColorWithRGB(0xebebee);
        
        UILabel *titleLabel = [UILabel labelWithFrame:CGRectZero text:@"等级加息奖励将在起息后以工豆形式发放，灵活期限标起息后只发放锁定期内工豆，其余将在回款时发放。" textColor:UIColorWithRGB(0x999999) font:[UIFont systemFontOfSize:11]];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.tag = 1001;
        titleLabel.numberOfLines = 0;
        [footerView addSubview:titleLabel];
        titleLabel.frame = CGRectMake(15, 0, ScreenWidth - 30, 48);
        return footerView;
    }else if(section == 0){
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 25)];
        footerView.backgroundColor = UIColorWithRGB(0xebebee);
        UILabel *titleLabel = [UILabel labelWithFrame:CGRectZero text:self.investDetailModel.interestMode  textColor:UIColorWithRGB(0x999999) font:[UIFont systemFontOfSize:11]];
        titleLabel.text = [_detailType intValue] == 2  ? self.investDetailModel.buyCueDes : self.investDetailModel.interestMode;
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.tag = 1001;
        titleLabel.numberOfLines = 0;
        [footerView addSubview:titleLabel];
        titleLabel.frame = CGRectMake(15, 5, ScreenWidth - 30, 15);
        [self viewAddLine:footerView Up:YES withColor:UIColorWithRGB(0xd8d8d8)];
        
        return footerView;
    } else if (section == 1) {
        if ([_detailType isEqualToString:@"1"]) {
            return nil;
        } else {
            UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 34)];
            footerView.backgroundColor = UIColorWithRGB(0xebebee);
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 2, ScreenWidth - 30, 16)];
            label.textColor = [Color color:PGColorOptionTitleGray];
            label.text = @"该借款标还款日不计息";
            label.font = [Color gc_Font:12];
            [footerView addSubview:label];
            
            return footerView;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        
        if ([_detailType isEqualToString:@"1"]) {
            if ([self.investDetailModel.interestMode isEqualToString:@""] || self.investDetailModel.interestMode == nil)
            {
                return 0;
            }
            else {
                return 25;
            }
        }else{
            if([self.investDetailModel.buyCueDes isEqualToString:@""] || self.investDetailModel.buyCueDes == nil )
                return 0;
            else {
                return 25;
            }
        }
    }
    if (section == 1) {
        //
        if ([_detailType isEqualToString:@"1"]) {
            return 0;
        } else {
            return 34;
        }
    }
    
    if (section == 2) {
        //未获得等级加息时的判断条件
        if (!self.investDetailModel.gradeIncreases || [[UCFToolsMehod isNullOrNilWithString:self.investDetailModel.gradeIncreases] isEqualToString:@""] || [self.investDetailModel.gradeIncreases doubleValue] == 0.0) {
            return 0;
        } else {
            return 48;
        }
    }
    
    return 0;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
        headView.backgroundColor = [Color color:PGColorOptionGrayBackgroundColor];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 50)];
        view.backgroundColor = [UIColor whiteColor];
        
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 17, 3, 16)];
        iconView.backgroundColor = UIColorWithRGB(0xFF4133);
        iconView.layer.cornerRadius = 2.0f;
        [view addSubview:iconView];
        
        UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconView.frame) + 5, 15, ScreenWidth/2,20)];
        labelTitle.text = self.investDetailModel.prdName;
        labelTitle.textColor = [Color color:PGColorOptionTitleBlack];
        labelTitle.backgroundColor = [UIColor clearColor];
        labelTitle.font = [Color gc_Font:16];
        [view addSubview:labelTitle];
        
        UIButton *headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [headBtn addTarget:self action:@selector(headBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        headBtn.frame = CGRectMake(0, 10, ScreenWidth, 50);
        [view addSubview:headBtn];
        
        UILabel *titleStateLabel = [UILabel labelWithFrame:CGRectMake(ScreenWidth - 100, (50 - 12) / 2, 70, 12) text:@"" textColor:UIColorWithRGB(0x999999) font:[UIFont systemFontOfSize:15]];
        titleStateLabel.textAlignment = NSTextAlignmentRight;
        switch ([self.investDetailModel.status integerValue]) {
            case 0:
                titleStateLabel.text = @"未审核";
                break;
            case 1:
                titleStateLabel.text = @"等待确认";
                break;
            case 2:
                titleStateLabel.text = @"招标中";
                break;
            case 3:
                titleStateLabel.text = @"流标";
                break;
            case 4:
                titleStateLabel.text = @"满标";
                break;
            case 5:
                titleStateLabel.text = @"回款中";
                break;
            case 6:
                titleStateLabel.text = @"已回款";
                break;
        }
        titleStateLabel.backgroundColor = [UIColor clearColor];
        titleStateLabel.textAlignment = NSTextAlignmentRight;
        titleStateLabel.font = [UIFont systemFontOfSize:15];
        [view addSubview:titleStateLabel];
        
//        if ([titleStateLabel.text isEqualToString:@"招标中"]) {
//            titleStateLabel.textColor = UIColorWithRGB(0xfd4d4c);
//        } else if ([titleStateLabel.text isEqualToString:@"待回款"]) {
//            titleStateLabel.textColor = UIColorWithRGB(0x4aa1f9);
//        } else {
//            titleStateLabel.textColor = UIColorWithRGB(0x999999);
//        }
        
        [headView addSubview:view];
        
        UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 22, 18.5, 8, 13)];
        arrowView.image = [UIImage imageNamed:@"list_icon_arrow.png"];
        [view addSubview:arrowView];
        
//        [self viewAddLine:view Up:YES withColor:UIColorWithRGB(0xd8d8d8)];
        [self viewAddLine:headView Up:NO withColor:[Color color:PGColorOptionCellSeparatorGray]];
        return headView;
    } else if(section == 1) {
        return nil;
        /*
        CGFloat headviewHeight;
        CGFloat viewYPos;
        if ([_detailType integerValue] == 1) {
            if ([self.investDetailModel.interestMode isEqualToString:@""] || self.investDetailModel.interestMode == nil) {
                headviewHeight = 48;
                viewYPos = 10;
            } else {
                headviewHeight = 38;
                viewYPos = 0;
            }
            
        }else{
            
            if ([self.investDetailModel.buyCueDes isEqualToString:@""] || self.investDetailModel.buyCueDes == nil) {
                headviewHeight = 48;
                viewYPos = 10;
            } else {
                headviewHeight = 38;
                viewYPos = 0;
            }
        }
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, headviewHeight)];
        headView.backgroundColor = UIColorWithRGB(0xebebee);
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, viewYPos, ScreenWidth, 38)];
        view.backgroundColor = UIColorWithRGB(0xf7f7f7);
        UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 12, ScreenWidth/2, 14)];
        labelTitle.text = @"应收本息";
        labelTitle.textColor = UIColorWithRGB(0x333333);
        labelTitle.backgroundColor = [UIColor clearColor];
        labelTitle.font = [UIFont systemFontOfSize:14];
        [view addSubview:labelTitle];
        [headView addSubview:view];
        
        UILabel *amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 15 - 100, 12, 100, 14)];
        NSString *strAllAmt = [UCFToolsMehod isNullOrNilWithString:[NSString stringWithFormat:@"%@",self.investDetailModel.allAmt]];
        strAllAmt = [UCFToolsMehod dealmoneyFormart:strAllAmt];
        amountLabel.text = [NSString stringWithFormat:@"¥%@",[UCFToolsMehod isNullOrNilWithString:strAllAmt]];
        amountLabel.textColor = UIColorWithRGB(0xfd4d4c);
        amountLabel.backgroundColor = [UIColor clearColor];
        amountLabel.textAlignment = NSTextAlignmentRight;
        amountLabel.numberOfLines = 1;
        amountLabel.font = [UIFont systemFontOfSize:14];
        [view addSubview:amountLabel];
        
        [self viewAddLine:view Up:YES withColor:UIColorWithRGB(0xd8d8d8)];
        [self viewAddLine:headView Up:YES withColor:UIColorWithRGB(0xd8d8d8)];
        [self viewAddLine:headView Up:NO withColor:UIColorWithRGB(0xeff0f3)];
        return headView;
         */
    } else if (section == 2) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
        headView.backgroundColor = UIColorWithRGB(0xebebee);
      
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 50)];
        view.backgroundColor = [Color color:PGColorOptionThemeWhite];
        [headView addSubview:view];
        
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 17, 3, 16)];
        iconView.backgroundColor = UIColorWithRGB(0xFF4133);
        iconView.layer.cornerRadius = 2.0f;
        [view addSubview:iconView];
        
        UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconView.frame) + 5, 15, ScreenWidth/2,20)];
        labelTitle.text = @"VIP专享";
        labelTitle.textColor = [Color color:PGColorOptionTitleBlack];
        labelTitle.backgroundColor = [UIColor clearColor];
        labelTitle.font = [Color gc_Font:16];
        [view addSubview:labelTitle];
        [Common addLineViewColor:[Color color:PGColorOptionCellSeparatorGray] With:headView isTop:NO];
        return headView;
    } else if(section == 3) {
         //未获得等级加息时的判断条件
        if (!self.investDetailModel.gradeIncreases || [[UCFToolsMehod isNullOrNilWithString:self.investDetailModel.gradeIncreases] isEqualToString:@""] || [self.investDetailModel.gradeIncreases doubleValue] == 0.0) {
            if (self.investDetailModel.contractClauses.count > 0) {
                UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
                headView.backgroundColor = UIColorWithRGB(0xebebee);
                [self viewAddLine:headView Up:YES withColor:UIColorWithRGB(0xd8d8d8)];
                [self viewAddLine:headView Up:NO withColor:UIColorWithRGB(0xd8d8d8)];
                return headView;
            }
        }
        UIView *headVw = [[UIView alloc] initWithFrame:CGRectZero];
        return headVw;
    } else if(section == 4) {
        if ([_detailType isEqualToString:@"1"]) {
            CGFloat headviewHeight;
            CGFloat viewYPos;
            if (self.investDetailModel.contractClauses.count == 0) {
                headviewHeight = 38;
                viewYPos = 0;
            } else {
                headviewHeight = 50;
                viewYPos = 10;
            }
             //未获得等级加息时的判断条件
            if (!self.investDetailModel.gradeIncreases || [[UCFToolsMehod isNullOrNilWithString:self.investDetailModel.gradeIncreases] isEqualToString:@""] || [self.investDetailModel.gradeIncreases doubleValue] == 0.0) {
                headviewHeight = 50;
                viewYPos = 10;
            }
            UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, headviewHeight)];
            headView.backgroundColor = [Color color:PGColorOptionGrayBackgroundColor];
            
            
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, viewYPos, ScreenWidth, 40)];
            view.backgroundColor = [Color color:PGColorOptionThemeWhite];;
            
            
            UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 3, 16)];
            iconView.backgroundColor = UIColorWithRGB(0xFF4133);
            iconView.layer.cornerRadius = 2.0f;
            [view addSubview:iconView];
            
            UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconView.frame) + 5, 10, ScreenWidth/2, 20)];
            labelTitle.text = @"回款明细";
            labelTitle.textColor = [Color color:PGColorOptionTitleBlack];
            labelTitle.backgroundColor = [UIColor clearColor];
            labelTitle.font = [UIFont systemFontOfSize:16];
            [view addSubview:labelTitle];
            [headView addSubview:view];
            
            
            UILabel *Label = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 15 - 100, 12, 100, 16)];
            if (self.investDetailModel.refundSummarys.count > 0) {
                NSString *lalText = [NSString stringWithFormat:@"第%@期/共%@期",self.investDetailModel.refundSummarysNow,self.investDetailModel.refundSummarysCount];
                Label.textColor = UIColorWithRGB(0x555555);
                Label.backgroundColor = [UIColor clearColor];
                Label.textAlignment = NSTextAlignmentRight;
                Label.font = [UIFont systemFontOfSize:13];
                [view addSubview:Label];
                
                UIFont *font = [UIFont boldSystemFontOfSize:13];
                
                NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:lalText];
                [attributed addAttribute:NSFontAttributeName value:font range:[lalText rangeOfString:@"2"]];
                [attributed addAttribute:NSFontAttributeName value:font range:[lalText rangeOfString:@"3"]];
                Label.attributedText = attributed;
                NSString *refundSummarysNow = [NSString stringWithFormat:@"%@",_investDetailModel.refundSummarysNow];
                NSString *refundSummarysCount = [NSString stringWithFormat:@"%@",_investDetailModel.refundSummarysCount];
                if ([refundSummarysNow isEqualToString:@""] || [refundSummarysCount isEqualToString:@""]) {
                    [Label setHidden:YES];
                } else {
                    [Label setHidden:NO];
                }
            }
            
            
//            [self viewAddLine:view Up:YES withColor:UIColorWithRGB(0xd8d8d8)];
//            [self viewAddLine:headView Up:YES withColor:UIColorWithRGB(0xd8d8d8)];
//            [self viewAddLine:headView Up:NO withColor:UIColorWithRGB(0xeff0f3)];
            return headView;
        } else {
            CGFloat headviewHeight;
            CGFloat viewYPos;
            if (self.investDetailModel.contractClauses.count == 0) {
                headviewHeight = 38;
                viewYPos = 0;
            } else {
                headviewHeight = 60;
                viewYPos = 10;
            }
            UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, headviewHeight)];
            headView.backgroundColor = [Color color:PGColorOptionGrayBackgroundColor];
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, viewYPos, ScreenWidth, 50)];
            view.backgroundColor = [Color color:PGColorOptionThemeWhite];
            [headView addSubview:view];
            
            UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 17, 3, 16)];
            iconView.backgroundColor = UIColorWithRGB(0xFF4133);
            iconView.layer.cornerRadius = 2.0f;
            [view addSubview:iconView];
            
            UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconView.frame) + 5, 16, 65, 18)];
            labelTitle.text = @"原标信息";
            labelTitle.textColor = [Color color:PGColorOptionTitleBlack];
            labelTitle.backgroundColor = [UIColor clearColor];
            labelTitle.font = [Color gc_Font:16];
            [view addSubview:labelTitle];
            
            UILabel *detalLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labelTitle.frame) + 5, 18, ScreenWidth - CGRectGetMaxX(labelTitle.frame), 18)];
            detalLabel.text = @"购买的项目，按原标路径回款，详见回款明细";
            detalLabel.textColor = [Color color:PGColorOptionTitleGray];
            detalLabel.backgroundColor = [UIColor clearColor];
            detalLabel.textAlignment = NSTextAlignmentLeft;
            detalLabel.numberOfLines = 1;
            detalLabel.font = [Color gc_Font:12];
            [view addSubview:detalLabel];
            
//            [self viewAddLine:view Up:YES withColor:UIColorWithRGB(0xd8d8d8)];
//            [self viewAddLine:headView Up:YES withColor:UIColorWithRGB(0xd8d8d8)];
//            [self viewAddLine:headView Up:NO withColor:UIColorWithRGB(0xeff0f3)];
            return headView;
        }
       
    } else if (section == 5) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
        headView.backgroundColor = UIColorWithRGB(0xebebee);
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 50)];
        view.backgroundColor = [Color color:PGColorOptionThemeWhite];
        
        [headView addSubview:view];
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 17, 3, 16)];
        iconView.backgroundColor = UIColorWithRGB(0xFF4133);
        iconView.layer.cornerRadius = 2.0f;
        [view addSubview:iconView];
        
        UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconView.frame) + 5, 15, ScreenWidth/2, 20)];
        labelTitle.text = @"回款明细";
        labelTitle.textColor = [Color color:PGColorOptionTitleBlack];
        labelTitle.backgroundColor = [UIColor clearColor];
        labelTitle.font = [UIFont systemFontOfSize:16];
        [view addSubview:labelTitle];
        
        
        UILabel *Label = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 15 - 100, 18, 100, 14)];
        if (self.investDetailModel.refundSummarys.count > 0) {
            NSString *lalText = [NSString stringWithFormat:@"第%@期/共%@期",self.investDetailModel.refundSummarysNow,self.investDetailModel.refundSummarysCount];
            Label.textColor = UIColorWithRGB(0x555555);
            Label.backgroundColor = [UIColor clearColor];
            Label.textAlignment = NSTextAlignmentRight;
            Label.font = [UIFont systemFontOfSize:13];
            [view addSubview:Label];
            
            UIFont *font = [UIFont boldSystemFontOfSize:13];
            
            NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:lalText];
            [attributed addAttribute:NSFontAttributeName value:font range:[lalText rangeOfString:@"2"]];
            [attributed addAttribute:NSFontAttributeName value:font range:[lalText rangeOfString:@"3"]];
            Label.attributedText = attributed;
            NSString *refundSummarysNow = [NSString stringWithFormat:@"%@",_investDetailModel.refundSummarysNow];
            NSString *refundSummarysCount = [NSString stringWithFormat:@"%@",_investDetailModel.refundSummarysCount];
            if ([refundSummarysNow isEqualToString:@""] || [refundSummarysCount isEqualToString:@""]) {
                [Label setHidden:YES];
            } else {
                [Label setHidden:NO];
            }
        }
        
        
//        [self viewAddLine:view Up:YES withColor:UIColorWithRGB(0xd8d8d8)];
//        [self viewAddLine:headView Up:YES withColor:UIColorWithRGB(0xd8d8d8)];
//        [self viewAddLine:headView Up:NO withColor:UIColorWithRGB(0xeff0f3)];
        return headView;
    }
    return nil;
}

- (void)viewAddLine:(UIView *)view Up:(BOOL)up withColor:(UIColor*)inputColor
{
    if (up) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
        lineView.backgroundColor = inputColor;
        [view addSubview:lineView];
    }else{
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height - 0.5, ScreenWidth, 0.5)];
        lineView.backgroundColor = inputColor;
        [view addSubview:lineView];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 3) {
        if ([_detailType intValue] == 1) {
            if (!self.investDetailModel.gradeIncreases || [[UCFToolsMehod isNullOrNilWithString:self.investDetailModel.gradeIncreases] isEqualToString:@""] || [self.investDetailModel.gradeIncreases doubleValue] == 0.0) { //没有等级加息
                return 10;
            } else {
                return 0;
            }
            
        } else {
            //未获得等级加息时的判断条件
            if (!self.investDetailModel.gradeIncreases || [[UCFToolsMehod isNullOrNilWithString:self.investDetailModel.gradeIncreases] isEqualToString:@""] || [self.investDetailModel.gradeIncreases doubleValue] == 0.0) {
                //            if (self.investDetailModel.contractClauses.count == 0) {
                //                return 0;
                //            }
                //            return 10;
                return 0;
            }
            return 0;
        }

    } else if (section == 0) {
        return 60;
    } else if (section == 4) {
        if ([_detailType intValue] == 1) {
            if (self.investDetailModel.contractClauses.count == 0) {
                return 38;
            }
            return 48;
        } else {
            return 60;
        }

    } else if (section == 2) {
         //未获得等级加息时的判断条件
        NSLog(@"%@",self.investDetailModel.gradeIncreases);
        if (!self.investDetailModel.gradeIncreases || [[UCFToolsMehod isNullOrNilWithString:self.investDetailModel.gradeIncreases] isEqualToString:@""] || [self.investDetailModel.gradeIncreases doubleValue] == 0.0) {
            return 0;
        }
        return 60;
    } else if(section == 1){
        return 0.01;

    } else if(section == 5){
        return 60;
        
    }
    return 48;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_detailType isEqualToString:@"1"]) {
        if([indexPath section] == 3)
        {
            return 50; //合同
        } else if([indexPath section] == 1) {
            return 199;

        } else if ([indexPath section] == 2) {
            if (indexPath.row == 0) {
                return 31;
            } else if ([indexPath row] == 2) {
                return 27 + 7;
            } else {
                return 31;
            }
        }
        else if([indexPath section] == 4) {
            if ([indexPath row] == 0 || [indexPath row] == self.investDetailModel.refundSummarys.count) {
                return 27 + 8;
            } else {
                if (self.investDetailModel.refundSummarys.count == 0) {
                    return 27 + 8;
                }
                return 27;
            }
        } else {
            
            return 104;
            
            //已回款状态增加实际回款日
            if ([self.investDetailModel.status integerValue] == 6) {
                return 102;
            }
            return 82;
        }
    } else {
        if([indexPath section] == 3)
        {
            return 50;
        } else if([indexPath section] == 1) {
            if ([indexPath row] == 0) {
                return 14 + 20;
            } else if ([indexPath row] == 5) {
                return 14 + 20 + 13;
            } else {
                return 27;
            }
        } else if ([indexPath section] == 2) {
            if ([indexPath row] == 0 || [indexPath row] == 2) {
                return 27 + 7;
            } else {
                return 27;
            }
        }
        else if ([indexPath section] == 4) {
            return 118;
        } else if([indexPath section] == 5) {
            if ([indexPath row] == 0 || [indexPath row] == self.investDetailModel.refundSummarys.count) {
                return 27 + 8;
            } else {
                if (self.investDetailModel.refundSummarys.count == 0) {
                    return 27 + 8;
                }
                return 27;
            }
        } else {
            return 104;
        }
    }
   
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_detailType isEqualToString:@"1"]) {
        if(section == 1) {
            return 1;
        } else if (section == 2) {
             //未获得等级加息时的判断条件
            DDLogDebug(@"%@",self.investDetailModel.gradeIncreases);
            if (!self.investDetailModel.gradeIncreases || [[UCFToolsMehod isNullOrNilWithString:self.investDetailModel.gradeIncreases] isEqualToString:@""] || [self.investDetailModel.gradeIncreases doubleValue] == 0.0) {
                return 0;
            }
            return 2;
        } else if(section == 3) {
            return self.investDetailModel.contractClauses.count;
        } else if(section == 4 ) {
            if (self.investDetailModel.refundSummarys.count > 0) {
                return self.investDetailModel.refundSummarys.count + 1;
            }
            else return 2;
        } else {
            return 1;
        }

    } else {
        if(section == 1) {
            return 6;
        } else if (section == 2) {
             //未获得等级加息时的判断条件
            if (!self.investDetailModel.gradeIncreases || [[UCFToolsMehod isNullOrNilWithString:self.investDetailModel.gradeIncreases] isEqualToString:@""] || [self.investDetailModel.gradeIncreases doubleValue] == 0.0) {
                return 0;
            }
            return 2;
        } else if(section == 3) {
            return self.investDetailModel.contractClauses.count;
        } else if(section == 5) {
            if (self.investDetailModel.refundSummarys.count > 0) {
                return self.investDetailModel.refundSummarys.count + 1;
            }
            else return 2;
        } else {
            return 1;
        }
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([_detailType isEqualToString:@"2"]) {
        return 6;
    }
    return 5;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *reCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if ([indexPath section] == 0) {
        NSString *cellindifier = @"firstSectionCell";
        NewInvestmentDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellindifier];
        if (!cell) {
            cell = [[NewInvestmentDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellindifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.accoutType = self.accoutType;
        if ([_detailType isEqualToString:@"1"]) {
            [cell setValueOfTableViewCellLabel:self.investDetailModel type:@"1"];
        } else {
            [cell setValueOfTableViewCellLabel:self.investDetailModel type:@"2"];
        }
        
        return cell;
    } else if ([indexPath section] == 1) {
        
        if ([_detailType isEqualToString:@"1"]) {
            NSString *cellindifier = @"newoneSectionCell";
            NewInvestmentDetailTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellindifier];
            if (!cell) {
                cell = [[NewInvestmentDetailTwoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellindifier];
            }
            [cell setValueOfTableViewCellLabel:self.investDetailModel type:@"1"];
            return cell;
            
        } else {
            NSString *cellindifier = @"oneSectionCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellindifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellindifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
               
                UILabel *titleLabel = [UILabel labelWithFrame:CGRectZero text:@"" textColor:[Color color:PGColorOptionTitleBlack] font:[Color gc_Font:14]];
                titleLabel.textAlignment = NSTextAlignmentLeft;
                titleLabel.tag = 1001;
                [cell.contentView addSubview:titleLabel];
                
                UILabel *amountLabel = [UILabel labelWithFrame:CGRectMake(ScreenWidth / 2 + 14, 15, ScreenWidth / 2 - 29, 12) text:@"" textColor:UIColorWithRGB(0x555555) font:[Color gc_Font:14]];
                amountLabel.textAlignment = NSTextAlignmentRight;
                amountLabel.tag = 1002;
                amountLabel.numberOfLines = 1;
                [cell.contentView addSubview:amountLabel];
                
                if ([indexPath row] == 0) {
                    titleLabel.frame = CGRectMake(15, 20, ScreenWidth / 2, 14);
                    amountLabel.frame = CGRectMake(ScreenWidth / 2 + 14, 20, ScreenWidth / 2 - 29, 14);
                } else {
                    titleLabel.frame = CGRectMake(15, 12, ScreenWidth / 2, 14);
                    amountLabel.frame = CGRectMake(ScreenWidth / 2 + 14, 12, ScreenWidth / 2 - 29, 14);
                }
            }
            UILabel *titleLabel = (UILabel*)[cell.contentView viewWithTag:1001];
            UILabel *amountLabel = (UILabel*)[cell.contentView viewWithTag:1002];
            
            NSArray *titleArr = @[@"实付金额",@"预期利息",@"预期年化",@"还款方式",@"原标期限",@"起息日期"];
            
            
            NSString * markTime = @"-";
            if ([[UCFToolsMehod isNullOrNilWithString:self.investDetailModel.repayModeText] isEqualToString:@""]) {
                markTime = @"还款方式：-";
            } else {
                markTime = self.investDetailModel.repayModeText;
            }
            
            NSString *actMoney = [UCFToolsMehod isNullOrNilWithString:self.investDetailModel.actualInvestAmt];
            actMoney = [NSString stringWithFormat:@"¥%@",actMoney];
            
            NSString *taotalIntrest = [UCFToolsMehod isNullOrNilWithString:self.investDetailModel.taotalIntrest];
            taotalIntrest = [NSString stringWithFormat:@"¥%@",taotalIntrest];
            
            NSString *annualRate = [UCFToolsMehod isNullOrNilWithString:self.investDetailModel.annualRate];
            annualRate = [NSString stringWithFormat:@"%@%%",annualRate];
            
            NSString *repayPeriod = @"-";
            if ([[UCFToolsMehod isNullOrNilWithString:self.investDetailModel.repayPeriod] isEqualToString:@""]) {
                repayPeriod = @"-";
            } else {
                repayPeriod = [NSString stringWithFormat:@"%@天",self.investDetailModel.repayPeriod];
            }
            NSString *effactiveDate = @"-";
            if ([[UCFToolsMehod isNullOrNilWithString:self.investDetailModel.effactiveDate] isEqualToString:@""]) {
                effactiveDate = @"-";
            } else {
                effactiveDate = self.investDetailModel.effactiveDate;
            }
            
            NSArray *amountArr = @[actMoney,
                                   taotalIntrest,
                                   annualRate,
                                   markTime,
                                   repayPeriod,
                                   effactiveDate,
                                   ];
            NSString *title = [titleArr objectAtIndex:[indexPath row]];
            titleLabel.text = title;
            NSString *anmout = [NSString stringWithFormat:@"%@",[amountArr objectAtIndex:[indexPath row]]];
            
            amountLabel.text = [NSString stringWithFormat:@"%@",anmout];
            if ([title isEqualToString:@"预期利息"]) {
                amountLabel.textColor = [Color color:PGColorOpttonTextRedColor];
            } else {
                amountLabel.textColor = [Color color:PGColorOptionTitleBlack];
            }
            return cell;
        }
        

    } else if ([indexPath section] == 2) {//***************加息奖励***********************//
        NSString *cellindifier = @"twoSectionCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellindifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellindifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *titleLabel = [UILabel labelWithFrame:CGRectZero text:@"" textColor:[Color color:PGColorOptionTitleBlack] font:[UIFont systemFontOfSize:14]];
            titleLabel.textAlignment = NSTextAlignmentLeft;
            titleLabel.tag = 1001;
            titleLabel.numberOfLines = 0;
            [cell.contentView addSubview:titleLabel];
            
            UILabel *amountLabel = [UILabel labelWithFrame:CGRectMake(ScreenWidth / 2 + 14, 15, ScreenWidth / 2 - 29, 12) text:@"" textColor:[Color color:PGColorOptionTitleBlack] font:[UIFont boldSystemFontOfSize:14]];
            amountLabel.textAlignment = NSTextAlignmentRight;
            amountLabel.tag = 1002;
            amountLabel.numberOfLines = 1;
            [cell.contentView addSubview:amountLabel];
            if ([indexPath row] == 0) {
                titleLabel.frame = CGRectMake(15, 15, ScreenWidth / 2, 12);
                amountLabel.frame = CGRectMake(ScreenWidth / 2 + 14, 15, ScreenWidth / 2 - 29, 12);
            } else if ([indexPath row] == 2) {
                titleLabel.frame = CGRectMake(15, 8, ScreenWidth - 30, 30);
                amountLabel.frame = CGRectZero;
            } else {
                titleLabel.frame = CGRectMake(15, 8, ScreenWidth / 2, 12);
                amountLabel.frame = CGRectMake(ScreenWidth / 2 + 14, 8, ScreenWidth / 2 - 29, 12);
            }
        }
        
        UILabel *titleLabel = (UILabel*)[cell.contentView viewWithTag:1001];
        UILabel *amountLabel = (UILabel*)[cell.contentView viewWithTag:1002];
        NSArray *titleArr = @[@"会员等级加息奖励",@"返还工豆"];
        titleLabel.text = [titleArr objectAtIndex:[indexPath row]];
        if ([indexPath row] == 0) {
            amountLabel.text = [NSString stringWithFormat:@"%@%%",self.investDetailModel.gradeIncreases];//self.investDetailModel.gradeIncreases
            amountLabel.textColor = UIColorWithRGB(0xfd4d4c);
        } else if ([indexPath row] == 1) {
            amountLabel.text = [NSString stringWithFormat:@"¥%@",self.investDetailModel.returnBeans];//self.investDetailModel.returnBeans
        }
        return cell;
    }else if ([indexPath section] == 3) {
        NSString *cellindifier = @"thirdSectionCell";
        UITableViewCell *cell = nil;
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellindifier];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.textColor = [Color color:PGColorOptionTitleBlack];
            
            UILabel *acessoryLabel = [UILabel labelWithFrame:CGRectMake(ScreenWidth - 100, (50 - 14) / 2, 70, 14) text:@"" textColor:[Color color:PGColorOptionTitleGray] font:[UIFont systemFontOfSize:13]];
            acessoryLabel.tag = 100;
            acessoryLabel.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:acessoryLabel];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 49, ScreenWidth - 15, 1)];
            lineView.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
            lineView.tag = 101;
            [cell.contentView addSubview:lineView];
        }
        UILabel *acessoryLabel = (UILabel*)[cell.contentView viewWithTag:100];
        UILabel *lineView = (UILabel*)[cell.contentView viewWithTag:101];
        if (indexPath.row == self.investDetailModel.contractClauses.count - 1) {
            lineView.hidden = YES;
        } else {
            lineView.hidden = NO;
        }
        UCFConstractModel *constract = self.investDetailModel.contractClauses[indexPath.row];
        cell.textLabel.text = constract.contracttitle;
        switch ([constract.signStatus integerValue]) {
            case 0:
                acessoryLabel.text = @"未签署";
                break;
                
            default: acessoryLabel.text = @"已签署";
                break;
        }
        
        return cell;
    } else if ([indexPath section] == 4 || [indexPath section] == 5) {
        if ([_detailType isEqualToString:@"2"] && [indexPath section] == 4) {
            NSString *cellindifier = @"transthreeSectionCell";
            UITableViewCell *cell = nil;
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellindifier];
                
                UILabel *tarnsBidMarkLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, ScreenWidth / 2 - 15, 15)];
                tarnsBidMarkLabel1.text = @"预期年化利率";
                tarnsBidMarkLabel1.textColor = [Color color:PGColorOptionTitleBlack];
                tarnsBidMarkLabel1.font = [Color gc_Font:14];
                [cell addSubview:tarnsBidMarkLabel1];
                
                UILabel *tarnsBidLabel1 = [UILabel labelWithFrame:CGRectMake(ScreenWidth / 2, 5, ScreenWidth / 2 - 15, 15) text:@"" textColor:nil font:[UIFont systemFontOfSize:14]];
                tarnsBidLabel1.textAlignment = NSTextAlignmentRight;
                tarnsBidLabel1.numberOfLines = 1;
                tarnsBidLabel1.tag = 0x1000;
                tarnsBidLabel1.textColor = [Color color:PGColorOptionTitleBlack];
                [cell.contentView addSubview:tarnsBidLabel1];
                
                CGFloat Vspace = 10;
                
                UILabel *tarnsBidMarkLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(tarnsBidMarkLabel1.frame) + Vspace, ScreenWidth / 2 - 15, 15)];
                tarnsBidMarkLabel2.text = @"原标期限";
                tarnsBidMarkLabel2.textColor = [Color color:PGColorOptionTitleBlack];
                tarnsBidMarkLabel2.font = [Color gc_Font:14];
                [cell addSubview:tarnsBidMarkLabel2];
                
                UILabel *tarnsBidLabel2 = [UILabel labelWithFrame:CGRectMake(ScreenWidth / 2, CGRectGetMaxY(tarnsBidMarkLabel1.frame) + Vspace, ScreenWidth / 2 - 15, 15) text:@"" textColor:nil font:[UIFont systemFontOfSize:14]];
                tarnsBidLabel2.textAlignment = NSTextAlignmentRight;
                tarnsBidLabel2.tag = 0x1001;
                [cell.contentView addSubview:tarnsBidLabel2];
                
                UILabel *tarnsBidMarkLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(tarnsBidMarkLabel2.frame) + Vspace, ScreenWidth / 2 - 15, 15)];
                tarnsBidMarkLabel3.text = @"还款方式";
                tarnsBidMarkLabel3.textColor = [Color color:PGColorOptionTitleBlack];
                tarnsBidMarkLabel3.font = [Color gc_Font:14];
                [cell addSubview:tarnsBidMarkLabel3];
                
                UILabel *tarnsBidLabel3 = [UILabel labelWithFrame:CGRectMake(ScreenWidth / 2, CGRectGetMaxY(tarnsBidMarkLabel2.frame) + Vspace, ScreenWidth / 2 - 15, 15) text:@"" textColor:nil font:[UIFont systemFontOfSize:14]];
                tarnsBidLabel3.numberOfLines = 1;
                tarnsBidLabel3.tag = 0x1002;
                tarnsBidLabel3.textColor = [Color color:PGColorOptionTitleBlack];
                tarnsBidLabel3.textAlignment = NSTextAlignmentRight;
                [cell.contentView addSubview:tarnsBidLabel3];
                
                UILabel *tarnsBidMarkLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(tarnsBidMarkLabel3.frame) + Vspace, ScreenWidth / 2 - 15, 15)];
                tarnsBidMarkLabel4.text = @"起息日期";
                tarnsBidMarkLabel4.textColor = [Color color:PGColorOptionTitleBlack];
                tarnsBidMarkLabel4.font = [Color gc_Font:14];
                [cell addSubview:tarnsBidMarkLabel4];
                
                UILabel *tarnsBidLabel4 = [UILabel labelWithFrame:CGRectMake(ScreenWidth / 2,  CGRectGetMaxY(tarnsBidMarkLabel3.frame) + Vspace, ScreenWidth / 2 - 15, 15) text:@"" textColor:nil font:[UIFont systemFontOfSize:14]];
                tarnsBidLabel4.textAlignment = NSTextAlignmentRight;
                tarnsBidLabel4.tag = 0x1003;
                tarnsBidLabel4.textColor = [Color color:PGColorOptionTitleBlack];
                [cell.contentView addSubview:tarnsBidLabel4];
            }
            
            UILabel *tarnsBidLabel1 = (UILabel*)[cell.contentView viewWithTag:0x1000];
            UILabel *tarnsBidLabel2 = (UILabel*)[cell.contentView viewWithTag:0x1001];
            UILabel *tarnsBidLabel3 = (UILabel*)[cell.contentView viewWithTag:0x1002];
            UILabel *tarnsBidLabel4 = (UILabel*)[cell.contentView viewWithTag:0x1003];
            
            
//            NSMutableAttributedString *str1 = [SharedSingleton getAcolorfulStringWithText1:@"预期年化利率：" Color1:UIColorWithRGB(0x999999) Text2:[NSString stringWithFormat:@"%@%%", self.investDetailModel.oldPrdClaimAnnualRate] Color2:UIColorWithRGB(0x555555) AllText:[NSString stringWithFormat:@"预期年化利率：%@%%", self.investDetailModel.oldPrdClaimAnnualRate]];
            tarnsBidLabel1.text = [NSString stringWithFormat:@"%@%%", self.investDetailModel.oldPrdClaimAnnualRate];
            
//            NSMutableAttributedString *str2 = [SharedSingleton getAcolorfulStringWithText1:@"原标期限：" Color1:UIColorWithRGB(0x999999) Text2:[NSString stringWithFormat:@"%@", self.investDetailModel.oldPrdClaimRepayPeriod] Color2:UIColorWithRGB(0x555555) AllText:[NSString stringWithFormat:@"原标期限：%@", self.investDetailModel.oldPrdClaimRepayPeriod]];
            tarnsBidLabel2.text = [NSString stringWithFormat:@"%@", self.investDetailModel.oldPrdClaimRepayPeriod];
            
//            NSMutableAttributedString *str3 = [SharedSingleton getAcolorfulStringWithText1:@"还款方式：" Color1:UIColorWithRGB(0x999999) Text2:[NSString stringWithFormat:@"%@", self.investDetailModel.oldPrdClaimRepayModeText] Color2:UIColorWithRGB(0x555555) AllText:[NSString stringWithFormat:@"还款方式：%@", self.investDetailModel.oldPrdClaimRepayModeText]];
            tarnsBidLabel3.text = [NSString stringWithFormat:@"%@", self.investDetailModel.oldPrdClaimRepayModeText];
            
//            NSMutableAttributedString *str4 = [SharedSingleton getAcolorfulStringWithText1:@"起息日期：" Color1:UIColorWithRGB(0x999999) Text2:[NSString stringWithFormat:@"%@", self.investDetailModel.oldPrdClaimAnnualRate] Color2:UIColorWithRGB(0x555555) AllText:[NSString stringWithFormat:@"起息日期：%@", self.investDetailModel.oldPrdClaimEffactiveDate]];
            tarnsBidLabel4.text = [NSString stringWithFormat:@"%@", self.investDetailModel.oldPrdClaimEffactiveDate];
            
            return cell;
        } else {
            NSString *cellindifier = @"fourSectionCell";
            UITableViewCell *cell = nil;
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellindifier];
                UILabel *dateLabel = [UILabel labelWithFrame:CGRectZero text:@"" textColor:[Color color:PGColorOptionTitleBlack] font:[UIFont systemFontOfSize:12]];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                dateLabel.textAlignment = NSTextAlignmentLeft;
                dateLabel.numberOfLines = 1;
                dateLabel.tag = 1003;
                [cell.contentView addSubview:dateLabel];
                
                UILabel *styleLabel = [UILabel labelWithFrame:CGRectZero text:@"" textColor:[Color color:PGColorOptionTitleBlack] font:[UIFont boldSystemFontOfSize:12]];
                styleLabel.textAlignment = NSTextAlignmentCenter;
                styleLabel.tag = 1004;
                [cell.contentView addSubview:styleLabel];
                
                UILabel *amoutLabel = [UILabel labelWithFrame:CGRectZero text:@"" textColor:[Color color:PGColorOptionTitleBlack] font:[UIFont boldSystemFontOfSize:12]];
                amoutLabel.textAlignment = NSTextAlignmentRight;
                amoutLabel.tag = 1005;
                amoutLabel.numberOfLines = 1;
                [cell.contentView addSubview:amoutLabel];
                
                UILabel *stateLabel = [UILabel labelWithFrame:CGRectZero text:@"" textColor:[Color color:PGColorOptionTitleBlack] font:[UIFont boldSystemFontOfSize:12]];
                stateLabel.textAlignment = NSTextAlignmentRight;
                stateLabel.tag = 1006;
                [cell.contentView addSubview:stateLabel];
                
                if ([indexPath row] == 0) {
                    dateLabel.frame = CGRectMake(15, 15, (ScreenWidth - 30)/4, 12);
                    styleLabel.frame = CGRectMake(CGRectGetMaxX(dateLabel.frame), 15, (ScreenWidth - 30)/4, 12);
                    amoutLabel.frame = CGRectMake(CGRectGetMaxX(styleLabel.frame), 15, (ScreenWidth - 30)/4, 12);
                    stateLabel.frame = CGRectMake(CGRectGetMaxX(amoutLabel.frame), 15, (ScreenWidth - 30)/4, 12);
                    dateLabel.font = [UIFont boldSystemFontOfSize:12];
                    styleLabel.font = [UIFont boldSystemFontOfSize:12];
                    amoutLabel.font = [UIFont boldSystemFontOfSize:12];
                    stateLabel.font = [UIFont boldSystemFontOfSize:12];
                } else {
                    dateLabel.frame = CGRectMake(15, 8, (ScreenWidth - 30)/4 + 10, 12);
                    styleLabel.frame = CGRectMake(CGRectGetMaxX(dateLabel.frame)-10, 8, (ScreenWidth - 30)/4, 12);
                    amoutLabel.frame = CGRectMake(CGRectGetMaxX(styleLabel.frame)-10, 8, (ScreenWidth - 30)/4+10, 12);
                    stateLabel.frame = CGRectMake(CGRectGetMaxX(amoutLabel.frame), 8, (ScreenWidth - 30)/4, 12);
                    dateLabel.font = [UIFont systemFontOfSize:12];
                    styleLabel.font = [UIFont systemFontOfSize:12];
                    amoutLabel.font = [UIFont systemFontOfSize:12];
                    stateLabel.font = [UIFont systemFontOfSize:12];
                }
            }
            UILabel *dateLabel = (UILabel*)[cell.contentView viewWithTag:1003];
            UILabel *styleLabel = (UILabel*)[cell.contentView viewWithTag:1004];
            UILabel *amoutLabel = (UILabel*)[cell.contentView viewWithTag:1005];
            UILabel *stateLabel = (UILabel*)[cell.contentView viewWithTag:1006];
            
            if ([indexPath row] == 0) {
                dateLabel.text = @"回款日期";
                styleLabel.text = @"类型";
                amoutLabel.text = @"金额";
                stateLabel.text = @"状态";
                
                stateLabel.textColor =  amoutLabel.textColor = styleLabel.textColor = dateLabel.textColor = [Color color:PGColorOptionInputDefaultBlackGray];
            } else {
                amoutLabel.textColor = styleLabel.textColor = dateLabel.textColor = [Color color:PGColorOptionTitleBlack];
                stateLabel.textColor = [Color color:PGColorOpttonRateNoramlTextColor];
                
                if (self.investDetailModel.refundSummarys.count > 0) {
                    UCFRefundDetailModel *refundDetai = self.investDetailModel.refundSummarys[indexPath.row - 1];
                    dateLabel.text = refundDetai.repayPerDate;
                    styleLabel.text = [refundDetai.type isEqualToString:@"1"] ? @"本金" : @"利息";
                    NSString *anmout = [UCFToolsMehod isNullOrNilWithString:[NSString stringWithFormat:@"%@", refundDetai.interest]];
                    anmout = [UCFToolsMehod dealmoneyFormart:anmout];
                    amoutLabel.text = [NSString stringWithFormat:@"¥%@", anmout];
                    if ([refundDetai.status isEqualToString:@"0"]) {
                        stateLabel.text = @"未回款";
                    }
                    else if ([refundDetai.status isEqualToString:@"1"] || [refundDetai.status isEqualToString:@"3"])
                    {
                        stateLabel.text = @"已回款";
                    }
                    else if ([refundDetai.status isEqualToString:@"2"])
                    {
                        stateLabel.text = @"转出";
                    }
                    else stateLabel.text = @"未定";
                    if (![stateLabel.text isEqualToString:@"已回款"]) {
                        stateLabel.textColor = [Color color:PGColorOpttonRateNoramlTextColor];
                    } else {
                        stateLabel.textColor = [Color color:PGColorOpttonRateNoramlTextColor];
                    }
                }
                else {
                    dateLabel.text = @"未起息，暂无回款计划";
                    dateLabel.frame = CGRectMake(30, 8, ScreenWidth - 30*2, 12);
                    dateLabel.textAlignment = NSTextAlignmentCenter;
                }
            }
            return cell;
        }
    }
    return reCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    if (indexPath.section != 3) {
        return;
    }
    UCFConstractModel *constract = self.investDetailModel.contractClauses[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(investmentDetailView:didSelectConstractDetailWithModel:)]) {
        [self.delegate investmentDetailView:self didSelectConstractDetailWithModel:constract];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _tableView)
    {
        CGFloat sectionHeaderHeight = 57;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

- (void)headBtnClicked:(id)sender
{
    NSString *uuid = _investDetailModel.prdNum;
    [[NSUserDefaults standardUserDefaults] setValue:_investDetailModel.status forKey:@"bidStatus"];
    [[NSUserDefaults standardUserDefaults] setValue:_investDetailModel.repayPeriod forKey:@"bidDate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [_delegate headBtnClicked:sender selectViewId:uuid state:_investDetailModel.status];
}

@end
