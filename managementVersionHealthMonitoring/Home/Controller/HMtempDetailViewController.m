//
//  HMtempDetailViewController.m
//  managementVersionHealthMonitoring
//
//  Created by Mr - 宋 on 2020/3/30.
//  Copyright © 2020 song. All rights reserved.
//

#import "HMtempDetailViewController.h"
@interface HMtempDetailViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) PYZoomEchartsView *kEchartView;
@property(nonatomic,strong)UILabel *alarmLabel,*changeLabel;
@property (nonatomic,strong)UIButton *changeBtn,*threeBtn,*sevenBtn,*fourBtn;
@property (nonatomic,strong)NSArray *dataArray;
@property (nonatomic,strong)NSMutableArray *timeArray,*valueArray,*listTimeArray;
@end

@implementation HMtempDetailViewController

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
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
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
    [self creatScrollView];
//    [self showLineDemo];
    UIImageView *imageVC = [[UIImageView alloc] initWithFrame:CGRectMake(30, 95, kSWidth, 3)];
    imageVC.image = [self drawLineOfDashByImageView:imageVC];
    [self.view addSubview:imageVC];
   
    
    for (int i = 0; i<7; i++) {
        UILabel *temLabel = [UILabel new];
        temLabel.frame = CGRectMake(7, 60+i*42, 30, 20);
        temLabel.text = [NSString stringWithFormat:@"%d",39-i*3];
        [self.view addSubview:temLabel];
    }
    self.alarmLabel = [UILabel new];
    self.alarmLabel.frame = CGRectMake(kSWidth-50, 100, 40, 20);
    self.alarmLabel.text = @"37.3";
    self.alarmLabel.textColor = [UIColor redColor];
    [self.view addSubview:self.alarmLabel];
    self.changeLabel = [UILabel new];
    self.changeLabel.frame = CGRectMake(10, 10, kSWidth, 20);
    self.changeLabel.text = [NSString stringWithFormat:@"%@的近期体温变化图",self.model.username];
    self.changeLabel.textColor = UIColorFromHex(0x666666, 1);
    [self.view addSubview:self.changeLabel];
    
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
        make.top.equalTo(self.scrollView.mas_bottom).offset(20);
        make.height.equalTo(@40);
        make.width.equalTo(@((kSWidth-40)/3));
    }];
    [self.sevenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.threeBtn.mas_right);
        make.top.equalTo(self.scrollView.mas_bottom).offset(20);
        make.height.equalTo(@40);
        make.width.equalTo(@((kSWidth-40)/3));
    }];
    [self.fourBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.mas_bottom).offset(20);
        make.height.equalTo(@40);
        make.width.equalTo(@((kSWidth-40)/3));
        make.left.equalTo(self.sevenBtn.mas_right);
    }];
    [self getDataTime:3];
}

- (void)getDataTime:(int )time{
    [MyTool showHud];
       NSString *url = [NSString stringWithFormat:@"%@/api/temp/list",base_url];
       YYLog(@"YYUserToken==%@",YYUserToken);
    NSDictionary *dict = @{@"userId":self.model.userId,@"start":[self beforeDay:[self getCurrentTimes:@"YYYY-MM-dd HH:mm:ss"] dyas:time],@"end":[self getCurrentTimes:@"YYYY-MM-dd HH:mm:ss"]
       };
       [NetworkTool sharedNetworkTool].requestSerializer = [AFJSONRequestSerializer serializer];
       [[NetworkTool sharedNetworkTool].requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
       [[NetworkTool sharedNetworkTool].requestSerializer setValue:YYUserToken forHTTPHeaderField:@"Authorization"];
       [[NetworkTool sharedNetworkTool] requestWithMethod:CGNetworkMethodGET URLString:url parameters:dict finished:^(id result, NSString *error) {
           YYLog(@"loaduserid==%@",result);
           [MyTool dismissHud];
           if (error == nil) {
               NSString *staTime = [self beforeDay:[self getCurrentTimes:@"YYYY-MM-dd HH:mm:ss"] dyas:time];
               self.dataArray = [NSArray yy_modelArrayWithClass:[HMDayLiveModel class] json:result[@"data"]];
               NSMutableArray *stampArray = [NSMutableArray array];
               [self.timeArray removeAllObjects];
               [self.valueArray removeAllObjects];
               for (int i = 0; i<288*time; i++) {
                   NSString *time = [self beforeDay:staTime min:i*5];
                   [stampArray addObject:[self getTimeStrWithString:time]];
                   [self.timeArray addObject:time];
                   [self.valueArray addObject:@"-"];
               }
               NSMutableArray *monthArray = [NSMutableArray array];
               NSMutableArray *tempArray = [NSMutableArray array];
               for (HMDayLiveModel *model in self.dataArray) {
                   NSString *days = [NSString stringWithFormat:@"%@ %@",[model.timepoint substringWithRange:NSMakeRange(5, 5)],[model.timepoint substringWithRange:NSMakeRange(11, 5)]];
                   [monthArray addObject:[self getTimeStrWithString:days]];
                   [tempArray addObject:model.value];
               }
               dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_CONCURRENT);
               
               // 同步执行任务创建方法
               //                          dispatch_sync(queue, ^{
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
               //                          });
               [self showLineDemo];
           }
           
       }];
}

- (void)threeSel{
    [self getDataTime:3];
    self.threeBtn.selected = YES;
    self.sevenBtn.selected = NO;
    self.fourBtn.selected = NO;
    [self.threeBtn setBackgroundColor:RGB(52, 137, 255)];
    [self.sevenBtn setBackgroundColor:RGB(231, 231, 231)];
    [self.fourBtn setBackgroundColor:RGB(231, 231, 231)];
}

- (void)sevenSel{
    [self getDataTime:7];
    self.threeBtn.selected = NO;
    self.sevenBtn.selected = YES;
    self.fourBtn.selected = NO;
    [self.sevenBtn setBackgroundColor:RGB(52, 137, 255)];
    [self.threeBtn setBackgroundColor:RGB(231, 231, 231)];
    [self.fourBtn setBackgroundColor:RGB(231, 231, 231)];
}

- (void)fourSel{
    [self getDataTime:14];
        self.threeBtn.selected = NO;
        self.sevenBtn.selected = NO;
        self.fourBtn.selected = YES;
        [self.fourBtn setBackgroundColor:RGB(52, 137, 255)];
        [self.threeBtn setBackgroundColor:RGB(231, 231, 231)];
        [self.sevenBtn setBackgroundColor:RGB(231, 231, 231)];
}
-(void)showLineDemo{
    
/** 图表选项 */
    PYOption *option = [[PYOption alloc] init];
    //是否启用拖拽重计算特性，默认关闭
    option.calculable = NO;
    //数值系列的颜色列表(折线颜色)
    option.color = @[@"#20BCFC", @"#ff6347"];
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
    yAxis.splitNumber = @6;
    
    // 分割线类型
    // yAxis.splitLine.lineStyle.type = @"dashed";   //'solid' | 'dotted' | 'dashed' 虚线类型

    //单位设置,  设置最大值, 最小值
    // yAxis.axisLabel.formatter = @"{value} k";
     yAxis.max = @39;
     yAxis.min = @21;
    

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
        self.kEchartView = [[PYZoomEchartsView alloc] initWithFrame:CGRectMake(-37, 0, self.view.frame.size.width, 300)];
        // 添加到 scrollView 上
        [self.scrollView addSubview:self.kEchartView];
       }
    // 图表选项添加到图表上
    [self.kEchartView setOption:option];
     [self.kEchartView loadEcharts];
}


- (void)p_popViewController{
    [self.navigationController popViewControllerAnimated:NO];
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

#pragma mark 字符串转时间戳
- (NSString *)getTimeStrWithString:(NSString *)str{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:@"MM-dd HH:mm"]; //设定时间的格式
    NSDate *tempDate = [dateFormatter dateFromString:str];//将字符串转换为时间对象
    NSString *timeStr = [NSString stringWithFormat:@"%ld", (long)[tempDate timeIntervalSince1970]*1000];//字符串转成时间戳,精确到毫秒*1000
    return timeStr;
}


- (void)creatScrollView{

    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(30, 50, self.view.frame.size.width , 300)];
    [self.view addSubview:self.scrollView];
    self.scrollView.showsHorizontalScrollIndicator = NO;
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
