//
//  HMAbnormalViewController.m
//  managementVersionHealthMonitoring
//
//  Created by Mr - 宋 on 2020/3/23.
//  Copyright © 2020 song. All rights reserved.
//

#import "HMAbnormalViewController.h"
#import "HMAbnorTableViewCell.h"
#import "WMZDialog.h"
#import "CalanderModel.h"
@interface HMAbnormalViewController ()<UITableViewDelegate,UITableViewDataSource,abnorDelegate,UISearchBarDelegate,sortAbnorDelegate>
@property (nonatomic,strong)UILabel *updateLabel,*tipsLabel,*refreshLabel,*labelHistory,*totalLabel;
@property (nonatomic,strong)UIButton *historyBtn;
@property (nonatomic,strong)UIScrollView *bgScrollView;
@property (nonatomic,strong)UITableView *dayTableView;
@property (nonatomic,strong)UIView *headView;
@property (nonatomic,strong)UILabel *beforeLabel,*dateLabel,*nextLabel;
@property (nonatomic,strong)NSArray *dataArray,*listArray;
@property (nonatomic,strong)UISearchBar *serachBar;
@property (nonatomic,strong)NSString *textSearch;
@property (nonatomic,assign)NSInteger number;
@property (nonatomic,assign)BOOL sortBool;
@end

@implementation HMAbnormalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.sortBool = NO;
    self.number = 1;
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
        make.left.equalTo(self.view.mas_left).offset(3);
        make.top.equalTo(self.serachBar.mas_bottom).offset(5);
    }];
    self.tipsLabel = [UILabel new];
    self.tipsLabel.textColor = UIColorFromHex(0x666666, 1);
    self.tipsLabel.numberOfLines = 0;
    self.tipsLabel.text = @"小贴士:近期内体温超过37.3的用户,\n点击用户姓名可填写筛查反馈以及查看用户体温变化";
    self.tipsLabel.font = [UIFont systemFontOfSize:14];
    self.tipsLabel.textAlignment = NSLEFT;
    [self.view addSubview:self.tipsLabel];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(3);
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
    
    self.historyBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.historyBtn setImage:[UIImage imageNamed:@"noSelect_Icon"] forState:(UIControlStateNormal)];
    [self.historyBtn setImage:[UIImage imageNamed:@"hasSelect_Icon"] forState:(UIControlStateSelected)];
    self.historyBtn.selected = NO;
    [self.historyBtn addTarget:self action:@selector(hasSelectc:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.historyBtn];
    [self.historyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(3);
        make.top.equalTo(self.tipsLabel.mas_bottom).offset(20);
        make.width.height.equalTo(@25);
    }];
    
    self.labelHistory = [UILabel new];
    self.labelHistory.text = @"显示历史体温异常的用户";
    self.labelHistory.font = [UIFont systemFontOfSize:14];
    self.labelHistory.textColor = UIColorFromHex(0x666666, 1);
    [self.view addSubview:self.labelHistory];
    [self.labelHistory mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.historyBtn.mas_right).offset(2);
        make.centerY.equalTo(self.historyBtn.mas_centerY);
    }];
    
    self.totalLabel = [UILabel new];
    self.totalLabel.font = [UIFont systemFontOfSize:14];
    self.totalLabel.textColor = UIColorFromHex(0x666666, 1);
    self.totalLabel.textAlignment = NSRIGHT;
    [self.view addSubview:self.totalLabel];
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.centerY.equalTo(self.historyBtn.mas_centerY);
    }];
    
    self.headView = [UIView new];
    self.headView.frame = CGRectMake(0, 170, kSWidth, 50);
    self.headView.hidden = NO;
    self.headView.userInteractionEnabled = YES;
    [self.view addSubview:self.headView];
    
    self.beforeLabel = [UILabel new];
    self.beforeLabel.text = @"< 前一天";
    self.beforeLabel.textColor = RGB(52, 137, 255);
    self.beforeLabel.font = [UIFont systemFontOfSize:14];
    self.beforeLabel.userInteractionEnabled = YES;
    self.beforeLabel.textAlignment = NSCENTER;
    self.beforeLabel.userInteractionEnabled = YES;
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
    self.beforeLabel.userInteractionEnabled = YES;
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
    self.nextLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *nextTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nextTapSel)];
    [self.nextLabel addGestureRecognizer:nextTap];
    [self.headView addSubview:self.nextLabel];
    [self.nextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headView.mas_centerY);
        make.centerX.equalTo(self.headView.mas_centerX).multipliedBy(1.6);
    }];
    
    self.bgScrollView = [UIScrollView new];
    self.bgScrollView.contentSize = CGSizeMake(kSWidth/4*5, 0);
    self.bgScrollView.scrollEnabled = YES;
    self.bgScrollView.bounces = NO;
    self.bgScrollView.showsHorizontalScrollIndicator = NO;
    self.bgScrollView.showsVerticalScrollIndicator   = YES;
    [self.view addSubview:self.bgScrollView];
    [self.bgScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.top.equalTo(self.view.mas_top).offset(220);
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
    self.textSearch = searchBar.text;
    [self searchGetData];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    self.textSearch = searchBar.text;
}
#pragma mark 获取搜索数据
- (void)searchGetData{
    [MyTool showHud];
    NSString *url = [NSString stringWithFormat:@"%@/api/deviant/tatol",base_url];
    YYLog(@"YYUserToken==%@",YYUserToken);
    int type = self.historyBtn.selected==1?1:0;
    NSDictionary *dict = @{@"end":[NSString stringWithFormat:@"%@ %@",self.dateLabel.text,[self getCurrentTimes:@"HH:mm:ss"]],
                           @"type":@(type),@"searchStr":self.textSearch
    };
    YYLog(@"YYUserToken=11=%@",access_token);
    [NetworkTool sharedNetworkTool].requestSerializer = [AFJSONRequestSerializer serializer];
    [[NetworkTool sharedNetworkTool].requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [[NetworkTool sharedNetworkTool].requestSerializer setValue:YYUserToken forHTTPHeaderField:@"Authorization"];
    [[NetworkTool sharedNetworkTool] requestWithMethod:CGNetworkMethodGET URLString:url parameters:dict finished:^(id result, NSString *error) {
        YYLog(@"loaduserid==%@",result);
        [MyTool dismissHud];
        if (error == nil) {
            self.listArray = [NSArray yy_modelArrayWithClass:[HMabnormalModel class] json:result[@"data"]];
            self.dataArray = [self.listArray sortedArrayUsingComparator:^NSComparisonResult(HMabnormalModel*  _Nonnull obj1, HMabnormalModel*  _Nonnull obj2) {
                return [obj2.mobile compare:obj1.mobile];
            }];
            self.dayTableView.hidden = NO;
            [self.dayTableView reloadData];
            self.totalLabel.text = [NSString stringWithFormat:@"总条数:%ld",self.dataArray.count];
        }
        
    }];
}


#pragma mark 获取数据
- (void)getData{
    [MyTool showHud];
    NSString *url = [NSString stringWithFormat:@"%@/api/deviant/tatol",base_url];
    YYLog(@"YYUserToken==%@",YYUserToken);
    int type = self.historyBtn.selected==1?1:0;
    NSDictionary *dict = @{@"end":[NSString stringWithFormat:@"%@ %@",self.dateLabel.text,[self getCurrentTimes:@"HH:mm:ss"]],
                           @"type":@(type)
    };
    YYLog(@"YYUserToken=11=%@",access_token);
    [NetworkTool sharedNetworkTool].requestSerializer = [AFJSONRequestSerializer serializer];
    [[NetworkTool sharedNetworkTool].requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [[NetworkTool sharedNetworkTool].requestSerializer setValue:YYUserToken forHTTPHeaderField:@"Authorization"];
    [[NetworkTool sharedNetworkTool] requestWithMethod:CGNetworkMethodGET URLString:url parameters:dict finished:^(id result, NSString *error) {
        YYLog(@"loaduserid==%@",result);
        [MyTool dismissHud];
        if (error == nil) {
            self.listArray = [NSArray yy_modelArrayWithClass:[HMabnormalModel class] json:result[@"data"]];
            self.dataArray = [self.listArray sortedArrayUsingComparator:^NSComparisonResult(HMabnormalModel*  _Nonnull obj1, HMabnormalModel*  _Nonnull obj2) {
                return [obj2.mobile compare:obj1.mobile];
            }];
            self.dayTableView.hidden = NO;
            [self.dayTableView reloadData];
            self.totalLabel.text = [NSString stringWithFormat:@"总条数:%ld",self.dataArray.count];
        }
        
    }];
}

- (void)abnormalModel:(HMabnormalModel *)model{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushAbnorModel:)]) {
        [self.delegate pushAbnorModel:model];
    }
}

#pragma mark 排序
- (void)sortAbnorNumber:(NSInteger)number{
    self.number = number;
    switch (number) {
        case 0:
        {
            NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
            self.dataArray = [self.listArray sortedArrayUsingComparator:^NSComparisonResult(HMabnormalModel*  _Nonnull obj1, HMabnormalModel*  _Nonnull obj2) {
                NSString *string1 = obj1.userName;
                NSString *string2 = obj2.userName;
                NSRange string1Range = NSMakeRange(0, [string1 length]);
                if (self.sortBool) {
                    return [string1 compare:string2 options:0 range:string1Range locale:locale];
                }else{
                    return [string2 compare:string1 options:0 range:string1Range locale:locale];
                }
                
            }];
        }
            break;
        case 1:
        {
            self.dataArray = [self.listArray sortedArrayUsingComparator:^NSComparisonResult(HMabnormalModel*  _Nonnull obj1, HMabnormalModel*  _Nonnull obj2) {
                if (self.sortBool) {
                    return [obj2.mobile compare:obj1.mobile];
                }else{
                    return [obj1.mobile compare:obj2.mobile];
                }
            }];
        }
            break;
        case 2:
        {
            NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
            self.dataArray = [self.listArray sortedArrayUsingComparator:^NSComparisonResult(HMabnormalModel*  _Nonnull obj1, HMabnormalModel*  _Nonnull obj2) {
                NSString *string1 = obj1.company;
                NSString *string2 = obj2.company;
                NSRange string1Range = NSMakeRange(0, [string1 length]);
                if (self.sortBool) {
                    return [string1 compare:string2 options:0 range:string1Range locale:locale];
                }else{
                    return [string2 compare:string1 options:0 range:string1Range locale:locale];
                }
            }];
        }
            break;
        case 3:
        {
            NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
            self.dataArray = [self.listArray sortedArrayUsingComparator:^NSComparisonResult(HMabnormalModel*  _Nonnull obj1, HMabnormalModel*  _Nonnull obj2) {
                NSString *string1;
                NSString *string2;
                if (obj1.level == 2 || obj1.level == 3) {
                    string1 = @"ZZZZZ";
                }else{
                    string1 = obj1.lastRecord;
                }
                if (obj2.level == 2 || obj2.level == 3) {
                    string2 = @"ZZZZ";
                }else{
                    string2 = obj2.lastRecord;
                }
                NSRange string1Range = NSMakeRange(0, [string1 length]);
                if (self.sortBool) {
                    return [string1 compare:string2 options:0 range:string1Range locale:locale];
                }else{
                    return [string2 compare:string1 options:0 range:string1Range locale:locale];
                }
            }];
        }
            break;
        default:
            break;
    }
    self.sortBool = !self.sortBool;
    [self.dayTableView reloadData];

}
#pragma mark 前一天
- (void)befTapSel{
    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[self beforeDay:self.dateLabel.text] attributes:attribtDic];
    self.dateLabel.attributedText = attribtStr;
    if (self.textSearch.length == 0) {
        [self getData];
    }else{
        [self searchGetData];
    }
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
            NSInteger compare = [self compareWithDate:[NSString stringWithFormat:@"%ld-%.2ld-%.2ld",model.wYear,model.wMonth,model.wDay]];
            if (compare == -1) {
                [MyTool showHudMessage:@"所选日期没有数据"];
                return ;
            }
            
            NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
            NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%ld-%.2ld-%.2ld",model.wYear,model.wMonth,model.wDay] attributes:attribtDic];
            self.dateLabel.attributedText = attribtStr;
            if (self.textSearch.length == 0) {
                [self getData];
            }else{
                [self searchGetData];
            }
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
    if (self.textSearch.length == 0) {
        [self getData];
    }else{
        [self searchGetData];
    }
}

- (void)hasSelectc:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.headView.hidden = YES;
        [self.bgScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(170);
        }];
    }else{
        self.headView.hidden = NO;
        [self.bgScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(220);
        }];
    }
    if (self.textSearch.length == 0) {
        [self getData];
    }else{
        [self searchGetData];
    }
}

- (void)refreshSel{
    self.updateLabel.text = [NSString stringWithFormat:@"最后更新时间:%@",[self getCurrentTimes:@"YYYY-MM-dd HH:mm:ss"]];
    if (self.textSearch.length == 0) {
        [self getData];
    }else{
        [self searchGetData];
    }
}



-(NSString*)getCurrentTimes:(NSString *)temFormat{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:temFormat];
    NSDate *datenow = [NSDate date];
    //----------将nsdate按formatter格式转成nsstring
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    return currentTimeString;
}
#pragma mark 一天之前
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count+1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HMAbnorTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    // 完美解决xib自定义cell所产生的复用问题
    if (nil == cell) {
        cell= (HMAbnorTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"HMAbnorTableViewCell" owner:self options:nil]  lastObject];
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
        cell.phoneLabel.text = @"联系电话";
        cell.unitLabel.text = @"所属单位";
        cell.situationLabel.text = @"最新情况";
        if (self.sortBool) {
            switch (self.number) {
                case 0:
                {
                    cell.nameLabel.text = @"姓名↑";
                }
                    break;
                case 1:
                {
                    cell.phoneLabel.text = @"联系电话↑";
                }
                    break;
                case 2:
                {
                    cell.unitLabel.text = @"所属单位↑";
                }
                    break;
                case 3:
                {
                    cell.situationLabel.text = @"最新情况↑";
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
                    cell.phoneLabel.text = @"联系电话↓";
                }
                    break;
                case 2:
                {
                    cell.unitLabel.text = @"所属单位↓";
                }
                    break;
                case 3:
                {
                    cell.situationLabel.text = @"最新情况↓";
                }
                    break;
                default:
                    break;
            }
        }
        
        cell.nameLabel.font = cell.phoneLabel.font = cell.unitLabel.font = cell.situationLabel.font = [UIFont systemFontOfSize:19];
        cell.phoneLabel.textColor = cell.unitLabel.textColor = RGB(52, 137, 255);
        cell.sortDelegate = self;
    }else{
        cell.model = self.dataArray[indexPath.row-1];
        cell.unitLabel.textColor = RGB(81, 81, 81);
        cell.delegate = self;
    }
    return cell;
}

-(UITableView *)dayTableView{
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
        [_dayTableView registerNib:[UINib nibWithNibName:@"HMAbnorTableViewCell" bundle:nil] forCellReuseIdentifier:@"HMabnorID"];
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
