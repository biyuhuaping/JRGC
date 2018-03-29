//
//  UCFAccountTool.m
//  Test01
//
//  Created by NJW on 16/10/20.
//  Copyright © 2016年 NJW. All rights reserved.
//

#import "UCFAccountTool.h"
#import "UCFAccount.h"

#define MBWKAccountFileName [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingString:@"/wkaccount.data"]

@interface UCFAccountTool ()

@end

@implementation UCFAccountTool
static  UCFAccount *_account;

+ (void)saveAccount:(UCFAccount *)account{
    [NSKeyedArchiver archiveRootObject:account toFile:MBWKAccountFileName];
    NSLog(@"========>%@",MBWKAccountFileName);
//    NSString* fileContents =[NSString stringWithContentsOfFile:MBWKAccountFileName encoding:NSUTF8StringEncoding error:nil];
    
    _account = [NSKeyedUnarchiver unarchiveObjectWithFile:MBWKAccountFileName];
    NSLog(@"file content is: %@", _account.userId);
}

+ (UCFAccount *)account{
    if (nil == _account) {
        _account = [NSKeyedUnarchiver unarchiveObjectWithFile:MBWKAccountFileName];
        
        if (_account.userId==nil || [_account.userId isEqualToString:@""]) {
            return nil;
        }
    }
    return _account;
}

+ (void)deleteAccout
{
    BOOL isDir = NO;
    isDir = [[NSFileManager defaultManager] fileExistsAtPath:MBWKAccountFileName isDirectory:nil];
    if (isDir) {
        [[NSFileManager defaultManager] removeItemAtPath:MBWKAccountFileName error:nil];
        _account = nil;
    }
    
}



@end
