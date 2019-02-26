//
//  KFNetPasswordTools.h
//  SmallSheep
//
//  Created by kfzs on 2018/8/10.
//  Copyright © 2018年 KFZS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KFNetPasswordTools : NSObject
+ (KFNetPasswordTools*)share;
- (NSString*)conversionToDictionary:(NSDictionary*)paramDic;
- (NSDictionary*)conversionToJson:(NSData*)data;
@end
