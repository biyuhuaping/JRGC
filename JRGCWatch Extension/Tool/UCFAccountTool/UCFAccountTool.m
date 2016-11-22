//
//  UCFAccountTool.m
//  Test01
//
//  Created by NJW on 16/10/20.
//  Copyright © 2016年 NJW. All rights reserved.
//

#import "UCFAccountTool.h"
#import "UCFAccount.h"
#import "UCFSession.h"
#define MBWKAccountFileName [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingString:@"/wkaccount.data"]
@implementation UCFAccountTool
static  UCFAccount *_account;

+ (void)saveAccount:(UCFAccount *)account{
    [NSKeyedArchiver archiveRootObject:account toFile:MBWKAccountFileName];
//    NSLog(@"========>%@",MBWKAccountFileName);
    NSString* fileContents =[NSString stringWithContentsOfFile:MBWKAccountFileName encoding:NSUTF8StringEncoding error:nil];
//    NSLog(@"file content is: %@", fileContents);
     [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadPersonData" object:nil];
    
}

+ (UCFAccount *)account{
    if (nil == _account) {
        _account = [NSKeyedUnarchiver unarchiveObjectWithFile:MBWKAccountFileName];
        
        if (_account==nil) {
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
