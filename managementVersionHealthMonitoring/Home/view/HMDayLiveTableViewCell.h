//
//  HMDayLiveTableViewCell.h
//  managementVersionHealthMonitoring
//
//  Created by Mr - 宋 on 2020/3/24.
//  Copyright © 2020 song. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol dayLiveDelegata <NSObject>

- (void)dayliveModel:(HMDayLiveModel *)model;

@end
@protocol sortingDayDelegate <NSObject>

- (void)sortingNumber:(int)number;

@end

@interface HMDayLiveTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *startingLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *detectionLabel;
@property(nonatomic,strong)HMDayLiveModel *dayModel;
@property(nonatomic,assign)id<dayLiveDelegata> delegate;
@property(nonatomic,assign)id <sortingDayDelegate>sortDelegate;
@property(nonatomic,assign)NSInteger indexRow;
@end

NS_ASSUME_NONNULL_END
