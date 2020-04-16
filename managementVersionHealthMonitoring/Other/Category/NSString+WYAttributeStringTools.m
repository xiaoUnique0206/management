//
//  NSString+WYAttributeStringTools.m
//  WYTest
//
//  Created by Mac mini on 16/8/4.
//  Copyright © 2016年 DryoungDr. All rights reserved.
//

#import "NSString+WYAttributeStringTools.h"

@implementation NSString (WYAttributeStringTools)

- (NSMutableAttributedString *)changeToAttributeStringWithSubstringArray:(NSArray *)substringArray
                                                                   Color:(UIColor *)color
                                                                FontSize:(float)fontSize {

    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self];
    
    for (NSString *substring in substringArray) {
        
        NSRange range = [self rangeOfString:substring];
        [attributeString addAttribute:NSForegroundColorAttributeName value:color range:range];
        [attributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize] range:range];
    }
    
    return attributeString;
}

- (NSMutableAttributedString *)changeToAttributeStringWithWordSpaceSize:(float)wordSpaceSize
                                                          LineSpaceSize:(float)lineSpaceSize {
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self];
    
    long tempNumber = wordSpaceSize;
    CFNumberRef number = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt8Type, &tempNumber);
    [attributeString addAttribute:(id)kCTKernAttributeName value:(__bridge id _Nonnull)(number) range:NSMakeRange(0, self.length)];
    CFRelease(number);
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpaceSize];
    [attributeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.length)];
    
    return attributeString;
}

- (NSMutableAttributedString *)changeToAttributeStringWithSubstringArray:(NSArray *)substringArray
                                                         DeletelineColor:(UIColor *)deletelineColor {
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self];
    
    for (NSString *substring in substringArray) {
        
        NSRange range = [self rangeOfString:substring];
        [attributeString addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:range];// 删除线的类型
        [attributeString addAttribute:NSStrikethroughColorAttributeName value:deletelineColor range:range];
    }
    
    return attributeString;
}

- (NSMutableAttributedString *)changeToAttributeStringWithSubstringArray:(NSArray *)substringArray
                                                                   Color:(UIColor *)color
                                                          UnderlineColor:(UIColor *)underlineColor {
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self];
    
    for (NSString *substring in substringArray) {
        
        NSRange range = [self rangeOfString:substring];
        [attributeString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:range];// 下划线的类型
        [attributeString addAttribute:NSUnderlineColorAttributeName value:underlineColor range:range];
        [attributeString addAttribute:NSForegroundColorAttributeName value:color range:range];
    }
    
    return attributeString;
}

- (NSMutableAttributedString *)changeToAttributeStringWithSubstringArray:(NSArray *)substringArray
                                                             BorderWidth:(float)borderWidth
                                                             BorderColor:(UIColor *)borderColor {
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self];
    
    for (NSString *substring in substringArray) {
        
        NSRange range = [self rangeOfString:substring];
        [attributeString addAttribute:NSStrokeWidthAttributeName value:[NSNumber numberWithFloat:borderWidth]range:range];
        [attributeString addAttribute:NSStrokeColorAttributeName value:borderColor range:range];
    }
    
    return attributeString;
}

@end
