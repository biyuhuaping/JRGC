//
//  UCFMineIntoCoinPageApi.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/1/18.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UCFMineIntoCoinPageApi : BaseRequest

- (id)initWithPageType:(NSString *)vip; //传@"vip"进入vip页面,不传vip正常进入工贝页面

@end


NS_ASSUME_NONNULL_END
