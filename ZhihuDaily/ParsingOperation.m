//
//  ParsingOperation.m
//  ZhihuDaily
//
//  Created by 杨弘宇 on 16/5/21.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

#import "ParsingOperation.h"
#import "URLDownloadingOperation.h"

@implementation ParsingOperation

- (NSData *)data {
    __block NSData *inputData = self->_data;
    
    if (!inputData) {
        [self.dependencies enumerateObjectsUsingBlock:^(NSOperation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[URLDownloadingOperation class]]) {
                inputData = ((URLDownloadingOperation *) obj).data;
                
                if (inputData) {
                    *stop = YES;
                }
            }
        }];
    }
    
    if (!inputData) {
        [self finishWithError:[NSError errorWithDomain:@"ErrorDomainInvalidParameter" code:1 userInfo:nil]];
        return nil;
    }
    
    return inputData;
}

@end
