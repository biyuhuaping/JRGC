//
//  UCFFactoryCodefaceController.m
//  Test01
//
//  Created by NJW on 2016/10/26.
//  Copyright © 2016年 NJW. All rights reserved.
//

#import "UCFFactoryCodefaceController.h"
#import "UCFTool.h"

@interface UCFFactoryCodefaceController ()
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceImage *factoryCodeImage;

@end

@implementation UCFFactoryCodefaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
    NSString *iOSPath = [[UCFTool getDocumentsPath] stringByAppendingPathComponent:@"factory.png"];
    NSData *data = [NSData dataWithContentsOfFile:iOSPath];
    [self.factoryCodeImage setImageData:data];
    
//   NSData *imageData  = [[NSUserDefaults standardUserDefaults] objectForKey:@"gcmCodeData"];
//    [self.factoryCodeImage setImageData:imageData];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



