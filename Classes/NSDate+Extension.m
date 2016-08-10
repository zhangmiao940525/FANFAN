//
//  NSDate+Extension.m
//  Fanner
//
//  Created by ZHANGMIA on 8/9/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

- (NSString *)defaultDateString
{
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    formater.dateStyle = NSDateFormatterShortStyle;
    formater.timeStyle = NSDateFormatterShortStyle;
    return  [formater stringFromDate:self];
}

@end
