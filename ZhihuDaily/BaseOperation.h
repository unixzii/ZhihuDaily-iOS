//
//  BaseOperation.h
//  ZhihuDaily
//
//  Created by 杨弘宇 on 16/5/21.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, OperationState) {
    OperationStateInitialized,
    OperationStatePending,
    OperationStateEvaluating,
    OperationStateReady,
    OperationStateExecuting,
    OperationStateFinished
};

@interface BaseOperation : NSOperation

@property (readonly, assign, atomic) OperationState state;
@property (readonly, strong, nonatomic) NSArray *errors;
@property (readonly, assign, nonatomic) BOOL hasErrors;
@property (readonly, weak, nonatomic) NSOperationQueue *parentQueue;

- (void)willEnqueue:(NSOperationQueue *)queue;

- (void)executeMain;

- (void)finish;
- (void)finishWithError:(NSError *)error;

@end
