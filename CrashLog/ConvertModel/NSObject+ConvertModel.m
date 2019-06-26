//
//  NSObject+ConvertModel.m
//  ConvertModel
//
//  Created by Sunny on 16/7/15.
//  Copyright © 2016年 Sunny. All rights reserved.
//

#import "NSObject+ConvertModel.h"
#import <objc/runtime.h>

@implementation NSObject (ConvertModel)


- (NSDictionary *)convertModelToDicionary
{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    
    unsigned int outCount, i;
    
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for (i = 0; i < outCount;  i ++ )
    {
        objc_property_t property = properties[i];
        
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        
        id value = [self valueForKey:propertyName];
        
        if (![value isKindOfClass:[NSNull class]] && value != nil)
        {
            if ([value isKindOfClass:[self class]])
            {
                NSDictionary * vDic = [value convertModelToDicionary];
                [dic setValue:vDic forKey:propertyName];
            }
            else
            {
                [dic setValue:value forKey:propertyName];
            }
        }
    }
    free(properties);
    
    return dic;
}

-(void)convertDataFromDictionary:(NSDictionary *)dic
{
    unsigned int outCount, i;
    
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        
        NSString *propertyType = [[NSString alloc] initWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
        
        if ([[dic allKeys] containsObject:propertyName]) {
            
            id value = [dic valueForKey:propertyName];
            
            if (![value isKindOfClass:[NSNull class]] && value != nil) {
                
                if ([value isKindOfClass:[NSDictionary class]]) {
                    
                    id pro = [self createInstanceByClassName:[self getClassName:propertyType]];
                    
                    [pro convertDataFromDictionary:value];
                    
                    [self setValue:pro forKey:propertyName];
                    
                }else{
                    [self setValue:value forKey:propertyName];
                }
            }
        }
    }
    free(properties);
}

-(NSString *)getClassName:(NSString *)attributes
{
    NSRange range = [attributes rangeOfString:@"\"" options:NSRegularExpressionSearch];
    NSString * type = [attributes substringFromIndex:(range.location + 1)];
    range = [type rangeOfString:@"\"" options:NSRegularExpressionSearch];
    type = [type substringToIndex:range.location];
    
    return type;
}

-(id) createInstanceByClassName: (NSString *)className {
    
    NSBundle *bundle = [NSBundle mainBundle];
    Class aClass = [bundle classNamed:className];
    id anInstance = [[aClass alloc] init];
    return anInstance;
}

@end
