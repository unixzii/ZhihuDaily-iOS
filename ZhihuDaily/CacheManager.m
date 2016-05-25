//
//  CacheManager.m
//  ZhihuDaily
//
//  Created by 杨弘宇 on 16/5/21.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

#import "CacheManager.h"
#import "AppDelegate.h"
#import "NSLock+Helpers.h"
#import "NSString+MD5.h"

@interface CacheManager ()

@property (strong, nonatomic) NSLock *cacheLock;
@property (strong, nonatomic) NSMutableDictionary<NSString *, NSObject *> *memoryCache;

@end

@implementation CacheManager

+ (instancetype)defaultManager {
    static CacheManager *DefaultManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        DefaultManager = [[CacheManager alloc] init];
    });
    
    return DefaultManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cacheLock = [[NSLock alloc] init];
    }
    return self;
}

- (NSString *)filePathForKey:(NSString *)key {
    NSString *basePath = [[[AppDelegate sharedDelegate] applicationCachesDirectory].absoluteString substringFromIndex:5];
    NSString *finalPath = [[basePath stringByAppendingPathComponent:[key stringDigestedViaMD5]] stringByAppendingString:@".bcache"];
    
    return finalPath;
}

- (void)putObject:(NSObject<NSCoding> *)object forKey:(NSString *)key {
    [self putObject:object forKey:key toBothDiskAndMemory:NO];
}

- (void)putObject:(NSObject<NSCoding> *)object forKey:(NSString *)key toBothDiskAndMemory:(BOOL)flag {
    [self.cacheLock withCriticalZone:^id{
        (self.memoryCache)[key] = object;
        return nil;
    }];
    
    if (flag) {
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:object forKey:@"CachedData"];
        [archiver encodeObject:[NSDate dateWithTimeIntervalSinceNow:0] forKey:@"LastModifiedDate"];
        [archiver finishEncoding];
        
        [data writeToFile:[self filePathForKey:key] options:kNilOptions error:nil];
    }
}

- (id)objectForKey:(NSString *)key {
    NSObject *obj = [self.cacheLock withCriticalZone:^id{
        return (self.memoryCache)[key];
    }];
    
    if (!obj) {
        NSString *filePath = [self filePathForKey:key];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
            NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
            obj = [unarchiver decodeObjectForKey:@"CachedData"];
            [unarchiver finishDecoding];
        }
    }
    
    return obj;
}

- (void)clearMemoryCaches {
    [self.cacheLock withCriticalZone:^id{
        [self.memoryCache removeAllObjects];
        return nil;
    }];
}

@end
