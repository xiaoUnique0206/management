//
//  HMDayLiveTableViewCell.m
//  managementVersionHealthMonitoring
//
//  Created by Mr - 宋 on 2020/3/24.
//  Copyright © 2020 song. All rights reserved.
//

#import "HMDayLiveTableViewCell.h"

@implementation HMDayLiveTableViewCell

- (void)setDayModel:(HMDayLiveModel *)dayModel{
    _dayModel = dayModel;
    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:dayModel.departmentName attributes:attribtDic];
    self.departmentLabel.attributedText = attribtStr;
    self.totalNumberLabel.text = [NSString stringWithFormat:@"%.f",dayModel.total];
    float Live = dayModel.bootNumberTotal/dayModel.total;
    if (dayModel.bootNumberTotal == 0 || dayModel.total == 0){
        self.startingLabel.text = @"0%";
    }else if (Live>= 1) {
        self.startingLabel.text = @"100%";
    } else{
        self.startingLabel.text = [[NSString stringWithFormat:@"%.1f",Live*100] stringByAppendingString:@"%"];
    }
//    number/total
    float day = dayModel.number/dayModel.total;
    if (dayModel.number == 0 || dayModel.total == 0) {
        self.dayLabel.text = [@"0%" stringByAppendingFormat:@"\n(%.f)",dayModel.number];
    }else if (day>1){
        self.dayLabel.text = [@"100%" stringByAppendingFormat:@"\n(%.f)",dayModel.number];
    }else{
        self.dayLabel.text = [[[NSString stringWithFormat:@"%.1f",day*100] stringByAppendingString:@"%"]stringByAppendingFormat:@"\n(%.f)",dayModel.number];
    }
    float etection = dayModel.effectiveNumberTotal/dayModel.number;
    if (etection>1) {
        self.detectionLabel.text = @"100%";
    }else if(dayModel.number == 0 || dayModel.effectiveNumberTotal == 0){
        self.detectionLabel.text = @"0%";
    }else{
        self.detectionLabel.text = [[NSString stringWithFormat:@"%.1f",etection*100] stringByAppendingString:@"%"];
        
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *departTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(departTapSel)];
    [self.departmentLabel addGestureRecognizer:departTap];
    
    UITapGestureRecognizer *oneTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(oneTapSel)];
    [self.totalNumberLabel addGestureRecognizer:oneTap];
    
    UITapGestureRecognizer *twoTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(twoTapSel)];
    [self.startingLabel addGestureRecognizer:twoTap];
    
    UITapGestureRecognizer *theTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(thrTapSel)];
    [self.dayLabel addGestureRecognizer:theTap];
    
    UITapGestureRecognizer *fourTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fourTapSel)];
    [self.detectionLabel addGestureRecognizer:fourTap];
}

- (void)departTapSel{
    if (self.indexRow == 0) {
        if (self.sortDelegate && [self.sortDelegate respondsToSelector:@selector(sortingNumber:)]) {
            [self.sortDelegate sortingNumber:0];
        }
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(dayliveModel:)]) {
            [self.delegate dayliveModel:_dayModel];
        }
    }
}
- (void)oneTapSel{
    if (self.sortDelegate && [self.sortDelegate respondsToSelector:@selector(sortingNumber:)]) {
        [self.sortDelegate sortingNumber:1];
    }
}

- (void)twoTapSel{
    if (self.sortDelegate && [self.sortDelegate respondsToSelector:@selector(sortingNumber:)]) {
           [self.sortDelegate sortingNumber:2];
       }
}

- (void)thrTapSel{
    if (self.sortDelegate && [self.sortDelegate respondsToSelector:@selector(sortingNumber:)]) {
           [self.sortDelegate sortingNumber:3];
       }
}
- (void)fourTapSel{
    if (self.sortDelegate && [self.sortDelegate respondsToSelector:@selector(sortingNumber:)]) {
           [self.sortDelegate sortingNumber:4];
       }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
