//
//  URLDownloadingOperation.h
//  ZhihuDaily
//
//  Created by 杨弘宇 on 16/5/21.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

#import "BaseOperation.h"

@interface URLDownloadingOperation : BaseOperation

@property (copy, nonatomic) NSURL *URL;
@property (readonly, copy, nonatomic) NSData *data;

+ (instancetype)operationWithURL:(NSURL *)URL;

@end
