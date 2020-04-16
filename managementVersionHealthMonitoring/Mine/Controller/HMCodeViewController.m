//
//  HMCodeViewController.m
//  managementVersionHealthMonitoring
//
//  Created by Mr - 宋 on 2020/4/13.
//  Copyright © 2020 song. All rights reserved.
//

#import "HMCodeViewController.h"

@interface HMCodeViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UILabel *sendLabel;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property(nonatomic,strong)NSTimer *timeCountdown;
@end

@implementation HMCodeViewController
{
    NSInteger timerCount;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *sendTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sendTapSel)];
    [self.sendLabel addGestureRecognizer:sendTap];
}

- (void)sendTapSel{
    if (self.phoneTF.text.length != 11) {
        [MyTool showHudMessage:@"请输入正确的手机号"];
        return;
    }
    self.timeCountdown = [NSTimer scheduledTimerWithTimeInterval:1
                                                          target:self
                                                        selector:@selector(updateTime)
                                                        userInfo:nil
                                                         repeats:YES];
//    NSDictionary *dict =@{@"mobile":self.phoneTF.text,@"username":self.phoneTFText,@"password":self.pwdTF};
//    NSString *url = [NSString stringWithFormat:@"%@/oauth/smscode",login_token_base_url];
    NSString *url = [NSString stringWithFormat:@"%@/oauth/smscode?mobile=%@&username=%@&password=%@",login_token_base_url,self.phoneTF.text,self.phoneTFText,self.pwdTF];
    [NetworkTool sharedNetworkTool].requestSerializer = [AFJSONRequestSerializer serializer];
     [[NetworkTool sharedNetworkTool].requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//     [[NetworkTool sharedNetworkTool].requestSerializer setValue:@"Basic cGRhX2NsaWVudDp1c2VyMTIz" forHTTPHeaderField:@"Authorization"];
    
     [[NetworkTool sharedNetworkTool]requestWithMethod:CGNetworkMethodPOST URLString:url parameters:nil finished:^(id result, NSString *error) {
         if (error == nil) {
             BOOL succes = result[@"success"];
             if (succes) {
                 [MyTool showHudMessage:@"验证码已发送到您的手机"];
             }else{
             NSString *message = result[@"message"];
             [MyTool showHudMessage:message];
             }
             
         }
     }];
}
- (void)updateTime{
    timerCount ++;
    if (timerCount>= 30) {
        timerCount = 0;
        self.sendLabel.userInteractionEnabled = YES;
        self.sendLabel.text = @"发送验证码";
        [ self.timeCountdown invalidate];
        return;
    }
    self.sendLabel.userInteractionEnabled = NO;
    self.sendLabel.text = [NSString stringWithFormat:@" %ld秒",(30-timerCount)];
}

- (IBAction)login:(UIButton *)sender {
    if (self.phoneTF.text.length != 11) {
        [MyTool showHudMessage:@"请输入正确的手机号"];
        return;
    }
    if (self.codeTF.text.length !=6) {
        [MyTool showHudMessage:@"请输入验证码"];
    }
    [self loadlogin];
}

- (void)loadlogin{

    NSString *url = [NSString stringWithFormat:@"%@/oauth/token",login_token_base_url];
    
    NSDictionary *dict = @{@"username":self.phoneTFText,
                           @"password":self.pwdTF,
                           @"grant_type":@"password",
                           @"type":@"third",
                           @"imei":self.phoneTFText,
                           @"mobile":self.phoneTF.text,
                           @"code":self.codeTF.text
    };

    
    [NetworkTool sharedNetworkTool].requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [[NetworkTool sharedNetworkTool].requestSerializer setValue:@"1.0" forHTTPHeaderField:@"Version"];
    NSString *uuid = YYUUID;
    if (uuid == nil) {
        uuid = @"1111";
    }
    [[NetworkTool sharedNetworkTool].requestSerializer setValue:uuid forHTTPHeaderField:@"Sn"];
    [[NetworkTool sharedNetworkTool].requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
 
    
   [[NetworkTool sharedNetworkTool].requestSerializer setValue:@"Basic aW9zX2NsaWVudDp1c2VyMTIz" forHTTPHeaderField:@"Authorization"];

    [[NetworkTool sharedNetworkTool] requestWithMethod:CGNetworkMethodPOST URLString:url parameters:dict
     
        finished:^(id result, NSString *error) {
        YYLog(@"loadlogin==%@",result);
        if (error == nil) {
            [YYUserDefault setObject:[NSString stringWithFormat:@"%@ %@",result[@"token_type"],result[@"access_token"]] forKey:@"userToken"];
            [YYUserDefault setObject:[NSString stringWithFormat:@"%@",result[@"access_token"]] forKey:@"access_token"];
            [YYUserDefault synchronize];
            [self loaduserid];
        }
    }];
}

-(NSString *)base64EncodeString:(NSString *)string{
    //1、先转换成二进制数据
    NSData *data =[string dataUsingEncoding:NSUTF8StringEncoding];
    //2、对二进制数据进行base64编码，完成后返回字符串
    return [data base64EncodedStringWithOptions:0];
}


- (void)loaduserid{
    [MyTool showHud];
    NSString *url = [NSString stringWithFormat:@"%@/oauth/me",login_token_base_url];
    YYLog(@"YYUserToken==%@",YYUserToken);
    NSDictionary *dict = @{
                           @"token":access_token
    };
    YYLog(@"YYUserToken=11=%@",access_token);
    [NetworkTool sharedNetworkTool].requestSerializer = [AFJSONRequestSerializer serializer];

    [[NetworkTool sharedNetworkTool].requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
[[NetworkTool sharedNetworkTool].requestSerializer setValue:YYUserToken forHTTPHeaderField:@"Authorization"];


    [[NetworkTool sharedNetworkTool] requestWithMethod:CGNetworkMethodGET URLString:url parameters:dict

        finished:^(id result, NSString *error) {
        YYLog(@"loaduserid==%@",result);
        [MyTool dismissHud];

        if (error == nil) {
            [YYUserDefault setObject:@{@"tel":self.phoneTFText,@"pwd":self.pwdTF} forKey:@"userAccount"];
            [YYUserDefault setObject:[NSString stringWithFormat:@"%@",result[@"user"][@"id"]] forKey:@"userId"];
            [YYUserDefault setObject:result[@"user_name"] forKey:@"user_name"];
            [YYUserDefault synchronize];
            [YYNotificationCenter postNotificationName:@"switchTarBar" object:@"login"];
        }

    }];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
