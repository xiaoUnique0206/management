//
//  Color.h
//  BaseFile
//
//  Created by 东方盈 on 2017/5/6.
//  Copyright © 2017年 DFY. All rights reserved.
//

#ifndef Color_h
#define Color_h


#define UIColorMain                 0xEE9821
#define UIColorNavColor             0xF6F6F6
#define UIColorBlack                0x333333
#define UIColorCy                   0x666666
#define UIColor999                  0x999999
#define UIColorWhite                0xFFFFFF
#define UIColorLineColor            0xE0E0E0
#define UIColorTableColor           0xF5F5F5
#define UIColorPickBtnColor         0x007CFF
#define UIColorPickViewColor        0xDDDDDD
#define UIColorBlue                 0x51B338
#define UIColorStarSelColor         0x51B338
#define SCOrign                     RGB(250, 98, 27)
#define TitleColor                  RGB(51, 51, 51)
#define NSLEFT                      NSTextAlignmentLeft
#define NSRIGHT                     NSTextAlignmentRight
#define NSCENTER                    NSTextAlignmentCenter
#define LineBackColor               RGB(222, 222, 222)
#define BD_WEAKSELF(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#define objectOrNull(obj) ((obj) ? (obj) : [NSNull null])
#define objectOrEmptyStr(obj) ((obj) ? (obj) : @"")

#define isNull(x)             (!x || [x isKindOfClass:[NSNull class]])
#define toInt(x)              (isNull(x) ? 0 : [x intValue])
#define isEmptyString(x)      (isNull(x) || [x isEqual:@""] || [x isEqual:@"(null)"])
#define RGBA(r,g,b,a)         [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RGB(r,g,b)            [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

#define BDBackgroundColor RGB(215,215,215)// [UIColor whiteColor] //
#define YYUserDefault   [NSUserDefaults standardUserDefaults]
#define Longitude [NSString stringWithFormat:@"%@",[YYUserDefault objectForKey:@"longitude"]]
//主绿色色值
#define MaingreenColor   RGB(25, 108, 199)
//主蓝色色值
#define MainBlueColor   RGB(85, 132, 255)
//常用字体色
#define Text1Color             RGB(51, 51, 51)
#define Latitude [NSString stringWithFormat:@"%@",[YYUserDefault objectForKey:@"latitude"]]

#define TTBG RGB(239, 239, 244)
#define MTT_WEAKSELF(weakSelf)  __weak __typeof(&*self)weakSelf = self;


//#define BDOrange           RGB(0xff,0x97,0x48)
//#define BDYellow           RGB(0xfb,0xcd,0x4c)
//#define BDRed               RGB(0xff,0x5a,0x5e)
//#define BDGray              RGB(0x87,0x87,0x87)

#define BDTableViewSeperatorColor RGB(0xb3, 0xb3, 0xb3)

#endif /* Color_h */
