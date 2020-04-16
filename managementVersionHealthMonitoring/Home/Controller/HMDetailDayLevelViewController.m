//
//  HMDetailDayLevelViewController.m
//  managementVersionHealthMonitoring
//
//  Created by Mr - 宋 on 2020/3/27.
//  Copyright © 2020 song. All rights reserved.
//

#import "HMDetailDayLevelViewController.h"
#import "HMDetailDayTableViewCell.h"
@interface HMDetailDayLevelViewController ()<UITableViewDataSource,UITableViewDelegate,personDetailDelegate,sortPersonDelagate>
@property(nonatomic,strong)NSArray *dataArray,*listArray;
@property (nonatomic,strong)UILabel *topLabel;
@property (nonatomic,strong)UIScrollView *bgScrollView;
@property (nonatomic,strong)UITableView *dayTableView;
@property (nonatomic,assign)BOOL sort;
@property (nonatomic,assign)int number;
@end

@implementation HMDetailDayLevelViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"日活人员明细";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:19],NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
       [self.navigationController.navigationBar setBarTintColor:MaingreenColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
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
    self.sort = NO;
    self.number = 2;
    NSString *titleString = [NSString stringWithFormat:@"%@     %@%@日活日活人员明细",[self getCurrentTimes:@"YYYY年MM月dd日"],self.time,self.name];
    self.topLabel = [UILabel new];
    self.topLabel.numberOfLines = 0;
    self.topLabel.textAlignment = NSLEFT;
    self.topLabel.textColor = UIColorFromHex(0x666666, 1);
    self.topLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:self.topLabel];
    NSArray *array = @[[titleString substringWithRange:NSMakeRange(0, 11)]];
        self.topLabel.attributedText = [titleString changeToAttributeStringWithSubstringArray:array Color:UIColorFromHex(0x000000, 1) FontSize:16];
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.top.equalTo(self.view.mas_top).offset(10);
    }];
    self.bgScrollView = [UIScrollView new];
    self.bgScrollView.frame = CGRectMake(0, 80, kSWidth, kSHeight-80);
    self.bgScrollView.contentSize = CGSizeMake(kSWidth/4*5, kSHeight-80);
    self.bgScrollView.scrollEnabled = YES;
    self.bgScrollView.bounces = NO;
    self.bgScrollView.showsHorizontalScrollIndicator = NO;
    self.bgScrollView.showsVerticalScrollIndicator   = YES;
    [self.view addSubview:self.bgScrollView];

    self.dayTableView.frame = CGRectMake(0, 0, kSWidth/4*5, KHight-100-TABBAR_HEIGHT);
    [self.bgScrollView addSubview:self.dayTableView];
    self.dayTableView.hidden = YES;
    [self.dayTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgScrollView.mas_left);
        make.top.equalTo(self.bgScrollView.mas_top);
        make.width.equalTo(@(kSWidth/4*5));
        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
    }];
    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HMDetailDayTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    // 完美解决xib自定义cell所产生的复用问题
    if (nil == cell) {
        cell= (HMDetailDayTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"HMDetailDayTableViewCell" owner:self options:nil]  lastObject];
    }else{
        //删除cell的所有子视图
        while ([cell.contentView.subviews lastObject] != nil)
        {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    cell.indexRow = indexPath.row;
    if (indexPath.row == 0) {
        cell.nameLabel.text = @"姓名";
        cell.phoneLabel.text = @"手机";
        cell.temLabel.text = @"体温";
        cell.timeLabel.text = @"最后测温时间";
        if (self.sort) {
            switch (self.number) {
                case 0:
                {
                    cell.nameLabel.text = @"姓名↑";
                }
                    break;
                case 1:
                {
                    cell.phoneLabel.text = @"手机↑";
                }
                    break;
                case 2:
                {
                    cell.temLabel.text = @"体温↑";
                }
                    break;
                case 3:
                {
                    cell.timeLabel.text = @"最后测温时间↑";
                }
                    break;
                default:
                    break;
            }
        }else{
            switch (self.number) {
                case 0:
                {
                    cell.nameLabel.text = @"姓名↓";
                }
                    break;
                case 1:
                {
                    cell.phoneLabel.text = @"手机↓";
                }
                    break;
                case 2:
                {
                    cell.temLabel.text = @"体温↓";
                }
                    break;
                case 3:
                {
                    cell.timeLabel.text = @"最后测温时间↓";
                }
                    break;
                default:
                break;
        }
        }
        cell.nameLabel.font = cell.phoneLabel.font = cell.temLabel.font = cell.timeLabel.font = [UIFont systemFontOfSize:19];
        cell.temLabel.textColor = cell.timeLabel.textColor = RGB(52, 137, 255);
        cell.sortDelegate = self;
    }else{
        cell.model = self.dataArray[indexPath.row-1];
        cell.temLabel.textColor = cell.timeLabel.textColor = RGB(81, 81, 81);
        cell.delegate = self;
    }
    
    
    
    return cell;
}

- (void)personModel:(HMPersonModel *)model{
    HMtempDetailViewController *temDetailVC = [HMtempDetailViewController new];
    temDetailVC.model = model;
    [self.navigationController pushViewController:temDetailVC animated:NO];
}

#pragma mark 排序
- (void)sortingNumber:(int)number{
    self.number = number;
    switch (number) {
        case 0:
        {
            NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
            self.dataArray = [self.dataArray sortedArrayUsingComparator:^NSComparisonResult(HMPersonModel*  _Nonnull obj1, HMPersonModel*  _Nonnull obj2) {
                NSString *departmentName1 = obj1.username;
                NSString *departmentName2 = obj2.username;
                NSRange string1Range = NSMakeRange(0, [departmentName1 length]);
                if (self.sort) {
                    return [departmentName2 compare:departmentName1 options:0 range:string1Range locale:locale];
                }else{
                    return [departmentName1 compare:departmentName2 options:0 range:string1Range locale:locale];
                }
            }];
        }
            break;
        case 1:
        {
            self.dataArray = [self.listArray sortedArrayUsingComparator:^NSComparisonResult(HMPersonModel*  _Nonnull obj1, HMPersonModel*  _Nonnull obj2) {
                if (self.sort) {
                    return [obj2.mobile compare:obj1.mobile];
                }else{
                    return [obj1.mobile compare:obj2.mobile];
                }
            }];
        }
            break;
        case 2:
        {
            self.dataArray = [self.listArray sortedArrayUsingComparator:^NSComparisonResult(HMPersonModel*  _Nonnull obj1, HMPersonModel*  _Nonnull obj2) {
                if (self.sort) {
                    return [@(obj2.lastTemp) compare:@(obj1.lastTemp)];
                }else{
                    return [@(obj1.lastTemp) compare:@(obj2.lastTemp)];
                }
            }];
        }
            break;
        case 3:
        {
            self.dataArray = [self.listArray sortedArrayUsingComparator:^NSComparisonResult(HMPersonModel*  _Nonnull obj1, HMPersonModel*  _Nonnull obj2) {
                if (self.sort) {
                    return [obj2.lastActiveTime compare:obj1.lastActiveTime];
                }else{
                    return [obj1.lastActiveTime compare:obj2.lastActiveTime];
                }
            }];
        }
            break;
        default:
            break;
    }
    self.sort = !self.sort;
    [self.dayTableView reloadData];
    
}

- (void)getData{
    [MyTool showHud];
    NSString *url = [NSString stringWithFormat:@"%@/api/daylive_user",base_url];

    NSDictionary *dict = @{@"department":self.FirstLevel,@"company":self.departmentCode, @"day":[self.time substringFromIndex:7],@"useCompanyCode":@"true"};

    [NetworkTool sharedNetworkTool].requestSerializer = [AFJSONRequestSerializer serializer];
    [[NetworkTool sharedNetworkTool].requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [[NetworkTool sharedNetworkTool].requestSerializer setValue:YYUserToken forHTTPHeaderField:@"Authorization"];
    [[NetworkTool sharedNetworkTool] requestWithMethod:CGNetworkMethodGET URLString:url parameters:dict finished:^(id result, NSString *error) {
        YYLog(@"loaduserid==%@",result);
        [MyTool dismissHud];
        if (error == nil) {
            self.listArray = [NSArray yy_modelArrayWithClass:[HMPersonModel class] json:result[@"data"]];
            self.dataArray = [self.listArray sortedArrayUsingComparator:^NSComparisonResult(HMPersonModel*  _Nonnull obj1, HMPersonModel*  _Nonnull obj2) {
                return [@(obj2.lastTemp) compare:@(obj1.lastTemp)];
            }];
            self.dayTableView.hidden = NO;
            [self.dayTableView reloadData];
        }
        
    }];
}


-(NSString*)getCurrentTimes:(NSString *)temFormat{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:temFormat];
    NSDate *datenow = [NSDate date];
    //----------将nsdate按formatter格式转成nsstring
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    NSLog(@"currentTimeString =  %@",currentTimeString);
    return currentTimeString;
}

- (void)p_popViewController{
    [self.navigationController popViewControllerAnimated:NO];
}

- (UITableView *)dayTableView{
    if (!_dayTableView) {
        _dayTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, KHight*0.256, FrameSize.width, KHight*0.375) style:(UITableViewStylePlain)];
        _dayTableView.scrollEnabled = YES;
        _dayTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _dayTableView.backgroundColor = [UIColor whiteColor];
        _dayTableView.delegate = self;
        _dayTableView.dataSource = self;
        _dayTableView.bounces = YES;
        _dayTableView.estimatedRowHeight = 95;  //  随便设个不那么离谱的值
        _dayTableView.rowHeight = UITableViewAutomaticDimension;
        [_dayTableView registerNib:[UINib nibWithNibName:@"HMDetailDayTableViewCell" bundle:nil] forCellReuseIdentifier:@"HMPersonID"];
    }
    return _dayTableView;
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
