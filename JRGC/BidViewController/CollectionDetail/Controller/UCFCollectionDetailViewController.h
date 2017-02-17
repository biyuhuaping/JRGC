//
//  UCFCollectionDetailViewController.h
//  JRGC
//
//  Created by hanqiyuan on 2017/2/15.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFBaseViewController.h"

@interface UCFCollectionDetailViewController : UCFBaseViewController

@property (nonatomic,strong) NSString *souceVC;//从哪个页面过来的
- (void)setProcessViewProcess:(CGFloat)process;
@end
