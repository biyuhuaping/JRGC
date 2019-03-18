//
//  UCFMineServiceCellView.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/18.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseView.h"
#import "NZLabel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UCFMineServiceCellView : BaseView

@property (nonatomic, strong) NZLabel     *serviceTitleLabel;//标题

@property (nonatomic, strong) NZLabel     *serviceContentLabel;//版本号

@property (nonatomic, strong) UIView *horizontalLineView;//水平分割线线

@end

NS_ASSUME_NONNULL_END
