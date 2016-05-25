//
//  StartupImageParsingOperation.m
//  ZhihuDaily
//
//  Created by 杨弘宇 on 16/5/21.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

#import "StartupImageParsingOperation.h"
#import "URLDownloadingOperation.h"

@interface StartupImageParsingOperation ()

@property (readwrite, strong, nonatomic) UIImage *image;
@property (readwrite, copy, nonatomic) NSString *text;

@end

@implementation StartupImageParsingOperation

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
    
    NSString *imgURLString = ((NSDictionary *) obj)[@"img"];
    NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgURLString]];
    
    if (imgData) {
        self.image = [UIImage imageWithData:imgData];
    }
    
    self.text = ((NSDictionary *) obj)[@"text"];
    
    [self finish];
}

@end
