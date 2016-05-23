//
//  StartupImageParsingOperation.h
//  ZhihuDaily
//
//  Created by 杨弘宇 on 16/5/21.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParsingOperation.h"

@interface StartupImageParsingOperation : ParsingOperation

@property (readonly, strong, nonatomic) UIImage *image;
@property (readonly, copy, nonatomic) NSString *text;

@end
