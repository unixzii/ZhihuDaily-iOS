//
//  BlockOperation.h
//  ZhihuDaily
//
//  Created by 杨弘宇 on 16/5/21.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

#import "BaseOperation.h"

@interface BlockOperation : BaseOperation

@property (assign, nonatomic) dispatch_queue_t dispatchQueue;
@property (copy, nonatomic) void(^block)();

+ (instancetype)mainQueueOperationWithBlock:(void(^)())block;
+ (instancetype)globalQueueOperationWithBlock:(void(^)())block;

@end
