//
//  UCFAssetProofApplyIdCell.h
//  JRGC
//
//  Created by hanqiyuan on 2017/12/1.
//  Copyright © 2017年 JRGC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UCFAssetProofApplyIdCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;

@property (strong, nonatomic) IBOutlet UITextField *userIdNumberTextField;
@end
@interface UCFAssetProofApplyCodeCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UITextField *messageCodeTextField;
@property (strong, nonatomic) IBOutlet UIButton *MessageCodeBtn;
@property (strong, nonatomic) IBOutlet UILabel *mobileNumberLabel;

@end
