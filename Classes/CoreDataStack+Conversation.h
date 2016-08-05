//
//  CoreDataStack+Conversation.h
//  Fanner
//
//  Created by ZHANGMIA on 8/5/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "CoreDataStack.h"
@class Conversation;

@interface CoreDataStack (Conversation)

- (Conversation *)insertOrUpdateConversationProfile:(NSDictionary *)profile;
- (void)addConversationsWithProfile:(NSArray *)profile;

@end
