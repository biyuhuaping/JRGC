//
//  UCFAssetProofListModel.h
//  JRGC
//
//  Created by hanqiyuan on 2017/12/4.
//  Copyright © 2017年 JRGC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCFAssetProofListModel : NSObject
/*
 applyNo    申请单号    string    @mock=$order('ZCZM201711301047550179Q6fg3mA1','ZCZM201711301046450312MLPB4MZ5')
 applyStatus    申请状态：0:申请中 1:申请成功 2:申请失败    string    @mock=$order('SUCCESS','SUCCESS')
 applyTime    申请时间    number    @mock=$order(1511923518000,1511923449000)
 issueTime    开具时间    number    @mock=$order(1511923520000,1511923451000)
 proofFileName    文件名称    string    @mock=$order('/apps/nas_new/resources_zx/contactpdf/assertproof/6206_7329976.pdf','/apps/nas_new/resources_zx/contactpdf/assertproof/6206_7329975.pdf')
 
 */
@property (copy, nonatomic) NSString *applyNo;//  申请单号
@property (copy, nonatomic) NSString *applyStatus;//申请状态：0:申请中 1:申请成功 2:申请失败
@property (copy, nonatomic) NSString *applyTime;//申请时间
@property (copy, nonatomic) NSString *issueTime;//   开具时间
@property (copy, nonatomic) NSString *proofFileName  ;// 文件名称 ;

+ (instancetype)assetProofListModelWithDict:(NSDictionary *)dict;
@end
