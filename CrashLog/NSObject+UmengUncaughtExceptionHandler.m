//
//  NSObject+UmengUncaughtExceptionHandler.m
//  SMZDM
//
//  Created by Sunny on 2018/11/26.
//  Copyright © 2018 smzdm. All rights reserved.
//

#import "NSObject+UmengUncaughtExceptionHandler.h"
#import "SXLogHelper.h"
#import "SXReportExceptionSender.h"
#import <objc/runtime.h>


/// 静态就交换静态，实例方法就交换实例方法
void __SXTransition_Swizzle(Class c, SEL origSEL, SEL newSEL)
{
    /// 获取实例方法
    Method origMethod = class_getInstanceMethod(c, origSEL);
    Method newMethod = nil;
    if (!origMethod)
    {
        /// 获取静态方法
        origMethod = class_getClassMethod(c, origSEL);
        newMethod = class_getClassMethod(c, newSEL);
    }
    else
    {
        newMethod = class_getInstanceMethod(c, newSEL);
    }
    
    if (!origMethod||!newMethod)
    {
        return;
    }
    
    /// 自身已经有了就添加不成功，直接交换即可
    if (class_addMethod(c, origSEL, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
    {
        /// 添加成功一般情况是因为，origSEL本身是在c的父类里。这里添加成功了一个继承方法。
        class_replaceMethod(c,
                            newSEL,
                            method_getImplementation(origMethod),
                            method_getTypeEncoding(origMethod));
    }
    else
    {
        method_exchangeImplementations(origMethod, newMethod);
    }
}

@implementation NSObject (UmengUncaughtExceptionHandler)


/**
 如果添加了友盟等搜集crash工具，需要拦截崩溃方法再去处理，否则crash收集处理不生效。
 */
+ (void)load
{
    __SXTransition_Swizzle(NSClassFromString(@"UmengUncaughtExceptionHandler"), @selector(handleException:), @selector(xx_UmengUncaughtExceptionHandler:));
}


- (void)xx_UmengUncaughtExceptionHandler:(id)exception
{
    NSLog(@"xx_UmengUncaughtExceptionHandler:%@",exception);
    
    if ([exception isKindOfClass:[NSException class]])
    {
        [SXLogHelper exceptionHandler:exception];
        [self xx_UmengUncaughtExceptionHandler:exception];
    }
}


@end
