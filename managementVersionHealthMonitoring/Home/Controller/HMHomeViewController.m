//
//  HMHomeViewController.m
//  managementVersionHealthMonitoring
//
//  Created by Mr - 宋 on 2020/3/23.
//  Copyright © 2020 song. All rights reserved.
//

#import "HMHomeViewController.h"
#import "HMDayLiveViewController.h"
#import "HMAbnormalViewController.h"
#import "HMDetailAbnorViewController.h"
#import "HMSearchViewController.h"
@interface HMHomeViewController ()<DFYSliderSwitchViewDeleagte,pushLiveDayDelegate,PushAbnorDelegate>
@property(nonatomic,strong)DFYSliderSwitchView *sliderSwitchView;

@end

@implementation HMHomeViewController
{
    HMDayLiveViewController *_dayVC;
    HMAbnormalViewController *_avnoraVC;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    UIView *topView = [UIView new];
    topView.frame = CGRectMake(0, 0, kSWidth, kSHeight>=812?38:14);
    topView.backgroundColor = MaingreenColor;
    [self.view addSubview:topView];
    self.sliderSwitchView = [[DFYSliderSwitchView alloc]initWithFrame:CGRectMake(0, kSHeight>=812?38:14, kSWidth, kSHeight-50-(kSHeight>=812?38:14))];
    self.sliderSwitchView.delegate = self;
    _sliderSwitchView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.sliderSwitchView];
    self.sliderSwitchView.tabItemTitleColor = [UIColor whiteColor];
    self.sliderSwitchView.tabItemTitleFont = [UIFont systemFontOfSize:18];
    self.sliderSwitchView.tabItemTitleSelectedFont = [UIFont systemFontOfSize:18];
    self.sliderSwitchView.tabItemTitleSelectedColor = [UIColor whiteColor];
    self.sliderSwitchView.tabItemSelectedBgColor = [UIColor whiteColor];
    self.sliderSwitchView.isFullWidth = YES;
    //    self.sliderSwitchView.contentViewFrame = CGRectMake(0, 0, kScreenWidth, 90);
    _dayVC = [[HMDayLiveViewController alloc]init];
    _dayVC.deletgate = self;
    _dayVC.title =@"佩戴情况";
    [self addChildViewController:_dayVC];
    
    _avnoraVC = [[HMAbnormalViewController alloc]init];
    _avnoraVC.title =@"异常报警";
    _avnoraVC.delegate = self;
    [self addChildViewController:_avnoraVC];
    _sliderSwitchView.viewControllers = [NSMutableArray arrayWithObjects:_dayVC,_avnoraVC, nil];
}

- (void)pushLiveDayArray:(NSArray *)array name:(NSString *)name time:(NSString *)time model:(HMDayLiveModel *)model{
    if (array.count == 0) {
        HMDetailDayLevelViewController *detailVC = [HMDetailDayLevelViewController new];
        detailVC.FirstLevel = name;
        detailVC.time = time;
        detailVC.name = model.departmentName;
        detailVC.departmentCode = model.departmentCode;
        [self.navigationController pushViewController:detailVC animated:NO];
    }else{
        HMLevelOneViewController *levelVC = [HMLevelOneViewController new];
           levelVC.dataArray = array;
           levelVC.name = name;
           levelVC.time = time;
           levelVC.dayModel = model;
           [self.navigationController pushViewController:levelVC animated:NO];
    }
   

}

- (void)pushAbnorModel:(HMabnormalModel *)model{
    HMDetailAbnorViewController *delAbnorVC = [HMDetailAbnorViewController new];
    delAbnorVC.model = model;
    [self.navigationController pushViewController:delAbnorVC animated:NO];
    
}

- (void)searchText:(NSString *)text{
    HMSearchViewController *searchVC = [HMSearchViewController new];
    searchVC.textStr = text;
    [self.navigationController pushViewController:searchVC animated:NO];
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
