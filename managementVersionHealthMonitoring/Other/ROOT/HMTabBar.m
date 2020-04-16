//
//  HMTabBar.m
//  healthMonitoring
//
//  Created by gaotianyu on 2020/1/30.
//  Copyright © 2020 gaotianyu. All rights reserved.
//

#import "HMTabBar.h"

@implementation HMTabBar
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        // 去掉半透明
        self.translucent = NO;
        [self setShadowImage:[UIImage new]];
        // 添加阴影
        self.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
        self.layer.shadowOpacity = 0.2;//阴影透明度，默认0
        self.layer.shadowOffset = CGSizeMake(0,0);
        self.layer.shadowRadius = 3;//阴影半径，默认3
        UIBezierPath *path = [UIBezierPath bezierPath];
        
        [path moveToPoint:CGPointMake(0, -2)];
        [path addLineToPoint:CGPointMake(ScreenWidth, -2)];
        [path addLineToPoint:CGPointMake(ScreenWidth, 0.5)];
        [path addLineToPoint:CGPointMake(0, 0.5)];
        [path addLineToPoint:CGPointMake(0, -2)];
        
        self.layer.shadowPath = path.CGPath;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
