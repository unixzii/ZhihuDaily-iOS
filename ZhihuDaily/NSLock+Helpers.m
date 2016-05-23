//
//  NSLock+Helpers.m
//  ZhihuDaily
//
//  Created by 杨弘宇 on 16/5/21.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

#import "NSLock+Helpers.h"

@implementation NSLock (Helpers)

- (id)withCriticalZone:(id(^)())block {
    [self lock];
    id obj = block();
    [self unlock];
    
    return obj;
}

@end
