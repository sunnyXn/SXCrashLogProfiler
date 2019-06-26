//
//  SXReportExceptionSender.h
//  SXExceptionLog
//
//  Created by Sunny on 2018/11/23.
//  Copyright © 2018 Sunny. All rights reserved.
//

#import <Foundation/Foundation.h>


/// 处理crash上传
@interface SXReportExceptionSender : NSObject


/**
 处理异常 然后上传
 */
+ (void)ExceptionHandler;

@end

