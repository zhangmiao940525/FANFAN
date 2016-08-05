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
     NSString *mid = profile[@"id"];
   Message *msg = (Message *)[self findUniqueEntityWithUniqueKey:@"mid" value:mid entityName:MESSAGE_ENTITY];
    if (!msg) {
        [NSEntityDescription insertNewObjectForEntityForName:MESSAGE_ENTITY inManagedObjectContext:self.context];
    }
    
    NSString *text = profile[@"text"];
    NSString *sender_id = profile[@"sender_id"];
    NSString *recipient_id = profile[@"recipient_id"];
    NSString *created_at = profile[@"created_at"];
    
    NSString *sender_screen_name = profile[@"sender_screen_name"];
    NSString *recipient_screen_name = profile[@"recipient_screen_name"];
    NSDictionary *sender = profile[@"sender"];
    NSDictionary *recipient = profile[@"recipient"];
    
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

@end
