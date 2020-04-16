//
//  Value.h
//  BaseFile
//
//  Created by 东方盈 on 2017/5/6.
//  Copyright © 2017年 DFY. All rights reserved.
//

#ifndef Value_h
#define Value_h


//屏幕高度
#define kSHeight           [UIScreen mainScreen].bounds.size.height

//屏幕宽度
#define kSWidth            [UIScreen mainScreen].bounds.size.width

#define kIs_iphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define kIs_iPhoneX kSWidth >=375.0f && kSHeight >=812.0f&& kIs_iphone
// 底部高度
#define kTabBarHeight (CGFloat)(kIs_iPhoneX?(49.0 + 34.0):(49.0))

#define ZERO               0     // x轴 0
#define NAV_HEIGHT         64    // nav高度
#define ANIMATETIME        0.5   // 动画时间
#define TABBAR_HEIGHT      50    // tabBar高度
#define BOTTOMVIEW_HEIGHT  50    // 底部view 高度


/**
 *  10号字体
 */
#define TenFontSize [UIFont systemFontOfSize:10]
/**
 *  11号字体
 */
#define ElevenFontSize [UIFont systemFontOfSize:11]
/**
 *  12号字体
 */
#define TwelveFontSize [UIFont systemFontOfSize:12]
/**
 *  13号字体
 */
#define ThirteenFontSize [UIFont systemFontOfSize:13]
/**
 *  14号字体
 */
#define FourteenFontSize [UIFont systemFontOfSize:14]
/**
 *  15号字体
 */
#define FifteenFontSize [UIFont systemFontOfSize:15]
/**
 *  17号字体
 */
#define SeventeenFontSize [UIFont systemFontOfSize:17]
/**
 *  18号字体
 */
#define EighteenFontSize [UIFont systemFontOfSize:18]
/**
 *  20号字体
 */
#define TwentyFontSize [UIFont systemFontOfSize:20]


#endif /* Value_h */
