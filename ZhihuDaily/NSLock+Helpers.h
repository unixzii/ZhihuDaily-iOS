//
//  NSLock+Helpers.h
//  ZhihuDaily
//
//  Created by 杨弘宇 on 16/5/21.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSLock (Helpers)

- (id)withCriticalZone:(id(^)())block;

@end
