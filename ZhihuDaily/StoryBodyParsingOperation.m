//
//  StoryBodyParsingOperation.m
//  ZhihuDaily
//
//  Created by 杨弘宇 on 16/5/22.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

#import "StoryBodyParsingOperation.h"
#import "StoryBody.h"

@implementation StoryBodyParsingOperation

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
    
    self.story.body = [[StoryBody alloc] init];
    self.story.body.htmlString = ((NSDictionary *) obj)[@"body"];
    self.story.body.cssString = [((NSDictionary *) obj)[@"css"] firstObject];
    self.story.body.imageSource = ((NSDictionary *) obj)[@"image_source"];
    self.story.body.shareURL = [NSURL URLWithString:((NSDictionary *) obj)[@"share_url"]];
    
    [self finish];
}

@end
