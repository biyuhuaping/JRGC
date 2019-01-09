//
//  UCFContractTypleModel.h
//  JRGC
//
//  Created by zrc on 2018/12/19.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UCFContractTypleModel : NSObject

/**
 // 1 代表普通html合同 2代表PDF合同 3代表html文件
 */
@property(nonatomic, copy)NSString      *type;
//合同地址
@property(nonatomic, copy)NSString       *url;
//pdf路径
@property(nonatomic, copy)NSString       *pdfPath;
//合同内容
@property(nonatomic, copy)NSString       *htmlContent;
//标题
@property(nonatomic, copy)NSString       *title;
@end

NS_ASSUME_NONNULL_END
