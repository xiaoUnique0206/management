//
//  HMLevelTwoViewController.h
//  managementVersionHealthMonitoring
//
//  Created by Mr - 宋 on 2020/3/27.
//  Copyright © 2020 song. All rights reserved.
//

#import "HMBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HMLevelTwoViewController : UIViewController
@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *time;
@property(nonatomic,strong)NSString *FirstLevel;
@property(nonatomic,strong)NSString *departmentCode;
@property(nonatomic,strong)HMDayLiveModel *dayModel;
@end

NS_ASSUME_NONNULL_END
