//
//  DDLogDetailedMessage.h
//  GeneralProject
//
//  Created by kuangzhanzhidian on 2018/5/3.
//  Copyright © 2018年 kuangzhanzhidian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaLumberjack.h>
@interface DDLogDetailedMessage : NSObject<DDLogFormatter>
{
    // Direct accessors to be used only for performance
    @public
    NSString *_message;
    DDLogLevel _level;
    DDLogFlag _flag;
    NSUInteger _context;
    NSString *_file;
    NSString *_fileName;
    NSString *_function;
    NSUInteger _line;
    id _tag;
    DDLogMessageOptions _options;
    NSDate *_timestamp;
    NSString *_threadID;
    NSString *_threadName;
    NSString *_queueLabel;
}
@end
