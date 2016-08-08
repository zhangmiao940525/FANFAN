//
//  CoreDataStack+Message.m
//  Fanner
//
//  Created by ZHANGMIA on 8/5/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "CoreDataStack+Message.h"
#import "Message.h"
#import "CoreDataStack+Common.h"
#import "EntityNameConstant.h"
#import "CoreDataStack+User.h"

@implementation CoreDataStack (Message)

- (Message *)insertOrUpdateMessageProfile:(NSDictionary *)profile
{
    /**
     *   conversation－list 返回的字典包含的内容
     */
    
    // Profile返回的是接口哪个部分？
    // conversation－list 返回的字典中的键值dm所对应的值（字典）
    
    NSString *text = profile[@"text"];
    NSString *sender_id = profile[@"sender_id"];
    NSString *recipient_id = profile[@"recipient_id"];
    NSString *created_at = profile[@"created_at"];
    
    NSString *sender_screen_name = profile[@"sender_screen_name"];
    NSString *recipient_screen_name = profile[@"recipient_screen_name"];
    NSDictionary *sender = profile[@"sender"];
    NSDictionary *recipient = profile[@"recipient"];
    NSString *mid = profile[@"id"];
    
    Message *msg = (Message *)[self findUniqueEntityWithUniqueKey:@"mid" value:mid entityName:MESSAGE_ENTITY];
    if (!msg) {
        msg = [NSEntityDescription insertNewObjectForEntityForName:MESSAGE_ENTITY inManagedObjectContext:self.context];
    }
    
    msg.mid = mid;
    msg.text = text;
    msg.sender_id = sender_id;
    msg.recipient_id = recipient_id;
    msg.created_at = [self dateFromString:created_at];
    msg.sender_screen_name = sender_screen_name;
    msg.recipient_screen_name = recipient_screen_name;
    
    // 插入用户表
    User *senderPro = [self insertOrUpdateWithUserProfile:sender token:nil tokenSecret:nil];
    User *recipientPro = [self insertOrUpdateWithUserProfile:recipient token:nil tokenSecret:nil];
    
    msg.sender = senderPro;
    msg.recipient = recipientPro;
    
    return msg;
}

- (void)addMessagesWitArray:(NSArray *)array
{
    
   // 将每一个message模型添加到数据库
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.context performBlockAndWait:^{
            // 插入数据时需要保证是同步插入
            [self insertOrUpdateMessageProfile:obj];
        }];
    }];
}

// 从数据库查询所有的msgs模型
- (NSArray *)fetchMessagesWithUserID:(NSString *)userID
{
    // 1.创建一个NSFetchRequest 查询请求
    NSFetchRequest *fr = [[NSFetchRequest alloc] initWithEntityName:CONVERSATION_ENTITY];
    // 2.创建NSPredicate 查询条件
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"sender_id = %@ OR  recipient_id = %@", userID, userID];
    fr.predicate = pre;
    // 3.创建一个NSSortDescription 排序条件
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"created_at" ascending:YES];
    fr.sortDescriptors = @[sortDescriptor];
    
NSError *error;
    // 4.在内存数据库context里执行查询 返回给我数组模型
   NSArray *msgArr = [self.context executeFetchRequest:fr error:&error];
    if (error) {
        NSLog(@"%@", error.description);
    }
    return msgArr;
}

@end
