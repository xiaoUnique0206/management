//
//  DFYSwithItem.h
//  测试scrollVIew
//
//  Created by 东方盈 on 2016/11/14.
//  Copyright © 2016年 DFY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DFYSwithItem : UIButton

/**
 *  item在tabBar中的index，此属性不能手动设置
 */
@property (nonatomic, assign) NSInteger index;

/**
 *  用于记录tabItem在缩放前的frame，
 *  在TabBar的属性itemFontChangeFollowContentScroll == YES时会用到
 */
@property (nonatomic, assign, readonly) CGRect frameWithOutTransform;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *titleSelectedColor;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *selectedImage;

/**
 *  设置Image和Title水平居中
 */
@property (nonatomic, assign, getter = isContentHorizontalCenter) BOOL contentHorizontalCenter;

/**
 *  设置Image和Title水平居中
 *
 *  @param verticalOffset   竖直方向的偏移量
 *  @param spacing          Image与Title的间距
 */
- (void)setContentHorizontalCenterWithVerticalOffset:(CGFloat)verticalOffset
                                             spacing:(CGFloat)spacing;
/**
 *  添加双击事件回调
 */
- (void)setDoubleTapHandler:(void (^)(void))handler;


@end
