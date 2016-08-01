//
//  CoreDataStack+Status.m
//  Fanner
//
//  Created by ZHANGMIA on 7/29/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "CoreDataStack+Status.h"
#import "Status.h"
#import "CoreDataStack+User.h"
#import "Photo.h"

static NSString *const STATUS_ENTITY = @"Status";
static NSString *const PHOTO_ENTITY = @"Photo";

@implementation CoreDataStack (Status)



- (Status *)checkImportedWithStatusID:(NSString *)sid
{
    NSFetchRequest *fr = [[NSFetchRequest alloc] initWithEntityName:STATUS_ENTITY];
    //
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sid = %@",sid];
    fr.predicate = predicate;
    // 执行查询
    NSError *error;
    NSArray *status = [self.context executeFetchRequest:fr error:&error];
    if (status.count > 0) {
        return status[0];
    }
    return nil;
}

- (Status *)insertOrUpdateWithStatusProfile:(NSDictionary *)statusProfile
{
    // 取出微博 字典id
    Status *status = [self checkImportedWithStatusID:statusProfile[@"id"]];
    // 取出照片
    Photo *photo = status.photo;
    
    if (!status) {
        status = [NSEntityDescription insertNewObjectForEntityForName:STATUS_ENTITY inManagedObjectContext:self.context];
        if (!photo) {
            // 插入用户发布的图片
            photo = [NSEntityDescription insertNewObjectForEntityForName:PHOTO_ENTITY inManagedObjectContext:self.context];
        }
    }
    // 更新用户发布的图片 （photo表）
    NSDictionary *photoDic = statusProfile[@"photo"];
    photo.imageurl = photoDic[@"imageurl"];
    photo.thumburl = photoDic[@"thumburl"];
    photo.largeurl = photoDic[@"largeurl"];
    
    // 建立status和photo的关系 (更新关系）
    status.photo = photo;
    
    // 更新status表
    status.sid = statusProfile[@"id"];
    status.source = statusProfile[@"source"];
    status.text = statusProfile[@"text"];
    
    NSString *dataStr = statusProfile[@"created_at"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"E MM dd HH:mm:ssZZZZZ yyyy";
    status.created_at = [formatter dateFromString:dataStr];
    
   // NSLog(@"created_at = %@",status.created_at);
   
    
    
    return status;
}

- (void)insertStatusWithArrayProfile:(NSArray *)arrayProfile
{
    // obj 是字典
    [arrayProfile enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [self.context performBlockAndWait:^{
            // 插入status
            Status *status = [self insertOrUpdateWithStatusProfile:obj]; // 同步插入
            // 插入user
            User *user = [self insertOrUpdateWithUserProfile:obj[@"user"] token:nil tokenSecret:nil];
            
            // 设置表与表之间的关系
            status.user = user;
        }];
        
        
    }];
}

@end
