//
//  Service+Conversation.h
//  Fanner
//
//  Created by ZHANGMIA on 8/5/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "Service.h"

@interface Service (Conversation)
/** 返回一个conversation数组 */
- (void)conversationListWithSuccess:(void(^)(NSArray *result))success failure:(void(^)(NSError *error))failure;
/** 返回一个message数组 */
- (void)conversationsWithUserID:(NSString *)userID success:(void(^)(id result))success failure:(void(^)(NSError *error))failure;

@end
