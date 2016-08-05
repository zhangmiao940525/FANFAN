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

@end
