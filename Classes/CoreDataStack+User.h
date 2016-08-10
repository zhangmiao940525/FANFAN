//
//  CoreDataStack+User.h
//  Fanner
//
//  Created by ZHANGMIA on 7/26/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "CoreDataStack.h"
@class User;

@interface CoreDataStack (User)

// 当前用户
@property (nonatomic,strong)User *currentUser;

- (User *)insertOrUpdateWithUserProfile:(NSDictionary *)userProfile token:(NSString *)token tokenSecret:(NSString *)tokenSecret;
// 根据用户ID查找用户数据
- (User *)findUserWithId:(NSString *)uid;
@end
