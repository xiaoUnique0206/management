//
//  KEYHeader.h
//  ProjectMusic
//
//  Created by young on 15/7/31.
//  Copyright (c) 2015年 young. All rights reserved.
//  这里是三方key的声明/宏定义.

#ifndef Project_KEYHeader_h
#define Project_KEYHeader_h
#define FrameSize (self.view.frame.size)
#define graycol ([UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1])
#define KWidth [UIScreen mainScreen].bounds.size.width
#define KHight [UIScreen mainScreen].bounds.size.height
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

#define kGrayColor  RGBCOLOR(196, 197, 198)
#define WeakSelf  __weak __typeof(&*self)weakSelf = self;
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define KEYWINDOW [UIApplication sharedApplication].keyWindow
#define LightColor [UIColor colorWithRed:199/255.0 green:199/255.0 blue:204/255.0 alpha:1]
#define KGap (KWidth/15)
#define UIColorFromHex(s,a) [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:a]

#define kScreenHeight CGRectGetHeight([UIScreen mainScreen].bounds)
#define butHeight 50
#define IOS8 ([[UIDevice currentDevice].systemVersion intValue] >= 8 ? YES : NO)

#endif


