//
//  KFNetPasswordTools.m
//  SmallSheep
//
//  Created by kfzs on 2018/8/10.
//  Copyright © 2018年 KFZS. All rights reserved.
//

#import "KFNetPasswordTools.h"
#import "XXTEA.h"
#import "NSDictionary+JSON.h"
#define  XXTeaKey @"bbu423&(gBUjX#$s"
@implementation KFNetPasswordTools
+ (KFNetPasswordTools *)share
{
    static KFNetPasswordTools* tool = nil;
    static dispatch_once_t Token;
    dispatch_once(&Token, ^{
        tool = [KFNetPasswordTools new];
    });
    return tool;
}
- (NSString *)conversionToDictionary:(NSDictionary *)paramDic
{
    NSData * xxData = [XXTEA encryptString:[paramDic dictionaryToJsonString] stringKey:XXTeaKey];
    NSString * unicodeString = [self convertDataToHexStr:xxData];
    return unicodeString;
}
- (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}
- (NSDictionary *)conversionToJson:(NSData *)data
{
    NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString * json = [XXTEA decryptToString:[self convertHexStrToData:str] stringKey:XXTeaKey];
    NSDictionary * dic = [self dictionaryWithJsonString:json];
    return dic;
}
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    
    return dic;
    
}
//16进制转NSData
- (NSData *)convertHexStrToData:(NSString *)str {
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    return hexData;
}
@end
