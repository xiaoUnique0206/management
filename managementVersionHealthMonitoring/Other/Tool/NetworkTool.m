//
//  NetworkTool.m
//  HealthyMall
//
//  Created by imax on 2017/6/10.
//  Copyright © 2017年 白沙科技. All rights reserved.
//

#import "NetworkTool.h"
#import "SVProgressHUD.h"
#import "MyTool.h"

NSString *const Course_Base_URL = @"";

@protocol NetworkToolProtocal <NSObject>

@optional
/// AFN 内部的数据访问方法
///
/// @param method           HTTP 方法
/// @param URLString        URLString
/// @param parameters       请求参数字典
/// @param uploadProgress   上传进度
/// @param downloadProgress 下载进度
/// @param success          成功回调
/// @param failure          失败回调
///
/// @return NSURLSessionDataTask，需要 resume
- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                  uploadProgress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgress
                                downloadProgress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgress
                                         success:(void (^)(NSURLSessionDataTask *, id))success
                                         failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;

@end




@interface NetworkTool() <NetworkToolProtocal>

@end



@implementation NetworkTool

//网络工具的类方法,单例模式
+ (instancetype)sharedNetworkTool {
    static NetworkTool *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    AFSecurityPolicy *security = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];

    [security setValidatesDomainName:NO];

    security.allowInvalidCertificates = YES;

    instance.securityPolicy = security;

    return instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//        self.requestSerializer = [AFHTTPRequestSerializer serializer];

        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain",@"text/html",nil];
        [self.requestSerializer setTimeoutInterval:60];

        [self.requestSerializer setValue:@"1.0" forHTTPHeaderField:@"Version"];
//        NSString *uuid = YYUUID;
        NSString *uuid;
        if (uuid == nil) {
            uuid = @"1111";
        }
        
        [self.requestSerializer setValue:uuid forHTTPHeaderField:@"Sn"];
        
        
    }
    return self;
}

/// 网络请求，封装了GET和POST
///
/// @param method     枚举，GET/POST
/// @param URLString  baseURL之后的地址
/// @param parameters 请求参数
/// @param finished   返回回调
- (void)requestWithMethod:(CGNetWorkMethod)method URLString:(NSString *)URLString parameters:(id)parameters finished:(CGRequestCallBack)finished {
    
//    NSString *cid = YYCID;
//    if (cid == nil) {
//        cid = @"";
//    }
//    NSString *uid = YYUserId;
//    YYLog(@"YYuid==%@",uid);
//    if (uid == nil) {
//        uid = @"";
//        YYLog(@"YYff==%@",uid);
//    }
//    YYLog(@"YYcid==%@",cid);
//    [self.requestSerializer setValue:cid forHTTPHeaderField:@"cid"];
//    [self.requestSerializer setValue:uid forHTTPHeaderField:@"uid"];
    
    
    URLString = URLString == nil ? @"" : URLString;
    NSString *methodName = (method == CGNetworkMethodGET) ? @"GET" : @"POST";

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [[self dataTaskWithHTTPMethod:methodName URLString:URLString parameters:parameters uploadProgress:nil downloadProgress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        YYLog(@"mainresponseobject==%@",responseObject);
        // 获取 header  中的cid的方法：
//        NSString *cid;
//        if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
//            NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;
//            cid = [r allHeaderFields][@"cid"];
//            YYLog(@"cid===%@",cid);
//            if (cid.length > 0) {
//                [YYUserDefault setObject:cid forKey:@"cid"];
//                [YYUserDefault synchronize];
//                YYLog(@"Defaultcid===%@",YYCID);
//            }
//
//        }
        
        ;
        if ([responseObject[@"code"] integerValue] == 200 || [URLString containsString:login_token_base_url]){
            finished(responseObject, nil);
        }else if ([responseObject[@"code"] integerValue] == 401){
            finished(nil, @"401");
        }else{
            finished(nil, responseObject[@"message"]);
//            [MyTool
//             showHudMessage:responseObject[@"message"]];
        }
        
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        YYLog(@"errorerror----%@", error);
       
        if (error.code  == -1011 && [URLString containsString:@"oauth/token"]) {

            NSDictionary *usin = error.userInfo;
            NSHTTPURLResponse *auth = [usin objectForKey:@"com.alamofire.serialization.response.error.response"];
            NSString *Authenticate = [auth.allHeaderFields objectForKey:@"Www-Authenticate"];
            if ([Authenticate containsString:@"2001"]) {
                finished(nil, @"获取验证码");
            }else{
                [MyTool showHudMessage:@"账号或密码错误"];
            }
        }else{
//            [MyTool showHudMessage:error.localizedDescription];
        }
        finished(nil, @"请检查您的网络连接!");
        //[MyTool showHudMessage:@"请检查您的网络连接!"];
        
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }] resume];
}


@end
