//
//  Other.h
//  BaseFile
//
//  Created by 东方盈 on 2017/5/6.
//  Copyright © 2017年 DFY. All rights reserved.
//

#ifndef Other_h
#define Other_h

//用户Token
#define USER_TOKEN                 [NSString stringWithFormat:@"%@",[UserDefaults readUserDefaultObjectValueForKey:@"token"]]

// 用户ID
#define USER_UID                   [NSString stringWithFormat:@"%@",[UserDefaults readUserDefaultObjectValueForKey:@"uid"]]

#define kUser_msg  @"userModel"
#define MKUser_msg  @"managementuserModel"

#define BADNETWORK @"网络未连接"
#define BADPHP     @"连接超时"


#define URLLOST(isNetworking) DFYSVPError(isNetworking?BADPHP:BADNETWORK)

#define TableViewDataError(count, page, view)\
if (count == 0 && page == 1) {\
view.promptMSgType = SKPromptMSgTypeNoDataType;\
}else{\
view.promptMSgType = SKPromptMSgTypeNormal;\
}

// 网络错误 or 数据库错误
#define URLTableViewLOST(isNetworking, page, View)\
if (isNetworking) {\
if (page == 1 && [View isKindOfClass:[UITableView class]]) {\
View.promptMSgType = SKPromptMSgTypeNoDataType;\
}\
DFYSVPError(BADPHP)\
}else{\
if (page == 1 && [View isKindOfClass:[UITableView class]]) {\
View.promptMSgType = SKPromptMSgTypeBadNetWork;\
}\
DFYSVPError(BADNETWORK)\
}

// weakself
#define WeakSelf __weak typeof(self) weakSelf = self;

// 是否加载网络图片
#define KISImage       [[NSString stringWithFormat:@"%@",[UserDefaults readUserDefaultObjectValueForKey:@"isImage"]] integerValue]  // 是否加载网络图片

// SD加载图片
#define KSDimage(imgView, msg)   [imgView sd_setImageWithURL:[NSURL URLWithString:msg] placeholderImage:[UIImage imageNamed:@"pic_placeholder"]];

#define KSDimageIcon(imgView, msg)   [imgView sd_setImageWithURL:[NSURL URLWithString:msg] placeholderImage:[UIImage imageNamed:@"touxiang"]];


#endif /* Other_h */
