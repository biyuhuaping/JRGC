//
//  UCFCollctionKeyBidViewController.h
//  JRGC
//
//  Created by hanqiyuan on 2017/2/21.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFBaseViewController.h"

@interface UCFCollctionKeyBidViewController : UCFBaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic, assign)int              bidType;  //0 代表普通和权益 1代表债券转让
@property (nonatomic, strong)NSDictionary    *dataDict;
@property (nonatomic, strong)NSMutableArray  *bidArray;
@property (nonatomic, copy)NSString          *beanIds;

- (void)reloadMainView;
@end
