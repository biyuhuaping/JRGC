//
//  NSData+UcfLib.h
//  UcfLib
//
//  Created by 杨名宇 on 29/11/2016.
//  Copyright © 2016 Ucf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (UcfLib)

@property (nonatomic, readonly) NSString *base64String;
@property (nonatomic, readonly) NSString *hexBytesString;

- (NSData *)dataWithRSAEncryption:(NSData *)certData;
- (NSData *)dataWithAES128Encryption:(NSString *)pwd;
- (NSData *)dataWithAES128Decryption:(NSString *)pwd;
- (NSData *)dataWithAES128EncryptionWithoutRound:(NSString *)pwd;
- (NSData *)dataWithAES128DecryptionWithoutRound:(NSString *)pwd;

@end
