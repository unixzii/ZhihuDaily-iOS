//
//  ImageDownloadingOperation.m
//  ZhihuDaily
//
//  Created by 杨弘宇 on 16/5/23.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

#import "ImageDownloadingOperation.h"
#import "CacheManager.h"

@interface ImageDownloadingOperation ()

@property (strong, nonatomic) NSURLSessionDataTask *task;

@end

@implementation ImageDownloadingOperation

+ (instancetype)operationWithURL:(NSURL *)URL forImageView:(UIImageView *)imageView {
    ImageDownloadingOperation *op = [[ImageDownloadingOperation alloc] init];
    op.URL = URL;
    op.targetImageView = imageView;
    
    return op;
}

- (void)executeMain {
    UIImage *cachedImage = [[CacheManager defaultManager] objectForKey:self.URL.absoluteString];
    if (cachedImage) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.targetImageView.image = cachedImage;
        });
        [self finish];
        return;
    }
    
    __weak typeof(ImageDownloadingOperation) *weakSelf = self;
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = 3.0;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    self.task = [session dataTaskWithURL:self.URL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            [weakSelf finishWithError:error];
        } else {
            UIImage *image = [UIImage imageWithData:data];
            if (image) {
                if (!weakSelf.cacheDisable) {
                    [[CacheManager defaultManager] putObject:image forKey:weakSelf.URL.absoluteString toBothDiskAndMemory:YES];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.targetImageView.image = image;
                });
                [weakSelf finish];
            } else {
                [weakSelf finishWithError:[NSError errorWithDomain:@"ErrorDomainUnknown" code:1 userInfo:nil]];
            }
            
        }
    }];
    
    [self.task resume];
}

- (void)cancel {
    [self.task cancel];
    
    [super cancel];
}

@end
