//
//  Message+CoreDataProperties.m
//  Fanner
//
//  Created by ZHANGMIA on 8/5/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Message+CoreDataProperties.h"

@implementation Message (CoreDataProperties)

@dynamic mid;
@dynamic text;
@dynamic sender_id;
@dynamic recipient_id;
@dynamic created_at;
@dynamic sender_screen_name;
@dynamic recipient_screen_name;
@dynamic sender;
@dynamic recipient;

@end
