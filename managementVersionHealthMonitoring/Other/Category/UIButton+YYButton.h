//
//  UIButton+YYButton.h
//  幺幺现车
//
//  Created by gaotianyu on 2019/3/15.
//  Copyright © 2019年 rain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (YYButton)
+(UIButton *)createButtonFrame:(CGRect)frame groundColor:(UIColor *)groundColor title:(NSString *)title titleColor:(UIColor *)color font:(UIFont *)font target:(id)target action:(SEL)action;

+(UIButton *)createButtonFrame:(CGRect)frame backImageName:(NSString *)imageName target:(id)target action:(SEL)action;
@end
