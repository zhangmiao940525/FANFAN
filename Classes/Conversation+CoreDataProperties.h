//
//  Conversation+CoreDataProperties.h
//  Fanner
//
//  Created by ZHANGMIA on 8/5/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Conversation.h"
#import "Message.h"

NS_ASSUME_NONNULL_BEGIN

@interface Conversation (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *new_conv;
@property (nullable, nonatomic, retain) NSNumber *msg_num;
@property (nullable, nonatomic, retain) NSString *otherid;
@property (nullable, nonatomic, retain) Message *message;

@end

NS_ASSUME_NONNULL_END
