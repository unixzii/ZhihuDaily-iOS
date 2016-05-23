//
//  TimelineParsingOperation.h
//  ZhihuDaily
//
//  Created by 杨弘宇 on 16/5/21.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

#import "ParsingOperation.h"
#import "Timeline.h"

@interface TimelineParsingOperation : ParsingOperation

@property (readonly, strong, nonatomic) Timeline *timeline;

@end
