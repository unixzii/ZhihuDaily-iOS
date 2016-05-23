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
    
    NSString *dateString = [((NSDictionary *) obj) objectForKey:@"date"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMdd";
    
    self.timeline.dateString = dateString;
    self.timeline.date = [formatter dateFromString:dateString];
    
    NSArray *stories = [((NSDictionary *) obj) objectForKey:@"stories"];
    NSArray *topStories = [((NSDictionary *) obj) objectForKey:@"top_stories"];
    
    [self inflateStories:stories forTop:NO];
    [self inflateStories:topStories forTop:YES];
    
    [self finish];
}

- (void)inflateStories:(NSArray *)stories forTop:(BOOL)top {
    [stories enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Story *story = [[Story alloc] init];
        story.title = [obj objectForKey:@"title"];
        story.storyId = [[obj objectForKey:@"id"] unsignedIntegerValue];
        
        if (top) {
            story.imageURL = [NSURL URLWithString:[obj objectForKey:@"image"]];
            [self.timeline.topStories addObject:story];
        } else {
            story.imageURL = [NSURL URLWithString:[[obj objectForKey:@"images"] firstObject]];
            [self.timeline.stories addObject:story];
        }
    }];
}

@end
