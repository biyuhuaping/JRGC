//
//  ModelTransition.h
//  GeneralProject
//
//  Created by kuangzhanzhidian on 2018/5/4.
//  Copyright © 2018年 kuangzhanzhidian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelTransition : NSObject

/**
 *  @author KZ, 17-09-11 19:09:32
 *
 *  把返回的数据转成对象
 *
 *  @param className 需要转换的类
 *  @param dataDic   请求的数据
 *
 *  @return 返回转换成功对象
 */
+ (id)TransitionModelClassName:(Class)className dataGenre:(NSDictionary* )dataDic;

@end
