//
//  UIImage+YYImage.h
//  幺幺现车
//
//  Created by gaotianyu on 2019/3/14.
//  Copyright © 2019年 rain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (YYImage)
// 加载图片颜色
+ (UIImage *)imageWithColor:(UIColor *)color;

// 返回圆形图片
- (instancetype)circleImage;

+ (instancetype)circleImage:(NSString *)name;

+ (UIImage *)resizedImageWithNamed:(NSString *)name;
+ (UIImage *)resizedImageWithNamed:(NSString *)name left:(CGFloat)left top:(CGFloat)top;
+ (UIImage *)refreshImageWithImage:(UIImage *)img;

/**
 *  生成一张圆形图片
 *
 *  @param image       要裁剪的图片
 *
 *  @return 生成的圆形图片
 */

+ (UIImage *)imageWithClipImage:(UIImage *)image;
@end
