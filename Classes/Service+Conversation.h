//
//  Service+Conversation.h
//  Fanner
//
//  Created by ZHANGMIA on 8/5/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "Service.h"

@interface Service (Conversation)

- (void)conversationListWithSuccess:(void(^)(NSArray *result))success failure:(void(^)(NSError *error))failure;

@end
