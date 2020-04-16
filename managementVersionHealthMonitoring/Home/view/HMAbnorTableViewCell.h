//
//  HMAbnorTableViewCell.h
//  managementVersionHealthMonitoring
//
//  Created by Mr - 宋 on 2020/4/1.
//  Copyright © 2020 song. All rights reserved.
//


@protocol abnorDelegate <NSObject>

- (void)abnormalModel:(HMabnormalModel *_Nullable)model;

@end


@protocol sortAbnorDelegate <NSObject>

- (void)sortAbnorNumber:(NSInteger)number;

@end
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HMAbnorTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UILabel *situationLabel;
@property(nonatomic,strong)HMabnormalModel *model,*searchModel;
@property(nonatomic,assign)id <abnorDelegate>delegate;
@property(nonatomic,assign)id <sortAbnorDelegate>sortDelegate;
@property(nonatomic,assign)NSInteger indexRow;
@end

NS_ASSUME_NONNULL_END
