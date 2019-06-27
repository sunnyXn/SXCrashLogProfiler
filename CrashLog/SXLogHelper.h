//
//  SXLogHelper.h
//  SXExceptionLog
//
//  Created by Sunny on 2018/11/23.
//  Copyright © 2018 Sunny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SXMacro.h"


#define SX_Crash_Reason             @"strCrashReson"
#define SX_Crash_Name               @"strCrashName"
#define SX_Crash_ThreadBackTrace    @"aryCrashThreadBackTrace"
#define SX_Crash_Arch               @"strCrashArch"
#define SX_Crash_Other              @"strCrashOther"
#define SX_Crash_SystemVersion      @"strCrashSystemVersion"


#define SX_Crash_Stack_Address      @"strCrashStackAddress"
#define SX_Crash_LoadAddress        @"strCrashLoadAddress"
#define SX_Crash_ImageName          @"strCrashImageName"


///crashlog 的release 路径
#define SX_CrashExceptionLog      @"SX_CrashExceptionLog"

///crashlog 的debug 路径
#define SX_CrashLocalExceptionLog @"SX_CrashLocalExceptionLog"

/// 文件后缀
#define SX_Log_File_Suffix @".dat"

#define SX_Crash_Log_Separator @"<App_Crash_Separator>"



/**
 crash处理工具类
 */
@interface SXLogHelper : NSObject


+ (void)exceptionHandler:(NSException*)exception;

+ (void)customExceptionInfo:(NSString*)exceptionInfo;

+ (NSString *)getDefaultApiUrl;

#pragma mark - 保存信息
+ (BOOL)saveLocalFileWithData:(NSData*)data withPrefixName:(NSString* )strPrefixName;

#pragma mark - 查看用
+ (NSString *)getLogsFilePathWithPrefixName:(NSString* )strPrefixName;
+ (NSArray*)getLogsWithPrefixName:(NSString* )strPrefixName;

#pragma mark - 删除用
+ (BOOL)deleteAllLogsWithPrefixName:(NSString* )strPrefixName;
+ (BOOL)deleteLogsWithPath:(NSString* )strPath;


@end



///崩溃信息收集的模型
@interface SXCrashInfo : NSObject

/// 崩溃原因 异常信息
@property (nonatomic, strong) NSString *strCrashReson;

///崩溃的名称
@property (nonatomic, strong) NSString *strCrashName;

///崩溃时系统的构建
@property (nonatomic, strong) NSString *strCrashArch;

///系统版本
@property (nonatomic, strong) NSString * strCrashSystemVersion;

///崩溃时的其他信息
@property (nonatomic, strong) NSString *strCrashOther;

///崩溃线程的调用堆栈 类型是 SXCrashBackTrace
@property (nonatomic, strong) NSArray *aryCrashThreadBackTrace;


@end



/// 崩溃线程的 回溯 信息
@interface SXCrashBackTrace : NSObject

///崩溃的堆栈地址
@property (nonatomic, strong) NSString *strCrashStackAddress;

/// 崩溃所在镜像的加载地址
@property (nonatomic, strong) NSString *strCrashLoadAddress;

///崩溃所在镜像 的名称
@property (nonatomic, strong) NSString *strCrashImageName;

@end

