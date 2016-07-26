//
//  CoreDataStack.h
//  Fanner
//
//  Created by ZHANGMIA on 7/26/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataStack : NSObject

@property (nonatomic,strong)NSManagedObjectContext *context;

+ (instancetype)sharedCoreDataStack;

// 把context的内容保存到沙盒
- (void)saveContext;

@end
