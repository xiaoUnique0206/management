//
//  HMDetailDayTableViewCell.h
//  managementVersionHealthMonitoring
//
//  Created by Mr - 宋 on 2020/3/30.
//  Copyright © 2020 song. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol personDetailDelegate <NSObject>

- (void)personModel:(HMPersonModel *)model;

@end

@protocol sortPersonDelagate <NSObject>

- (void)sortingNumber:(int)number;

@end
@interface HMDetailDayTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *temLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property(nonatomic,assign)NSInteger indexRow;
@property(nonatomic,strong)HMPersonModel *model;
@property(nonatomic,assign)id <personDetailDelegate> delegate;
@property(nonatomic,assign)id <sortPersonDelagate>sortDelegate;
@end

NS_ASSUME_NONNULL_END
