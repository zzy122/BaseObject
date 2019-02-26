//
//  NSDictionary+JSON.m
//  小绵羊
//
//  Created by 123 on 2018/4/3.
//  Copyright © 2018年 KFZS. All rights reserved.
//

#import "NSDictionary+JSON.h"

@implementation NSDictionary (JSON)
/**
 *  字典转 json字符串
 *
 *  @return json字符串
 */
-(NSString *)dictionaryToJsonString
{
    NSError *error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    
    if (error) {
        return nil;
    }
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
