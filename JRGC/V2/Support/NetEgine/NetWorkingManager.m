//
//  NetWorking.m
//  AFNetWorking二次封装
//
//  Created by Jing  on 16/8/11.
//  Copyright © 2016年 Jing . All rights reserved.
//

#import "NetWorkingManager.h"
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AVFoundation/AVAssetExportSession.h>
//#import "UIImage+Compression.h"

/**
 * GET：获取资源，不会改动资源
 * POST：创建记录
 * PATCH：改变资源状态或更新部分属性
 * PUT：更新全部属性
 * DELETE：删除资源
 */
@implementation NetWorkingManager
/**
 *  单例
 *
 *  //@return 网络请求类的实例
 */
static NetWorkingManager * defualt_shareMananger = nil;

+ (instancetype)shareManager {
    
    static dispatch_once_t onceToken;
    _dispatch_once(&onceToken, ^{
        
        if (defualt_shareMananger == nil) {
            defualt_shareMananger = [[self alloc] initWithBaseURL:nil];
            defualt_shareMananger.requestSerializer.timeoutInterval = 30;
            
            defualt_shareMananger.requestSerializer = [AFHTTPRequestSerializer serializer];
            defualt_shareMananger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
            
            
        }
    });
    return defualt_shareMananger;
}

#pragma mark 重写


#pragma mark - GET 请求网络数据
/**
 *  请求网络数据
 *
 *  @param path             请求的地址
 *  @param paramters        请求的参数
 *  @param downLoadProgress 进度
 *  @param success          请求成功的回调
 *  @param failure          请求失败的回调
 */

+ (void)requestGETDataWithPath:(NSString *)path
                 withParamters:(NSDictionary *)paramters
                  withProgress:(void(^) (float progress))downLoadProgress
                       success:(void(^) (BOOL isSuccess, id responseObject))success
                       failure:(void(^) (NSError *error))failure  {
    
    [[NetWorkingManager shareManager] GET:path parameters:paramters progress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSLog(@"downLoadProcess = %@",downLoadProgress);
        if (downloadProgress) {

            downLoadProgress(downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"responseObject = %@",responseObject);
        if (success) {
            
            success(YES,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@",error);
        if (failure) {
            
            failure(error);
        }
    }];
    
}

#pragma mark - POST 传送网络数据

/**
 传送网络数据

 @param path 请求的地址
 @param paramters 请求的参数
 @param upLoadProgress 进度
 @param success1 请求成功的回调
 @param failure 请求失败的回调
 */
+ (void)sendPOSTDataWithPath:(NSString *)path
               withParamters:(NSDictionary *)paramters
                withProgress:(void(^) (float progress))upLoadProgress
                     success:(void(^) (BOOL isSuccess, id responseObject))success1
                     failure:(void(^) (NSError *error))failure {
    [[NetWorkingManager shareManager] POST:path parameters:paramters progress:^(NSProgress * _Nonnull uploadProgress) {
        if (upLoadProgress) {
            NSLog(@"downLoadProcess = %@",uploadProgress);
            if (uploadProgress) {
                upLoadProgress(uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
            }
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"responseObject = %@",responseObject);
        if (success1) {
            NSDictionary *dataDict = responseObject;
            NSInteger rstcode = [dataDict[@"code"] integerValue];
            if(rstcode == -1 || rstcode == -2 || rstcode == -3 || rstcode == -4 || rstcode == -6) {
//                [[GlobalMarkView sharedManager] switchToLogin:[NSString stringWithFormat:@"登录失效,请重新登录(%ld)",rstcode]];
//                [RCLoadHUD hideHUD];
            } else if (rstcode == -5) {
//                [RCLoadHUD hideHUD];
            } else {
                success1(YES,responseObject);
            }

        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@",error);
        if (failure) {
            
            failure(error);
        }
    }];
    NSLog(@"succee1 = %@",success1);
    
}

#pragma mark POST 上传图片
/**
 *  上传图片
 *
 *  @param path           上传的地址---需要填写完整的url
 *  @param paramters      上传图片预留参数---视具体情况而定，可移除
 *  @param imageArray     上传的图片数组
 *  @param width          图片要被压缩到的宽度
 *  @param upLoadProgress 进度
 *  @param success        请求成功的回调
 *  @param failure        请求失败的回调
 */
+ (void)sendPOSTImageWithPath:(NSString *)path
                withParamters:(NSDictionary *)paramters
               withImageArray:(NSArray *)imageArray
              withtargetWidth:(CGFloat )width
                 withProgress:(void(^) (float progress))upLoadProgress
                      success:(void(^) (BOOL isSuccess, id responseObject))success
                      failure:(void(^) (NSError *error))failure {
    
    
    [[NetWorkingManager shareManager] POST:path parameters:paramters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        // 上传图片时，为了用户体验或是考虑到性能需要进行压缩
//        for (UIImage * image in imageArray) {
//            // 压缩图片，指定宽度
////            UIImage * resizedImage =  [UIImage imageCompressed:image withdefineWidth:width];
//            NSData * imgData = UIImageJPEGRepresentation(image, 0.7);
//            // 拼接Data
//            if (imageArray.firstObject) {
//                [formData appendPartWithFileData:imgData name:@"selfie_file" fileName:@"selfie_file" mimeType:@"image/jpeg"];
//            } else {
//                [formData appendPartWithFileData:imgData name:@"watermark_picture_file" fileName:@"watermark_picture_file" mimeType:@"image/jpeg"];
//            }
//        }
        
        
//        NSData *fileData1 = UIImageJPEGRepresentation(self.iDCardImage, 0.6f);
//        NSString *name1 = @"selfie_file";
//        NSString *fileName1 = @"selfie_file";
//        NSDictionary *dict1 = [NSDictionary dictionaryWithObjectsAndKeys:fileData1,@"file",name1,@"name",fileName1,@"fileName", nil];
        
        for (NSDictionary *dict  in imageArray) {
                NSData *fileData = dict[@"file"];
                NSString *name = dict[@"name"];
                NSString *fileName = dict[@"fileName"];
                NSString *fileType = dict[@"fileType"];
                [formData appendPartWithFileData:fileData name:name fileName:fileName mimeType:fileType];
        }
//        UIImage *fileimg = imageArray.firstObject;
//        NSData *fileData = UIImageJPEGRepresentation(fileimg, 0.6f);
//
//        UIImage *waterImg = imageArray.lastObject;
//        NSData *waterData = UIImageJPEGRepresentation(waterImg, 0.6f);
//
//        [formData appendPartWithFileData:fileData name:@"selfie_file" fileName:@"selfie_file" mimeType:@"image/jpeg"];
//        [formData appendPartWithFileData:waterData name:@"watermark_picture_file" fileName:@"watermark_picture_file" mimeType:@"image/jpeg"];
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"downLoadProcess = %@",uploadProgress);
        if (uploadProgress) {
            
            upLoadProgress(uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"responseObject = %@",responseObject);
        if (success) {
            
            success(YES,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@",error);
        if (failure) {
            
            failure(error);
        }
    }];;
    
}

#pragma mark POST 上传视频
/**
 *  上传视频
 *
 *  @param path           上传的地址--需要填写完整的url
 *  @param videoPath      上传的视频--本地沙盒的路径
 *  @param paramters      上传视频预留参数--根据具体需求而定，可以出
 *  @param upLoadProgress 进度
 *  @param success        请求成功的回调
 *  @param failure        请求失败的回调
 */
+ (void)sendPOSTImageWithPath:(NSString *)path
                withVideoPath:(NSString *)videoPath
                withParamters:(NSDictionary *)paramters
                 withProgress:(void(^) (float progress))upLoadProgress
                      success:(void(^) (BOOL isSuccess, id responseObject))success
                      failure:(void(^) (NSError *error))failure {
    
    // 获取视频资源
    AVURLAsset * avUrlAsset = [AVURLAsset assetWithURL:[NSURL URLWithString:videoPath]];
    // 视频压缩
//    NSString *const AVAssetExportPreset640x480;
//    NSString *const AVAssetExportPreset960x540;
//    NSString *const AVAssetExportPreset1280x720;
//    NSString *const AVAssetExportPreset1920x1080;
//    NSString *const AVAssetExportPreset3840x2160;
    
    AVAssetExportSession  *  avAssetExport = [[AVAssetExportSession alloc] initWithAsset:avUrlAsset presetName:AVAssetExportPreset640x480];
    // 获取上传的时间
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    // 转化后直接写入Library---caches
    NSString *  videoWritePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:[NSString stringWithFormat:@"/output-%@.mp4",[formatter stringFromDate:[NSDate date]]]];
    avAssetExport.outputURL = [NSURL URLWithString:videoWritePath];
    avAssetExport.outputFileType =  AVFileTypeMPEG4;
    [avAssetExport exportAsynchronouslyWithCompletionHandler:^{
    
        switch ([avAssetExport status]) {
                
            case AVAssetExportSessionStatusCompleted:
            {
    
                [[NetWorkingManager shareManager] POST:path parameters:paramters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    
                    //获得沙盒中的视频内容
                    
                    [formData appendPartWithFileURL:[NSURL fileURLWithPath:videoWritePath] name:@"write you want to writre" fileName:videoWritePath mimeType:@"video/mpeg4" error:nil];
                    
                } progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                    NSLog(@"downLoadProcess = %@",uploadProgress);
                    if (uploadProgress) {
                        
                        upLoadProgress(uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
                    }
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
                    
                    NSLog(@"responseObject = %@",responseObject);
                    if (success) {
                        
                        success(YES,responseObject);
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                    NSLog(@"responseObject = %@",error);
                    if (failure) {
                        
                        failure(error);
                    }
                }];
                
                break;
            }
            default:
                break;
        }
    }];
}

#pragma mark DOWNLOAD 文件下载
+ (void)requestDownLoadDataWithPath:(NSString *)path
                      withParamters:(NSDictionary *)paramters
                       withSavaPath:(NSString *)savePath
                       withProgress:(void(^) (float progress))downLoadProgress
                            success:(void(^) (BOOL isSuccess, id responseObject))success
                            failure:(void(^) (NSError *error))failure {
    
    [[NetWorkingManager shareManager] downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:path]] progress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSLog(@"downLoadProcess = %@",downLoadProgress);
        if (downloadProgress) {
            
            downLoadProgress(downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        return  [NSURL URLWithString:savePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (error) {
            
            failure(error);
        }
        
    }];
}

#pragma mark - DELETE 删除资源
+ (void)requestDELETEDataWithPath:(NSString *)path
                    withParamters:(NSDictionary *)paramters
                          success:(void (^) (BOOL isSuccess, id responseObject))success
                          failure:(void (^) (NSError *error))failure {
    
    [[NetWorkingManager  shareManager] DELETE:path parameters:paramters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"success %@",success);
        if (success) {
            
            success(YES,success);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"failure %@",error);
        if (failure) {
            
            failure(error);
        }
    }];

}

#pragma mark - PUT 更新全部属性
+ (void)sendPUTDataWithPath:(NSString *)path
              withParamters:(NSDictionary *)paramters
                    success:(void(^) (BOOL isSuccess, id responseObject))success
                    failure:(void(^) (NSError *error))failure {
    
    [[NetWorkingManager shareManager] PUT:path parameters:paramters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"success %@",success);
        if (success) {
            
            success(YES,success);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"failure %@",error);
        if (failure) {
            
            failure(error);
        }
    }];
}

#pragma  mark - PATCH 改变资源状态或更新部分属性
+ (void)sendPATCHDataWithPath:(NSString *)path
                withParamters:(NSDictionary *)paramters
                      success:(void (^) (BOOL isSuccess, id responseObject))success
                      failure:(void (^) (NSError *error))failure {
    [[NetWorkingManager shareManager] PATCH:path parameters:paramters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"success %@",success);
        if (success) {
            
            success(YES,success);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
      
        NSLog(@"failure %@",error);
        if (failure) {
            
            failure(error);
        }
    }];
}

#pragma mark - 取消网络请求--全部请求
+ (void)cancelAllNetworkRequest {
    
    [[NetWorkingManager shareManager].operationQueue cancelAllOperations];
}

#pragma mark - 取消网络请求--指定请求
/**
 *  取消指定的url请求
 *
 *  @param type 该请求的请求类型
 *  @param path 该请求的完整url
 */
+(void)cancelHttpRequestWithType:(NSString *)type WithPath:(NSString *)path {
    
    NSError * error;
    // 根据请求的类型 以及 请求的url创建一个NSMutableURLRequest---通过该url去匹配请求队列中是否有该url,如果有的话 那么就取消该请求
    NSString * urlToPeCanced = [[[[NetWorkingManager shareManager].requestSerializer requestWithMethod:type URLString:path parameters:nil error:&error] URL] path];

    for (NSOperation * operation in [NetWorkingManager shareManager].operationQueue.operations) {
        
        // 如果是请求队列
        if ([operation isKindOfClass:[NSURLSessionTask class]]) {
            
            // 请求的类型匹配
            BOOL hasMatchRequestType = [type isEqualToString:[[(NSURLSessionTask *)operation currentRequest] HTTPMethod]];
            
            // 请求的url匹配
            
            BOOL hasMatchRequestUrlString = [urlToPeCanced isEqualToString:[[[(NSURLSessionTask *)operation currentRequest] URL] path]];
            
            // 两项都匹配的话  取消该请求
            if (hasMatchRequestType&&hasMatchRequestUrlString) {
                
                [operation cancel];
            }
        }
    }
}

@end

