//
//  Service+Photo.m
//  Fanner
//
//  Created by ZHANGMIA on 8/10/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "Service+Photo.h"
#import "APIContant.h"

@implementation Service (Photo)
- (void)getPhotosUserTimelineWithUserID:(NSString *)userID sucess:(void(^)(id result))sucess failure:(void (^)(NSError *error))failure; {
    
    NSDictionary *params = @{@"id":userID};
    [self requestWithPath:API_PHOTOS_TIMELINE parameters:params requestMethod:@"GET" success:sucess failure:failure];
}
@end
