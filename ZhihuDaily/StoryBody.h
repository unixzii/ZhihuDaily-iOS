//
//  StoryBody.h
//  ZhihuDaily
//
//  Created by 杨弘宇 on 16/5/21.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoryBody : NSObject

@property (copy, nonatomic) NSString *htmlString;
@property (strong, nonatomic) NSString *cssString;
@property (strong, nonatomic) NSString *imageSource;
@property (copy, nonatomic) NSURL *shareURL;

@end
