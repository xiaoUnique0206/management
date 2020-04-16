//
//  HMAbnorTableViewCell.m
//  managementVersionHealthMonitoring
//
//  Created by Mr - 宋 on 2020/4/1.
//  Copyright © 2020 song. All rights reserved.
//

#import "HMAbnorTableViewCell.h"

@implementation HMAbnorTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *nameTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nameTapSel)];
    [self.nameLabel addGestureRecognizer:nameTap];
    
    UITapGestureRecognizer *oneTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(oneTapSel)];
    [self.phoneLabel addGestureRecognizer:oneTap];
    
    UITapGestureRecognizer *twoTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(twoTapSel)];
    [self.unitLabel addGestureRecognizer:twoTap];
    
    UITapGestureRecognizer *thrTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(thrTapSel)];
    [self.situationLabel addGestureRecognizer:thrTap];
    
}

- (void)nameTapSel{
    if (self.indexRow == 0) {
        if (self.sortDelegate && [self.sortDelegate respondsToSelector:@selector(sortAbnorNumber:)]) {
            [self.sortDelegate sortAbnorNumber:0];
        }
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(abnormalModel:)]) {
            [self.delegate abnormalModel:_model];
        }
    }
}

- (void)oneTapSel{
    if (self.sortDelegate && [self.sortDelegate respondsToSelector:@selector(sortAbnorNumber:)]) {
        [self.sortDelegate sortAbnorNumber:1];
    }
}
- (void)twoTapSel{
    if (self.sortDelegate && [self.sortDelegate respondsToSelector:@selector(sortAbnorNumber:)]) {
        [self.sortDelegate sortAbnorNumber:2];
    }
}
- (void)thrTapSel{
    if (self.sortDelegate && [self.sortDelegate respondsToSelector:@selector(sortAbnorNumber:)]) {
        [self.sortDelegate sortAbnorNumber:3];
    }
}

- (void)setModel:(HMabnormalModel *)model{
    _model = model;
    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString: model.userName attributes:attribtDic];
    self.nameLabel.attributedText = attribtStr;
//    self.nameLabel.text = model.userName;
    self.phoneLabel.text = model.mobile;
    self.unitLabel.text = model.company;
    if (model.level == 2 || model.level == 3) {
        self.situationLabel.text = @"未反馈";
        self.situationLabel.textColor = [UIColor redColor];
    }else{
        self.situationLabel.textColor = RGB(81, 81, 81);
        self.situationLabel.text = model.lastRecord;
    }
}

- (void)setSearchModel:(HMabnormalModel *)searchModel{
     _model = searchModel;
    self.nameLabel.text = searchModel.username;
    self.phoneLabel.text = searchModel.mobile;
    self.unitLabel.text = searchModel.company;
    self.situationLabel.text = searchModel.parentCompany;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
