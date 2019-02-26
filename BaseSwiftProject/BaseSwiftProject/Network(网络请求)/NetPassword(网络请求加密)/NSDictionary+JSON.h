//
//  NSDictionary+JSON.h
//  小绵羊
//
//  Created by 123 on 2018/4/3.
//  Copyright © 2018年 KFZS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JSON)
/**
 *  字典转 json字符串
 *
 *  @return json字符串
 */
-(NSString *)dictionaryToJsonString;
@end
