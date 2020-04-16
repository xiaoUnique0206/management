//
//  HMDayLiveViewController.h
//  managementVersionHealthMonitoring
//
//  Created by Mr - 宋 on 2020/3/23.
//  Copyright © 2020 song. All rights reserved.
//

#import "HMBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@protocol pushLiveDayDelegate <NSObject>

- (void)pushLiveDayArray:(NSArray *)array name:(NSString *)name time:(NSString *)time model:(HMDayLiveModel *)model;
- (void)searchText:(NSString *)text;
@end
@interface HMDayLiveViewController : HMBaseViewController
@property(nonatomic,assign)id <pushLiveDayDelegate>deletgate;
@end

NS_ASSUME_NONNULL_END
