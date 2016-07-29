//
//  Service.m
//  Fanner
//
//  Created by ZHANGMIA on 7/27/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "Service.h"
#import <TDOAuth.h>
#import "APIContant.h"
#import "CoreDataStack.h"
#import "CoreDataStack+User.h"
#import "APIContant.h"
#import "User+CoreDataProperties.h"

@interface Service ()

@property (nonatomic,strong)NSURLSession *session;

@end

@implementation Service
//AcessToken:(NSString *)token tokenSecret:(NSString *)tokenSecret

// 登录验证 最终目的是获取到access_token 和 access_secret
- (void)authoriseWithUserName:(NSString *)userName password:(NSString *)password success:(void(^)(NSString *token, NSString *tokenSecret))success
{
    
    NSURLRequest *request = [TDOAuth URLRequestForPath:API_ACCESS_TOKEN
                                         GETParameters:[NSDictionary dictionaryWithObjectsAndKeys:
                                                        userName, @"x_auth_username",
                                                        password, @"x_auth_password",
                                                        @"client_auth", @"x_auth_mode",
                                                        nil]
                                                  host:FANFOU_BASE_HOST
                                           consumerKey:API_OAUTH_CONSUMER_KEY
                                        consumerSecret:API_OAUTH_CONSUMERSECRET
                                           accessToken:nil
                                           tokenSecret:nil];
    // 下载
    NSURLSessionDataTask *task = [_session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",str);
        NSArray *sp1 = [str componentsSeparatedByString:@"="];
        NSLog(@"sp1 = %@", sp1);
        NSString *tokenSecret = sp1[2];
        NSLog(@"tokenSecret = %@", tokenSecret);
        NSString *ele1 = sp1[1];
        NSLog(@"ele1 = %@", ele1);
        
        NSArray *sp2 = [ele1 componentsSeparatedByString:@"&"];
        NSLog(@"sp2 = %@", sp2);
        NSString *token = sp2[0];
        NSLog(@"token = %@", token);
        
        success(token,tokenSecret);
        
        
        
    }];
    // 发送请求
    [task resume];
}

- (void)requestVertifyCredential:(NSDictionary *)parameters accessToken:(NSString *)accessToken tokenSecret:(NSString *)tokenSecret requestMethod:(NSString *)requestMethod success:(void(^)(NSDictionary *result))success
{
    NSURLRequest *request = [TDOAuth URLRequestForPath:API_VERIFY_CREDENTIAL parameters:parameters host:FANFOU_API_HOST consumerKey:API_OAUTH_CONSUMER_KEY consumerSecret:API_OAUTH_CONSUMERSECRET accessToken:accessToken tokenSecret:tokenSecret scheme:@"http" requestMethod:requestMethod dataEncoding:TDOAuthContentTypeUrlEncodedForm headerValues:nil signatureMethod:TDOAuthSignatureMethodHmacSha1];
    
    
    NSURLSessionDataTask *task = [_session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        NSLog(@"%@",result);
        [[CoreDataStack sharedCoreDataStack] insertOrUpdateWithUserProfile:result token:accessToken tokenSecret:tokenSecret];
        success(result);
    }];
    [task resume];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 管理请求
        // 抽象类专门用来配置
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.timeoutIntervalForRequest = 30.0;
        _session = [NSURLSession sessionWithConfiguration:configuration];
        
    }
    return self;
}

+ (instancetype)sharedInstance
{
    static Service *service;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[Service alloc] init];
        
    });
    return service;
}


#pragma mark - Base Request
- (void)requestWithPath:(NSString *)path parameters:(NSDictionary *)parameters accessToken:(NSString *)accessToken tokenSecret:(NSString *)tokenSecret requestMethod:(NSString *)requestMethod success:(void (^)(NSArray *result))success failure:(void(^)(NSError *error))failure
{
    NSURLRequest *request = [TDOAuth URLRequestForPath:path parameters:parameters host:FANFOU_API_HOST consumerKey:API_OAUTH_CONSUMER_KEY consumerSecret:API_OAUTH_CONSUMERSECRET accessToken:accessToken tokenSecret:tokenSecret scheme:@"http" requestMethod:requestMethod dataEncoding:TDOAuthContentTypeUrlEncodedForm headerValues:nil signatureMethod:TDOAuthSignatureMethodHmacSha1];
    
    NSURLSessionDataTask *task = [_session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            failure(error);
        } else {
            NSArray *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            NSLog(@"%@",result);
            
            success(result);
        }
    }];
    [task resume];
    
}

#pragma mark - Status
- (void)requestStatusWithSuccess:(void (^)(NSArray *result))success failure:(void(^)(NSError *error))failure
{
    
    User *user = [CoreDataStack sharedCoreDataStack].currentUser;
    
    
    [self requestWithPath:API_HOME_TIMELINE parameters:nil accessToken:user.token tokenSecret:user.tokenSecret requestMethod:@"GET" success:success failure:failure];
    
}

@end
