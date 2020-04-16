//
//  HMDetailDayTableViewCell.m
//  managementVersionHealthMonitoring
//
//  Created by Mr - 宋 on 2020/3/30.
//  Copyright © 2020 song. All rights reserved.
//

#import "HMDetailDayTableViewCell.h"

@implementation HMDetailDayTableViewCell


- (void)setModel:(HMPersonModel *)model{
    _model = model;
    self.nameLabel.text = model.username;
    self.temLabel.text = model.lastTemp <= 0?@"-":[NSString stringWithFormat:@"%.1f",model.lastTemp];
    if (model.lastTemp>37.2) {
        self.nameLabel.textColor = [UIColor redColor];
    }else{
        self.nameLabel.textColor = RGB(52, 137, 255);
    }
    self.timeLabel.text = model.lastActiveTime.length>0?model.lastActiveTime:@"今日未测温";
    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
       NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString: model.mobile attributes:attribtDic];
       self.phoneLabel.attributedText = attribtStr;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *personTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(personSel)];
    [self.nameLabel addGestureRecognizer:personTap];
    
    UITapGestureRecognizer *oneTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(oneTapSel)];
    [self.phoneLabel addGestureRecognizer:oneTap];
    
    UITapGestureRecognizer *twoTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(twoTapSel)];
    [self.temLabel addGestureRecognizer:twoTap];
    
    UITapGestureRecognizer *theTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(thrTapSel)];
    [self.timeLabel addGestureRecognizer:theTap];
}

- (void)personSel{
    if (self.indexRow == 0) {
        if (self.sortDelegate && [self.sortDelegate respondsToSelector:@selector(sortingNumber:)]) {
            [self.sortDelegate sortingNumber:0];
        }
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(personModel:)]) {
            [self.delegate personModel:_model];
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
