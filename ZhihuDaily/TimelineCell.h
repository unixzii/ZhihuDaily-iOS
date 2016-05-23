//
//  TimelineCell.h
//  ZhihuDaily
//
//  Created by 杨弘宇 on 16/5/21.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
#import "Story.h"

@interface TimelineCell : BaseTableViewCell

- (void)loadWithStory:(Story *)story;

@end
