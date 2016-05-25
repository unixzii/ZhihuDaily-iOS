//
//  TimelineDataSource.h
//  ZhihuDaily
//
//  Created by 杨弘宇 on 16/5/21.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Timeline.h"

@interface TimelineDataSource : NSObject <UITableViewDataSource>

@property (copy, nonatomic) NSString *cellIdentifier;
@property (copy, nonatomic) NSArray<Timeline *> *timelines;

- (Story *)storyAtIndexPath:(NSIndexPath *)indexPath;

@end
