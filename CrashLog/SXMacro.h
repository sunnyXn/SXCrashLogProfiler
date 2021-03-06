//
//  SXMacro.h
//  SXExceptionLog
//
//  Created by Sunny on 2018/11/23.
//  Copyright © 2018 Sunny. All rights reserved.
//

#ifndef SXMacro_h
#define SXMacro_h

#import "NSObject+ConvertModel.h"

#pragma mark - 时间相关的定义，秒、分、时、天、年

#define TIME_SECOND (1)               // 秒
#define TIME_MINUTE (60*TIME_SECOND)  // 分
#define TIME_HOUR (60*TIME_MINUTE)    // 时
#define TIME_DAY (24*TIME_HOUR)       // 天
#define TIME_YEAR (TIME_DAY*365)      // 年


#pragma mark - 服务器时间格式yyyy-MM-dd HH:mm:ss

#define ServerDateFormat @"yyyy-MM-dd HH:mm:ss"


// 切换环境, 上传appstore时需注释掉
#if DEBUG
#define MODE_CanSwitchEnvironment
#endif


#define screenH   ([UIScreen mainScreen].bounds.size.height)
#define screenW   ([UIScreen mainScreen].bounds.size.width)

#define ISIPhoneXDevice  ([[[UIApplication sharedApplication] delegate] window].safeAreaInsets.bottom > 0.0)

#define SX_NavBar_H_XAdd   (ISIPhoneXDevice ? [[UIApplication sharedApplication] statusBarFrame].size.height : 0) /// iphoneX导航栏 多了24高度 = 88
#define SX_NavBar_H (44 + SX_NavBar_H_XAdd) /// NavBar的高度 添加X的多余高度



// 判断obj是否为className类型
#define SX_Object_Is_Class(obj,className) [obj isKindOfClass:[className class]]


/// 是否为NSString类型（单独处理NSMutableString）
#define SX_Str_Class(str) [str isKindOfClass:[NSString class]]
#define SX_mStr_Class(mstr) [mstr isKindOfClass:[NSMutableString class]]

/// 是否有效，不为空，且是NSString类型，且count值大于0（单独处理NSMutableString）
#define SX_Str_Is_Valid(str) ((str) && (SX_Str_Class(str)) && ([str length] > 0))
#define SX_mStr_Is_Valid(mstr) ((mstr) && (SX_mStr_Class(mstr)) && ([mstr length] > 0))

/// 是否无效，或为空，或不是NSString类型，或count值小于等于0（单独处理NSMutableString）
#define SX_Str_Not_Valid(str) ((!str) || (!SX_Str_Class(str)) || ([str length] <= 0))
#define SX_mStr_Not_Valid(mstr) ((!mstr) || (!SX_mStr_Class(mstr)) || ([mstr length] <= 0))

/// 格式化字符串
#define SX_Str_Format(...) [NSString stringWithFormat:__VA_ARGS__]

/// nil保护，当为nil时，返回@""，避免一些Crash
#define SX_Str_Protect(str) ((str) && (![str isKindOfClass:[NSNull class]]) ? (str) : (@""))



/// 是否NSArray类型（单独处理NSMutableArray）
#define SX_Ary_Class(ary) SX_Object_Is_Class(ary, NSArray)
#define SX_mAry_Class(mary) SX_Object_Is_Class(mary,NSMutableArray)

/// 是否有效，不为空，且是NSArray类型，且count值大于0（单独处理NSMutableArray）
#define SX_Ary_Is_Valid(ary) ((ary) && (SX_Ary_Class(ary)) && ([ary count] > 0))
#define SX_mAry_Is_Valid(mary) ((mary) && (SX_mAry_Class(mary)) && ([mary count] > 0))

/// 是否无效，或为空，或不是NSArray类型，或count值小于等于0（单独处理NSMutableArray）
#define SX_Ary_Not_Valid(ary) ((!ary) || (!SX_Ary_Class(ary)) || ([ary count] <= 0))
#define SX_mAry_Not_Valid(mary) ((!mary) || !(SX_mAry_Class(mary)) || ([mary count] <= 0))


/// 是否NSDictionary类型（单独处理NSMutableDictionary）
#define SX_Dic_Class(dic) [dic isKindOfClass:[NSDictionary class]]
#define SX_mDic_Class(mdic) [mdic isKindOfClass:[NSMutableDictionary class]]

/// 是否有效，不为空，且是NSDictionary类型，且count值大于0（单独处理NSMutableDictionary）
#define SX_Dic_Is_Valid(dic) ((dic) && (SX_Dic_Class(dic)) && ([dic count] > 0))
#define SX_mDic_Is_Valid(mdic) ((mdic) && (SX_mDic_Class(mdic)) && (mdic.count > 0))

/// 是否无效，或为空，或不是NSDictionary类型，或count值小于等于0（单独处理NSMutableDictionary）
#define SX_Dic_Not_Valid(dic) ((!dic) || (!SX_Dic_Class(dic)) || ([dic count] <= 0))
#define SX_mDic_Not_Valid(mdic) ((!mdic) || (!SX_mDic_Class(mdic)) || (mdic.count <= 0))



// instanceObj
#define SX_Instance(obj , cls)   if(!obj) obj = [cls new];
#define SX_Instance_GetObj(_obj , cls)  {SX_Instance(_obj,cls); return _obj;}

/// instance_obj
#define SX_Instance_Get_Obj(obj , cls)  \
- (id)obj \
{   \
SX_Instance_GetObj(_##obj , cls)   \
}

/// instance_mAry
#define SX_Instance_Get_mAry(obj)   SX_Instance_Get_Obj(obj , [NSMutableArray class])

/// instance_Ary
#define SX_Instance_Get_Ary(obj)    SX_Instance_Get_Obj(obj , [NSArray class])

/// instance_Dic
#define SX_Instance_Get_Dic(obj)    SX_Instance_Get_Obj(obj , [NSDictionary class])

/// instance_mDic
#define SX_Instance_Get_mDic(obj)   SX_Instance_Get_Obj(obj , [NSMutableDictionary class])



#define SX_Release(obj)          if(obj) { obj = nil;}
#define SX_Release_View(v)       if(v) {[v removeFromSuperview]; v = nil;}

#endif /* SXMacro_h */
