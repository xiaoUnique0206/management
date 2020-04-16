//
//  MyTool.h
//  healthMonitoring
//
//  Created by gaotianyu on 2020/1/30.
//  Copyright © 2020 gaotianyu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyTool : NSObject

// 获取当前时间的毫秒(时间戳)
+ (NSString *)getNowTimeTimestamp;

+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

// HUD
+ (void)showHudMessage:(NSString *) message;
// HUD progress
+ (void)showHudMessage:(NSString *) message showProgress:(float)progress;
// HUD加载
+ (void)showHud;
// HUD加载带文字
+ (void)showHudStatus:(NSString *)state;
+ (void)dismissHud;

+ (NSDate *)timeStr:(NSString *)timeS withType:(NSString *)type;
//获取时间戳
+(NSString *)getNowTimeTimestamp3;



+ (NSInteger)genderOfIDNumber:(NSString *)IDNumber;

+(void)upLongitudeAndLatitude;
//获取前一天
+(NSString*)getLastDayTimes:(NSString *)temFormat timeLenth:(float)lenth;

+ (NSString *)stringFromHexString:(NSString *)hexString;



//字符串转成ascii字符串
+(NSString *)stringToAsci:(NSString *)string;
//获取当前时间 无符号
+(NSString*)getCurrentTimes;
//字符串转成data
+(NSData*)hexToBytes:(NSString *)dataStr;


+ (NSString *)Safe:(id)string;
// 有取消按钮的警示框
+ (UIAlertController *)alertTitle:(NSString *)title
                          mesasge:(NSString *)message
                       confirmStr:(NSString *)confirmStr
                        cancleStr:(NSString *)cancleStr
                   confirmHandler:(void(^)(UIAlertAction *))confirmHandler
                    cancleHandler:(void(^)(UIAlertAction *))cancleHandler
                   viewController:(UIViewController *)vc;
@end

NS_ASSUME_NONNULL_END
