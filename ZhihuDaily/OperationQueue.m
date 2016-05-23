//
//  OperationQueue.m
//  ZhihuDaily
//
//  Created by 杨弘宇 on 16/5/21.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

#import "OperationQueue.h"
#import "BaseOperation.h"

@implementation OperationQueue

+ (instancetype)globalQueue {
    static OperationQueue *GlobalQueue = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        GlobalQueue = [[OperationQueue alloc] init];
    });
    
    return GlobalQueue;
}

- (void)addOperation:(NSOperation *)op {
    if ([op isKindOfClass:[BaseOperation class]]) {
        [((BaseOperation *) op) willEnqueue:self];
    }
    
    [super addOperation:op];
}

@end
