//
//  SXLogHelper.m
//  SXExceptionLog
//
//  Created by Sunny on 2018/11/23.
//  Copyright © 2018 Sunny. All rights reserved.
//

#import "SXLogHelper.h"
#import <UIKit/UIKit.h>
#include <mach-o/dyld.h>


NSString * const UncaughtExceptionHandlerSignalExceptionName = @"UncaughtExceptionHandlerSignalExceptionName";
NSString * const UncaughtExceptionHandlerSignalKey = @"UncaughtExceptionHandlerSignalKey";
NSString * const UncaughtExceptionHandlerAddressesKey = @"UncaughtExceptionHandlerAddressesKey";

const NSInteger UncaughtExceptionHandlerSkipAddressCount = 4;
const NSInteger UncaughtExceptionHandlerReportAddressCount = 5;

/*
 获取 应用程序的名称
 */
NSString * getAppName()
{
    ///获取应用程序的名称
    NSDictionary *dicInfo =   [[NSBundle mainBundle] infoDictionary];
    if (SX_Dic_Not_Valid(dicInfo))  return nil;
    
    NSString *strAppName = dicInfo[@"CFBundleName"];
    return strAppName;
}

/*
 获取 应用程序的版本号
 */
NSString * getAppVersion()
{
    ///获取应用程序的版本号
    NSDictionary *dicInfo =   [[NSBundle mainBundle] infoDictionary];
    if (SX_Dic_Not_Valid(dicInfo))  return nil;
    
    NSString *strAppVersion = dicInfo[@"CFBundleShortVersionString"];
    return strAppVersion;
}

/*
 获取 应用程序的buildversion
 */
NSString * getAppBuildVersion()
{
    ///获取应用程序的buildversion
    NSDictionary *dicInfo =   [[NSBundle mainBundle] infoDictionary];
    if (SX_Dic_Not_Valid(dicInfo))  return nil;
    
    NSString *strAppBuildVersion = dicInfo[@"CFBundleVersion"];
    return strAppBuildVersion;
}

/*
 获取应用程序的加载地址
 */
NSString * getAppLoadAddress()
{
    NSString *strLoadAddress =nil;
    
    
    NSString * strAppName = getAppName();
    if (SX_Str_Not_Valid(strAppName))  return strLoadAddress;
    
    ///获取应用程序的load address
    uint32_t count = _dyld_image_count();
    for(uint32_t iImg = 0; iImg < count; iImg++)
    {
        const char* szName = _dyld_get_image_name(iImg);
        if (strstr(szName, strAppName.UTF8String) != NULL)
        {
            const struct mach_header* header = _dyld_get_image_header(iImg);
            strLoadAddress = [NSString stringWithFormat:@"0x%lX",(uintptr_t)header];
            break;
        }
    }
    return strLoadAddress;
}



/*
 获取系统的构架
 */
NSString * getSystemArch()
{
    NSString *strSystemArch =nil;
    
    NSString *strAppName = getAppName();
    if (SX_Str_Not_Valid(strAppName))  return strSystemArch;
    
    ///获取  cpu 的大小版本号
    uint32_t count = _dyld_image_count();
    cpu_type_t cpuType = -1;
    cpu_type_t cpuSubType =-1;
    
    for(uint32_t iImg = 0; iImg < count; iImg++)
    {
        const char* szName = _dyld_get_image_name(iImg);
        if (strstr(szName, strAppName.UTF8String) != NULL)
        {
            const struct mach_header* machHeader = _dyld_get_image_header(iImg);
            cpuType = machHeader->cputype;
            cpuSubType = machHeader->cpusubtype;
            break;
        }
    }
    
    if(cpuType < 0 ||  cpuSubType <0)  return  strSystemArch;
    
    ///转化cpu 版本
    switch(cpuType)
    {
        case CPU_TYPE_ARM:
        {
            strSystemArch = @"arm";
            switch (cpuSubType)
            {
                case CPU_SUBTYPE_ARM_V6:
                    strSystemArch = @"armv6";
                    break;
                case CPU_SUBTYPE_ARM_V7:
                    strSystemArch = @"armv7";
                    break;
                case CPU_SUBTYPE_ARM_V7F:
                    strSystemArch = @"armv7f";
                    break;
                case CPU_SUBTYPE_ARM_V7K:
                    strSystemArch = @"armv7k";
                    break;
#ifdef CPU_SUBTYPE_ARM_V7S
                case CPU_SUBTYPE_ARM_V7S:
                    strSystemArch = @"armv7s";
                    break;
#endif
            }
            break;
        }
#ifdef CPU_TYPE_ARM64
        case CPU_TYPE_ARM64:
            strSystemArch = @"arm64";
            break;
#endif
        case CPU_TYPE_X86:
            strSystemArch = @"i386";
            break;
        case CPU_TYPE_X86_64:
            strSystemArch = @"x86_64";
            break;
    }
    return strSystemArch;
}


id getNSUserDefaultsValueForKey(NSString *key)
{
    if (!key || [key isEqualToString:@""])
    {
        return nil;
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}


@implementation SXLogHelper

#pragma  mark - 自定义log
/**
 *  自定义Log日志,你可以通过NSString *string = [NSString stringWithFormat:@"FUNCTION=%s\nLINE=%d\n];获取调用行数+方法名
 *
 *  @param exceptionInfo 自定义Log日志字符串
 */
+ (void)customExceptionInfo:(NSString*)exceptionInfo
{
    //    SXLogModel *model = [[SXLogModel alloc] init];
    //    model.exceptionInfo = exceptionInfo;
    //#ifdef MODE_Debug
    //    model.others = @"自定义[测试]";
    //#else
    //    model.others = @"自定义[生产]";
    //#endif
    //    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
    //    [SXLogHelper saveLocalFileWithData:data withPrefixName:SX_ExceptionLog];
    //    [SXLogHelper saveLocalFileWithData:data withPrefixName:SX_LocalExceptionLog];
}

#pragma  mark - 辅助方法
/**
 获取自定义的不同的环境下的接口地址

 @return 不同的环境下的地址
 */
+ (NSString *)getDefaultApiUrl
{
    NSString * urlString = nil;
    
#ifdef MODE_CanSwitchEnvironment
    // 测试环境
    urlString = @"http://www.xxx.com";
#else
    // 生产环境
    urlString = @"http://www.xxx.com";
#endif
    return urlString;
}


/**
 根据filePath获取创建时间
 
 @param filePath 文件路径
 @return createtime
 */
+ (NSString*)getExceptionTimeWithFilePath:(NSString*)filePath
{
    NSDictionary *fileAttributes = [[NSFileManager defaultManager]attributesOfItemAtPath:filePath error:nil];
    NSDate *creationDate = [fileAttributes objectForKey:NSFileCreationDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:ServerDateFormat];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    NSString *currentDateStr = [dateFormatter stringFromDate:creationDate];
    return currentDateStr;
}


/**
 生成文件名，格式exception+timestamp+filesuffix
 
 @return 文件名
 */
+ (NSString*)getExceptionFileName
{
    NSDate *localDate = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[localDate timeIntervalSince1970]];
    NSString *fileName = [NSString stringWithFormat:@"exception%@%@",timeSp,SX_Log_File_Suffix];
    return fileName;
}


/**
  根据文件名生成log文件夹
 
 @param strPrefixName 前缀（文件名）
 @return 文件夹路径
 */
+ (NSString *)getLogsFilePathWithPrefixName:(NSString* ) strPrefixName
{
    return [NSTemporaryDirectory() stringByAppendingPathComponent:SX_Str_Protect(strPrefixName)];
}


#pragma mark - 处理log
/// 获取异常并处理
+ (void)exceptionHandler:(NSException*)exception
{
    if (!exception || ![exception isKindOfClass:[NSException class]])  return;
        
    ///获取应用程序的名称
    NSString *strAppName = getAppName();
    
    
    /// 异常的堆栈信息
    NSArray *aryCrashBackTrace = [exception callStackSymbols];
    if (SX_Ary_Not_Valid(aryCrashBackTrace))
    {
        return;
    }
    
    /// 出现异常的原因
    NSString *strCrashReason = [exception reason];
    
    /// 异常名称
    NSString *strCrashName = [exception name];
    
    //NSTextCheckingResult
    /// 构建崩溃model
    SXCrashInfo *modelCrashInfo = [SXCrashInfo new];
    modelCrashInfo.strCrashReson = SX_Str_Protect(strCrashReason);
    modelCrashInfo.strCrashName = SX_Str_Protect(strCrashName);
    modelCrashInfo.strCrashArch = SX_Str_Protect(getSystemArch());
    modelCrashInfo.strCrashSystemVersion = [[UIDevice currentDevice] systemVersion];
    modelCrashInfo.strCrashOther = @"systems";
    
    NSMutableArray *maryBackTrace = [NSMutableArray array];
    ///崩溃的调用堆栈信息
    for (NSString *strBackTrace in aryCrashBackTrace)
    {
        ///查找崩溃的镜像名称 、 崩溃堆栈地址、 镜像加载地址
        NSError * error;
        NSRegularExpression * regulorStackAddress = [NSRegularExpression regularExpressionWithPattern:@"0x[0-9a-fA-F]{8,16}" options:NSRegularExpressionCaseInsensitive error:&error];
        
        NSRegularExpression * regulorAdd = [NSRegularExpression regularExpressionWithPattern:@"\\+ [0-9]+" options:NSRegularExpressionCaseInsensitive error:&error];
        
        NSRange rangeStackAddress = [regulorStackAddress rangeOfFirstMatchInString:strBackTrace options:NSMatchingReportProgress range:NSMakeRange(0, strBackTrace.length)];
        
        NSRange rangeAdd = [regulorAdd rangeOfFirstMatchInString:strBackTrace options:NSMatchingReportProgress range:NSMakeRange(0, strBackTrace.length)];
        
        if (rangeStackAddress.location == NSNotFound || rangeAdd.location == NSNotFound  )
        {
            continue;
        }
        
        ///镜像名称
        NSRange rangeImageName = NSMakeRange(3, rangeStackAddress.location-3);
        if (rangeImageName.location + rangeImageName.length >strBackTrace.length )
        {
            continue;
        }
        NSString *strImageName = [strBackTrace substringWithRange:rangeImageName];
        strImageName = [strImageName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        ///堆栈地址
        if (rangeStackAddress.location + rangeStackAddress.length > strBackTrace.length)
        {
            continue;
        }
        NSString *strStackAddress = [strBackTrace substringWithRange:rangeStackAddress];
        strStackAddress = [strStackAddress stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        
        ///加载地址
        NSRange rangeLoadAddress = NSMakeRange(rangeStackAddress.location + rangeStackAddress.length +1, rangeAdd.location - rangeStackAddress.location - rangeStackAddress.length -2);
        if (rangeLoadAddress.location + rangeLoadAddress.length>  strBackTrace.length)
        {
            continue;
        }
        NSString *strLoadAddress =[strBackTrace substringWithRange:NSMakeRange(rangeStackAddress.location + rangeStackAddress.length +1, rangeAdd.location - rangeStackAddress.location - rangeStackAddress.length -2)];
        
        
        
        SXCrashBackTrace *modelBackTrace = [SXCrashBackTrace new];
        modelBackTrace.strCrashImageName = strImageName;
        modelBackTrace.strCrashStackAddress = strStackAddress;
        if ([strLoadAddress isEqualToString:strAppName])
        {
            modelBackTrace.strCrashLoadAddress = SX_Str_Protect(getAppLoadAddress());
        }
        else
        {
            modelBackTrace.strCrashLoadAddress = SX_Str_Protect(strLoadAddress);
        }
        [maryBackTrace addObject:modelBackTrace];
    }
    modelCrashInfo.aryCrashThreadBackTrace  = maryBackTrace ;
    
    
    ///转为json 格式，并保存文件
    NSDictionary *dicCrashInfo = [NSMutableDictionary dictionary];
    [dicCrashInfo setValue:SX_Str_Protect(modelCrashInfo.strCrashReson) forKey:SX_Crash_Reason];
    [dicCrashInfo setValue:SX_Str_Protect(modelCrashInfo.strCrashName) forKey:SX_Crash_Name];
    
    [dicCrashInfo setValue:SX_Str_Protect(modelCrashInfo.strCrashArch) forKey:SX_Crash_Arch];
    [dicCrashInfo setValue:SX_Str_Protect(modelCrashInfo.strCrashOther) forKey:SX_Crash_Other];
    
    [dicCrashInfo setValue:SX_Str_Protect(modelCrashInfo.strCrashSystemVersion) forKey:SX_Crash_SystemVersion];
    
    
    NSMutableArray *maryDecodeBackTrack = [NSMutableArray array];
    for (SXCrashBackTrace *modelCrashBackTrack in modelCrashInfo.aryCrashThreadBackTrace)
    {
        NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
        [mdic setValue:SX_Str_Protect(modelCrashBackTrack.strCrashImageName) forKey:SX_Crash_ImageName];
        [mdic setValue:SX_Str_Protect(modelCrashBackTrack.strCrashStackAddress) forKey:SX_Crash_Stack_Address];
        [mdic setValue:SX_Str_Protect(modelCrashBackTrack.strCrashLoadAddress) forKey:SX_Crash_LoadAddress];
        [maryDecodeBackTrack addObject:mdic];
    }
    if (SX_Ary_Is_Valid(maryDecodeBackTrack))
    {
        [dicCrashInfo setValue:maryDecodeBackTrack forKey:SX_Crash_ThreadBackTrace];
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:dicCrashInfo options:0 error:nil];
#ifdef MODE_CanSwitchEnvironment
    
    [SXLogHelper saveLocalFileWithData:data withPrefixName:SX_CrashLocalExceptionLog];
#else
    // 生产环境下存服务器，后台能查看
    [SXLogHelper saveLocalFileWithData:data withPrefixName:SX_CrashExceptionLog];
#endif
}


#pragma mark - 保存、删除操作
/*!
 *  保存不同路径下的log信息
 *
 *  @param data 本地log数据模型
 *
 *  @param strPrefixName 测试环境的
 *
 *  @return 保存成功/失败
 */
+ (BOOL)saveLocalFileWithData:(NSData*)data withPrefixName:(NSString* ) strPrefixName
{
    //创建目录
    NSString* path = [self getLogsFilePathWithPrefixName:strPrefixName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path])
    {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    //创建log日志文件,每次名字后面拼接时间戳。
    NSString* exceptionFilePath = [path stringByAppendingString:[NSString stringWithFormat:@"/%@",[SXLogHelper getExceptionFileName]]];
    return [data writeToFile:exceptionFilePath atomically:YES];
}

/**
 获取本地所有log信息

 @param strPrefixName 不同环境下的路径前缀(文件夹名)
 @return 包含数据字典得数组
 */
+ (NSArray*)getLogsWithPrefixName:(NSString* ) strPrefixName
{
    NSMutableArray *logs = [NSMutableArray array];
    NSString *path = [self getLogsFilePathWithPrefixName:strPrefixName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:path error:NULL];
    if (contents.count > 0)
    {
        for (NSString* fileName in contents)
        {
            if ([fileName hasSuffix:SX_Log_File_Suffix])
            {
                NSString *filePath = [path stringByAppendingFormat:@"/%@",fileName];
                
                //TODO: 反序列化
                NSError *error = nil;
                NSData *dataCrashInfo = [NSData dataWithContentsOfFile:filePath];
                
                NSDictionary *dicCrashInfo =[NSJSONSerialization JSONObjectWithData:dataCrashInfo options:NSJSONReadingMutableContainers error:&error];
                if (!error)
                {
                    SXCrashInfo *modelCrashInfo = [SXCrashInfo new];
                    [modelCrashInfo convertDataFromDictionary:dicCrashInfo];
                    
                    NSMutableArray * mAryTheadBackTraceModel = [NSMutableArray array];
                    for (NSDictionary * dicThead in modelCrashInfo.aryCrashThreadBackTrace)
                    {
                        if (SX_Dic_Not_Valid(dicThead)) continue;
                        
                        SXCrashBackTrace *modelBackTrace = [SXCrashBackTrace new];
                        [modelBackTrace convertDataFromDictionary:dicThead];
                        [mAryTheadBackTraceModel addObject:modelBackTrace];
                    }
                    
                    NSString *crashLogs = [NSString stringWithFormat:@"%@",mAryTheadBackTraceModel];
                    
                    NSString *appName = getAppName();
                    NSString *others = modelCrashInfo.strCrashOther;
                    
                    NSMutableDictionary *params = [NSMutableDictionary dictionary];
                    [params setValue:SX_Str_Protect(getAppVersion()) forKey:@"appVersionCode"];
                    [params setValue:[[UIDevice currentDevice] systemVersion] forKey:@"systemVersionCode"];
                    [params setValue:[[UIDevice currentDevice] model] forKey:@"phoneModel"];
                    
                    [params setValue:[[UIDevice currentDevice] systemName] forKey:@"phonePlatform"];
                    [params setValue:crashLogs forKey:@"crashLogs"];
                    [params setValue:appName forKey:@"appName"];
                    [params setValue:others forKey:@"others"];
                    
                    
                    NSString *createTime = [SXLogHelper getExceptionTimeWithFilePath:filePath];
                    [params setValue:createTime forKey:@"createTime"];
                    [params setValue:SX_Str_Protect(modelCrashInfo.strCrashReson) forKey:@"reason"];
                    [params setValue:SX_Str_Protect(modelCrashInfo.strCrashName) forKey:@"name"];
                    
                    
                    [params setValue:filePath forKey:@"filePath"];
                    
                    //倒序
                    [logs insertObject:params atIndex:0];
                }
                else
                {
                    NSMutableDictionary *params = [NSMutableDictionary dictionary];
                    
                    NSString *str = [[NSString alloc] initWithData:dataCrashInfo encoding:NSUTF8StringEncoding];
                    
                    NSString *createTime = [SXLogHelper getExceptionTimeWithFilePath:filePath];
                    [params setValue:SX_Str_Protect(createTime) forKey:@"createTime"];
                    [params setValue:SX_Str_Protect(str) forKey:@"reason"];
                    
                    [logs insertObject:params atIndex:0];
                }
            }
        }
    }
    return (NSArray*)logs;
}



+ (BOOL)deleteAllLogsWithPrefixName:(NSString* )strPrefixName
{
    NSString* path = [self getLogsFilePathWithPrefixName:strPrefixName];
    return [self deleteLogsWithPath:path];
}

+ (BOOL)deleteLogsWithPath:(NSString* )strPath
{
    return [[NSFileManager defaultManager] removeItemAtPath:strPath error:nil];
}



@end







@implementation SXCrashInfo

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        self.aryCrashThreadBackTrace = [NSMutableArray arrayWithObject:[SXCrashBackTrace new]];
    }
    return self;
}

@end


@implementation SXCrashBackTrace

-(NSString*)description
{
    if (SX_Str_Is_Valid(_strCrashStackAddress)
        && SX_Str_Is_Valid(_strCrashLoadAddress)
        )
    {
        NSString *strBackTrace = [NSString stringWithFormat:@"%-25s %s %s",SX_Str_Protect(_strCrashImageName).UTF8String,
                                  SX_Str_Protect(_strCrashStackAddress).UTF8String,
                                  SX_Str_Protect(_strCrashLoadAddress).UTF8String];
        return strBackTrace;
    }
    else
        return @"";
    
}
@end
