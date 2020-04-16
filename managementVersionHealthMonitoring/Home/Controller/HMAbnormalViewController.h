//
//  HMAbnormalViewController.h
//  managementVersionHealthMonitoring
//
//  Created by Mr - 宋 on 2020/3/23.
//  Copyright © 2020 song. All rights reserved.
//

@protocol PushAbnorDelegate <NSObject>

- (void)pushAbnorModel:(HMabnormalModel *_Nullable)model;

@end

#import "HMBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HMAbnormalViewController : HMBaseViewController
@property(nonatomic,assign)id <PushAbnorDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
