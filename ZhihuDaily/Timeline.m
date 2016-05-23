//
//  Timeline.m
//  ZhihuDaily
//
//  Created by 杨弘宇 on 16/5/21.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

#import "Timeline.h"

@implementation Timeline

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.stories = [[NSMutableArray alloc] init];
        self.topStories = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
