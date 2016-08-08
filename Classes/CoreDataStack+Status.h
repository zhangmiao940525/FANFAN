//
//  CoreDataStack+Status.h
//  Fanner
//
//  Created by ZHANGMIA on 7/29/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//
//  管理模型类

#import "CoreDataStack.h"
@class Status;
@interface CoreDataStack (Status)

//
- (Status *)insertOrUpdateWithStatusProfile:(id)statusProfile;
//
- (void)insertStatusWithArrayProfile:(NSArray *)arrayProfile;

@end
