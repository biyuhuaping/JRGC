//
//  UCFJYDownPDFAPi.h
//  JRGC
//
//  Created by 金融工场 on 2019/6/3.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UCFJYDownPDFAPi : BaseRequest

- (instancetype)initWithURL:(NSString *)URL andParam:(NSString *)paramURL;

@end

NS_ASSUME_NONNULL_END
