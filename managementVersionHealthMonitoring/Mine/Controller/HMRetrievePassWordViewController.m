//
//  HMRetrievePassWordViewController.m
//  healthMonitoring
//
//  Created by Mr - 宋 on 2020/3/6.
//  Copyright © 2020 gaotianyu. All rights reserved.
//

#import "HMRetrievePassWordViewController.h"

@interface HMRetrievePassWordViewController ()
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UIView *view5;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *verificanTF;
@property (weak, nonatomic) IBOutlet UITextField *passWordTF;
@property (weak, nonatomic) IBOutlet UITextField *confirmTF;
@property (weak, nonatomic) IBOutlet UILabel *sendLabel;
@property (weak, nonatomic) IBOutlet UIButton *determineButton;
@property(nonatomic,strong)NSTimer *timeCountdown;
@end

@implementation HMRetrievePassWordViewController
{
    NSInteger timerCount;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = RGB(245, 245, 245);
    UITapGestureRecognizer *sendTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sendSel)];
    [self.sendLabel addGestureRecognizer:sendTap];
    [self.phoneTF addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventEditingChanged];
    [self.userNameTF addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventEditingChanged];
    [self.verificanTF addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventEditingChanged];
    [self.passWordTF addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventEditingChanged];
    [self.confirmTF addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventEditingChanged];
    self.determineButton.layer.masksToBounds = YES;
    self.determineButton.layer.cornerRadius = 25;
    self.view1.layer.masksToBounds = YES;
    self.view1.layer.cornerRadius = 5;
    self.view2.layer.masksToBounds = YES;
    self.view2.layer.cornerRadius = 5;
    self.view3.layer.masksToBounds = YES;
    self.view3.layer.cornerRadius = 5;
    self.view4.layer.masksToBounds = YES;
    self.view4.layer.cornerRadius = 5;
    self.view5.layer.masksToBounds = YES;
    self.view5.layer.cornerRadius = 5;
    self.passWordTF.secureTextEntry = YES;
    self.confirmTF.secureTextEntry = YES;
    
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {

    if (self.phoneTF.text.length == 11 && self.userNameTF.text.length>0) {
        self.sendLabel.textColor = RGB(96, 154, 220);
        self.sendLabel.userInteractionEnabled = YES;
    }else{
        self.sendLabel.textColor = RGB(164, 164, 164);
        self.sendLabel.userInteractionEnabled = NO;
    }
    if (self.phoneTF.text.length == 11 && self.userNameTF.text.length>0 && self.verificanTF.text.length==6 && self.passWordTF.text.length>5 && self.confirmTF.text.length>5 && [self.passWordTF.text isEqualToString:self.confirmTF.text]) {
        self.determineButton.backgroundColor = RGB(96, 154, 220);
        self.determineButton.userInteractionEnabled = YES;
    }else{
        self.determineButton.backgroundColor = RGB(164, 164, 164);
        self.determineButton.userInteractionEnabled = NO;
    }
}


#pragma mark 获取验证码
- (void)sendSel{

    self.timeCountdown = [NSTimer scheduledTimerWithTimeInterval:1
                                                          target:self
                                                        selector:@selector(updateTime)
                                                        userInfo:nil
                                                         repeats:YES];
   
            [MyTool showHudMessage:@"验证码已发送到您的手机"];
      
    
}

- (void)updateTime{
    timerCount ++;
    if (timerCount>= 30) {
        timerCount = 0;
        self.sendLabel.textColor = RGB(96, 154, 220);
        self.sendLabel.userInteractionEnabled = YES;
        self.sendLabel.text = @"发送验证码";
        [ self.timeCountdown invalidate];
        return;
    }
    self.sendLabel.textColor = RGB(164, 164, 164);
    self.sendLabel.userInteractionEnabled = NO;
    self.sendLabel.text = [NSString stringWithFormat:@" %d  s",(30-timerCount)];
}

- (IBAction)determineBtnSel:(UIButton *)sender {
    [self modify];
}

#pragma mark 重置密码
- (void)modify{

   
            [MyTool showHudMessage:@"注册成功"];
            [self.navigationController popViewControllerAnimated:YES];
      

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
