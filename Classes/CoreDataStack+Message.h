//
//  CoreDataStack+Message.h
//  Fanner
//
//  Created by ZHANGMIA on 8/5/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "CoreDataStack.h"
@class Message;

@interface CoreDataStack (Message)

- (Message *)insertOrUpdateMessageProfile:(NSDictionary *)profile;
- (void)addMessagesWitArray:(NSArray *)array;
// 从数据库查询所有的绘画msgs模型
- (NSArray *)fetchMessagesWithUserID:(NSString *)userID;
@end
