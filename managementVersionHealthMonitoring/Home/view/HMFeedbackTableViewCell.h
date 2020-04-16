//
//  HMFeedbackTableViewCell.h
//  managementVersionHealthMonitoring
//
//  Created by Mr - 宋 on 2020/4/7.
//  Copyright © 2020 song. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HMFeedbackTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property(nonatomic,strong)HMabnormalModel *model;

@end

NS_ASSUME_NONNULL_END
