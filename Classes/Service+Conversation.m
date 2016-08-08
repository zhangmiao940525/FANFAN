//
//  Service+Conversation.m
//  Fanner
//
//  Created by ZHANGMIA on 8/5/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "Service+Conversation.h"
#import "APIContant.h"

@implementation Service (Conversation)

- (void)conversationListWithSuccess:(void(^)(NSArray *result))success failure:(void(^)(NSError *error))failure
{
    [self requestWithPath:API_CONVERSATION_LIST parameters:nil requestMethod:@"GET" success:success failure:failure ];
}

- (void)conversationsWithUserID:(NSString *)userID success:(void(^)(id result))success failure:(void(^)(NSError *error))failure
{
    NSDictionary *params = @{@"id":userID};
    [self requestWithPath:API_CONVERSATION parameters:params requestMethod:@"GET" success:success failure:failure];
}

@end
