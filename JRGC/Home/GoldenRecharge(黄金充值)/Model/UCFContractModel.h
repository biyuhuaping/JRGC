//
//  UCFContractModel.h
//  JRGC
//
//  Created by njw on 2017/7/21.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCFContractModel : NSObject
@property (copy, nonatomic) NSString *Id;
@property (copy, nonatomic) NSString *contractContent;
@property (copy, nonatomic) NSString *contractName;
@property (copy, nonatomic) NSString *icoUrl;
@property (copy, nonatomic) NSString *cfcaContractName;
@property (copy, nonatomic) NSString *cfcaContractUrl;
@end
