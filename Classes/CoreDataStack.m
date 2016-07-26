//
//  CoreDataStack.m
//  Fanner
//
//  Created by ZHANGMIA on 7/26/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "CoreDataStack.h"

@interface CoreDataStack ()

@property (nonatomic,strong)NSManagedObjectModel *model;
@property (nonatomic,strong)NSPersistentStoreCoordinator *coordinator;

@end

@implementation CoreDataStack

+ (instancetype)sharedCoreDataStack
{
    static CoreDataStack *coreDataStack = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        coreDataStack = [[CoreDataStack alloc] init];
    });
    return coreDataStack;
}

- (NSManagedObjectModel *)model
{
    if (_model) {
        
        // 1. 方法一
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
        _model = [[NSManagedObjectModel alloc] initWithContentsOfURL:url];
        
        // 2. 方法二
        // _model = [NSManagedObjectModel mergedModelFromBundles:nil];
    }
    
    return _model;
}

/** 创建SQLite数据库*/
- (NSURL *)docmentURL
{
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSArray *urls = [fm URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    return urls[0];
}

// 1.创建 NSPersistentStoreCoordinator

- (NSPersistentStoreCoordinator *)coordinator
{
    if (_coordinator == nil) {
        //
        _coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.model];
        // 数据库存储方式：NSPersistentStoreCoordinator 持久化存储协调者
        // 指定数据存储类型和位置
        
        NSURL *sqliteURL = [[self docmentURL] URLByAppendingPathComponent:@"Model.sqlite"];
        
        NSError *error;
        NSPersistentStore *store = [_coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:sqliteURL options:nil error:&error];
        if (!store) {
            NSLog(@"error = %@",error.description);
        }
    }
    
    return _coordinator;
}

// 2.

- (NSManagedObjectContext *)context
{
    if (_context == nil) {
        // NSMainQueueConcurrencyType 并发（异步）
        _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    }
    
    return _context;
}

- (void)saveContext
{
    NSError *error;
    if (![_context save:&error]) {
        NSLog(@"%@", error.description);
    } ;
}




@end
