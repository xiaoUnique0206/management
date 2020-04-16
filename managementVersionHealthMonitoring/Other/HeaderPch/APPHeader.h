//
//  APPHeader.h
//  ProjectMusic
//
//  Created by young on 15/7/31.
//  Copyright (c) 2015年 young. All rights reserved.
//  这里存放普通的app宏定义和声明等信息.

#ifndef Project_APPHeader_h
#define Project_APPHeader_h


#define BD_SERVER @"https://appserv.beidoujinfu.com/bdjf/%@"
#define BD_PIC @"https://file.beidoujinfu.com/%@"
//
//#define BD_SERVER @"http://101.200.155.227:8186/bdjf/%@"
//#define BD_PIC @"http://101.200.155.227:8186/pic/%@"

#define APPLEID @"1220754799"
//快速定义一个weakSelf 用于block
#define BD_WEAKSELF(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#define objectOrNull(obj) ((obj) ? (obj) : [NSNull null])
#define objectOrEmptyStr(obj) ((obj) ? (obj) : @"")

#define isNull(x)             (!x || [x isKindOfClass:[NSNull class]])
#define toInt(x)              (isNull(x) ? 0 : [x intValue])
#define isEmptyString(x)      (isNull(x) || [x isEqual:@""] || [x isEqual:@"(null)"])
#define RGBA(r,g,b,a)         [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RGB(r,g,b)            [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

#define BDBackgroundColor RGB(215,215,215)// [UIColor whiteColor] //
#define YYLog(...) NSLog(__VA_ARGS__)

#define TTBG RGB(239, 239, 244)
#define MTT_WEAKSELF(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define YYNotificationCenter   [NSNotificationCenter defaultCenter]
#define YYUserToken    [YYUserDefault objectForKey:@"userToken"]
#define YYUUID    [YYUserDefault objectForKey:@"uuid"]
#define access_token  [YYUserDefault objectForKey:@"access_token"]
//#define BDOrange           RGB(0xff,0x97,0x48)
//#define BDYellow           RGB(0xfb,0xcd,0x4c)
//#define BDRed               RGB(0xff,0x5a,0x5e)
//#define BDGray              RGB(0x87,0x87,0x87)

//#define BDTableViewSeperatorColor RGB(0xb3, 0xb3, 0xb3)


//typedef enum : NSUInteger {
//    BDPayTypeAll=0,
//    BDPayTypeStage,
//} BDPayType;

//typedef enum : NSUInteger {
// } BDPayType;




//-------------------打印--------------------
#ifdef DEBUG
#define NEED_OUTPUT_LOG             1
#else
#define NEED_OUTPUT_LOG             0
#endif


#if NEED_OUTPUT_LOG
#define BDLog(xx, ...)                      NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define BDLog(xx, ...)                 nil
#endif




#endif
