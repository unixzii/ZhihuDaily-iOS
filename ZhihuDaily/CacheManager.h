//
//  CacheManager.h
//  ZhihuDaily
//
//  Created by 杨弘宇 on 16/5/21.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheManager : NSObject

+ (instancetype)defaultManager;

- (void)putObject:(NSObject<NSCoding> *)object forKey:(NSString *)key;
- (void)putObject:(NSObject<NSCoding> *)object forKey:(NSString *)key toBothDiskAndMemory:(BOOL)flag;

- (id)objectForKey:(NSString *)key;

- (void)clearMemoryCaches;

@end
