//
//  Service.h
//  Fanner
//
//  Created by ZHANGMIA on 7/27/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Service : NSObject
- (void)authoriseWithUserName:(NSString *)userName password:(NSString *)password success:(void(^)(NSString *token, NSString *tokenSecret))success;

+ (instancetype)sharedInstance;

- (void)requestVertifyCredential:(NSDictionary *)parameters accessToken:(NSString *)accessToken tokenSecret:(NSString *)tokenSecret requestMethod:(NSString *)requestMethod success:(void(^)(NSDictionary *result))success;

@end
