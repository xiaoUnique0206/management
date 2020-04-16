//
//  HMLoginViewController.m
//  healthMonitoring
//
//  Created by gaotianyu on 2020/1/30.
//  Copyright © 2020 gaotianyu. All rights reserved.
//

#import "HMLoginViewController.h"
#import "HMCodeViewController.h"
#import "HMRetrievePassWordViewController.h"


@interface HMLoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UILabel *nextBtn;
@property (weak, nonatomic) IBOutlet UILabel *regisLabel;

@end

@implementation HMLoginViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (self.navigationController.viewControllers.count == 1) {
            self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"fanhui"] target:self action:@selector(backFirstPage)];
    }
    self.pwdTF.secureTextEntry = YES;
    self.nextBtn.layer.masksToBounds = YES;
    self.nextBtn.layer.cornerRadius = 25;
    UITapGestureRecognizer *nextTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nextBtnClick)];
    [self.nextBtn addGestureRecognizer:nextTap];

    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:19],NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
       [self.navigationController.navigationBar setBarTintColor:MaingreenColor];
    UITapGestureRecognizer *regisTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(regisSel)];
    [self.regisLabel addGestureRecognizer:regisTap];
    self.title=@"智能体温计";
    self.navigationItem.leftBarButtonItem = nil;
    // 初始化设置
    [self setupBase];
    self.regisLabel.hidden = YES;
    NSInteger dayeInt = [self compareWithDate:@"2020-04-18"];
    if (dayeInt == -1) {
        self.regisLabel.hidden = NO;
    }
}
- (void)backFirstPage{
    [YYNotificationCenter postNotificationName:@"switchTarBar" object:@"login"];
}
#pragma mark - <UITextFieldDelegate>
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
        if (self.phoneTF.text.length != 0 && self.pwdTF.text.length != 0) {
//            [self.nextBtn setBackgroundColor:RGBA(25, 108, 199,1)];
            self.nextBtn.userInteractionEnabled = YES;
        }else {
//            [self.nextBtn setBackgroundColor:RGBA(25, 108, 199,0.5)];
            self.nextBtn.userInteractionEnabled = NO;
        }
    
    
}
// 初始化设置
- (void)setupBase {
    
    [self.phoneTF addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventEditingChanged];
    
    [self.pwdTF addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventEditingChanged];
    
//    [self.nextBtn setBackgroundColor:RGBA(25, 108, 199,0.5)];
    self.nextBtn.userInteractionEnabled = NO;
}
- (void)nextBtnClick{
    
    [self loadlogin];
}


- (void)loadlogin{
    
    [MyTool showHud];
    
    self.nextBtn.userInteractionEnabled = NO;
    NSString *url = [NSString stringWithFormat:@"%@/oauth/token",login_token_base_url];
    
    NSDictionary *dict = @{@"username":self.phoneTF.text,
                           @"password":self.pwdTF.text,
                           @"grant_type":@"password",
                           @"type":@"third",
                           @"imei":self.phoneTF.text
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
        [MyTool dismissHud];
        if (error == nil) {
            [YYUserDefault setObject:[NSString stringWithFormat:@"%@ %@",result[@"token_type"],result[@"access_token"]] forKey:@"userToken"];
            [YYUserDefault setObject:[NSString stringWithFormat:@"%@",result[@"access_token"]] forKey:@"access_token"];
            [YYUserDefault synchronize];
            [self loaduserid];
            
        }else if ([error isEqualToString:@"获取验证码"]){
            HMCodeViewController *codeVC =[HMCodeViewController new];
            codeVC.phoneTFText = self.phoneTF.text;
            codeVC.pwdTF = self.pwdTF.text;
            [self.navigationController pushViewController:codeVC animated:YES];
        }else{
            self.nextBtn.userInteractionEnabled = YES;
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
        self.nextBtn.enabled = YES;
        if (error == nil) {
            [YYUserDefault setObject:@{@"tel":self.phoneTF.text,@"pwd":self.pwdTF.text} forKey:@"userAccount"];
            [YYUserDefault setObject:[NSString stringWithFormat:@"%@",result[@"user"][@"id"]] forKey:@"userId"];
            [YYUserDefault setObject:result[@"user_name"] forKey:@"user_name"];
            [YYUserDefault synchronize];
            [YYNotificationCenter postNotificationName:@"switchTarBar" object:@"login"];
        }

    }];
}


//用户协议
- (IBAction)agreeBtnClick:(id)sender {
    
//
//    PeiDaiWebViewController *webVc= [[PeiDaiWebViewController alloc] init];
//    webVc.title =@"用户协议及隐私政策";
//    webVc.webUrl = @"agreement.html";
//    [self.navigationController pushViewController:webVc animated:NO];
    
    
    
}

- (void)regisSel{
    HMRetrievePassWordViewController *regisVC = [HMRetrievePassWordViewController new];
    [self.navigationController pushViewController:regisVC animated:YES];
}

- (NSInteger)compareWithDate:(NSString*)bDate{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString*aDate=[formatter stringFromDate:[NSDate date]];
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"yyyy-MM-dd"];
    NSDate*dta = [[NSDate alloc]init];
    NSDate*dtb = [[NSDate alloc]init];
    dta = [dateformater dateFromString:aDate];
    
    dtb = [dateformater dateFromString:bDate];
    NSComparisonResult result = [dta compare:dtb];
    if (result == NSOrderedDescending) {
        //指定时间 已过期
        return 1;
    }else if(result ==NSOrderedAscending){
        // 没过期
        return -1;
    }else{
        // 时间一样
        return 0;
    }
}


- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    if ([YYUserDefault objectForKey:@"userAccount"]  != nil) {
    NSDictionary *userAccount = [YYUserDefault objectForKey:@"userAccount"];
    self.phoneTF.text = userAccount[@"tel"];
    self.pwdTF.text = userAccount[@"pwd"];
        [self.nextBtn setBackgroundColor:RGBA(25, 108, 199,1)];
        self.nextBtn.userInteractionEnabled = YES;
    }
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
