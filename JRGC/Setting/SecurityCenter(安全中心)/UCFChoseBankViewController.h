//
//  UCFChoseBankViewController.h
//  JRGC
//  qinyangyue
//  Created by 秦 on 16/8/19.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFBaseViewController.h"
@protocol UCFChoseBankViewControllerDelegate <NSObject>
//***将银行名称和行号以字典_dicBranchBank传回
-(void)chosenBranchBank:(NSDictionary*)_dicBranchBank;

@end

@interface UCFChoseBankViewController : UCFBaseViewController
@property(nonatomic, assign)id<UCFChoseBankViewControllerDelegate> delegate;
@property(nonatomic, strong) NSString *bankName; //***hqy添加 
@end
