//
//  DFYSwithItem.m
//  测试scrollVIew
//
//  Created by 东方盈 on 2016/11/14.
//  Copyright © 2016年 DFY. All rights reserved.
//

#import "DFYSwithItem.h"

@interface DFYSwithItem ()

@property (nonatomic, strong) UIView *doubleTapView;
@property (nonatomic, assign) CGFloat verticalOffset;
@property (nonatomic, assign) CGFloat spacing;
@property (nonatomic, copy) void (^doubleTapHandler)(void);

@end

@implementation DFYSwithItem

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setup];
}

+ (instancetype)buttonWithType:(UIButtonType)buttonType {
    DFYSwithItem *item = [super buttonWithType:buttonType];
    [item setup];
    return item;
}

- (void)setup {
    self.adjustsImageWhenHighlighted = NO;
}

/**
 *  覆盖父类的setHighlighted:方法，按下时，不高亮该item
 */
- (void)setHighlighted:(BOOL)highlighted {
    if (self.adjustsImageWhenHighlighted) {
        [super setHighlighted:highlighted];
    }
}

- (void)setContentHorizontalCenter:(BOOL)contentHorizontalCenter {
    _contentHorizontalCenter = contentHorizontalCenter;
    if (!_contentHorizontalCenter) {
        self.verticalOffset = 0;
        self.spacing = 0;
    }
    if (self.superview) {
        [self layoutSubviews];
    }
}

- (void)setContentHorizontalCenterWithVerticalOffset:(CGFloat)verticalOffset
                                             spacing:(CGFloat)spacing {
    self.verticalOffset = verticalOffset;
    self.spacing = spacing;
    self.contentHorizontalCenter = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if ([self imageForState:UIControlStateNormal] && self.contentHorizontalCenter) {
        CGSize titleSize = self.titleLabel.frame.size;
        CGSize imageSize = self.imageView.frame.size;
        titleSize = CGSizeMake(ceilf(titleSize.width), ceilf(titleSize.height));
        CGFloat totalHeight = (imageSize.height + titleSize.height + self.spacing);
        self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height - self.verticalOffset), 0, 0, - titleSize.width);
        self.titleEdgeInsets = UIEdgeInsetsMake(self.verticalOffset, - imageSize.width, - (totalHeight - titleSize.height), 0);
    } else {
        self.imageEdgeInsets = UIEdgeInsetsZero;
        self.titleEdgeInsets = UIEdgeInsetsZero;
    }
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (self.doubleTapView) {
        self.doubleTapView.hidden = !selected;
    }
}

- (void)setDoubleTapHandler:(void (^)(void))handler {
    _doubleTapHandler = handler;
    if (!self.doubleTapView) {
        self.doubleTapView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:self.doubleTapView];
        UITapGestureRecognizer *doubleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapped:)];
        doubleRecognizer.numberOfTapsRequired = 2;
        [self.doubleTapView addGestureRecognizer:doubleRecognizer];
    }
}

- (void)doubleTapped:(UITapGestureRecognizer *)recognizer {
    if (self.doubleTapHandler) {
        self.doubleTapHandler();
    }
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    _frameWithOutTransform = frame;
    if (self.doubleTapView) {
        self.doubleTapView.frame = self.bounds;
    }
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect rect = self.frame;
    rect.size = size;
    self.frame = rect;
}

#pragma mark - Title and Image
- (void)setTitle:(NSString *)title {
    _title = title;
    [self setTitle:title forState:UIControlStateNormal];
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    [self setTitleColor:titleColor forState:UIControlStateNormal];
}

- (void)setTitleSelectedColor:(UIColor *)titleSelectedColor {
    _titleSelectedColor = titleSelectedColor;
    [self setTitleColor:titleSelectedColor forState:UIControlStateSelected];
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    if ([UIDevice currentDevice].systemVersion.integerValue >= 8) {
        self.titleLabel.font = titleFont;
    }
}

- (void)setImage:(UIImage *)image {
    _image = image;
    [self setImage:image forState:UIControlStateNormal];
}

- (void)setSelectedImage:(UIImage *)selectedImage {
    _selectedImage = selectedImage;
    [self setImage:selectedImage forState:UIControlStateSelected];
}

@end
