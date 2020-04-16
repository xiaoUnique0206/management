//
//  UIButton+YYButton.m
//  幺幺现车
//
//  Created by gaotianyu on 2019/3/15.
//  Copyright © 2019年 rain. All rights reserved.
//

#import "UIButton+YYButton.h"

@implementation UIButton (YYButton)
+(UIButton *)createButtonFrame:(CGRect)frame groundColor:(UIColor *)groundColor title:(NSString *)title titleColor:(UIColor *)color font:(UIFont *)font target:(id)target action:(SEL)action{
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=frame;
    [btn setBackgroundColor:groundColor];
    btn.titleLabel.font=font;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}
+(UIButton *)createButtonFrame:(CGRect)frame backImageName:(NSString *)imageName target:(id)target action:(SEL)action{
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=frame;
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}
@end
