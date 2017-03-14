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

#define SERVER_IP   @"https://app.9888.cn/"      //正式网
#define JPUSHKEY    @"d3fa655cc616a27b694fa9cb" //极光推送正式key
#define NEW_SERVER_IP   @"https://app.9888.cn/"

#else
// 老接口下的服务器IP
#define SERVER_IP   @"http://app.9888.cn/"              //TestA
//#define SERVER_IP   @"http://10.10.100.42:8080/mpapp/"  //测试网
//#define SERVER_IP   @"http://10.105.6.69:8080/mpapp/"   //薛林
//#define SERVER_IP   @"http://10.105.6.222:8090/mpappOld/"  //洪东
//#define SERVER_IP   @"http://10.105.6.219:8089/mpapp/"  //刘丹
//#define SERVER_IP   @"http://10.105.6.219:8087/mpapp/"  //刘丹

// 新接口下的服务器IP
#define NEW_SERVER_IP   @"http://app.9888.cn/"              //TestA
//#define NEW_SERVER_IP   @"http://10.105.6.222:8080/mpapp/"  //洪东
//#define NEW_SERVER_IP   @"http://10.105.6.203:8080/mpapp/"  //薛林
//#define NEW_SERVER_IP   @"http://10.105.6.219:8087/mpapp/"  //刘丹
//#define NEW_SERVER_IP   @"http://10.105.6.219:8087/mpapp/"  //刘丹


#define JPUSHKEY    @"0662ab9ab4f20736d8fe0df3"         //极光推送测试key
#endif



