//
//  UCFMineTableViewHead.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/2/15.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseView.h"
@class UCFMineMyReceiptModel;
@class UCFMineMySimpleInfoModel;

NS_ASSUME_NONNULL_BEGIN

typedef void(^tableHeadCallBack) (UIButton *btn);//1

@interface UCFMineTableViewHead : BaseView

@property (nonatomic,copy) tableHeadCallBack callBack;//2

- (void)showMyReceipt:(UCFMineMyReceiptModel *)myModel;

- (void)showMySimple:(UCFMineMySimpleInfoModel *)myModel;

@end

NS_ASSUME_NONNULL_END
