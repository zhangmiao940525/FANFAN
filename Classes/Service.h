//
//  Service.h
//  Fanner
//
//  Created by ZHANGMIA on 7/27/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Service : NSObject
/** 单例 */
+ (instancetype)sharedInstance;

/** XAuth授权 */
- (void)authoriseWithUserName:(NSString *)userName password:(NSString *)password success:(void(^)(NSString *token, NSString *tokenSecret))success;

/** 请求用户数据 */
- (void)requestVertifyCredential:(NSDictionary *)parameters accessToken:(NSString *)accessToken tokenSecret:(NSString *)tokenSecret requestMethod:(NSString *)requestMethod success:(void(^)(NSDictionary *result))success;

- (void)requestWithPath:(NSString *)path parameters:(NSDictionary *)parameters requestMethod:(NSString *)requestMethod success:(void (^)(NSArray *result))success failure:(void(^)(NSError *error))failure;

/** 请求HomeTimeline的数据 （首页加载的数据） */
- (void)requestStatusWithSuccess:(void (^)(NSArray *result))success failure:(void(^)(NSError *error))failure;
/** 发饭的接口 包括文本、图片 */
- (void)postData:(NSString *)text imageData:(NSData *)imageData replyToStatusID:(NSString *)replyToStatusID repostStatusID:(NSString *)repostStatusID success:(void (^)(NSArray *result))success failure:(void(^)(NSError *error))failure;

/** 收藏 */
- (void)starWithStatusID:(NSString *)statusID success:(void(^)(id result))success failure:(void(^)(NSError *error))failure;



@end
