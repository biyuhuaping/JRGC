//
//  WalletBankView.h
//  JRGC
//
//  Created by 张瑞超 on 2017/5/15.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WalletBankView;
typedef void(^WalletBlock)(WalletBankView *blockContent);
@interface WalletBankView : UIView
@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet UIImageView *bankIcon;
@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property (weak, nonatomic) IBOutlet UILabel *bankType;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *bankNum;
@property (weak, nonatomic) IBOutlet UIImageView *quickLogo;
@property (weak, nonatomic) IBOutlet UIImageView *selectTipImageView;
@property (copy, nonatomic) WalletBlock block;
@end
