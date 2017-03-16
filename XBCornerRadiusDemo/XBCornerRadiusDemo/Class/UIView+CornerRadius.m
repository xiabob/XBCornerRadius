//
//  UIView+CornerRadius.m
//  XBCornerRadiusDemo
//
//  Created by xiabob on 17/3/3.
//  Copyright © 2017年 xiabob. All rights reserved.
//

#import "UIView+CornerRadius.h"
#import <objc/runtime.h>

#pragma mark - _RoundedCornerLayer

@interface _RoundedCornerLayer : CALayer
@end

@implementation _RoundedCornerLayer
@end


#pragma mark - CALayer Category

@interface CALayer (CornerRadius)

@property (nonatomic, strong) NSString *_cornerLayerIdentifier;

@end


@implementation CALayer (CornerRadius)

- (void)xb_setRoundedCorner:(CGSize)cornerRadii
                cornerColor:(nonnull UIColor *)cornerColor
                    corners:(UIRectCorner)corners
                borderColor:(nullable UIColor *)borderColor
                borderWidth:(CGFloat)borderWidth {
    NSString *key = [NSString stringWithFormat:@"Identifier_%@x%@_%@_%@_%@_%@", @(cornerRadii.width), @(cornerRadii.height), cornerColor.description, @(corners), borderColor.description, @(borderWidth)];
    if ([key isEqualToString:self._cornerLayerIdentifier]) {
        //无需重复设置
        return;
    } else {
        self._cornerLayerIdentifier = key;
    }
    
    //remove exit layer
    for (CALayer *layer in self.sublayers) {
        if ([layer isKindOfClass:[_RoundedCornerLayer class]]) {
            [layer removeFromSuperlayer];
            break;
        }
    }
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!context) {return;}
    
    //draw round corner by using eo rule
    CGContextSetLineWidth(context, 0);
    CGContextSetFillColorWithColor(context, cornerColor.CGColor);
    
    //outer rect path
    UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:self.bounds];
    //inner round path
    UIBezierPath *roundPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:cornerRadii];
    [rectPath appendPath:roundPath];
    
    CGContextAddPath(context, rectPath.CGPath);
    CGContextEOFillPath(context);
    
    //set border
    if (borderColor && borderWidth > 0) {
        CGContextSetFillColorWithColor(context, borderColor.CGColor);
        UIBezierPath *borderOutterPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:cornerRadii];
        UIBezierPath *borderInnerPath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(self.bounds, borderWidth, borderWidth) byRoundingCorners:corners cornerRadii:cornerRadii];
        [borderOutterPath appendPath:borderInnerPath];
        
        CGContextAddPath(context, borderOutterPath.CGPath);
        CGContextEOFillPath(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    _RoundedCornerLayer *subLayer = [_RoundedCornerLayer new];
    subLayer.frame = self.bounds;
    subLayer.opaque = YES;
    subLayer.contents = (__bridge id _Nullable)(image.CGImage);
    [self addSublayer:subLayer];
}

- (NSString *)_cornerLayerIdentifier {
    return objc_getAssociatedObject(self, @selector(_cornerLayerIdentifier));
}

- (void)set_cornerLayerIdentifier:(NSString *)_cornerLayerIdentifier {
    objc_setAssociatedObject(self, @selector(_cornerLayerIdentifier), _cornerLayerIdentifier, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end


#pragma mark - UIView

@implementation UIView (CornerRadius)

- (void)xb_setRoundedCorner:(CGFloat)radius {
    [self xb_setRoundedCorner:radius backgroundColor:[UIColor whiteColor]];
}

- (void)xb_setRoundedCorner:(CGFloat)radius
            backgroundColor:(nonnull UIColor *)backgroundColor {
    [self xb_setRoundedCorner:radius backgroundColor:backgroundColor corners:UIRectCornerAllCorners];
}

- (void)xb_setRoundedCorner:(CGFloat)radius
            backgroundColor:(nonnull UIColor *)backgroundColor
                    corners:(UIRectCorner)corners {
    [self xb_setRoundedCorner:CGSizeMake(radius, radius) backgroundColor:backgroundColor corners:corners borderColor:nil borderWidth:0];
}

- (void)xb_setRoundedCorner:(CGSize)cornerRadii
            backgroundColor:(nonnull UIColor *)backgroundColor
                    corners:(UIRectCorner)corners
                borderColor:(nullable UIColor *)borderColor
                borderWidth:(CGFloat)borderWidth {
    //only scaleAspectFill not cause offscreen-renderd, do this for better display
    if ([self isKindOfClass:[UIImageView class]]) {
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
    }
    
    [self.layer xb_setRoundedCorner:cornerRadii cornerColor:backgroundColor corners:corners borderColor:borderColor borderWidth:borderWidth];
}

@end

