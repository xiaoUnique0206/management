//
//  NSString+WYAttributeStringTools.h
//  WYTest
//
//  Created by Mac mini on 16/8/4.
//  Copyright © 2016年 DryoungDr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface NSString (WYAttributeStringTools)

/**
 *  改变文本中某段文本的颜色, 大小
 *
 *  @param substringArray   需要改变的文本数组
 *  @param color            需要改变成的字体颜色
 *  @param fontSize         需要改变成的字体大小
 *
 *  @return 转换后的富文本
 */
- (NSMutableAttributedString *)changeToAttributeStringWithSubstringArray:(NSArray *)substringArray
                                                                   Color:(UIColor *)color
                                                                FontSize:(float)fontSize;

/**
 *  改变文本的字间距和行间距
 *
 *  @param wordSpaceSize    需要改变成的字间距大小, 0 代表默认
 *  @param lineSpaceSize    需要改变成的行间距大小, 0 代表默认
 *
 *  @return 转换后的富文本
 */
- (NSMutableAttributedString *)changeToAttributeStringWithWordSpaceSize:(float)wordSpaceSize
                                                          LineSpaceSize:(float)lineSpaceSize;

/**
 *  给文本中某段文本的添加删除线
 *
 *  @param substringArray   需要改变的文本数组
 *  @param deletelineColor  删除线颜色
 *
 *  @return 转换后的富文本
 */
- (NSMutableAttributedString *)changeToAttributeStringWithSubstringArray:(NSArray *)substringArray
                                                         DeletelineColor:(UIColor *)deletelineColor;

/**
 *  给文本中某段文本的添加下划线
 *
 *  @param substringArray   需要改变的文本数组
 *  @param color            文本颜色
 *  @param underlineColor   下划线颜色
 *
 *  @return 转换后的富文本
 */
- (NSMutableAttributedString *)changeToAttributeStringWithSubstringArray:(NSArray *)substringArray
                                                                   Color:(UIColor *)color
                                                          UnderlineColor:(UIColor *)underlineColor;

/**
 *  给文本中某段文本描边
 *
 *  @param substringArray   需要改变的文本数组
 *  @param borderWidth      描边的宽度
 *  @param borderColor      描边的颜色
 *
 *  @return 转换后的富文本
 */
- (NSMutableAttributedString *)changeToAttributeStringWithSubstringArray:(NSArray *)substringArray
                                                             BorderWidth:(float)borderWidth
                                                             BorderColor:(UIColor *)borderColor;

@end
