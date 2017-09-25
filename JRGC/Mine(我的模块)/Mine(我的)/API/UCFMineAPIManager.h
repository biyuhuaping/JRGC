//
//  UCFMineAPIManager.h
//  JRGC
//
//  Created by njw on 2017/9/22.
//  Copyright © 2017年 JRGC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UCFMineAPIManager;
@protocol UCFMineAPIManagerDelegate <NSObject>

- (void)mineApiManager:(UCFMineAPIManager *)apiManager didSuccessedReturnAssetResult:(id)result withTag:(NSUInteger)tag;


- (void)mineApiManager:(UCFMineAPIManager *)apiManager didSuccessedReturnBenefitResult:(id)result withTag:(NSUInteger)tag;
- (void)mineApiManager:(UCFMineAPIManager *)apiManager didSuccessedCashAccoutBalanceResult:(id)result withTag:(NSUInteger)tag;
- (void)mineApiManager:(UCFMineAPIManager *)apiManager didSuccessedRechargeBindingBankCardResult:(id)result withTag:(NSUInteger)tag;
@end

@interface UCFMineAPIManager : NSObject
@property (weak, nonatomic) id<UCFMineAPIManagerDelegate> delegate;

- (void)getAssetFromNet;
- (void)getBenefitFromNet;
- (void)getCashAccoutBalanceNet;
- (void)getRecharngeBindingBankCardNet;
@end
