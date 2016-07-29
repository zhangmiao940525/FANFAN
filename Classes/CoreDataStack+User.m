//
//  CoreDataStack+User.m
//  Fanner
//
//  Created by ZHANGMIA on 7/26/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "CoreDataStack+User.h"
#import "User.h"

NSString *const USER_ENTITY = @"User";

@implementation CoreDataStack (User)
@dynamic currentUser;

- (User *)currentUser
{
    NSFetchRequest *fr = [[NSFetchRequest alloc] initWithEntityName:USER_ENTITY];
    //
   // NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isActive = %@",@YES];
  //  fr.predicate = predicate;
    // 执行查询
    NSError *error;
    NSArray *users = [self.context executeFetchRequest:fr error:&error];
    if (users.count > 0) {
        return users[0];
    }
    return nil;
}

- (User *)checkImportedWithUserID:(NSString *)uid
{
    NSFetchRequest *fr = [[NSFetchRequest alloc] initWithEntityName:USER_ENTITY];
    //
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid = %@",uid];
    fr.predicate = predicate;
    // 执行查询
    NSError *error;
    NSArray *users = [self.context executeFetchRequest:fr error:&error];
    if (users.count > 0) {
        return users[0];
    }
    return nil;
}

// 如果用户不存在就插入数据，如果用户存在就更新数据
- (User *)insertOrUpdateWithUserProfile:(NSDictionary *)userProfile token:(NSString *)token tokenSecret:(NSString *)tokenSecret
{
    // 检测id是否存在
    User *user = [self checkImportedWithUserID:userProfile[@"id"]];
    if (!user) {
        user = [NSEntityDescription insertNewObjectForEntityForName:USER_ENTITY inManagedObjectContext:self.context];
    }
    user.name = userProfile[@"name"];
    user.uid = userProfile[@"id"];
    user.iconURL = userProfile[@"profile_image_url"];
    user.token = token;
    user.tokenSecret = tokenSecret;
    
    return user;
}

@end
