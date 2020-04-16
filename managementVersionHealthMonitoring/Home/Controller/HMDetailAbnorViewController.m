//
//  HMDetailAbnorViewController.m
//  managementVersionHealthMonitoring
//
//  Created by Mr - 宋 on 2020/4/2.
//  Copyright © 2020 song. All rights reserved.
//

#import "HMDetailAbnorViewController.h"
#import "HMFeedbackTableViewCell.h"
@interface HMDetailAbnorViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
@property (nonatomic,strong)UILabel *unitLabel;
@property (nonatomic,strong)UILabel *nameLabel,*alarmLabel,*screenLabel,*noData;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) PYZoomEchartsView *kEchartView;
@property (nonatomic,strong)UIButton *threeBtn,*sevenBtn,*fourBtn,*addRecordBtn;
@property (nonatomic,strong)UITableView *feedbackTableView;
@property (nonatomic,strong)NSArray *dataArray,*feedData;
@property (nonatomic,strong)NSMutableArray *timeArray,*valueArray,*listTimeArray;

@property (nonatomic,strong)UIView *bigView,*smallView;
@property (nonatomic,strong)UILabel *responLabel,*timeLabel,*placeHolderLabel;
@property (nonatomic,strong)UITextView *textView;
@property (nonatomic,strong)UITextField *otherAddress;
@property (nonatomic,assign)int position,followup;
@property (nonatomic,strong)NSString *lastAlertTime;
@end

@implementation HMDetailAbnorViewController

- (NSMutableArray *)timeArray{
    if (!_timeArray) {
        _timeArray = [NSMutableArray array];
    }
    return _timeArray;
}

- (NSMutableArray *)valueArray{
    if (!_valueArray) {
        _valueArray = [NSMutableArray array];
    }
    return _valueArray;
}
- (NSMutableArray *)listTimeArray{
    if (!_listTimeArray) {
        _listTimeArray = [NSMutableArray array];
    }
    return _listTimeArray;
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"近期体温详情";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:19],NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    [self.navigationController.navigationBar setBarTintColor:MaingreenColor];
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    leftBtn.frame = CGRectMake(0, 0, 18,23);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(p_popViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftBarBtn = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];;
    //创建UIBarButtonSystemItemFixedSpace
    UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //将宽度设为负值
    spaceItem.width = -10;
    //将两个BarButtonItem都返回给NavigationItem
    self.navigationItem.leftBarButtonItems = @[spaceItem,leftBarBtn];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatScrollView];
    
    UIImageView *imageVC = [[UIImageView alloc] initWithFrame:CGRectMake(30, 125, kSWidth, 3)];
    imageVC.image = [self drawLineOfDashByImageView:imageVC];
    [self.view addSubview:imageVC];
    
    
    for (int i = 0; i<6; i++) {
        UILabel *temLabel = [UILabel new];
        temLabel.frame = CGRectMake(7, 90+i*39, 30, 20);
        temLabel.text = [NSString stringWithFormat:@"%d",40-i*4];
        [self.view addSubview:temLabel];
    }
    
    self.alarmLabel = [UILabel new];
    self.alarmLabel.frame = CGRectMake(kSWidth-50, 130, 40, 20);
    self.alarmLabel.text = @"37.3";
    self.alarmLabel.textColor = [UIColor redColor];
    [self.view addSubview:self.alarmLabel];
    
    self.unitLabel = [UILabel new];
    self.unitLabel.numberOfLines = 0;
    self.unitLabel.textColor = UIColorFromHex(0x666666, 1);
    
    self.unitLabel.textAlignment = NSLEFT;
    self.unitLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:self.unitLabel];
    [self.unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top).offset(15);
    }];
    
    
    
    self.nameLabel = [UILabel new];
    
    self.nameLabel.textAlignment = NSLEFT;
    self.nameLabel.textColor = UIColorFromHex(0x666666, 1);
    self.nameLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.unitLabel.mas_bottom).offset(10);
    }];
    
    if (self.search == 2) {
        self.unitLabel.text = [NSString stringWithFormat:@"单位:%@/%@",self.model.parentCompany,self.model.company];
        self.nameLabel.text = [NSString stringWithFormat:@"%@的近期体温变化",self.model.username];
    }else{
        self.unitLabel.text = [NSString stringWithFormat:@"单位:%@/%@",self.model.parent,self.model.company];
        self.nameLabel.text = [NSString stringWithFormat:@"%@的近期体温变化",self.model.userName];
    }
    
    self.threeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.threeBtn.selected = YES;
    [self.threeBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [self.threeBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateSelected)];
    [self.threeBtn setBackgroundColor:RGB(52, 137, 255)];
    [self.threeBtn setTitle:@"三天数据" forState:(UIControlStateNormal)];
    [self.threeBtn addTarget:self action:@selector(threeSel) forControlEvents:(UIControlEventTouchUpInside)];
    self.threeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:self.threeBtn];
    
    
    self.sevenBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.sevenBtn.selected = NO;
    [self.sevenBtn addTarget:self action:@selector(sevenSel) forControlEvents:(UIControlEventTouchUpInside)];
    [self.sevenBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [self.sevenBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateSelected)];
    [self.sevenBtn setBackgroundColor:RGB(231, 231, 231)];
    [self.sevenBtn setTitle:@"七天数据" forState:(UIControlStateNormal)];
    self.sevenBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:self.sevenBtn];
    
    self.fourBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.fourBtn.selected = NO;
    [self.fourBtn addTarget:self action:@selector(fourSel) forControlEvents:(UIControlEventTouchUpInside)];
    [self.fourBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [self.fourBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateSelected)];
    [self.fourBtn setBackgroundColor:RGB(231, 231, 231)];
    [self.fourBtn setTitle:@"十四天数据" forState:(UIControlStateNormal)];
    self.fourBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:self.fourBtn];
    
    [self.threeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.top.equalTo(self.scrollView.mas_bottom).offset(10);
        make.height.equalTo(@40);
        make.width.equalTo(@((kSWidth-40)/3));
    }];
    [self.sevenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.threeBtn.mas_right);
        make.top.equalTo(self.scrollView.mas_bottom).offset(10);
        make.height.equalTo(@40);
        make.width.equalTo(@((kSWidth-40)/3));
    }];
    [self.fourBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.mas_bottom).offset(10);
        make.height.equalTo(@40);
        make.width.equalTo(@((kSWidth-40)/3));
        make.left.equalTo(self.sevenBtn.mas_right);
    }];
    
    self.screenLabel = [UILabel new];
    self.screenLabel.text = @"筛查反馈记录";
    self.screenLabel.textColor = UIColorFromHex(0x666666, 1);
    self.screenLabel.textAlignment = NSLEFT;
    self.screenLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.screenLabel];
    [self.screenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(self.threeBtn.mas_bottom).offset(10);
    }];
    [self.view addSubview:self.feedbackTableView];
    [self.feedbackTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.threeBtn.mas_bottom).offset(30);
        make.bottom.equalTo(self.view.mas_bottom).offset(-70);
    }];
    self.noData = [UILabel new];
    self.noData.text = @"暂无数据";
    self.noData.textColor = UIColorFromHex(0x666666, 1);
    self.noData.textAlignment = NSLEFT;
    self.noData.font = [UIFont systemFontOfSize:14];
    self.noData.hidden = YES;
    [self.view addSubview:self.noData];
    [self.noData mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.feedbackTableView.mas_left).offset(15);
        make.top.equalTo(self.feedbackTableView.mas_top).offset(5);
    }];
    self.addRecordBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.addRecordBtn setTitle:@"新增筛查反馈记录" forState:(UIControlStateNormal)];
    [self.addRecordBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    self.addRecordBtn.backgroundColor = RGB(52, 137, 255);
    self.addRecordBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.addRecordBtn addTarget:self action:@selector(addRecSel) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.addRecordBtn];
    [self.addRecordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.bottom.equalTo(self.view.mas_bottom).offset(-25);
        make.height.equalTo(@40);
    }];
    
    self.bigView = [UIView new];
    self.bigView.backgroundColor = [UIColor blackColor];
    self.bigView.alpha = 0.5;
    self.bigView.frame = CGRectMake(0, kSHeight, kSWidth, kSHeight);
    self.bigView.userInteractionEnabled = YES;
    UITapGestureRecognizer *bigTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bigSel)];
    [self.bigView addGestureRecognizer:bigTap];
    [self.view addSubview:self.bigView];
    self.smallView = [UIView new];
    self.smallView.alpha = 1;
    self.smallView.layer.masksToBounds = YES;
    self.smallView.layer.cornerRadius = 5;
    self.smallView.frame = CGRectMake(0, kSHeight, kSWidth-20, 280);
    self.smallView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.smallView];
    
    self.responLabel = [UILabel new];
    self.responLabel.numberOfLines = 0;
    self.responLabel.textColor = [UIColor redColor];
    self.responLabel.textAlignment = NSLEFT;
    self.responLabel.font = [UIFont systemFontOfSize:15];
    self.responLabel.text = @"责任单位需履行主体体责任,如实填写反馈信息,对造成严重后果的,将依据相关法律及规定追究责任";
    [self.smallView addSubview:self.responLabel];
    [self.responLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.smallView.mas_left).offset(5);
        make.right.equalTo(self.smallView.mas_right).offset(-5);
        make.top.equalTo(self.smallView.mas_top).offset(10);
    }];
    
    
    self.timeLabel = [UILabel new];
    self.timeLabel.text = [NSString stringWithFormat:@"时间:%@",[self getCurrentTimes:@"YYYY-MM-dd HH:mm:ss"]];
    self.timeLabel.textColor = UIColorFromHex(0x666666, 1);
    self.timeLabel.textAlignment = NSLEFT;
    self.timeLabel.font = [UIFont systemFontOfSize:15];
    [self.smallView addSubview:self.timeLabel];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.smallView.mas_left).offset(5);
        make.top.equalTo(self.responLabel.mas_bottom).offset(10);
    }];
    
    UILabel *bodyLabel = [UILabel new];
    bodyLabel.textColor = UIColorFromHex(0x666666, 1);
    bodyLabel.textAlignment = NSLEFT;
    bodyLabel.text = @"身体状况";
    bodyLabel.font = [UIFont systemFontOfSize:16];
    [self.smallView addSubview:bodyLabel];
    [bodyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.smallView.mas_left).offset(5);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(10);
        make.width.equalTo(@70);
    }];
    
    
    NSArray *bodeArray = @[@"无问题,健康",@"有问题,发烧",@"不确定,继续跟进"];
    for (int i = 0; i<3; i++) {
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        button.tag = 100+i;
        [button setImage:[UIImage imageNamed:@"yuan"] forState:(UIControlStateNormal)];
        [button setImage:[UIImage imageNamed:@"yuandian"] forState:(UIControlStateSelected)];
        [button setTitle:[NSString stringWithFormat:@" %@",bodeArray[i]] forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromHex(0x666666, 1) forState:(UIControlStateNormal)];
        [button addTarget:self action:@selector(bodySel:) forControlEvents:(UIControlEventTouchUpInside)];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        if (i == 0) {
            button.selected = YES;
        }
        [self.smallView addSubview:button];
        if (i<2) {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(bodyLabel.mas_right).offset(i*130+5);
                make.centerY.equalTo(bodyLabel.mas_centerY);
                make.height.equalTo(@20);
                make.width.equalTo(@120);
            }];
        }else{
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(bodyLabel.mas_right).offset(6);
                make.top.equalTo(bodyLabel.mas_bottom).offset(10);
                make.height.equalTo(@20);
                make.width.equalTo(@150);
            }];
        }
    }
    
    UIView *line1 = [UIView new];
    line1.backgroundColor = RGB(230, 230, 230);
    [self.smallView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.smallView.mas_left).offset(5);
        make.right.equalTo(self.smallView.mas_right).offset(-5);
        make.top.equalTo(bodyLabel.mas_bottom).offset(35);
        make.height.equalTo(@1);
    }];
    UILabel *address = [UILabel new];
    address.textColor = UIColorFromHex(0x666666, 1);
    address.textAlignment = NSLEFT;
    address.text = @"佩戴位置";
    address.font = [UIFont systemFontOfSize:16];
    [self.smallView addSubview:address];
    [address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.smallView.mas_left).offset(5);
        make.top.equalTo(line1.mas_bottom).offset(5);
        make.width.equalTo(@70);
    }];
    NSArray *addreArray = @[@"腋下",@"大臂内侧",@"腰部",@"其他"];
    for (int i = 0; i<4; i++) {
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [button setImage:[UIImage imageNamed:@"yuan"] forState:(UIControlStateNormal)];
        button.tag = 200+i;
        [button setImage:[UIImage imageNamed:@"yuandian"] forState:(UIControlStateSelected)];
        [button setTitle:[NSString stringWithFormat:@" %@",addreArray[i]] forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromHex(0x666666, 1) forState:(UIControlStateNormal)];
        button.titleLabel.textAlignment = NSLEFT;
        [button addTarget:self action:@selector(addressSel:) forControlEvents:(UIControlEventTouchUpInside)];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        if (i == 0) {
            button.selected = YES;
        }
        [self.smallView addSubview:button];
        if (i==0) {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(address.mas_right).offset(7);
                make.centerY.equalTo(address.mas_centerY);
                make.height.equalTo(@20);
                make.width.equalTo(@60);
            }];
        }else if (i == 1){
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(address.mas_right).offset(i*130-5);
                make.centerY.equalTo(address.mas_centerY);
                make.height.equalTo(@20);
                make.width.equalTo(@120);
            }];
        }else{
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(address.mas_right).offset((i-2)*132+2);
                make.top.equalTo(address.mas_bottom).offset(10);
                make.height.equalTo(@20);
                make.width.equalTo(@70);
            }];
        }
    }
    
    UIView *line2 = [UIView new];
    line2.backgroundColor = RGB(230, 230, 230);
    [self.smallView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.smallView.mas_left).offset(5);
        make.right.equalTo(self.smallView.mas_right).offset(-5);
        make.top.equalTo(address.mas_bottom).offset(35);
        make.height.equalTo(@1);
    }];
    
    self.otherAddress = [UITextField new];
    self.otherAddress.placeholder = @"其他部位";
    self.otherAddress.borderStyle = UITextBorderStyleRoundedRect;//圆角
    [self.smallView addSubview:self.otherAddress];
    [self.otherAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.smallView.mas_right).offset(-5);
        make.height.equalTo(@0);
        make.top.equalTo(line2.mas_bottom).offset(5);
        make.left.equalTo(address.mas_right).offset(5);
    }];
    
    UILabel *recordLabel = [UILabel new];
    recordLabel.textColor = UIColorFromHex(0x666666, 1);
    recordLabel.textAlignment = NSLEFT;
    recordLabel.text = @"反馈记录";
    recordLabel.font = [UIFont systemFontOfSize:16];
    [self.smallView addSubview:recordLabel];
    [recordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.smallView.mas_left).offset(5);
        make.top.equalTo(self.otherAddress.mas_bottom).offset(5);
        make.width.equalTo(@70);
    }];
    
    
    self.textView = [UITextView new];
    self.textView.textColor = UIColorFromHex(0x666666, 1);
    self.textView.font = [UIFont systemFontOfSize:16.f];
    self.textView.delegate = self;
    self.textView.layer.borderColor = UIColorFromHex(0x666666, 1).CGColor;
    self.textView.layer.borderWidth = 1.0;
    self.textView.layer.cornerRadius = 3.0;
    [self.textView.layer setMasksToBounds:YES];
    [self.smallView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(recordLabel.mas_right).offset(3);
        make.top.equalTo(recordLabel.mas_top);
        make.right.equalTo(self.smallView.mas_right).offset(-5);
        make.height.equalTo(@50);
    }];
    self.placeHolderLabel = [[UILabel alloc] init];
    self.placeHolderLabel.text = @"填写说明: 请尽量详细的阐述温度异常时段用户的所处环境,行为及具体情况";
    self.placeHolderLabel.numberOfLines = 0;
    self.placeHolderLabel.textAlignment = NSLEFT;
    self.placeHolderLabel.textColor = UIColorFromHex(0x666666, 1);
    self.placeHolderLabel.font = [UIFont systemFontOfSize:15.f];
    [self.smallView addSubview:self.placeHolderLabel];
    
    [self.placeHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(recordLabel.mas_right).offset(7);
        make.top.equalTo(recordLabel.mas_top);
        make.right.equalTo(self.smallView.mas_right).offset(-7);
        make.height.equalTo(@50);
    }];
    
    self.followup = 0;
    self.position = 1;
    
    UIButton *cofmBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [cofmBtn setTitle:@"确认" forState:(UIControlStateNormal)];
    [cofmBtn setTitleColor:UIColorFromHex(0x666666, 1) forState:(UIControlStateNormal)];
    cofmBtn.layer.masksToBounds = YES;
    cofmBtn.layer.borderColor = UIColorFromHex(0x999999, 1).CGColor;
    cofmBtn.layer.borderWidth =0.5;
    [cofmBtn addTarget:self action:@selector(cofmSel) forControlEvents:(UIControlEventTouchUpInside)];
    [self.smallView addSubview:cofmBtn];
    [cofmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.smallView.mas_left);
        make.height.equalTo(@50);
        make.width.equalTo(@((kSWidth-20)/2));
        make.bottom.equalTo(self.smallView.mas_bottom);
    }];
    
    UIButton *cancleBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [cancleBtn setTitle:@"取消" forState:(UIControlStateNormal)];
    [cancleBtn setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    cancleBtn.layer.masksToBounds = YES;
    cancleBtn.layer.borderColor = UIColorFromHex(0x999999, 1).CGColor;
    cancleBtn.layer.borderWidth =0.5;
    [cancleBtn addTarget:self action:@selector(cancleSel) forControlEvents:(UIControlEventTouchUpInside)];
    [self.smallView addSubview:cancleBtn];
    [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.smallView.mas_right);
        make.height.equalTo(@50);
        make.width.equalTo(@((kSWidth-20)/2));
        make.bottom.equalTo(self.smallView.mas_bottom);
    }];
//    [self getCurrentTimes:@"YYYY-MM-dd'T'HH:mm:ssZZZZ"]]

    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:self.model.dateTime/1000];
  NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];

   [dateFormat setDateFormat:@"YYYY-MM-dd'T'HH:mm:ss.SSSZ"];

  self.lastAlertTime = [dateFormat stringFromDate:confromTimesp];
    
    [self getFeedData];
    [self getDataTime:3];
}

#pragma mark 身体状况选择
- (void)bodySel:(UIButton *)sender{
    if (sender.tag == 100) {
        self.followup = 0;
        sender.selected = YES;
        UIButton *btn1 = (UIButton *)[self.view viewWithTag:101];
        UIButton *btn2 = (UIButton *)[self.view viewWithTag:102];
        btn1.selected = NO;
        btn2.selected = NO;
    }else if (sender.tag == 101){
        self.followup = 1;
        sender.selected = YES;
        UIButton *btn1 = (UIButton *)[self.view viewWithTag:100];
        UIButton *btn2 = (UIButton *)[self.view viewWithTag:102];
        btn1.selected = NO;
        btn2.selected = NO;
    }else if (sender.tag == 102){
        self.followup = 2;
        sender.selected = YES;
        UIButton *btn1 = (UIButton *)[self.view viewWithTag:101];
        UIButton *btn2 = (UIButton *)[self.view viewWithTag:100];
        btn1.selected = NO;
        btn2.selected = NO;
    }
}

#pragma mark 佩戴位置选择
- (void)addressSel:(UIButton *)sender{
    if (sender.tag == 200) {
        self.position = 1;
        sender.selected = YES;
        UIButton *btn1 = (UIButton *)[self.view viewWithTag:201];
        UIButton *btn2 = (UIButton *)[self.view viewWithTag:202];
        UIButton *btn3 = (UIButton *)[self.view viewWithTag:203];
        btn1.selected = NO;
        btn2.selected = NO;
        btn3.selected = NO;
        [self.otherAddress mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        [self.smallView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@330);
        }];
    }else if (sender.tag == 201){
        self.position = 2;
        sender.selected = YES;
        UIButton *btn1 = (UIButton *)[self.view viewWithTag:200];
        UIButton *btn2 = (UIButton *)[self.view viewWithTag:202];
        UIButton *btn3 = (UIButton *)[self.view viewWithTag:203];
        btn1.selected = NO;
        btn2.selected = NO;
        btn3.selected = NO;
        [self.otherAddress mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        [self.smallView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@330);
        }];
    }else if (sender.tag == 202){
        self.position = 3;
        sender.selected = YES;
        UIButton *btn1 = (UIButton *)[self.view viewWithTag:201];
        UIButton *btn2 = (UIButton *)[self.view viewWithTag:200];
        UIButton *btn3 = (UIButton *)[self.view viewWithTag:203];
        btn1.selected = NO;
        btn2.selected = NO;
        btn3.selected = NO;
        [self.otherAddress mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        [self.smallView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@330);
        }];
    }else if (sender.tag == 203){
        self.position = 99;
        sender.selected = YES;
        UIButton *btn1 = (UIButton *)[self.view viewWithTag:201];
        UIButton *btn2 = (UIButton *)[self.view viewWithTag:202];
        UIButton *btn3 = (UIButton *)[self.view viewWithTag:200];
        btn1.selected = NO;
        btn2.selected = NO;
        btn3.selected = NO;
        [self.otherAddress mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@30);
        }];
        [self.smallView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@360);
        }];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if (text.length != 0) {
        self.placeHolderLabel.text = @"";
    }else{
        if (textView.text.length == 0){
            self.placeHolderLabel.text = @"填写说明: 请尽量详细的阐述温度异常时段用户的所处环境,行为及具体情况";
        }
        else if (textView.text.length != 1) {
            self.placeHolderLabel.text = @"";
        }else{
            self.placeHolderLabel.text = @"填写说明: 请尽量详细的阐述温度异常时段用户的所处环境,行为及具体情况";
        }
    }
    return YES;
}



- (void)threeSel{
    self.threeBtn.selected = YES;
    self.sevenBtn.selected = NO;
    self.fourBtn.selected = NO;
    [self.threeBtn setBackgroundColor:RGB(52, 137, 255)];
    [self.sevenBtn setBackgroundColor:RGB(231, 231, 231)];
    [self.fourBtn setBackgroundColor:RGB(231, 231, 231)];
    [self getDataTime:3];
}

- (void)sevenSel{
    self.threeBtn.selected = NO;
    self.sevenBtn.selected = YES;
    self.fourBtn.selected = NO;
    [self.sevenBtn setBackgroundColor:RGB(52, 137, 255)];
    [self.threeBtn setBackgroundColor:RGB(231, 231, 231)];
    [self.fourBtn setBackgroundColor:RGB(231, 231, 231)];
    [self getDataTime:7];
}

- (void)fourSel{
    self.threeBtn.selected = NO;
    self.sevenBtn.selected = NO;
    self.fourBtn.selected = YES;
    [self.fourBtn setBackgroundColor:RGB(52, 137, 255)];
    [self.threeBtn setBackgroundColor:RGB(231, 231, 231)];
    [self.sevenBtn setBackgroundColor:RGB(231, 231, 231)];
    [self getDataTime:14];
}

#pragma mark 新增筛查反馈
- (void)addRecSel{
    [UIView animateWithDuration:1 animations:^{
        [self.bigView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.top.equalTo(self.view.mas_top);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
        [self.smallView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.centerY.equalTo(self.view.mas_centerY).multipliedBy(0.8);
            make.left.equalTo(self.view.mas_left).offset(10);
            make.height.equalTo(@330);
        }];
    }];
}

- (void)bigSel{
    [UIView animateWithDuration:1 animations:^{
        [self.bigView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.top.equalTo(self.view.mas_bottom);
            make.height.equalTo(@(kSHeight));
        }];
        [self.smallView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.centerY.equalTo(self.view.mas_centerY).multipliedBy(2.8);
            make.left.equalTo(self.view.mas_left).offset(10);
            make.height.equalTo(@330);
        }];
    }];
}

#pragma mark 提交反馈记录
- (void)cofmSel{
    NSString *addreOther;
    if (self.position == 99) {
        if (self.otherAddress.text.length == 0) {
            [MyTool showHudMessage:@"请填写佩戴位置"];
            return;
        }
        addreOther = self.otherAddress.text;
    }else{
        addreOther = @"";
    }
    
    if (self.textView.text.length == 0) {
        [MyTool showHudMessage:@"请填写反馈记录"];
        return;
    }
    NSDictionary *dict = @{@"userId":self.model.userId,@"comment":self.textView.text,@"position":@(self.position),@"followup":@(self.followup),@"otherPosition":addreOther,@"commentTime":[NSString stringWithFormat:@"%@",[self getCurrentTimes:@"YYYY-MM-dd'T'HH:mm:ss.SSSZ"]],@"insertTime":[self getCurrentTimes:@"YYYY-MM-dd'T'HH:mm:ss.SSSZ"],@"lastAlertTime;":self.lastAlertTime};
    
    NSString *url = [NSString stringWithFormat:@"%@/api/comment/save",base_url];
    YYLog(@"YYUserToken==%@",YYUserToken);
    
    [NetworkTool sharedNetworkTool].requestSerializer = [AFJSONRequestSerializer serializer];
    [[NetworkTool sharedNetworkTool].requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [[NetworkTool sharedNetworkTool].requestSerializer setValue:YYUserToken forHTTPHeaderField:@"Authorization"];
    [[NetworkTool sharedNetworkTool] requestWithMethod:CGNetworkMethodPOST URLString:url parameters:dict finished:^(id result, NSString *error) {
        YYLog(@"loaduserid==%@",result);
        if (error == nil) {
            [UIView animateWithDuration:1 animations:^{
                [self.bigView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.view.mas_left);
                    make.right.equalTo(self.view.mas_right);
                    make.top.equalTo(self.view.mas_bottom);
                    make.height.equalTo(@(kSHeight));
                }];
                [self.smallView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self.view.mas_centerX);
                    make.centerY.equalTo(self.view.mas_centerY).multipliedBy(2.8);
                    make.left.equalTo(self.view.mas_left).offset(10);
                    make.height.equalTo(@330);
                }];
            }];
            [self getFeedData];
        }
    }];
}

- (void)cancleSel{
    [UIView animateWithDuration:1 animations:^{
        [self.bigView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.top.equalTo(self.view.mas_bottom);
            make.height.equalTo(@(kSHeight));
        }];
        [self.smallView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.centerY.equalTo(self.view.mas_centerY).multipliedBy(2.8);
            make.left.equalTo(self.view.mas_left).offset(10);
            make.height.equalTo(@330);
        }];
    }];
}


-(void)showLineDemo{
    /** 图表选项 */
    PYOption *option = [[PYOption alloc] init];
    //是否启用拖拽重计算特性，默认关闭
    option.calculable = NO;
    //数值系列的颜色列表(折线颜色)
    option.color = @[@"#20BCFC", @"#333333"];
    // 图标背景色
    // option.backgroundColor = [[PYColor alloc] initWithColor:[UIColor orangeColor]];
    option.dataZoomEqual([PYDataZoom initPYDataZoomWithBlock:^(PYDataZoom *dataZoom) {
        dataZoom.showEqual(YES).startEqual(@0);
    }]);
    option.addXAxis([PYAxis initPYAxisWithBlock:^(PYAxis *axis) {
        axis.typeEqual(PYAxisTypeTime)
        .splitNumberEqual(@10);
    }]);
    
    option.addYAxis([PYAxis initPYAxisWithBlock:^(PYAxis *axis) {
        axis.typeEqual(PYAxisTypeValue);
    }]);
    /** 提示框 */
    PYTooltip *tooltip = [[PYTooltip alloc] init];
    // 触发类型 默认数据触发
    tooltip.trigger = @"axis";
    // 竖线宽度
    tooltip.axisPointer.lineStyle.width = @1;
    // 提示框 文字样式设置
    tooltip.textStyle = [[PYTextStyle alloc] init];
    tooltip.textStyle.fontSize = @12;
    // 提示框 显示自定义
    // tooltip.formatter = @"(function(params){ var res = params[0].name; for (var i = 0, l = params.length; i < l; i++) {res += '<br/>' + params[i].seriesName + ' : ' + params[i].value;}; return res})";
    // 添加到图标选择中
    option.tooltip = tooltip;
    
    
    /** 图例 */
    PYLegend *legend = [[PYLegend alloc] init];
    // 添加到图标选择中
    option.legend = legend;
    
    
    /** 直角坐标系内绘图网格, 说明见下图 */
    PYGrid *grid = [[PYGrid alloc] init];
    // 左上角位置
    grid.x = @(45);
    grid.y = @(20);
    // 右下角位置
    grid.x2 = @(20);
    grid.y2 = @(30);
    grid.borderWidth = @(0);
    
    // 添加到图标选择中
    option.grid = grid;
    
    /** X轴设置 */
    PYAxis *xAxis = [[PYAxis  alloc] init];
    //横轴默认为类目型(就是坐标自己设置)
    xAxis.type = @"category";
    // 起始和结束两端空白
    xAxis.boundaryGap = @(YES);
    // 分隔线
    xAxis.splitLine.show = NO;
    // 坐标轴线
    xAxis.axisLine.show = NO;
    // X轴坐标数据
    xAxis.data = self.timeArray;
    // 坐标轴小标记
    xAxis.axisTick = [[PYAxisTick alloc] init];
    xAxis.axisTick.show = YES;
    
    // 添加到图标选择中
    option.xAxis = [[NSMutableArray alloc] initWithObjects:xAxis, nil];
    
    
    /** Y轴设置 */
    PYAxis *yAxis = [[PYAxis alloc] init];
    yAxis.axisLine.show = NO;
    yAxis.axisLine.lineStyle.type = PYLineStyleTypeSolid;
    // 纵轴默认为数值型(就是坐标系统生成), 改为 @"category" 会有问题, 读者可以自行尝试
    yAxis.type = @"value";
    yAxis.axisTick.show = NO;
    yAxis.axisLabel.show = NO;
    // 分割段数，默认为5
    yAxis.splitNumber = @5;
    
    // 分割线类型
    // yAxis.splitLine.lineStyle.type = @"dashed";   //'solid' | 'dotted' | 'dashed' 虚线类型
    
    //单位设置,  设置最大值, 最小值
    // yAxis.axisLabel.formatter = @"{value} k";
    yAxis.max = @40;
    yAxis.min = @20;
    
    
    // 添加到图标选择中  ( y轴更多设置, 自行查看官方文档)
    option.yAxis = [[NSMutableArray alloc] initWithObjects:yAxis, nil];
    
    /** 定义坐标点数组 */
    NSMutableArray *seriesArr = [NSMutableArray array];
    /** 第一条折线设置 */
    PYCartesianSeries *series1 = [[PYCartesianSeries alloc] init];
    series1.name = @"温度";
    // 类型为折线
    series1.type = @"bar";
    // 曲线平滑
    // series1.smooth = YES;
    // 坐标点大小
    series1.symbolSize = @(1.5);
    // 坐标点样式, 设置连线的宽度
    series1.itemStyle = [[PYItemStyle alloc] init];
    series1.itemStyle.normal = [[PYItemStyleProp alloc] init];
    series1.itemStyle.normal.lineStyle = [[PYLineStyle alloc] init];
    series1.itemStyle.normal.lineStyle.width = @(1.5);
    // 添加坐标点 y 轴数据 ( 如果某一点 无数据, 可以传 @"-" 断开连线 如 : @[@"7566", @"-", @"7571"]  )
    series1.data = self.valueArray;
    [seriesArr addObject:series1];
    
    
    [option setSeries:seriesArr];
    /** 初始化图表 */
    if (self.kEchartView == nil) {
        self.kEchartView = [[PYZoomEchartsView alloc] initWithFrame:CGRectMake(-37, 0, self.view.frame.size.width, 240)];
        // 添加到 scrollView 上
        [self.scrollView addSubview:self.kEchartView];
    }

    // 图表选项添加到图表上
    [self.kEchartView setOption:option];
    [self.kEchartView loadEcharts];
}
#pragma mark 获取柱状图数据
- (void)getDataTime:(int )time{
    [MyTool showHud];
    NSString *url = [NSString stringWithFormat:@"%@/api/temp/list",base_url];
    YYLog(@"YYUserToken==%@",YYUserToken);
    NSDictionary *dict = @{@"userId":self.model.userId,@"start":[NSString stringWithFormat:@"%@ 00:00:00",[self beforeDay:[self getCurrentTimes:@"YYYY-MM-dd"] dyas:time]],@"end":[self getCurrentTimes:@"YYYY-MM-dd HH:mm:ss"]
    };
    NSLog(@"%@",YYUserToken);
    [NetworkTool sharedNetworkTool].requestSerializer = [AFJSONRequestSerializer serializer];
    [[NetworkTool sharedNetworkTool].requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [[NetworkTool sharedNetworkTool].requestSerializer setValue:YYUserToken forHTTPHeaderField:@"Authorization"];
    [[NetworkTool sharedNetworkTool] requestWithMethod:CGNetworkMethodGET URLString:url parameters:dict finished:^(id result, NSString *error) {
        YYLog(@"loaduserid==%@",result);
        [MyTool dismissHud];
        if (error == nil) {
            [self.timeArray removeAllObjects];
            [self.valueArray removeAllObjects];
            NSString *staTime = [self beforeDay:[self getCurrentTimes:@"YYYY-MM-dd HH:mm:ss"] dyas:time];
            self.dataArray = [NSArray yy_modelArrayWithClass:[HMDayLiveModel class] json:result[@"data"]];
            NSMutableArray *stampArray = [NSMutableArray array];
            for (int i = 0; i<288*time; i++) {
                NSString *time = [self beforeDay:staTime min:i*5];
                [stampArray addObject:[self getTimeStrWithString:time]];
                [self.timeArray addObject:time];
                [self.valueArray addObject:@"-"];
            }
            NSMutableArray *monthArray = [NSMutableArray array];
            NSMutableArray *tempArray = [NSMutableArray array];
            for (HMDayLiveModel *model in self.dataArray) {
                
                
               
                [monthArray addObject:[self getTimeStrWithString:[self timeZoneString:model.timepoint]]];
                [tempArray addObject:model.value];
            }
            dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_CONCURRENT);
            
            // 同步执行任务创建方法
            dispatch_sync(queue, ^{
                for (int i = 0; i<monthArray.count; i++) {
                    for (int j = 0; j<self.timeArray.count; j++) {
                        NSString *time = monthArray[i];
                        if (j == self.timeArray.count-1) {
                            break;
                        }else{
                            if ([time floatValue]>[stampArray[j] floatValue] && [time floatValue]<[stampArray[j+1] floatValue]) {
                                [self.valueArray replaceObjectAtIndex:j withObject:tempArray[i]];
                                break;
                            }
                        }
                    }
                }
            });
            [self showLineDemo];
        }
        
    }];
}

#pragma mark 获取筛查记录
- (void)getFeedData{
    
    NSString *url = [NSString stringWithFormat:@"%@/api/comment/list",base_url];
    YYLog(@"YYUserToken==%@",YYUserToken);
    NSDictionary *dict = @{@"userId":self.model.userId
    };
    [NetworkTool sharedNetworkTool].requestSerializer = [AFJSONRequestSerializer serializer];
    [[NetworkTool sharedNetworkTool].requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [[NetworkTool sharedNetworkTool].requestSerializer setValue:YYUserToken forHTTPHeaderField:@"Authorization"];
    [[NetworkTool sharedNetworkTool] requestWithMethod:CGNetworkMethodGET URLString:url parameters:dict finished:^(id result, NSString *error) {
        YYLog(@"loaduserid==%@",result);
        if (error == nil) {
            self.feedData = [NSArray yy_modelArrayWithClass:[HMabnormalModel class] json:result[@"data"]];
            if (self.feedData.count != 0) {
                self.noData.hidden = YES;
            }else{
                self.noData.hidden = NO;
            }
            [self.feedbackTableView reloadData];
        }
        
    }];
    
}

#pragma mark 字符串转时间戳
- (NSString *)getTimeStrWithString:(NSString *)str{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:@"MM-dd HH:mm"]; //设定时间的格式
    NSDate *tempDate = [dateFormatter dateFromString:str];//将字符串转换为时间对象
    NSString *timeStr = [NSString stringWithFormat:@"%ld", (long)[tempDate timeIntervalSince1970]*1000];//字符串转成时间戳,精确到毫秒*1000
    return timeStr;
}

-(NSString*)getCurrentTimes:(NSString *)temFormat{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:temFormat];
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    return currentTimeString;
}


- (UIImage *)drawLineOfDashByImageView:(UIImageView *)imageView {
    // 开始划线 划线的frame
    UIGraphicsBeginImageContext(imageView.frame.size);
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    // 获取上下文
    CGContextRef line = UIGraphicsGetCurrentContext();
    // 设置线条终点的形状
    CGContextSetLineCap(line, kCGLineCapRound);
    // 设置虚线的长度 和 间距
    CGFloat lengths[] = {5,5};
    CGContextSetStrokeColorWithColor(line, [UIColor redColor].CGColor);
    // 开始绘制虚线
    CGContextSetLineDash(line, 0, lengths, 2);
    CGContextMoveToPoint(line, 0.0, 2.0);
    CGContextAddLineToPoint(line, kSWidth-50, 2.0);
    CGContextStrokePath(line);
    
    return UIGraphicsGetImageFromCurrentImageContext();
}

- (void)creatScrollView{
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(30, 80, self.view.frame.size.width , 240)];
    [self.view addSubview:self.scrollView];
//    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width *4-30, 0);
    self.scrollView.showsHorizontalScrollIndicator = NO;
}

- (void)p_popViewController{
    [self.navigationController popViewControllerAnimated:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.feedData.count;
}

#pragma mark 几天之前
- (NSString *)beforeDay:(NSString *)temFormat dyas:(int)day{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:temFormat];
    NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60*day sinceDate:date];
    NSDateFormatter *lastformatter = [[NSDateFormatter alloc] init];
    [lastformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *dateTime = [lastformatter stringFromDate:lastDay];
    return dateTime;
}

#pragma mark 几分钟之后
- (NSString *)beforeDay:(NSString *)temFormat min:(int)min{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:temFormat];
    NSDate *lastDay = [NSDate dateWithTimeInterval:60*min sinceDate:date];
    NSDateFormatter *lastformatter = [[NSDateFormatter alloc] init];
    [lastformatter setDateFormat:@"MM-dd HH:mm"];
    NSString *dateTime = [lastformatter stringFromDate:lastDay];
    return dateTime;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HMFeedbackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HMFeedbackID" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.feedData[indexPath.row];
    return cell;
}

#pragma mark 返回的时区字符串转化成年月日字符串
- (NSString *)timeZoneString:(NSString *)timeString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
     [formatter setDateFormat:@"YYYY-MM-dd'T'HH:mm:ss.SSSZ"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    NSDate *date = [formatter dateFromString:timeString];
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
        [dateFormat setDateFormat:@"MM-dd HH:mm"];
     NSString *days = [dateFormat stringFromDate:date];
    return days;
}

- (UITableView *)feedbackTableView{
    if (!_feedbackTableView) {
        _feedbackTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, KHight*0.256, FrameSize.width, KHight*0.375) style:(UITableViewStylePlain)];
        _feedbackTableView.scrollEnabled = YES;
        _feedbackTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _feedbackTableView.backgroundColor = [UIColor whiteColor];
        _feedbackTableView.delegate = self;
        _feedbackTableView.dataSource = self;
        _feedbackTableView.bounces = YES;
        _feedbackTableView.estimatedRowHeight = 95;  //  随便设个不那么离谱的值
        _feedbackTableView.rowHeight = UITableViewAutomaticDimension;
        [_feedbackTableView registerNib:[UINib nibWithNibName:@"HMFeedbackTableViewCell" bundle:nil] forCellReuseIdentifier:@"HMFeedbackID"];
    }
    return _feedbackTableView;
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
