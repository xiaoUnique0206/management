//
//  HMFeedbackTableViewCell.m
//  managementVersionHealthMonitoring
//
//  Created by Mr - 宋 on 2020/4/7.
//  Copyright © 2020 song. All rights reserved.
//

#import "HMFeedbackTableViewCell.h"

@implementation HMFeedbackTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setModel:(HMabnormalModel *)model{
    self.timeLabel.text = [NSString stringWithFormat:@"%@ %@ %@:",[model.commentTime substringWithRange:NSMakeRange(5, 5)],[model.commentTime substringWithRange:NSMakeRange(11, 5)],model.commentBy];
    self.detailLabel.text = model.comment;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
