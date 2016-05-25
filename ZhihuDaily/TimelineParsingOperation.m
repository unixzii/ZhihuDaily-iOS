//
//  TimelineParsingOperation.m
//  ZhihuDaily
//
//  Created by 杨弘宇 on 16/5/21.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

#import "TimelineParsingOperation.h"

@interface TimelineParsingOperation ()

@property (readwrite, strong, nonatomic) Timeline *timeline;

@end

@implementation TimelineParsingOperation

- (void)executeMain {
    NSError *error;
    
    NSObject *obj = [NSJSONSerialization JSONObjectWithData:self.data options:kNilOptions error:&error];
    
    if (error) {
        [self finishWithError:error];
        return;
    }
    
    if (![obj isKindOfClass:[NSDictionary class]]) {
        [self finishWithError:[NSError errorWithDomain:@"ErrorDomainUnknown" code:1 userInfo:nil]];
        return;
    }
    
    self.timeline = [[Timeline alloc] init];
    
    NSString *dateString = ((NSDictionary *) obj)[@"date"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMdd";
    
    self.timeline.dateString = dateString;
    self.timeline.date = [formatter dateFromString:dateString];
    
    NSArray *stories = ((NSDictionary *) obj)[@"stories"];
    NSArray *topStories = ((NSDictionary *) obj)[@"top_stories"];
    
    [self inflateStories:stories forTop:NO];
    [self inflateStories:topStories forTop:YES];
    
    [self finish];
}

- (void)inflateStories:(NSArray *)stories forTop:(BOOL)top {
    NSMutableArray<Story *> *storyModels = [[NSMutableArray alloc] init];
    
    [stories enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Story *story = [[Story alloc] init];
        story.title = obj[@"title"];
        story.storyId = [obj[@"id"] unsignedIntegerValue];
        
        if (top) {
            story.imageURL = [NSURL URLWithString:obj[@"image"]];
        } else {
            story.imageURL = [NSURL URLWithString:[obj[@"images"] firstObject]];
        }
        
        [storyModels addObject:story];
    }];
    
    if (top) {
        self.timeline.topStories = storyModels;
    } else {
        self.timeline.stories = storyModels;
    }
}

@end
