//
//  URLDownloadingOperation.m
//  ZhihuDaily
//
//  Created by 杨弘宇 on 16/5/21.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

#import "URLDownloadingOperation.h"

@interface URLDownloadingOperation ()

@property (readwrite, copy, nonatomic) NSData *data;
@property (strong, nonatomic) NSURLSessionDataTask *task;

@end

@implementation URLDownloadingOperation

+ (instancetype)operationWithURL:(NSURL *)URL {
    URLDownloadingOperation *op = [[URLDownloadingOperation alloc] init];
    op.URL = URL;
    
    return op;
}

- (void)executeMain {
    __weak typeof(URLDownloadingOperation) *weakSelf = self;
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = 3.0;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    self.task = [session dataTaskWithURL:self.URL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            [weakSelf finishWithError:error];
        } else {
            weakSelf.data = data;
            [weakSelf finish];
        }
    }];
    
    [self.task resume];
}

- (void)cancel {
    [self.task cancel];
    
    [super cancel];
}

@end
