//
//   EnvironmentalFile.h
//  JRGC
//
//  Created by 金融工场 on 16/8/4.
//  Copyright © 2016年 qinwei. All rights reserved.
//


#define EnvironmentConfiguration  1// 0测试 1正式 2灰度测试

#define AES_TESTKEY @"awejfij124321aweg@##$!*&+=-13123j24325"
#define QDCODE      @""

#if EnvironmentConfiguration == 1

#define SERVER_IP       @"https://app.9888.cn/"      //正式网
#define P2P_SERVER_IP   @"https://app.9888.cn/"
#define NEW_SERVER_IP   @"https://app.9888.cn/"
#define ZX_SERVER_IP    @"https://app.9888.cn/mpappZX/"  // 尊享地址链接

#define JPUSHKEY    @"d3fa655cc616a27b694fa9cb" //极光推送正式key

#else
// 老接口下的服务器IP
//#define SERVER_IP   @"http://app.9888.cn/"              //TestA
//#define P2P_SERVER_IP   @"https://app.9888.cn/"
//#define ZX_SERVER_IP    @"https://app.9888.cn/mpappZX/"  // 尊享地址链接




#define JPUSHKEY    @"0662ab9ab4f20736d8fe0df3"         //极光推送测试key
#endif



