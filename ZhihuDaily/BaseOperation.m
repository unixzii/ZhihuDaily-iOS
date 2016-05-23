//
//  BaseOperation.m
//  ZhihuDaily
//
//  Created by 杨弘宇 on 16/5/21.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

#import "BaseOperation.h"
#import "NSLock+Helpers.h"

@interface BaseOperation () {
    OperationState _state;
}

@property (readwrite, assign, atomic) OperationState state;
@property (getter=errors, strong, nonatomic) NSArray *errors;
@property (getter=hasErrors, assign, nonatomic) BOOL hasErrors;
@property (readwrite, weak, nonatomic) NSOperationQueue *parentQueue;

@property (strong, nonatomic) NSLock *stateLock;
@property (strong, nonatomic) NSMutableArray<NSError *> *internalErrors;

@end

@implementation BaseOperation

+ (NSSet *)keyPathsForValuesAffectingIsReady {
    return [NSSet setWithObject:@"state"];
}

+ (NSSet *)keyPathsForValuesAffectingIsExecuting {
    return [NSSet setWithObject:@"state"];
}

+ (NSSet *)keyPathsForValuesAffectingIsFinished {
    return [NSSet setWithObject:@"state"];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.stateLock = [[NSLock alloc] init];
        self.internalErrors = [[NSMutableArray alloc] init];
    }
    return self;
}

- (BOOL)isReady {
    if (self.state >= OperationStateReady) {
        return super.ready || self.cancelled;
    }
    
    if ((self.state == OperationStateInitialized || self.state == OperationStatePending) && self.cancelled) {
        return YES;
    }
    
    if (self.state == OperationStatePending) {
        if (super.ready) {
            [self evaluateConditions];
        }
    }
    
    return NO;
}

- (BOOL)isExecuting {
    return self.state == OperationStateExecuting;
}

- (BOOL)isFinished {
    return self.state == OperationStateFinished;
}

- (void)start {
    [super start];
    
    if (self.cancelled) {
        [self finish];
    }
}

- (void)main {
    if (self.state != OperationStateReady) {
        NSLog(@"Invalid state.");
        abort();
    }
    
    if (self.cancelled || self.hasErrors) {
        [self finish];
    } else {
        __block BOOL needCancel = NO;
        
        [self.dependencies enumerateObjectsUsingBlock:^(NSOperation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[BaseOperation class]]) {
                if (((BaseOperation *) obj).hasErrors) {
                    needCancel = YES;
                    *stop = YES;
                }
            }
        }];
        
        if (needCancel) {
            [self finish];
            return;
        }
        
        self.state = OperationStateExecuting;
        
        [self executeMain];
    }
}

- (void)executeMain {
    NSLog(@"executeMain not implemented.");
    [self finish];
}

- (OperationState)state {
    return *(OperationState *) [[self.stateLock withCriticalZone:^id{
        return [NSValue valueWithPointer:&self->_state];
    }] pointerValue];
}

- (void)setState:(OperationState)state {
    [self willChangeValueForKey:@"state"];
    
    [self.stateLock withCriticalZone:^id{
        if (self->_state == OperationStateFinished) {
            return nil;
        }
        
        if (![self validateTranslationFromState:self->_state toState:state]) {
            NSLog(@"Invalid state translation");
            abort();
        }
        
        self->_state = state;
        
        return nil;
    }];
    
    [self didChangeValueForKey:@"state"];
}

- (NSArray *)errors {
    return [self.internalErrors copy];
}

- (BOOL)hasErrors {
    return self.internalErrors.count > 0;
}

- (BOOL)validateTranslationFromState:(OperationState)state toState:(OperationState)toState {
    if (state == OperationStateInitialized && toState == OperationStatePending) {
        return YES;
    }
    
    if (state == OperationStatePending && toState == OperationStateEvaluating) {
        return YES;
    }
    
    if (state == OperationStateEvaluating && toState == OperationStateReady) {
        return YES;
    }
    
    if (state == OperationStateReady && toState == OperationStateReady) {
        return YES;
    }
    
    if (state == OperationStateReady && toState == OperationStateExecuting) {
        return YES;
    }
    
    if (state == OperationStateReady && toState == OperationStateFinished) {
        return YES;
    }
    
    if (state == OperationStateExecuting && toState == OperationStateFinished) {
        return YES;
    }
    
    return NO;
}

- (void)evaluateConditions {
    self.state = OperationStateEvaluating;
    self.state = OperationStateReady; // TODO: not support conditions yet.
}

- (void)willEnqueue:(NSOperationQueue *)queue {
    self.state = OperationStatePending;
    self.parentQueue = queue;
}

- (void)finish {
    [self finishWithError:nil];
}

- (void)finishWithError:(NSError *)error {
    if (self.state == OperationStateFinished) {
        return;
    }
    
    if (error) {
        [self.internalErrors addObject:error];
    }
    
    self.state = OperationStateFinished;
}

@end
