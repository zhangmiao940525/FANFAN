//
//  CoreDataStack+User.m
//  Fanner
//
//  Created by ZHANGMIA on 7/26/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "CoreDataStack+User.h"
#import "User.h"
#import "CoreDataStack+Common.h"
#import "EntityNameConstant.h"

@implementation CoreDataStack (User)
@dynamic currentUser;


- (User *)currentUser
{
   
    User *user = (User *)[self findUniqueEntityWithUniqueKey:@"isActive"  value:@YES entityName:USER_ENTITY];
    return user;
}

// 根据用户ID查找用户数据
- (User *)findUserWithId:(NSString *)uid
{
    User *user = (User *)[self findUniqueEntityWithUniqueKey:@"uid" value:uid entityName:USER_ENTITY];
    return user;
}

// 如果用户不存在就插入数据，如果用户存在就更新数据
- (User *)insertOrUpdateWithUserProfile:(NSDictionary *)userProfile token:(NSString *)token tokenSecret:(NSString *)tokenSecret
{
    // 检测数据库是否已知有该条数据插入
    // 数据为空则插入一条新的数据 有则更像这条数据
    User *user = (User *)[self findUniqueEntityWithUniqueKey:@"uid" value:userProfile[@"id"] entityName:USER_ENTITY];
    
    if (!user) {
        // 插入
        user = [NSEntityDescription insertNewObjectForEntityForName:USER_ENTITY inManagedObjectContext:self.context];
    }
    
    // 更新
    user.name = userProfile[@"name"];
    user.uid = userProfile[@"id"];
    user.iconURL = userProfile[@"profile_image_url"];
    
    user.followers_count = userProfile[@"followers_count"];
    user.friends_count = userProfile[@"friends_count"];
    user.statuses_count = userProfile[@"statuses_count"];
    user.favourites_count = userProfile[@"favourites_count"];

    // 请求api
    if (token) {
        user.token = token;
    }
    if (tokenSecret) {
        user.tokenSecret = tokenSecret;
    }
    // 保存到数据库
    [self saveContext];
    
    return user;
}

@end
