//
//  UIBarButtonItem+YYItem.h
//  幺幺现车
//
//  Created by gaotianyu on 2019/3/15.
//  Copyright © 2019年 rain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (YYItem)
// 快速创建一个显示图片的item
+ (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image target:(id)target action:(SEL)action;
+ (UIBarButtonItem *)barButtonRightItemWithImage:(UIImage *)image target:(id)target action:(SEL)action;

+ (UIBarButtonItem *)itemWithButtonFrame:(CGRect)frame title:(NSString *)title color:(UIColor *)color font:(UIFont *)font target:(id)target action:(SEL)action;
@end
