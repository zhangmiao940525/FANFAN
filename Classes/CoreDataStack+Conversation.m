//
//  CoreDataStack+Conversation.m
//  Fanner
//
//  Created by ZHANGMIA on 8/5/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "CoreDataStack+Conversation.h"
#import "Conversation.h"
#import "CoreDataStack+Common.h"
#import "EntityNameConstant.h"
#import "CoreDataStack+Message.h"

@implementation CoreDataStack (Conversation)

// 插入单条Conversation数据
/**
 服务器返回的是一个数组
 */
- (Conversation *)insertOrUpdateConversationProfile:(NSDictionary *)profile
{
    /**
     conversation_list 接口返回的数据 区别于conversation接口
     */
    NSString *otherid = profile[@"otherid"];
    NSString *msg_num = profile[@"msg_num"];
    NSString *new_conv = profile[@"new_conv"];
    // message字典
    NSDictionary *message = profile[@"dm"];
    
   Conversation *conversation = (Conversation *)[self findUniqueEntityWithUniqueKey:@"otherid" value:otherid entityName:CONVERSATION_ENTITY];
    
    if (!conversation) {
        // 插入
       conversation = [NSEntityDescription insertNewObjectForEntityForName:CONVERSATION_ENTITY inManagedObjectContext:self.context];
    }
    // 更新
    conversation.otherid = otherid;
    // NSString --> NSNumber(int)
    conversation.msg_num = @(msg_num.integerValue);
    // NSString --> NSNumber（BOOL）
    conversation.new_conv = @(new_conv.boolValue);
    
    // 插入到message
  Message *msg = [self insertOrUpdateMessageProfile:message];
    // 建立关系
    conversation.message = msg;
    
    // 保存到数据库
    [self saveContext];
    
    return conversation;
    
}
// 接口是convercation_list
// 接口返回的类型:json(NSArray数组)
// 接口数组的元素: 字典
// 把返回字典先插入到数据库，由insertOrUpdateConversationProfile实现
// 把数组里面的每一个字典用遍历的方法全部插入到数据库

- (void)addConversationsWithProfile:(NSArray *)profile
{
    // 同步插入
    [self.context performBlockAndWait:^{
        [profile enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self insertOrUpdateConversationProfile:obj];
        }];
    }];
    
    
}


@end
