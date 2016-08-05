//
//  Message+CoreDataProperties.h
//  Fanner
//
//  Created by ZHANGMIA on 8/5/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Message.h"

NS_ASSUME_NONNULL_BEGIN

@interface Message (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *mid;
@property (nullable, nonatomic, retain) NSString *text;
@property (nullable, nonatomic, retain) NSString *sender_id;
@property (nullable, nonatomic, retain) NSString *recipient_id;
@property (nullable, nonatomic, retain) NSDate *created_at;
@property (nullable, nonatomic, retain) NSString *sender_screen_name;
@property (nullable, nonatomic, retain) NSString *recipient_screen_name;
@property (nullable, nonatomic, retain) User *sender;
@property (nullable, nonatomic, retain) User *recipient;

@end

NS_ASSUME_NONNULL_END
