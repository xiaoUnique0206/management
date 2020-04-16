//
//  HMSearchViewController.m
//  managementVersionHealthMonitoring
//
//  Created by Mr - 宋 on 2020/4/9.
//  Copyright © 2020 song. All rights reserved.
//

#import "HMSearchViewController.h"
#import "HMAbnorTableViewCell.h"
#import "HMDetailAbnorViewController.h"
@interface HMSearchViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,abnorDelegate,sortAbnorDelegate>
@property (nonatomic,strong)UISearchBar *serachBar;
@property (nonatomic,strong)UIScrollView *bgScrollView;
@property (nonatomic,strong)UITableView *searchTableView;
@property (nonatomic,strong)NSArray *dataArray,*listArray;
@property (nonatomic,assign)BOOL sort;
@property (nonatomic,assign)NSInteger number;
@end

@implementation HMSearchViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"符合条件人员列表";
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
    
    [self getData];
    self.sort = NO;
    self.number = 1;
    self.serachBar = [UISearchBar new];
    self.serachBar.delegate = self;
    self.serachBar.text = self.textStr;
    self.serachBar.placeholder = @"请输入姓名活单位或手机号码";
    self.serachBar.searchBarStyle = UISearchBarStyleDefault;
    [self.view addSubview:self.serachBar];
    [self.serachBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(3);
        make.right.equalTo(self.view.mas_right).offset(-3);
        make.top.equalTo(self.view.mas_top).offset(5);
        make.height.equalTo(@50);
    }];
    
    UILabel *tipLabel = [UILabel new];
    tipLabel = [UILabel new];
    tipLabel.textColor = UIColorFromHex(0x666666, 1);
    tipLabel.text = @"小贴士:近期内体温超过37.3的用户,\n点击用户姓名可填写筛查反馈以及查看用户体温变化";
    tipLabel.numberOfLines = 0;
    tipLabel.font = [UIFont systemFontOfSize:16];
    tipLabel.textAlignment = NSLEFT;
    [self.view addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(7);
        make.top.equalTo(self.serachBar.mas_bottom).offset(4);
        make.right.equalTo(self.view.mas_right).offset(-7);
    }];
    
    
    self.bgScrollView = [UIScrollView new];
    self.bgScrollView.frame = CGRectMake(0, 180, kSWidth, kSHeight-245);
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
        make.top.equalTo(self.view.mas_top).offset(160);
    }];
    [self.bgScrollView addSubview:self.searchTableView];
    [self.searchTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgScrollView.mas_left);
        make.top.equalTo(self.bgScrollView.mas_top);
        make.width.equalTo(@(kSWidth/4*5));
        make.bottom.equalTo(self.view.mas_bottom).offset(-kTabBarHeight+49);
    }];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.serachBar resignFirstResponder];
    self.textStr = searchBar.text;
    [self getData];
}

- (void)getData{
    [MyTool showHud];
       NSString *url = [NSString stringWithFormat:@"%@/api/daylive_user/search",base_url];
       YYLog(@"YYUserToken==%@",YYUserToken);
    NSDictionary *dict = @{@"searchStr":self.textStr
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
               self.searchTableView.hidden = NO;
               [self.searchTableView reloadData];
           }
           
       }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count+1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HMAbnorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HMSearchID" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexRow = indexPath.row;
    if (indexPath.row == 0) {
        cell.nameLabel.text = @"姓名";
        cell.phoneLabel.text = @"手机";
        cell.unitLabel.text = @"单位";
        cell.situationLabel.text = @"上级单位";
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
                    cell.unitLabel.text = @"单位↑";
                }
                    break;
                case 3:
                {
                    cell.situationLabel.text = @"上级单位↑";
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
                    cell.unitLabel.text = @"单位↓";
                }
                    break;
                case 3:
                {
                    cell.situationLabel.text = @"上级单位↓";
                }
                    break;
                default:
                    break;
            }
        }
        cell.nameLabel.font = cell.phoneLabel.font = cell.unitLabel.font = cell.situationLabel.font = [UIFont systemFontOfSize:19];
        cell.phoneLabel.textColor = cell.unitLabel.textColor = cell.situationLabel.textColor = RGB(52, 137, 255);
        cell.sortDelegate = self;
    }else{
        cell.searchModel = self.dataArray[indexPath.row-1];
        cell.unitLabel.textColor = cell.situationLabel.textColor = RGB(81, 81, 81);
        cell.delegate = self;
    }
    return cell;
}

- (void)abnormalModel:(HMabnormalModel *)model{
    HMDetailAbnorViewController *delAbnorVC = [HMDetailAbnorViewController new];
    delAbnorVC.model = model;
    delAbnorVC.search = 2;
    [self.navigationController pushViewController:delAbnorVC animated:NO];
}

- (void)sortAbnorNumber:(NSInteger)number{
    self.number = number;
    switch (number) {
        case 0:
        {
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        self.dataArray = [self.listArray sortedArrayUsingComparator:^NSComparisonResult(HMabnormalModel*  _Nonnull obj1, HMabnormalModel*  _Nonnull obj2) {
            NSString *string1 = obj1.username;
            NSString *string2 = obj2.username;
            NSRange string1Range = NSMakeRange(0, [string1 length]);
            if (self.sort) {
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
            NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
            self.dataArray = [self.listArray sortedArrayUsingComparator:^NSComparisonResult(HMabnormalModel*  _Nonnull obj1, HMabnormalModel*  _Nonnull obj2) {
                NSString *string1 = obj1.company;
                NSString *string2 = obj2.company;
                NSRange string1Range = NSMakeRange(0, [string1 length]);
                if (self.sort) {
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
                NSString *string1 = obj1.parentCompany;
                NSString *string2 = obj2.parentCompany;
                NSRange string1Range = NSMakeRange(0, [string1 length]);
                if (self.sort) {
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
    self.sort = !self.sort;
    [self.searchTableView reloadData];
}

- (void)p_popViewController{
    [self.navigationController popViewControllerAnimated:NO];
}

- (UITableView *)searchTableView{
    if (!_searchTableView) {
        _searchTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, KHight*0.256, FrameSize.width, KHight*0.375) style:(UITableViewStylePlain)];
        _searchTableView.scrollEnabled = YES;
        _searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _searchTableView.backgroundColor = [UIColor whiteColor];
        _searchTableView.delegate = self;
        _searchTableView.dataSource = self;
        _searchTableView.bounces = YES;
        _searchTableView.estimatedRowHeight = 95;  //  随便设个不那么离谱的值
        _searchTableView.rowHeight = UITableViewAutomaticDimension;
        [_searchTableView registerNib:[UINib nibWithNibName:@"HMAbnorTableViewCell" bundle:nil] forCellReuseIdentifier:@"HMSearchID"];
    }
    return _searchTableView;
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
