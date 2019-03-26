//
//  UCFHighQualityTableViewCell.h
//  JRGC
//
//  Created by zrc on 2019/3/25.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface UCFHighQualityTableViewCell : BaseTableViewCell
- (void)setDataDict:(NSDictionary *)dataDict isTrans:(BOOL)isTrans;
@end

NS_ASSUME_NONNULL_END
