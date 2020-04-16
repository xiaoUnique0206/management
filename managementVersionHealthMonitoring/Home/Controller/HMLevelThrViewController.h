//
//  HMLevelThrViewController.h
//  managementVersionHealthMonitoring
//
//  Created by Mr - 宋 on 2020/4/10.
//  Copyright © 2020 song. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HMLevelThrViewController : UIViewController
@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *time;
@property(nonatomic,strong)NSString *FirstLevel;
@property(nonatomic,strong)NSString *departmentCode;
@property(nonatomic,strong)HMDayLiveModel *dayModel;
@end

NS_ASSUME_NONNULL_END
