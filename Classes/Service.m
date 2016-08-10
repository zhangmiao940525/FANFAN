//
//  Service.m
//  Fanner
//
//  Created by ZHANGMIA on 7/27/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//
//#ifdef DEBUG
//#define NSLog(FORMAT, ...) fprintf(stderr,"\n %s:%d   %s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],__LINE__, [[[NSString alloc] initWithData:[[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] dataUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding] UTF8String]);
//#else
//#define NSLog(...)
//#endif

#import "Service.h"
#import <TDOAuth.h>
#import "APIContant.h"
#import "CoreDataStack+User.h"
#import "User.h"

@interface Service ()

@property (nonatomic,strong)NSURLSession *session;

@end

@implementation Service

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

#pragma mark - XAuth授权
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
       
        NSArray *sp1 = [str componentsSeparatedByString:@"="];
        
        NSString *tokenSecret = sp1[2];
        //NSLog(@"tokenSecret = %@", tokenSecret);
        NSString *ele1 = sp1[1];
        
        
        NSArray *sp2 = [ele1 componentsSeparatedByString:@"&"];
        
        NSString *token = sp2[0];
        //NSLog(@"token = %@", token);
        
        success(token,tokenSecret);
        
        
        
    }];
    // 发送请求
    [task resume];
}
// 获取用户信息
- (void)requestVertifyCredential:(NSDictionary *)parameters accessToken:(NSString *)accessToken tokenSecret:(NSString *)tokenSecret requestMethod:(NSString *)requestMethod success:(void(^)(NSDictionary *result))success
{
    NSURLRequest *request = [TDOAuth URLRequestForPath:API_VERIFY_CREDENTIAL parameters:parameters host:FANFOU_API_HOST consumerKey:API_OAUTH_CONSUMER_KEY consumerSecret:API_OAUTH_CONSUMERSECRET accessToken:accessToken tokenSecret:tokenSecret scheme:@"http" requestMethod:requestMethod dataEncoding:TDOAuthContentTypeUrlEncodedForm headerValues:nil signatureMethod:TDOAuthSignatureMethodHmacSha1];
    
    
    NSURLSessionDataTask *task = [_session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        //NSLog(@"%@",result);
        [[CoreDataStack sharedCoreDataStack] insertOrUpdateWithUserProfile:result token:accessToken tokenSecret:tokenSecret];
        success(result);
    }];
    [task resume];
}


#pragma mark - Base Request

// 授权的时候要使用
// 重构base1 request方法， 把和access_token有关的参数放到方法外部
- (void)requestWithPath:(NSString *)path parameters:(NSDictionary *)parameters requestMethod:(NSString *)requestMethod success:(void (^)(NSArray *result))success failure:(void(^)(NSError *error))failure
{
    User *user = [CoreDataStack sharedCoreDataStack].currentUser;
    
    NSURLRequest *request = [TDOAuth URLRequestForPath:path parameters:parameters host:FANFOU_API_HOST consumerKey:API_OAUTH_CONSUMER_KEY consumerSecret:API_OAUTH_CONSUMERSECRET accessToken:user.token tokenSecret:user.tokenSecret scheme:@"http" requestMethod:requestMethod dataEncoding:TDOAuthContentTypeUrlEncodedForm headerValues:nil signatureMethod:TDOAuthSignatureMethodHmacSha1];
    
    NSURLSessionDataTask *task = [_session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            failure(error);
            NSLog(@"%@",error.description);
        } else {
            NSArray *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
          
           // 这里主要是Ui更新 所以一定要在主线程上
            dispatch_async(dispatch_get_main_queue(), ^{
                success(result);
            });
            
        }
    }];
    [task resume];
    
}

// base重构
- (void)requestWithPath:(NSString *)path parameters:(NSDictionary *)parameters accessToken:(NSString *)accessToken tokenSecret:(NSString *)tokenSecret requestMethod:(NSString *)requestMethod success:(void (^)(NSArray *result))success failure:(void(^)(NSError *error))failure
{
    NSURLRequest *request = [TDOAuth URLRequestForPath:path parameters:parameters host:FANFOU_API_HOST consumerKey:API_OAUTH_CONSUMER_KEY consumerSecret:API_OAUTH_CONSUMERSECRET accessToken:accessToken tokenSecret:tokenSecret scheme:@"http" requestMethod:requestMethod dataEncoding:TDOAuthContentTypeUrlEncodedForm headerValues:nil signatureMethod:TDOAuthSignatureMethodHmacSha1];
    
    NSURLSessionDataTask *task = [_session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            failure(error);
        } else {
            NSArray *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            dispatch_async(dispatch_get_main_queue(), ^{
                success(result);
                
            });
        }
    }];
    [task resume];
    
}

// 上传图片
- (void)postPhotoWithPath:(NSString *)path parameters:(NSDictionary *)parameters sucess:(void (^)(NSArray *result))sucess failure:(void (^)(NSError *error))failure imageData:(NSData *)imageData{
    
    User *user = [CoreDataStack sharedCoreDataStack].currentUser;
    //parameters is nil 是因为后面重新传了这个参数所包含的头
    NSMutableURLRequest *request = [[TDOAuth URLRequestForPath:path parameters:nil host:FANFOU_API_HOST consumerKey:API_OAUTH_CONSUMER_KEY consumerSecret:API_OAUTH_CONSUMERSECRET accessToken:user.token tokenSecret:user.tokenSecret scheme:@"http" requestMethod:@"POST" dataEncoding:TDOAuthContentTypeUrlEncodedForm headerValues:nil signatureMethod:TDOAuthSignatureMethodHmacSha1]mutableCopy];
    NSString *boundary = [self generateBoundaryString];
    
    //与发布文本不同的http头和body
    request.HTTPBody = [self createBodyWithBoundary:boundary parameters:parameters data:imageData fileName:@"photo"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data;boundary=%@", boundary];
    
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionDataTask *task = [_session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@",error);
            failure(error);
        } else {
            NSArray *result =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
         //   NSLog(@"%@",result);
         
            dispatch_async(dispatch_get_main_queue(), ^{
                sucess(result);
                
            });
            
        }
    }];
    
    [task resume];
}






#pragma mark - Status
// API_HOME_TIMELINE
- (void)requestStatusWithSuccess:(void (^)(NSArray *result))success failure:(void(^)(NSError *error))failure
{
    
    [self requestWithPath:API_HOME_TIMELINE parameters:@{@"mode":@"lite", @"count":@60, @"format":@"html"} requestMethod:@"GET" success:success failure:failure];
}

#pragma mark - postData 发饭
// 同时包含文本和图片
- (void)postData:(NSString *)text imageData:(NSData *)imageData replyToStatusID:(NSString *)replyToStatusID repostStatusID:(NSString *)repostStatusID success:(void (^)(NSArray *result))success failure:(void(^)(NSError *error))failure
{

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"status"] = text;
    params[@"format"] = @"html";
    
    if (replyToStatusID) {
        params[@"in_reply_to_status_id"] = replyToStatusID;
    }
    if (repostStatusID) {
        params[@"repost_status_id"] = repostStatusID;
    }
    
    if (imageData) {
        //发布图片的接口
        [self postPhotoWithPath:API_UPLOAD_PHOTO parameters:params sucess:success failure:failure imageData:imageData];
    } else {
        
        //发布文本的接口
        [self requestWithPath:API_UPDATE_TEXT parameters:params requestMethod:@"POST" success:success failure:failure];
    }
}
// 用作图片上传的表单格式的构造
#pragma mark - PhotoUpload
- (NSData *)createBodyWithBoundary:(NSString *)boundary parameters:(NSDictionary *)parameters data:(NSData *)data fileName:(NSString *)fileName
{
    NSMutableData *httpBody = [NSMutableData data];
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *parameterKey, NSString *parameterValue, BOOL *stop) {
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", parameterKey] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"%@\r\n", parameterValue] dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"photo\"\r\n", fileName] dataUsingEncoding:NSUTF8StringEncoding]];
    [httpBody appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [httpBody appendData:data];
    [httpBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [httpBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return httpBody;
}

- (NSString *)generateBoundaryString
{
    return [NSString stringWithFormat:@"Boundary-%@", [[NSUUID UUID] UUIDString]];
}



#pragma mark - 收藏
- (void)starWithStatusID:(NSString *)statusID success:(void(^)(id  result))success failure:(void(^)(NSError *error))failure
{
    NSString *path = [NSString stringWithFormat:@"%@:%@.json",API_FAVORITES_CREATE,statusID];
    [self requestWithPath:path parameters:nil requestMethod:@"POST" success:success failure:failure];
}

@end
