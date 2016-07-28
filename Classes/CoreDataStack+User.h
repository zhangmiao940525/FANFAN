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

- (void)insertOrUpdateWithUserProfile:(NSDictionary *)userProfile token:(NSString *)token tokenSecret:(NSString *)tokenSecret;

@end
