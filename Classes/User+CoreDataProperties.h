//
//  User+CoreDataProperties.h
//  Fanner
//
//  Created by ZHANGMIA on 8/1/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"
@class Status;

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *iconURL;
@property (nullable, nonatomic, retain) NSNumber *isActive;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *token;
@property (nullable, nonatomic, retain) NSString *tokenSecret;
@property (nullable, nonatomic, retain) NSString *uid;
@property (nullable, nonatomic, retain) NSSet<Status *> *statuses;

@end

@interface User (CoreDataGeneratedAccessors)

- (void)addStatusesObject:(Status *)value;
- (void)removeStatusesObject:(Status *)value;
- (void)addStatuses:(NSSet<Status *> *)values;
- (void)removeStatuses:(NSSet<Status *> *)values;

@end

NS_ASSUME_NONNULL_END
