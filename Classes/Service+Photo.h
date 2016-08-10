//
//  Service+Photo.h
//  Fanner
//
//  Created by ZHANGMIA on 8/10/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "Service.h"

@interface Service (Photo)
- (void)getPhotosUserTimelineWithUserID:(NSString *)userID sucess:(void(^)(id result))sucess failure:(void (^)(NSError *error))failure;
@end
