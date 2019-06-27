//
//  SXReportExceptionSender.m
//  SXExceptionLog
//
//  Created by Sunny on 2018/11/23.
//  Copyright © 2018 Sunny. All rights reserved.
//

#import "SXReportExceptionSender.h"
#import "SXLogHelper.h"

@implementation SXReportExceptionSender


+ (void)ExceptionHandler
{
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    /// 将崩溃日志上传到服务器
    [self uploadCrashFeedbackAsync];
}

void uncaughtExceptionHandler(NSException *exception)
{
    [SXLogHelper exceptionHandler:exception];
}


+ (void)uploadCrashFeedbackAsync
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self sendLocalExceptionLog];
    });
}

+ (void)sendLocalExceptionLog
{
    NSArray *aryLocalKSCrashLog = [SXLogHelper getLogsWithPrefixName:SX_CrashExceptionLog];
    
    for (NSDictionary* dict in aryLocalKSCrashLog)
    {
        if (SX_Dic_Not_Valid(dict))   continue;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
        NSString *strCrashInfo = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        if (SX_Str_Not_Valid(strCrashInfo))  continue;
        
        NSString * filePath = dict[@"filePath"];
        
        
        [self reqSendException:[NSString stringWithFormat:@"%@ %@",SX_Crash_Log_Separator, strCrashInfo] completion:^
         {
             //上传成功删除日志
             dispatch_async(dispatch_get_main_queue(), ^{
                 [SXLogHelper deleteLogsWithPath:filePath];
             });
         }];
    }
}

/// 上传请求
+ (void)reqSendException:(NSString *)exception completion:(void (^)(void))completion
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:exception forKey:@"crashLog"];
    
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
    NSString *strCrashInfo = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    
    NSString *urlString = [SXLogHelper getDefaultApiUrl];
    
    
    // 去除一些特殊字符编码
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
    
    // 2.创建请求 并：设置缓存策略为每次都从网络加载 超时时间10秒
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [strCrashInfo dataUsingEncoding:NSUTF8StringEncoding];
    
    // 3.采用苹果提供的共享session
    NSURLSession *sharedSession = [NSURLSession sharedSession];
    
    // 4.由系统直接返回一个dataTask任务
    NSURLSessionDataTask *dataTask = [sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // 网络请求完成之后就会执行，NSURLSession自动实现多线程
        NSLog(@"%@",[NSThread currentThread]);
        if (data && (error == nil)) {
            // 网络访问成功
            NSLog(@"data=%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        } else {
            // 网络访问失败
            NSLog(@"error=%@",error);
        }
    }];
    
    [dataTask resume];
}



@end
