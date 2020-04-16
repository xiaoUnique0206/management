//
//  NetworkTool.h
//  HealthyMall
//
//  Created by imax on 2017/6/10.
//  Copyright © 2017年 白沙科技. All rights reserved.
//

//#import <AFNetworking/AFNetworking.h>

#import "AFNetworking.h"

typedef enum : NSUInteger {
    CGNetworkMethodGET = 0,
    CGNetworkMethodPOST
} CGNetWorkMethod;
/// 网络请求回调类型
///
/// @param result 返回结果
/// @param error  错误信息
typedef void (^CGRequestCallBack)(id result, NSString * error);

@interface NetworkTool : AFHTTPSessionManager

+ (instancetype)sharedNetworkTool;


/// 网络请求，封装了GET和POST
///
/// @param method     枚举，GET/POST
/// @param URLString  baseURL之后的地址
/// @param parameters 请求参数
/// @param finished   返回回调
- (void)requestWithMethod:(CGNetWorkMethod)method URLString:(NSString *)URLString parameters:(id)parameters finished:(CGRequestCallBack)finished;

@end
