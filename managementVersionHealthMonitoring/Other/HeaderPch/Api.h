//
//  Api.h
//  BaseFile
//
//  Created by 东方盈 on 2017/5/6.
//  Copyright © 2017年 DFY. All rights reserved.
//

#ifndef Api_h
#define Api_h


/**
 *  网络请求
 */

#define PAGESIZE  @"20"
#define POST_METHOD @"POST"
#define GET_METHOD  @"GET"
#define REQUEST_MAX_TIMEOUT  10

////////////////////////////////////////////////

// 主域名
#define URLDomain        @"http://nq.website-art.com/app/"

// ------------------------------------------------------------------------------------------------  //

// 获取用户信息
#define URLUserDomain    [NSString stringWithFormat:@"%@user.php?", URLDomain]

// 获取验证码
#define URLGetCode       [NSString stringWithFormat:@"%@act=get_sms", URLUserDomain]

#import <YTKNetworkConfig.h>
#import "APPHeader.h"
#import "KEYHeader.h"
#import "THRHeader.h"
#import "URLHeader.h"
#endif /* Api_h */
