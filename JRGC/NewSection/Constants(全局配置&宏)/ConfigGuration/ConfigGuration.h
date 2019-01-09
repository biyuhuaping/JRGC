//
//  ConfigGuration.h
//  GeneralProject
//
//  Created by kuangzhanzhidian on 2018/5/3.
//  Copyright © 2018年 kuangzhanzhidian. All rights reserved.
//

#ifndef ConfigGuration_h
#define ConfigGuration_h

//环境配置
#ifdef DEBUG //测试环境
static const int ddLogLevel = DDLogLevelVerbose;
//do sth.
#else
//do sth.
static const int ddLogLevel = DDLogLevelOff;

#endif



#endif /* ConfigGuration_h */



