//
//  Story.h
//  ZhihuDaily
//
//  Created by 杨弘宇 on 16/5/21.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StoryBody.h"

@interface Story : NSObject

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSURL *imageURL;
@property (assign, nonatomic) NSUInteger storyId;
@property (strong, nonatomic) StoryBody *body;

@end
