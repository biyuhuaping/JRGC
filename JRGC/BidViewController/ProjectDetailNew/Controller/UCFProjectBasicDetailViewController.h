//
//  UCFProjectBasicDetailViewController.h
//  JRGC
//
//  Created by hanqiyuan on 2017/12/5.
//  Copyright © 2017年 JRGC. All rights reserved.
//

#import "UCFBaseViewController.h"

@interface UCFProjectBasicDetailViewController : UCFBaseViewController
@property (nonatomic,strong)NSDictionary *dataDic;
@property(nonatomic,assign) PROJECTDETAILTYPE detailType;
@property (strong ,nonatomic)  NSString *projectId;//标Id
@property (assign ,nonatomic)  BOOL prdDesType;//新老项目标识
@property (strong ,nonatomic) NSString *tradeMark;//标产品标识
@end
