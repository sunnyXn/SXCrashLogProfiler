//
//  NSObject+ConvertModel.h
//  ConvertModel
//
//  Created by Sunny on 16/7/15.
//  Copyright © 2016年 Sunny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ConvertModel)

- (NSDictionary *)convertModelToDicionary;
- (void)convertDataFromDictionary:(NSDictionary *)dic;

@end
