//
//  CoreDataStack+Common.m
//  Fanner
//
//  Created by ZHANGMIA on 8/5/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "CoreDataStack+Common.h"

@implementation CoreDataStack (Common)
// 获取某条数据
// 例如 User key ＝ uid , value ＝ ～jdhhask
- (NSManagedObject *)findUniqueEntityWithUniqueKey:(NSString *)key value:(id)value entityName:(NSString *)entityName
{
    NSFetchRequest *fr = [[NSFetchRequest alloc] initWithEntityName:entityName];
    //
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@",key, value];
    fr.predicate = predicate;
    // 执行查询
    NSError *error;
    NSArray *users = [self.context executeFetchRequest:fr error:&error];
    if (users.count > 0) {
        return users[0];
    }
    return nil;
}

- (NSDate *)dateFromString:(NSString *)dateStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"E MM dd HH:mm:ssZZZZZ yyyy";
    NSDate *createDate = [dateFormatter dateFromString:dateStr];
    
    return createDate;

}

@end
