//
//  UIView+CornerRadius.h
//  XBCornerRadiusDemo
//
//  Created by xiabob on 17/3/3.
//  Copyright © 2017年 xiabob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CornerRadius)

- (void)xb_setRoundedCorner:(CGFloat)radius;

- (void)xb_setRoundedCorner:(CGFloat)radius
            backgroundColor:(nonnull UIColor *)backgroundColor;

- (void)xb_setRoundedCorner:(CGFloat)radius
            backgroundColor:(nonnull UIColor *)backgroundColor
                    corners:(UIRectCorner)corners;

- (void)xb_setRoundedCorner:(CGSize)cornerRadii
            backgroundColor:(nonnull UIColor *)backgroundColor
                    corners:(UIRectCorner)corners
                borderColor:(nullable UIColor *)borderColor
                borderWidth:(CGFloat)borderWidth;

@end
