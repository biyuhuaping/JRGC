//
//  DDLogDetailedMessage.m
//  GeneralProject
//
//  Created by kuangzhanzhidian on 2018/5/3.
//  Copyright © 2018年 kuangzhanzhidian. All rights reserved.
//

#import "DDLogDetailedMessage.h"

@implementation DDLogDetailedMessage
- (NSString *)formatLogMessage:(DDLogMessage *)logMessage
    
    {
        NSString *loglevel = nil;
        switch (logMessage.flag)
        {
            case DDLogFlagError:
            {
                loglevel = @"[ERROR]->❗️❗️❗️";
            }
            break;
            case DDLogFlagWarning:
            {
                loglevel = @"[WARN]-->⚠️";
            }
            break;
            case DDLogFlagInfo:
            {
                loglevel = @"[INFO]--->ℹ️";
            }
            break;
            case DDLogFlagDebug:
            {
                loglevel = @"[DEBUG]---->🔧";
            }
            break;
            case DDLogFlagVerbose:
            {
                loglevel = @"[VBOSE]----->🚩";
            }
            break;
            
            default:
            break;
        }
//        NSString *formatStr = [NSString stringWithFormat:@"%@ %@___line[%ld]\n{\n%@\n}", loglevel, logMessage->_function,logMessage->_line, logMessage->_message];
        
        
        
        return [NSString stringWithFormat:@"%@ %@(line:%zd)->\n%@: \n{\n%@\n}\n", loglevel, logMessage->_fileName, logMessage->_line, logMessage->_function, logMessage->_message];
    }
@end
