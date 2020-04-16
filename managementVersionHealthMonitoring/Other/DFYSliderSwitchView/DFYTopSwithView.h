//
//  DFYTopSwithView.h
//  测试scrollVIew
//
//  Created by 东方盈 on 2016/11/14.
//  Copyright © 2016年 DFY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DFYSwithItem.h"

@class DFYTopSwithView;

@protocol DFYTopSwithViewDelegate <NSObject>

@optional

/**
 *  是否能切换到指定index
 */
- (BOOL)topSwithView:(DFYTopSwithView *)topView shouldSelectItemAtIndex:(NSInteger)index;

/**
 *  将要切换到指定index
 */
- (void)topSwithView:(DFYTopSwithView *)topView willSelectItemAtIndex:(NSInteger)index;

/**
 *  已经切换到指定index
 */
- (void)topSwithView:(DFYTopSwithView *)topView didSelectedItemAtIndex:(NSInteger)index;

@end

@interface DFYTopSwithView : UIView

/**
 *  DFYSwithItem，顶部滑动视图是item
 */
@property (nonatomic, copy) NSArray <DFYSwithItem *> *items;

@property (nonatomic, strong) UIColor *itemSelectedBgColor;         // item选中背景颜色
@property (nonatomic, strong) UIImage *itemSelectedBgImage;         // item选中背景图像
@property (nonatomic, assign) CGFloat itemSelectedBgCornerRadius;   // item选中背景圆角
@property (nonatomic, strong) UIColor *itemTitleColor;              // 标题颜色
@property (nonatomic, strong) UIColor *itemTitleSelectedColor;      // 选中时标题的颜色
@property (nonatomic, strong) UIFont  *itemTitleFont;               // 标题字体
@property (nonatomic, strong) UIFont  *itemTitleSelectedFont;       // 选中时标题的字体
@property (nonatomic, assign) CGFloat leftAndRightSpacing;          // TabBar边缘与第一个和最后一个item的距离
@property (nonatomic, assign) NSInteger selectedItemIndex;          // 选中某一个item


/**
 *  拖动内容视图时，item的颜色是否根据拖动位置显示渐变效果，默认为YES
 */
@property (nonatomic, assign, getter = isItemColorChangeFollowContentScroll) BOOL itemColorChangeFollowContentScroll;

/**
 *  拖动内容视图时，item的字体是否根据拖动位置显示渐变效果，默认为NO
 */
@property (nonatomic, assign, getter = isItemFontChangeFollowContentScroll) BOOL itemFontChangeFollowContentScroll;

/**
 *  TabItem的选中背景是否随contentView滑动而移动
 */
@property (nonatomic, assign, getter = isItemSelectedBgScrollFollowContent) BOOL itemSelectedBgScrollFollowContent;

/**
 *  将Image和Title设置为水平居中，默认为YES
 */
@property (nonatomic, assign, getter = isItemContentHorizontalCenter) BOOL itemContentHorizontalCenter;

@property (nonatomic, weak) id<DFYTopSwithViewDelegate> delegate;

/**
 *  返回已选中的item
 */
- (DFYSwithItem *)selectedItem;

/**
 *  根据titles创建item
 */
- (void)setTitles:(NSArray <NSString *> *)titles;

/**
 *  设置tabItem的选中背景，这个背景可以是一个横条
 *
 *  @param insets       选中背景的insets
 *  @param animated     点击item进行背景切换的时候，是否支持动画
 */
- (void)setItemSelectedBgInsets:(UIEdgeInsets)insets tapSwitchAnimated:(BOOL)animated;


/**
 设置item间隔
 fullWidth 为YES 间隔就没用了
 @param spacing 间隔
 @param fullWidth 是否平分宽度
 */
- (void)setScrollEnabledAndItemFitTextWidthWithSpacing:(CGFloat)spacing andIsFullWidth:(BOOL)fullWidth;

/**
 添加一个item在最右面

 @param item item对象
 @param handler 点击回调
 */
- (void)setOtherItem:(DFYSwithItem *)item
    tapHandler:(void (^)(DFYSwithItem *item))handler;


/**
 同步选择内容视图

 @param scrollView 内容视图
 */
- (void)updateSubViewsWhenParentScrollViewScroll:(UIScrollView *)scrollView;

@end
