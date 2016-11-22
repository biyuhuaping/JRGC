//
//  UCFBindBankCardNormalTableViewCell.m
//  JRGC
//
//  Created by NJW on 15/5/11.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFBindBankCardNormalTableViewCell.h"

@implementation UCFBindBankCardNormalTableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableview andIndex:(NSIndexPath *)indexPath
{
    static NSString *ID = @"bindcardnormal";
    UCFBindBankCardNormalTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UCFBindBankCardNormalTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.textColor = UIColorWithRGB(0x555555);
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    cell.detailTextLabel.textColor = UIColorWithRGB(0x999999);
    switch (indexPath.row) {
            
        case 1: {
            cell.textLabel.text = @"银行";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.text = @"请选择";
        }
            break;
        case 2: {
            cell.textLabel.text = @"开户省份";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.text = @"请选择";
        }
            break;
            
        case 3: {
            cell.textLabel.text = @"城市";
        }
            break;
        case 4: {
            cell.textLabel.text = @"区域";
        }
            break;
    }
  
    return cell;
}

@end
