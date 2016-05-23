//
//  StoryBodyParsingOperation.h
//  ZhihuDaily
//
//  Created by 杨弘宇 on 16/5/22.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

#import "ParsingOperation.h"
#import "Story.h"

@interface StoryBodyParsingOperation : ParsingOperation

@property (weak, nonatomic) Story *story;

@end
