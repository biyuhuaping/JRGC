//
//  UCFSimpleNoticeTableViewCell.h
//  JRGC
//
//  Created by zrc on 2019/2/27.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "NoticeCenterModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UCFSimpleNoticeTableViewCell : BaseTableViewCell
-(void)setModel:(NoticeResult*)model isEndView:(BOOL)isEnd;
@end

NS_ASSUME_NONNULL_END
