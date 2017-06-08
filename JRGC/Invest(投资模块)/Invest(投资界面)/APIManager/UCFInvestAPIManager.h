//
//  UCFInvestAPIManager.h
//  JRGC
//
//  Created by njw on 2017/6/8.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UCFInvestAPIManager;
@protocol UCFInvestAPIWithMicroMoneyManagerDelegate <NSObject>

- (void)investApiManager:(UCFInvestAPIManager *)apiManager didSuccessedReturnMicroMoneyResult:(id)result withTag:(NSUInteger)tag;

@end

@interface UCFInvestAPIManager : NSObject
@property (weak, nonatomic) id<UCFInvestAPIWithMicroMoneyManagerDelegate> microMoneyDelegate;


- (void)getMicroMoneyFromNet;
@end
