//
//  HMLevelOneViewController.m
//  managementVersionHealthMonitoring
//
//  Created by Mr - 宋 on 2020/3/27.
//  Copyright © 2020 song. All rights reserved.
//

#import "HMLevelOneViewController.h"

@interface HMLevelOneViewController ()<UITableViewDelegate,UITableViewDataSource,dayLiveDelegata,sortingDayDelegate>
@property (nonatomic,strong)UILabel *topLabel;
@property (nonatomic,strong)UIScrollView *bgScrollView;
@property (nonatomic,strong)UITableView *dayTableView;
@property (nonatomic,assign)BOOL sort;
@property (nonatomic,assign)int number;
@end

@implementation HMLevelOneViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"部门日活统计";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:19],NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
       [self.navigationController.navigationBar setBarTintColor:MaingreenColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    self.number = 3;
    NSString *titleString = [NSString stringWithFormat:@"%@     %@%@日活统计",[self getCurrentTimes:@"YYYY年MM月dd日"],self.time,self.name];
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
    [self.dayTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgScrollView.mas_left);
        make.top.equalTo(self.bgScrollView.mas_top);
        make.width.equalTo(@(kSWidth/4*5));
        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
    }];
}

- (void)p_popViewController{
    [self.navigationController popViewControllerAnimated:NO];
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
        cell.sortDelegate = self;
        cell.departmentLabel.textColor = cell.totalNumberLabel.textColor = cell.startingLabel.textColor = cell.dayLabel.textColor = cell.detectionLabel.textColor = RGB(52, 137, 255);
    }else if (indexPath.row == self.dataArray.count+1){
         cell.departmentLabel.textColor = cell.totalNumberLabel.textColor = cell.startingLabel.textColor = cell.dayLabel.textColor = cell.detectionLabel.textColor = RGB(52, 137, 255);
        cell.departmentLabel.text = @"合计";
//        float ratio = 0;
        float effectiveNumberTotal = 0;
        float number = 0;
        float boot = 0;
        float total = 0;
        for (HMDayLiveModel *model in self.dataArray) {
            effectiveNumberTotal += model.effectiveNumberTotal;
            number += model.number;
            total += model.total;
            if (model.bootNumberTotal>model.total) {
                boot += model.total;
            }else{
                boot += model.bootNumberTotal;
            }
        }
        float day = number/total;
        cell.totalNumberLabel.text = [NSString stringWithFormat:@"%.f",self.dayModel.total];
        if (number == 0 || total == 0) {
            cell.dayLabel.text = [@"0%" stringByAppendingFormat:@"\n(%.f)",number];
        }else if (day>1){
            cell.dayLabel.text = [@"100%" stringByAppendingFormat:@"\n(%.f)",number];
        }else{
            cell.dayLabel.text = [NSString stringWithFormat:@"%@\n(%.f)",[[NSString stringWithFormat:@"%.1f",number/total*100] stringByAppendingString:@"%"],number];
        }

//        cell.detectionLabel.text = [[NSString stringWithFormat:@"%.1f",effectiveNumberTotal/number*100] stringByAppendingString:@"%"];
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
//        float star = boot/self.dayModel.total;
//        if (star>1) {
//            cell.startingLabel.text = @"100%";
//        }else{
//        cell.startingLabel.text = [[NSString stringWithFormat:@"%.1f",star*100] stringByAppendingString:@"%"];
//        }
         
    }else{
        cell.dayModel = self.dataArray[indexPath.row-1];
        cell.delegate = self;
        cell.departmentLabel.textColor = cell.totalNumberLabel.textColor = cell.startingLabel.textColor = cell.dayLabel.textColor = cell.detectionLabel.textColor = RGB(100, 100, 100);
        cell.departmentLabel.textColor = RGB(52, 137, 255);
        
       
        
    }
    return cell;
}

- (void)dayliveModel:(HMDayLiveModel *)model{
    if (model.children.count == 0) {
        HMDetailDayLevelViewController *detailVC = [HMDetailDayLevelViewController new];
        detailVC.FirstLevel = self.name;
        detailVC.time = self.time;
        detailVC.name = model.departmentName;
        detailVC.departmentCode = model.departmentCode;
        [self.navigationController pushViewController:detailVC animated:NO];
    }else{
        
        NSArray *array = [NSArray yy_modelArrayWithClass:[HMDayLiveModel class] json:model.children];
        NSArray *dataArray = [array sortedArrayUsingComparator:^NSComparisonResult(HMDayLiveModel*  _Nonnull obj1, HMDayLiveModel*  _Nonnull obj2) {
            float ratio1 = obj1.number/obj1.total;
            float ratio2 = obj2.number/obj2.total;
            return [@(ratio2) compare:@(ratio1)];
        }];
        
        HMLevelTwoViewController *levelTwoVC = [HMLevelTwoViewController new];
        levelTwoVC.dataArray = dataArray;
        levelTwoVC.name = model.departmentName;
        levelTwoVC.time = self.time;
        levelTwoVC.FirstLevel = self.name;
        levelTwoVC.departmentCode = model.departmentCode;
        levelTwoVC.dayModel = model;
        [self.navigationController pushViewController:levelTwoVC animated:NO];
    }
}

#pragma mark 点击排序
- (void)sortingNumber:(int)number{
    self.number = number;
    switch (number) {
        case 0:
        {
            NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
            self.dataArray = [self.dataArray sortedArrayUsingComparator:^NSComparisonResult(HMDayLiveModel*  _Nonnull obj1, HMDayLiveModel*  _Nonnull obj2) {
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
                self.dataArray = [self.dataArray sortedArrayUsingComparator:^NSComparisonResult(HMDayLiveModel*  _Nonnull obj1, HMDayLiveModel*  _Nonnull obj2) {
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
                self.dataArray = [self.dataArray sortedArrayUsingComparator:^NSComparisonResult(HMDayLiveModel*  _Nonnull obj1, HMDayLiveModel*  _Nonnull obj2) {
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
            self.dataArray = [self.dataArray sortedArrayUsingComparator:^NSComparisonResult(HMDayLiveModel*  _Nonnull obj1, HMDayLiveModel*  _Nonnull obj2) {
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
            self.dataArray = [self.dataArray sortedArrayUsingComparator:^NSComparisonResult(HMDayLiveModel*  _Nonnull obj1, HMDayLiveModel*  _Nonnull obj2) {
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
        [_dayTableView registerNib:[UINib nibWithNibName:@"HMDayLiveTableViewCell" bundle:nil] forCellReuseIdentifier:@"HMLeveOneID"];
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
