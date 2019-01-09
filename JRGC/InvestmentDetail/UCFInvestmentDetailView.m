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
    if (kIS_IOS7) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }else{
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
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
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
        footerView.backgroundColor = UIColorWithRGB(0xebebee);
        
        UILabel *titleLabel = [UILabel labelWithFrame:CGRectZero text:@"等级加息奖励将在起息后以工豆形式发放，灵活期限标起息后只发放锁定期内工豆，其余将在回款时发放。" textColor:UIColorWithRGB(0x999999) font:[UIFont systemFontOfSize:11]];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.tag = 1001;
        titleLabel.numberOfLines = 0;
        [footerView addSubview:titleLabel];
        titleLabel.frame = CGRectMake(15, 7, ScreenWidth - 30, 30);
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
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
         //未获得等级加息时的判断条件
        if (!self.investDetailModel.gradeIncreases || [[UCFToolsMehod isNullOrNilWithString:self.investDetailModel.gradeIncreases] isEqualToString:@""] || [self.investDetailModel.gradeIncreases doubleValue] == 0.0) {
            return 0;
        } else {
            return 44;
        }
    }if (section == 0) {
        
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
    return 0;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 54)];
        headView.backgroundColor = UIColorWithRGB(0xebebee);
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 44)];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 12, ScreenWidth/2,20)];
        labelTitle.text = self.investDetailModel.prdName;
        labelTitle.textColor = UIColorWithRGB(0x333333);
        labelTitle.backgroundColor = [UIColor clearColor];
        labelTitle.font = [UIFont systemFontOfSize:14];
        [view addSubview:labelTitle];
        
        UIButton *headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [headBtn addTarget:self action:@selector(headBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        headBtn.frame = CGRectMake(0, 10, ScreenWidth, 44);
        [view addSubview:headBtn];
        
        UILabel *titleStateLabel = [UILabel labelWithFrame:CGRectMake(ScreenWidth - 100, (44 - 12) / 2, 70, 12) text:@"" textColor:UIColorWithRGB(0x999999) font:[UIFont systemFontOfSize:12]];
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
        titleStateLabel.font = [UIFont systemFontOfSize:12];
        [view addSubview:titleStateLabel];
        
//        if ([titleStateLabel.text isEqualToString:@"招标中"]) {
//            titleStateLabel.textColor = UIColorWithRGB(0xfd4d4c);
//        } else if ([titleStateLabel.text isEqualToString:@"待回款"]) {
//            titleStateLabel.textColor = UIColorWithRGB(0x4aa1f9);
//        } else {
//            titleStateLabel.textColor = UIColorWithRGB(0x999999);
//        }
        
        [headView addSubview:view];
        
        UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 22, 15, 8, 13)];
        arrowView.image = [UIImage imageNamed:@"list_icon_arrow.png"];
        [view addSubview:arrowView];
        
        [self viewAddLine:view Up:YES withColor:UIColorWithRGB(0xd8d8d8)];
        [self viewAddLine:headView Up:NO withColor:UIColorWithRGB(0xeff0f3)];
        return headView;
    } if(section == 1) {
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
    } else if (section == 2) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 48)];
        headView.backgroundColor = UIColorWithRGB(0xebebee);
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 38)];
        view.backgroundColor = UIColorWithRGB(0xf7f7f7);
        UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 9, ScreenWidth/2,20)];
//        labelTitle.text = @"加息奖励";
        labelTitle.text = @"vip专享";
        labelTitle.textColor = UIColorWithRGB(0x333333);
        labelTitle.backgroundColor = [UIColor clearColor];
        labelTitle.font = [UIFont systemFontOfSize:14];
        [view addSubview:labelTitle];
        [headView addSubview:view];
        
        [self viewAddLine:view Up:YES withColor:UIColorWithRGB(0xd8d8d8)];
        [self viewAddLine:headView Up:YES withColor:UIColorWithRGB(0xd8d8d8)];
        [self viewAddLine:headView Up:NO withColor:UIColorWithRGB(0xeff0f3)];
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
                headviewHeight = 48;
                viewYPos = 10;
            }
             //未获得等级加息时的判断条件
            if (!self.investDetailModel.gradeIncreases || [[UCFToolsMehod isNullOrNilWithString:self.investDetailModel.gradeIncreases] isEqualToString:@""] || [self.investDetailModel.gradeIncreases doubleValue] == 0.0) {
                headviewHeight = 48;
                viewYPos = 10;
            }
            UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, headviewHeight)];
            headView.backgroundColor = UIColorWithRGB(0xebebee);
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, viewYPos, ScreenWidth, 38)];
            view.backgroundColor = UIColorWithRGB(0xf7f7f7);
            UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 11, ScreenWidth/2, 16)];
            labelTitle.text = @"回款明细";
            labelTitle.textColor = UIColorWithRGB(0x333333);
            labelTitle.backgroundColor = [UIColor clearColor];
            labelTitle.font = [UIFont systemFontOfSize:14];
            [view addSubview:labelTitle];
            [headView addSubview:view];
            
            
            UILabel *Label = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 15 - 100, 12, 100, 14)];
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
            
            
            [self viewAddLine:view Up:YES withColor:UIColorWithRGB(0xd8d8d8)];
            [self viewAddLine:headView Up:YES withColor:UIColorWithRGB(0xd8d8d8)];
            [self viewAddLine:headView Up:NO withColor:UIColorWithRGB(0xeff0f3)];
            return headView;
        } else {
            CGFloat headviewHeight;
            CGFloat viewYPos;
            if (self.investDetailModel.contractClauses.count == 0) {
                headviewHeight = 38;
                viewYPos = 0;
            } else {
                headviewHeight = 48;
                viewYPos = 10;
            }
            UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, headviewHeight)];
            headView.backgroundColor = UIColorWithRGB(0xebebee);
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, viewYPos, ScreenWidth, 38)];
            view.backgroundColor = UIColorWithRGB(0xf7f7f7);
            UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 12, 60, 14)];
            labelTitle.text = @"原标信息";
            labelTitle.textColor = UIColorWithRGB(0x333333);
            labelTitle.backgroundColor = [UIColor clearColor];
            labelTitle.font = [UIFont systemFontOfSize:14];
            [view addSubview:labelTitle];
            [headView addSubview:view];
            
            UILabel *detalLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labelTitle.frame), 14, 250, 10)];
            detalLabel.text = @"（购买的项目，按原标路径回款，详见回款明细）";
            detalLabel.textColor = UIColorWithRGB(0x999999);
            detalLabel.backgroundColor = [UIColor clearColor];
            detalLabel.textAlignment = NSTextAlignmentLeft;
            detalLabel.numberOfLines = 1;
            detalLabel.font = [UIFont systemFontOfSize:10];
            [view addSubview:detalLabel];
            
            [self viewAddLine:view Up:YES withColor:UIColorWithRGB(0xd8d8d8)];
            [self viewAddLine:headView Up:YES withColor:UIColorWithRGB(0xd8d8d8)];
            [self viewAddLine:headView Up:NO withColor:UIColorWithRGB(0xeff0f3)];
            return headView;
        }
       
    } else if (section == 5) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 48)];
        headView.backgroundColor = UIColorWithRGB(0xebebee);
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 38)];
        view.backgroundColor = UIColorWithRGB(0xf7f7f7);
        UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 11, ScreenWidth/2, 16)];
        labelTitle.text = @"回款明细";
        labelTitle.textColor = UIColorWithRGB(0x333333);
        labelTitle.backgroundColor = [UIColor clearColor];
        labelTitle.font = [UIFont systemFontOfSize:14];
        [view addSubview:labelTitle];
        [headView addSubview:view];
        
        
        UILabel *Label = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 15 - 100, 12, 100, 14)];
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
        
        
        [self viewAddLine:view Up:YES withColor:UIColorWithRGB(0xd8d8d8)];
        [self viewAddLine:headView Up:YES withColor:UIColorWithRGB(0xd8d8d8)];
        [self viewAddLine:headView Up:NO withColor:UIColorWithRGB(0xeff0f3)];
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
        //未获得等级加息时的判断条件
        if (!self.investDetailModel.gradeIncreases || [[UCFToolsMehod isNullOrNilWithString:self.investDetailModel.gradeIncreases] isEqualToString:@""] || [self.investDetailModel.gradeIncreases doubleValue] == 0.0) {
            if (self.investDetailModel.contractClauses.count == 0) {
                return 0;
            }
            return 10;
        }
        return 0;
    } else if (section == 0) {
        return 54;
    } else if (section == 4) {
        if (self.investDetailModel.contractClauses.count == 0) {
            return 38;
        }
        return 48;
    } else if (section == 2) {
         //未获得等级加息时的判断条件
        NSLog(@"%@",self.investDetailModel.gradeIncreases);
        if (!self.investDetailModel.gradeIncreases || [[UCFToolsMehod isNullOrNilWithString:self.investDetailModel.gradeIncreases] isEqualToString:@""] || [self.investDetailModel.gradeIncreases doubleValue] == 0.0) {
            return 0;
        }
        return 48;
    }else if(section == 1){
        if ([_detailType  intValue ] == 1) {
            if ([self.investDetailModel.interestMode isEqualToString:@""] || self.investDetailModel.interestMode == nil) {
                return 48;
            } else {
                return 38;
            }
            
        }else{
            if ([self.investDetailModel.buyCueDes isEqualToString:@""] || self.investDetailModel.buyCueDes == nil) {
                return 48;
            } else {
                return 38;
            }
        }
    }
    return 48;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_detailType isEqualToString:@"1"]) {
        if([indexPath section] == 3)
        {
            return 44;
        } else if([indexPath section] == 1 || [indexPath section] == 2) {
            if ([indexPath row] == 0 || [indexPath row] == 2) {
                return 27 + 7;
            } else {
                return 27;
            }
        } else if([indexPath section] == 4) {
            if ([indexPath row] == 0 || [indexPath row] == self.investDetailModel.refundSummarys.count) {
                return 27 + 8;
            } else {
                if (self.investDetailModel.refundSummarys.count == 0) {
                    return 27 + 8;
                }
                return 27;
            }
        } else {
            //已回款状态增加实际回款日
            if ([self.investDetailModel.status integerValue] == 6) {
                return 102;
            }
            return 82;
        }
    } else {
        if([indexPath section] == 3)
        {
            return 44;
        } else if([indexPath section] == 1 || [indexPath section] == 2) {
            if ([indexPath row] == 0 || [indexPath row] == 2) {
                return 27 + 7;
            } else {
                return 27;
            }
        } else if ([indexPath section] == 4) {
            return 61;
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
            return 82;
        }
    }
   
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_detailType isEqualToString:@"1"]) {
        if(section == 1) {
            return 3;
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
            return 3;
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
        InvestmentDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellindifier];
        if (!cell) {
            cell = [[InvestmentDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellindifier];
            cell.backgroundColor = UIColorWithRGB(0xf7f7f7);
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
        NSString *cellindifier = @"oneSectionCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellindifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellindifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *titleLabel = [UILabel labelWithFrame:CGRectZero text:@"" textColor:UIColorWithRGB(0x999999) font:[UIFont systemFontOfSize:12]];
            titleLabel.textAlignment = NSTextAlignmentLeft;
            titleLabel.tag = 1001;
            [cell.contentView addSubview:titleLabel];
            
            UILabel *amountLabel = [UILabel labelWithFrame:CGRectMake(ScreenWidth / 2 + 14, 15, ScreenWidth / 2 - 29, 12) text:@"" textColor:UIColorWithRGB(0x555555) font:[UIFont boldSystemFontOfSize:12]];
            amountLabel.textAlignment = NSTextAlignmentRight;
            amountLabel.tag = 1002;
            amountLabel.numberOfLines = 1;
            [cell.contentView addSubview:amountLabel];
            if ([indexPath row] == 0) {
                titleLabel.frame = CGRectMake(15, 15, ScreenWidth / 2, 12);
                amountLabel.frame = CGRectMake(ScreenWidth / 2 + 14, 15, ScreenWidth / 2 - 29, 12);
            } else {
                titleLabel.frame = CGRectMake(15, 8, ScreenWidth / 2, 12);
                amountLabel.frame = CGRectMake(ScreenWidth / 2 + 14, 8, ScreenWidth / 2 - 29, 12);
            }
        }
        UILabel *titleLabel = (UILabel*)[cell.contentView viewWithTag:1001];
        UILabel *amountLabel = (UILabel*)[cell.contentView viewWithTag:1002];

        NSArray *titleArr = @[@"应收本金",@"应收利息",@"应收违约金"];
        NSArray *amountArr = @[@(self.investDetailModel.awaitPrincipal.floatValue + self.investDetailModel.refundPrincipal.floatValue),@(self.investDetailModel.awaitInterest.floatValue + self.investDetailModel.refundInterest.floatValue),@(self.investDetailModel.refundPrepaymentPenalty.floatValue)];
        titleLabel.text = [titleArr objectAtIndex:[indexPath row]];
        NSString *anmout = [NSString stringWithFormat:@"%.2f",[[amountArr objectAtIndex:[indexPath row]] floatValue]];
        anmout = [UCFToolsMehod dealmoneyFormart:anmout];
        amountLabel.text = [NSString stringWithFormat:@"¥%@",anmout];
        return cell;
    } else if ([indexPath section] == 2) {//***************加息奖励***********************//
        NSString *cellindifier = @"twoSectionCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellindifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellindifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *titleLabel = [UILabel labelWithFrame:CGRectZero text:@"" textColor:UIColorWithRGB(0x999999) font:[UIFont systemFontOfSize:12]];
            titleLabel.textAlignment = NSTextAlignmentLeft;
            titleLabel.tag = 1001;
            titleLabel.numberOfLines = 0;
            [cell.contentView addSubview:titleLabel];
            
            UILabel *amountLabel = [UILabel labelWithFrame:CGRectMake(ScreenWidth / 2 + 14, 15, ScreenWidth / 2 - 29, 12) text:@"" textColor:UIColorWithRGB(0x555555) font:[UIFont boldSystemFontOfSize:12]];
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
        
//        NSArray *titleArr = @[@"年化加息奖励",@"返还工豆"];
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
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            cell.textLabel.textColor = UIColorWithRGB(0x555555);
            UILabel *acessoryLabel = [UILabel labelWithFrame:CGRectMake(ScreenWidth - 100, (cell.contentView.frame.size.height - 12) / 2, 70, 12) text:@"" textColor:UIColorWithRGB(0x999999) font:[UIFont systemFontOfSize:12]];
            acessoryLabel.tag = 100;
            acessoryLabel.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:acessoryLabel];
        }
        UILabel *acessoryLabel = (UILabel*)[cell.contentView viewWithTag:100];
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
                
                UILabel *tarnsBidLabel1 = [UILabel labelWithFrame:CGRectMake(15, 15, ScreenWidth / 2, 12) text:@"" textColor:nil font:[UIFont systemFontOfSize:12]];
                tarnsBidLabel1.textAlignment = NSTextAlignmentLeft;
                tarnsBidLabel1.numberOfLines = 1;
                tarnsBidLabel1.tag = 0x1000;
                [cell.contentView addSubview:tarnsBidLabel1];
                
                UILabel *tarnsBidLabel2 = [UILabel labelWithFrame:CGRectMake(ScreenWidth / 2 + 15, 15, ScreenWidth / 2 - 15, 12) text:@"" textColor:nil font:[UIFont systemFontOfSize:12]];
                tarnsBidLabel2.textAlignment = NSTextAlignmentLeft;
                tarnsBidLabel2.tag = 0x1001;
                [cell.contentView addSubview:tarnsBidLabel2];
                
                UILabel *tarnsBidLabel3 = [UILabel labelWithFrame:CGRectMake(15,CGRectGetMaxY(tarnsBidLabel1.frame) + 8, ScreenWidth / 2, 12) text:@"" textColor:nil font:[UIFont systemFontOfSize:12]];
                tarnsBidLabel3.numberOfLines = 1;
                tarnsBidLabel3.tag = 0x1002;
                tarnsBidLabel3.textAlignment = NSTextAlignmentLeft;
                [cell.contentView addSubview:tarnsBidLabel3];
                
                UILabel *tarnsBidLabel4 = [UILabel labelWithFrame:CGRectMake(ScreenWidth / 2 + 15, CGRectGetMaxY(tarnsBidLabel1.frame) + 8, ScreenWidth / 2 - 15, 12) text:@"" textColor:nil font:[UIFont systemFontOfSize:12]];
                tarnsBidLabel4.textAlignment = NSTextAlignmentLeft;
                tarnsBidLabel4.tag = 0x1003;
                [cell.contentView addSubview:tarnsBidLabel4];
            }
            UILabel *tarnsBidLabel1 = (UILabel*)[cell.contentView viewWithTag:0x1000];
            UILabel *tarnsBidLabel2 = (UILabel*)[cell.contentView viewWithTag:0x1001];
            UILabel *tarnsBidLabel3 = (UILabel*)[cell.contentView viewWithTag:0x1002];
            UILabel *tarnsBidLabel4 = (UILabel*)[cell.contentView viewWithTag:0x1003];
            NSMutableAttributedString *str1 = [SharedSingleton getAcolorfulStringWithText1:@"预期年化利率：" Color1:UIColorWithRGB(0x999999) Text2:[NSString stringWithFormat:@"%@%%", self.investDetailModel.oldPrdClaimAnnualRate] Color2:UIColorWithRGB(0x555555) AllText:[NSString stringWithFormat:@"预期年化利率：%@%%", self.investDetailModel.oldPrdClaimAnnualRate]];
            tarnsBidLabel1.attributedText = str1;
            
            NSMutableAttributedString *str2 = [SharedSingleton getAcolorfulStringWithText1:@"原标期限：" Color1:UIColorWithRGB(0x999999) Text2:[NSString stringWithFormat:@"%@", self.investDetailModel.oldPrdClaimRepayPeriod] Color2:UIColorWithRGB(0x555555) AllText:[NSString stringWithFormat:@"原标期限：%@", self.investDetailModel.oldPrdClaimRepayPeriod]];
            tarnsBidLabel2.attributedText = str2;
            
            NSMutableAttributedString *str3 = [SharedSingleton getAcolorfulStringWithText1:@"还款方式：" Color1:UIColorWithRGB(0x999999) Text2:[NSString stringWithFormat:@"%@", self.investDetailModel.oldPrdClaimRepayModeText] Color2:UIColorWithRGB(0x555555) AllText:[NSString stringWithFormat:@"还款方式：%@", self.investDetailModel.oldPrdClaimRepayModeText]];
            tarnsBidLabel3.attributedText = str3;
            
            NSMutableAttributedString *str4 = [SharedSingleton getAcolorfulStringWithText1:@"起息日期：" Color1:UIColorWithRGB(0x999999) Text2:[NSString stringWithFormat:@"%@", self.investDetailModel.oldPrdClaimAnnualRate] Color2:UIColorWithRGB(0x555555) AllText:[NSString stringWithFormat:@"起息日期：%@", self.investDetailModel.oldPrdClaimEffactiveDate]];
            tarnsBidLabel4.attributedText = str4;
            
            return cell;
        } else {
            NSString *cellindifier = @"fourSectionCell";
            UITableViewCell *cell = nil;
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellindifier];
                UILabel *dateLabel = [UILabel labelWithFrame:CGRectZero text:@"" textColor:UIColorWithRGB(0x555555) font:[UIFont systemFontOfSize:12]];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                dateLabel.textAlignment = NSTextAlignmentLeft;
                dateLabel.numberOfLines = 1;
                dateLabel.tag = 1003;
                [cell.contentView addSubview:dateLabel];
                
                UILabel *styleLabel = [UILabel labelWithFrame:CGRectZero text:@"" textColor:UIColorWithRGB(0x555555) font:[UIFont boldSystemFontOfSize:12]];
                styleLabel.textAlignment = NSTextAlignmentCenter;
                styleLabel.tag = 1004;
                [cell.contentView addSubview:styleLabel];
                
                UILabel *amoutLabel = [UILabel labelWithFrame:CGRectZero text:@"" textColor:UIColorWithRGB(0x555555) font:[UIFont boldSystemFontOfSize:12]];
                amoutLabel.textAlignment = NSTextAlignmentRight;
                amoutLabel.tag = 1005;
                amoutLabel.numberOfLines = 1;
                [cell.contentView addSubview:amoutLabel];
                
                UILabel *stateLabel = [UILabel labelWithFrame:CGRectZero text:@"" textColor:UIColorWithRGB(0x555555) font:[UIFont boldSystemFontOfSize:12]];
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
            } else {
                if (self.investDetailModel.refundSummarys.count > 0) {
                    UCFRefundDetailModel *refundDetai = self.investDetailModel.refundSummarys[indexPath.row - 1];
                    dateLabel.text = refundDetai.repayPerDate;
                    styleLabel.text = [refundDetai.type isEqualToString:@"1"] ? @"本金" : @"利息";
                    NSString *anmout = [UCFToolsMehod isNullOrNilWithString:[NSString stringWithFormat:@"%@", refundDetai.interest]];
                    anmout = [UCFToolsMehod dealmoneyFormart:anmout];
                    amoutLabel.text = [NSString stringWithFormat:@"¥%@", anmout];
                    if ([refundDetai.status isEqualToString:@"0"]) {
                        stateLabel.text = @"未回";
                    }
                    else if ([refundDetai.status isEqualToString:@"1"] || [refundDetai.status isEqualToString:@"3"])
                    {
                        stateLabel.text = @"已回";
                    }
                    else if ([refundDetai.status isEqualToString:@"2"])
                    {
                        stateLabel.text = @"转出";
                    }
                    else stateLabel.text = @"未定";
                    if (![stateLabel.text isEqualToString:@"已回"]) {
                        stateLabel.textColor = UIColorWithRGB(0xfd4d4c);
                    } else {
                        stateLabel.textColor = UIColorWithRGB(0x555555);
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
