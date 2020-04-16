//
//  HMDayLiveViewController.m
//  managementVersionHealthMonitoring
//  一级单位
//  Created by Mr - 宋 on 2020/3/23.
//  Copyright © 2020 song. All rights reserved.
//

#import "HMDayLiveViewController.h"
#import "WMZDialog.h"
#import "CalanderModel.h"
@interface HMDayLiveViewController ()<UITableViewDelegate,UITableViewDataSource,dayLiveDelegata,UISearchBarDelegate,sortingDayDelegate>
@property (nonatomic,strong)UILabel *updateLabel,*tipsLabel,*refreshLabel;
@property (nonatomic,strong)UIScrollView *bgScrollView;
@property (nonatomic,strong)UITableView *dayTableView;
@property (nonatomic,strong)NSArray *dataArray,*listArray;
@property (nonatomic,strong)UIView *headView;
@property (nonatomic,strong)UILabel *beforeLabel,*dateLabel,*nextLabel;
@property (nonatomic,strong)UISearchBar *serachBar;
@property (nonatomic,assign)BOOL sort;
@property (nonatomic,assign)int number;
@end

@implementation HMDayLiveViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.sort = NO;
    self.number = 3;
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.dayTableView.hidden = YES;
    self.serachBar = [UISearchBar new];
    self.serachBar.delegate = self;
    self.serachBar.placeholder = @"请输入姓名或单位或手机号码";
    self.serachBar.searchBarStyle = UISearchBarStyleDefault;
    [self.view addSubview:self.serachBar];
    [self.serachBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(3);
        make.right.equalTo(self.view.mas_right).offset(-3);
        make.top.equalTo(self.view.mas_top).offset(5);
        make.height.equalTo(@50);
    }];
    
    self.updateLabel = [UILabel new];
    self.updateLabel.textColor = UIColorFromHex(0x666666, 1);
    self.updateLabel.text = [NSString stringWithFormat:@"最后更新时间:%@",[self getCurrentTimes:@"YYYY-MM-dd HH:mm:ss"]];
    self.updateLabel.font = [UIFont systemFontOfSize:14];
    self.updateLabel.textAlignment = NSLEFT;
    [self.view addSubview:self.updateLabel];
    [self.updateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(7);
        make.top.equalTo(self.serachBar.mas_bottom).offset(10);
    }];
    
    self.tipsLabel = [UILabel new];
    self.tipsLabel.textColor = UIColorFromHex(0x666666, 1);
    self.tipsLabel.text = @"小贴士:点击表头可以排序";
    self.tipsLabel.font = [UIFont systemFontOfSize:14];
    self.tipsLabel.textAlignment = NSLEFT;
    [self.view addSubview:self.tipsLabel];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(7);
        make.top.equalTo(self.updateLabel.mas_bottom).offset(4);
    }];
    
    self.refreshLabel = [UILabel new];
    self.refreshLabel.text = @"刷新";
    self.refreshLabel.textAlignment = NSCENTER;
    self.refreshLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *refTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(refreshSel)];
    [self.refreshLabel addGestureRecognizer:refTap];
    self.refreshLabel.backgroundColor = MainBlueColor;
    self.refreshLabel.layer.masksToBounds = YES;
    self.refreshLabel.layer.cornerRadius = 15;
    self.refreshLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.refreshLabel];
    [self.refreshLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.equalTo(@30);
        make.width.equalTo(@60);
        make.top.equalTo(self.serachBar.mas_bottom).offset(5);
    }];
    
    self.headView = [UIView new];
    self.headView.frame = CGRectMake(0, 100, kSWidth, 50);
    self.headView.hidden = NO;
    self.headView.userInteractionEnabled = YES;
    [self.view addSubview:self.headView];

    self.beforeLabel = [UILabel new];
    self.beforeLabel.text = @"< 前一天";
    self.beforeLabel.textColor = RGB(52, 137, 255);
    self.beforeLabel.font = [UIFont systemFontOfSize:14];
    self.beforeLabel.userInteractionEnabled = YES;
    self.beforeLabel.textAlignment = NSCENTER;
    UITapGestureRecognizer *befTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(befTapSel)];
    [self.beforeLabel addGestureRecognizer:befTap];
    [self.headView addSubview:self.beforeLabel];
    [self.beforeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headView.mas_centerY);
        make.centerX.equalTo(self.headView.mas_centerX).multipliedBy(0.4);
    }];
    
    self.dateLabel = [UILabel new];
    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[self getCurrentTimes:@"YYYY-MM-dd"] attributes:attribtDic];
    self.dateLabel.attributedText = attribtStr;
    self.dateLabel.textColor = RGB(52, 137, 255);
    self.dateLabel.font = [UIFont systemFontOfSize:14];
    self.dateLabel.userInteractionEnabled = YES;
    self.dateLabel.textAlignment = NSCENTER;
    UITapGestureRecognizer *dateTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dateTapSel)];
    [self.dateLabel addGestureRecognizer:dateTap];
    [self.headView addSubview:self.dateLabel];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headView.mas_centerY);
        make.centerX.equalTo(self.headView.mas_centerX);
    }];
    
    self.nextLabel = [UILabel new];
    self.nextLabel.text = @"后一天 >";
    self.nextLabel.textColor = RGB(52, 137, 255);
    self.nextLabel.font = [UIFont systemFontOfSize:14];
    self.nextLabel.userInteractionEnabled = YES;
    self.nextLabel.textAlignment = NSCENTER;
    UITapGestureRecognizer *nextTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nextTapSel)];
    [self.nextLabel addGestureRecognizer:nextTap];
    [self.headView addSubview:self.nextLabel];
    [self.nextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headView.mas_centerY);
        make.centerX.equalTo(self.headView.mas_centerX).multipliedBy(1.6);
    }];
    
    self.bgScrollView = [UIScrollView new];
    self.bgScrollView.frame = CGRectMake(0, 180, kSWidth-3, kSHeight-245);
    self.bgScrollView.contentSize = CGSizeMake(kSWidth/4*5.1, 0);
    self.bgScrollView.scrollEnabled = YES;
    self.bgScrollView.bounces = NO;
    self.bgScrollView.showsHorizontalScrollIndicator = NO;
    self.bgScrollView.showsVerticalScrollIndicator   = YES;
    [self.view addSubview:self.bgScrollView];
    
    [self.bgScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.top.equalTo(self.view.mas_top).offset(160);
    }];
    [self.bgScrollView addSubview:self.dayTableView];
    [self.dayTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgScrollView.mas_left);
        make.top.equalTo(self.bgScrollView.mas_top);
        make.width.equalTo(@(kSWidth/4*5));
        make.bottom.equalTo(self.view.mas_bottom).offset(-kTabBarHeight+49);
    }];
    
    
    [self getData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.serachBar resignFirstResponder];
    if (self.deletgate && [self.deletgate respondsToSelector:@selector(searchText:)]) {
        [self.deletgate searchText:searchBar.text];
    }
}


#pragma mark 获取数据
- (void)getData{
    [MyTool showHud];
    NSString *url = [NSString stringWithFormat:@"%@/api/departments/daylive",base_url];
    YYLog(@"YYUserToken==%@",YYUserToken);
    NSDictionary *dict = @{@"end":[NSString stringWithFormat:@"%@ %@",self.dateLabel.text,[self getCurrentTimes:@"HH:mm:ss"]]
    };
    YYLog(@"YYUserToken=11=%@",access_token);
    [NetworkTool sharedNetworkTool].requestSerializer = [AFJSONRequestSerializer serializer];
    [[NetworkTool sharedNetworkTool].requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [[NetworkTool sharedNetworkTool].requestSerializer setValue:YYUserToken forHTTPHeaderField:@"Authorization"];
    [[NetworkTool sharedNetworkTool] requestWithMethod:CGNetworkMethodGET URLString:url parameters:dict finished:^(id result, NSString *error) {
        YYLog(@"loaduserid==%@",result);
        [MyTool dismissHud];
        if (error == nil) {
            self.listArray = [NSArray yy_modelArrayWithClass:[HMDayLiveModel class] json:result[@"data"]];
            self.dataArray = [self.listArray sortedArrayUsingComparator:^NSComparisonResult(HMDayLiveModel*  _Nonnull obj1, HMDayLiveModel*  _Nonnull obj2) {
                float ratio1 = obj1.number/obj1.total;
                float ratio2 = obj2.number/obj2.total;
                return [@(ratio1) compare:@(ratio2)];
            }];
            
            self.dayTableView.hidden = NO;
            [self.dayTableView reloadData];
        }
        
    }];
    
}
#pragma mark 前一天
- (void)befTapSel{
    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[self beforeDay:self.dateLabel.text] attributes:attribtDic];
    self.dateLabel.attributedText = attribtStr;
    [self getData];
}

#pragma mark 日期
- (void)dateTapSel{
    WMZDialog *alert =
    Dialog()
    .wTypeSet(DialogTypeCalander);
    alert.wHideCalanderBtnSet(NO);
    alert
    .wTitleSet(@"日历")
    //确定的点击方法
    .wEventOKFinishSet(^(id anyID, id otherData) {
        if (otherData != NULL) {
            CalanderModel *model = (CalanderModel *)otherData;
            NSInteger compare = [self compareWithDate:[NSString stringWithFormat:@"%ld-%.2ld-%.2ld",(long)model.wYear,(long)model.wMonth,model.wDay]];
            if (compare == -1) {
                [MyTool showHudMessage:@"所选日期没有数据"];
                return ;
            }
            
            NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
            NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%ld-%.2ld-%.2ld",(long)model.wYear,model.wMonth,model.wDay] attributes:attribtDic];
            self.dateLabel.attributedText = attribtStr;
            [self getData];
        }
    })
    
    //开启滚动 default YES
    .wCalanderCanScrollSet(YES)
    //标题颜色
    .wMessageColorSet(DialogColor(0x0096ff))
    //改变主题色
    .wOKColorSet(DialogColor(0x0096ff))
    .wStart();
    
}

#pragma mark 后一天
- (void)nextTapSel{
    NSInteger compare = [self compareWithDate:[self nextDay:self.dateLabel.text]];
    if (compare == -1) {
        [MyTool showHudMessage:@"所选日期没有数据"];
        return ;
    }
    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[self nextDay:self.dateLabel.text] attributes:attribtDic];
    self.dateLabel.attributedText = attribtStr;
    [self getData];
}

#pragma mark 刷新
- (void)refreshSel{
    self.updateLabel.text = [NSString stringWithFormat:@"最后更新时间:%@",[self getCurrentTimes:@"YYYY-MM-dd HH:mm:ss"]];
    [self getData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count+2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HMDayLiveTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    // 完美解决xib自定义cell所产生的复用问题
    if (nil == cell) {
        cell= (HMDayLiveTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"HMDayLiveTableViewCell" owner:self options:nil]  lastObject];
    }else{
        //删除cell的所有子视图
        while ([cell.contentView.subviews lastObject] != nil)
        {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    cell.indexRow = indexPath.row;
    if (indexPath.row == 0) {
        cell.departmentLabel.text = @"部门";
        cell.totalNumberLabel.text = @"总人数";
        cell.startingLabel.text = @"开机率";
        cell.dayLabel.text = @"日活率";
        cell.detectionLabel.text = @"有效检测率";
        if (self.sort) {
            switch (self.number) {
                case 0:
                {
                    cell.departmentLabel.text = @"部门↑";
                }
                    break;
                case 1:
                {
                    cell.totalNumberLabel.text = @"总人数↑";
                }
                    break;
                case 2:
                {
                    cell.startingLabel.text = @"开机率↑";
                }
                    break;
                case 3:
                {
                    cell.dayLabel.text = @"日活率↑";
                }
                    break;
                case 4:
                {
                    cell.detectionLabel.text = @"有效检测率↑";
                }
                    break;
                default:
                    break;
            }
        }else{
            switch (self.number) {
                case 0:
                {
                    cell.departmentLabel.text = @"部门↓";
                }
                    break;
                case 1:
                {
                    cell.totalNumberLabel.text = @"总人数↓";
                }
                    break;
                case 2:
                {
                    cell.startingLabel.text = @"开机率↓";
                }
                    break;
                case 3:
                {
                    cell.dayLabel.text = @"日活率↓";
                }
                    break;
                case 4:
                {
                    cell.detectionLabel.text = @"有效检测率↓";
                }
                    break;
                default:
                    break;
            }
        }
        
        cell.departmentLabel.font = cell.totalNumberLabel.font = cell.startingLabel.font = cell.dayLabel.font = cell.detectionLabel.font = [UIFont systemFontOfSize:19];
        cell.departmentLabel.textColor = cell.totalNumberLabel.textColor = cell.startingLabel.textColor = cell.dayLabel.textColor = cell.detectionLabel.textColor = RGB(52, 137, 255);
        cell.sortDelegate = self;
    }else if (indexPath.row == self.dataArray.count+1){
        cell.departmentLabel.textColor = cell.totalNumberLabel.textColor = cell.startingLabel.textColor = cell.dayLabel.textColor = cell.detectionLabel.textColor = RGB(52, 137, 255);
        cell.departmentLabel.text = @"合计";
        float total = 0;
        float effectiveNumberTotal = 0;
        float number = 0;
        float boot = 0;
        for (HMDayLiveModel *model in self.dataArray) {
            total += model.total;
            effectiveNumberTotal += model.effectiveNumberTotal;
            number += model.number;
            if (model.bootNumberTotal>model.total) {
                boot += model.total;
            }else{
                boot += model.bootNumberTotal;
            }
        }
        
        cell.totalNumberLabel.text = [NSString stringWithFormat:@"%.f",total];
        float day = number/total;
        
        if (number == 0 || total == 0) {
            cell.dayLabel.text = [@"0%" stringByAppendingFormat:@"\n(%.f)",number];
        }else if (day>1){
            cell.dayLabel.text = [@"100%" stringByAppendingFormat:@"\n(%.f)",number];
        }else{
            cell.dayLabel.text = [NSString stringWithFormat:@"%@\n(%.f)",[[NSString stringWithFormat:@"%.1f",number/total*100] stringByAppendingString:@"%"],number];
        }
        if (effectiveNumberTotal == 0 || number == 0) {
            cell.detectionLabel.text = @"0%";
        }else if (effectiveNumberTotal/number>1){
            cell.detectionLabel.text = @"100%";
        }else{
            cell.detectionLabel.text = [[NSString stringWithFormat:@"%.1f",effectiveNumberTotal/number*100] stringByAppendingString:@"%"];
        }
        if (boot == 0 || total == 0) {
            cell.startingLabel.text = @"0%";
        }else if (boot/total>1){
            cell.startingLabel.text = @"100%";
        }else{
            cell.startingLabel.text = [[NSString stringWithFormat:@"%.1f",boot/total*100] stringByAppendingString:@"%"];
        }
    }else{
        cell.dayModel = self.dataArray[indexPath.row-1];
        cell.delegate = self;
        cell.departmentLabel.textColor = cell.totalNumberLabel.textColor = cell.startingLabel.textColor = cell.dayLabel.textColor = cell.detectionLabel.textColor = RGB(100, 100, 100);
        cell.departmentLabel.textColor = RGB(52, 137, 255);
        
        
        
    }
    return cell;
}


- (void)dayliveModel:(HMDayLiveModel *)model{
    NSArray *array = [NSArray yy_modelArrayWithClass:[HMDayLiveModel class] json:model.children];
    NSArray *dataArray = [array sortedArrayUsingComparator:^NSComparisonResult(HMDayLiveModel*  _Nonnull obj1, HMDayLiveModel*  _Nonnull obj2) {
        float ratio1 = obj1.number/obj1.total;
        float ratio2 = obj2.number/obj2.total;
        return [@(ratio2) compare:@(ratio1)];
    }];
    
    
    if (self.deletgate && [self.deletgate respondsToSelector:@selector(pushLiveDayArray:name:time:model:)]) {
        [self.deletgate pushLiveDayArray:dataArray name:model.departmentName time:self.updateLabel.text model:model];
    }
    
}

#pragma mark 点击排序
- (void)sortingNumber:(int)number{
    self.number = number;
    switch (number) {
        case 0:
        {
            NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
            self.dataArray = [self.listArray sortedArrayUsingComparator:^NSComparisonResult(HMDayLiveModel*  _Nonnull obj1, HMDayLiveModel*  _Nonnull obj2) {
                NSString *departmentName1 = obj1.departmentName;
                NSString *departmentName2 = obj2.departmentName;
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
            self.dataArray = [self.listArray sortedArrayUsingComparator:^NSComparisonResult(HMDayLiveModel*  _Nonnull obj1, HMDayLiveModel*  _Nonnull obj2) {
                if (self.sort) {
                    return [@(obj1.total) compare:@(obj2.total)];
                }else{
                    return [@(obj2.total) compare:@(obj1.total)];
                }
                
            }];
        }
            break;
        case 2:
        {
            self.dataArray = [self.listArray sortedArrayUsingComparator:^NSComparisonResult(HMDayLiveModel*  _Nonnull obj1, HMDayLiveModel*  _Nonnull obj2) {
                float Live1 = obj1.bootNumberTotal/obj1.total;
                if (obj1.bootNumberTotal == 0 || obj1.total == 0){
                    Live1 = 0;
                }
                
                float Live2 = obj2.bootNumberTotal/obj2.total;
                if (obj2.bootNumberTotal == 0 || obj2.total == 0){
                    Live2 = 0;
                }
                // 排序
                if (self.sort) {
                    return [@(Live1) compare:@(Live2)];
                }else{
                    return [@(Live2) compare:@(Live1)];
                }
            }];
        }
            break;
        case 3:
        {
            self.dataArray = [self.listArray sortedArrayUsingComparator:^NSComparisonResult(HMDayLiveModel*  _Nonnull obj1, HMDayLiveModel*  _Nonnull obj2) {
                float ratio1 = obj1.number/obj1.total;
                float ratio2 = obj2.number/obj2.total;

                if (self.sort) {
                    return [@(ratio1) compare:@(ratio2)];
                }else{
                    return [@(ratio2) compare:@(ratio1)];
                }
                
            }];
        }
            break;
        case 4:
        {
            self.dataArray = [self.listArray sortedArrayUsingComparator:^NSComparisonResult(HMDayLiveModel*  _Nonnull obj1, HMDayLiveModel*  _Nonnull obj2) {
                float etection1 = obj1.effectiveNumberTotal/obj1.number;
                if(obj1.number == 0 || obj1.effectiveNumberTotal == 0){
                    etection1 = 0;
                }
                
                float etection2 = obj2.effectiveNumberTotal/obj2.number;
                if(obj2.number == 0 || obj2.effectiveNumberTotal == 0){
                    etection2 = 0;
                }
                
                if (self.sort) {
                    return [@(etection1) compare:@(etection2)];
                }else{
                    return [@(etection2) compare:@(etection1)];
                }
                
            }];
        }
            break;
        default:
            break;
    }
    [self.dayTableView reloadData];
    self.sort = !self.sort;
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
- (NSString *)beforeDay:(NSString *)temFormat{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [formatter dateFromString:temFormat];
    NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:date];
    NSDateFormatter *lastformatter = [[NSDateFormatter alloc] init];
    [lastformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateTime = [lastformatter stringFromDate:lastDay];
    return dateTime;
}

- (NSString *)nextDay:(NSString *)temFormat{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [formatter dateFromString:temFormat];
    NSDate *lastDay = [NSDate dateWithTimeInterval:24*60*60 sinceDate:date];
    NSDateFormatter *lastformatter = [[NSDateFormatter alloc] init];
    [lastformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateTime = [lastformatter stringFromDate:lastDay];
    return dateTime;
}

#pragma mark 和当前日期比较
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
        [_dayTableView registerNib:[UINib nibWithNibName:@"HMDayLiveTableViewCell" bundle:nil] forCellReuseIdentifier:@"HMDayLiveID"];
    }
    return _dayTableView;
}


@end
