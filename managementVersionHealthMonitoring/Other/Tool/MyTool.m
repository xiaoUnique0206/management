//
//  MyTool.m
//  healthMonitoring
//
//  Created by gaotianyu on 2020/1/30.
//  Copyright © 2020 gaotianyu. All rights reserved.
//

#import "MyTool.h"

@implementation MyTool

+ (NSString *)getNowTimeTimestamp{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    //NSLog(@"===当前时间%@", timeSp);
    return timeSp;
}



+ (NSString*)dictionaryToJson:(NSDictionary *)dic

{

NSError *parseError = nil;

NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];

return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

}


// HUD
+ (void)showHudMessage:(NSString *) message {
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    [SVProgressHUD setBackgroundColor:RGBA(51, 51, 51, 0.8)];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD showImage:[UIImage imageNamed:@""] status:message];
}
// HUD progress
+ (void)showHudMessage:(NSString *) message showProgress:(float)progress{
    [SVProgressHUD setMinimumDismissTimeInterval:2];
    [SVProgressHUD setBackgroundColor:RGBA(51, 51, 51, 0.8)];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD showProgress:progress status:message];
}
// HUD加载
+ (void)showHud {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setBackgroundColor:RGBA(55, 55, 55, 0.75)];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    //[SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    //[SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD show];
}
// HUD加载带文字
+ (void)showHudStatus:(NSString *)state {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setBackgroundColor:RGBA(55, 55, 55, 0.75)];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    //[SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    //[SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD showWithStatus:state];;
}
+ (void)dismissHud{
    [SVProgressHUD dismiss];
}

//时间转时间戳
+ (NSDate *)timeStr:(NSString *)timeS withType:(NSString *)type{
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = type;
    return [format dateFromString:timeS];
}

+(NSString *)getNowTimeTimestamp3{

    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式

    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)([datenow timeIntervalSince1970]*1000)];

    return timeSp;
}
+ (NSInteger)genderOfIDNumber:(NSString *)IDNumber
{
      //  记录校验结果：0未知，1男，2女
    NSInteger result = 0;
    NSString *fontNumer = nil;
    
    if (IDNumber.length == 15)
    { // 15位身份证号码：第15位代表性别，奇数为男，偶数为女。
        fontNumer = [IDNumber substringWithRange:NSMakeRange(14, 1)];
 
    }else if (IDNumber.length == 18)
    { // 18位身份证号码：第17位代表性别，奇数为男，偶数为女。
        fontNumer = [IDNumber substringWithRange:NSMakeRange(16, 1)];
    }else
    { //  不是15位也不是18位，则不是正常的身份证号码，直接返回
        return result;
    }
    
    NSInteger genderNumber = [fontNumer integerValue];
    
    if(genderNumber % 2 == 1)
        result = 1;
    
    else if (genderNumber % 2 == 0)
        result = 2;
    return result;
    }


+(void)upLongitudeAndLatitude{
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
//    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
//    NSDate *datenow = [NSDate date];
//    //----------将nsdate按formatter格式转成nsstring
//
//    NSString *currentTimeString = [formatter stringFromDate:datenow];
//    currentTimeString = [currentTimeString stringByReplacingOccurrencesOfString:@" " withString:@"T"];
//    currentTimeString = [currentTimeString stringByAppendingString:@"+0800"];
//    NSString *url = [NSString stringWithFormat:@"%@/api/userfootprint/save",base_url];
//   NSString *longitu = Longitude == nil ? @"" : Longitude;
//    NSString *latitu = Latitude == nil ? @"" : Latitude;
//    NSDictionary *dict = @{
//            @"longitude":longitu,
//            @"latitude":latitu,
//            @"userId":UserId,
//            @"timepoint":currentTimeString
//        };
//    [NetworkTool sharedNetworkTool].requestSerializer = [AFJSONRequestSerializer serializer];
//    
//    [[NetworkTool sharedNetworkTool].requestSerializer setValue:[MyTool getNowTimeTimestamp3] forHTTPHeaderField:@"Timestamp"];
//    
//    [[NetworkTool sharedNetworkTool].requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//
//    [[NetworkTool sharedNetworkTool].requestSerializer setValue:YYUserToken forHTTPHeaderField:@"Authorization"];
//    
//
//
//        [[NetworkTool sharedNetworkTool] requestWithMethod:CGNetworkMethodPOST URLString:url parameters:dict finished:^(id result, NSString *error) {
////            YYLog(@"upLongitudeAndLatitude==%@",result);
//
//            if (error==nil) {
//
//
//            }
//        }];
////
//    
   

    
}


+(NSString*)getLastDayTimes:(NSString *)temFormat timeLenth:(float)lenth{

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制

    [formatter setDateFormat:temFormat];

    NSDate * date = [NSDate date];//当前时间
    NSDate *lastDay;
    if (lenth == 0) {
        lastDay = [NSDate dateWithTimeInterval:-10*60 sinceDate:date];//前一天
    }else{
        lastDay = [NSDate dateWithTimeInterval:-lenth*60*60 sinceDate:date];
    }

    //----------将nsdate按formatter格式转成nsstring

    NSString *lastDayTimeString = [formatter stringFromDate:lastDay];

    NSLog(@"lastDayTimeString =  %@",lastDayTimeString);

    return lastDayTimeString;

}



// 十六进制转换为普通字符串的。
+ (NSString *)stringFromHexString:(NSString *)hexString { //
   NSString *str1 = @"this is zero"; //1.从第三个字符开始，截取长度为2的字符串.........注:空格算作一个字符
    NSString *str2 = [hexString substringWithRange:NSMakeRange(5,2)];//str2 = "is"
 
char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
bzero(myBuffer, [hexString length] / 2 + 1);
for (int i = 0; i < [hexString length] - 1; i += 2) {
unsigned int anInt;
NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
[scanner scanHexInt:&anInt];
myBuffer[i / 2] = (char)anInt;
}
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    NSLog(@"------字符串=======%@",unicodeString);
    return unicodeString;

}
//字符串转成ascii字符串
+(NSString *)stringToAsci:(NSString *)string {
    NSMutableString *mustring = [[NSMutableString alloc]init];
    const char *ch = [string cStringUsingEncoding:NSASCIIStringEncoding];
    for (int i = 0; i < strlen(ch); i++) {
        [mustring appendString:[NSString stringWithFormat:@"%x",ch[i]]];
    }
    return mustring;
}
//获取当前时间 无符号
+(NSString*)getCurrentTimes{

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制

    [formatter setDateFormat:@"YYYYMMddHHmmss"];

    //现在时间,你可以输出来看下是什么格式

    NSDate *datenow = [NSDate date];

    //----------将nsdate按formatter格式转成nsstring

    NSString *currentTimeString = [formatter stringFromDate:datenow];

    NSLog(@"currentTimeString =  %@",currentTimeString);

    return currentTimeString;

}
 
//字符串转成data
 
+(NSData*)hexToBytes:(NSString *)dataStr {
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= dataStr.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [dataStr substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
        
    }
    return data;

}

+ (NSString *)Safe:(id)string {
    if ([string isEqual:@"NULL"] || [string isKindOfClass:[NSNull class]] || [string isEqual:[NSNull null]] || [string isEqual:NULL] || [[string class] isSubclassOfClass:[NSNull class]] || string == nil || string == NULL || [string isKindOfClass:[NSNull class]] || [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0 || [string isEqualToString:@"<null>"] || [string isEqualToString:@"(null)"]) {
        return @"";
    } else {
        return (NSString *)string;
        
    }
}

#pragma mark - 有取消按钮的警示框
+ (UIAlertController *)alertTitle:(NSString *)title
                          mesasge:(NSString *)message
                       confirmStr:(NSString *)confirmStr
                        cancleStr:(NSString *)cancleStr
                   confirmHandler:(void(^)(UIAlertAction *))confirmHandler
                    cancleHandler:(void(^)(UIAlertAction *))cancleHandler
                   viewController:(UIViewController *)vc{
    
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirmAction=[UIAlertAction actionWithTitle:confirmStr style:UIAlertActionStyleDefault handler:confirmHandler];
    if (cancleStr.length > 0) {
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:cancleStr style:UIAlertActionStyleCancel handler:cancleHandler];
        [alertController addAction:cancleAction];
    }
    
    [alertController addAction:confirmAction];
    
    alertController.modalPresentationStyle = 0;
    [vc presentViewController:alertController animated:YES completion:nil];
    
    return alertController;
}
@end
