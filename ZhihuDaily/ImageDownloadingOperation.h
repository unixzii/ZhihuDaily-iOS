//
//  ImageDownloadingOperation.h
//  ZhihuDaily
//
//  Created by 杨弘宇 on 16/5/23.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseOperation.h"

@interface ImageDownloadingOperation : BaseOperation

@property (copy, nonatomic) NSURL *URL;
@property (weak, nonatomic) UIImageView *targetImageView;
@property (assign, nonatomic) BOOL cacheDisable;

+ (instancetype)operationWithURL:(NSURL *)URL forImageView:(UIImageView *)imageView;

@end
