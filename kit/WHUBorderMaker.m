//
//  WHUBorderMaker.m
//  CornerViewDemo
//
//  Created by Mitty on 16/4/8.
//  Copyright © 2016年 Mitty. All rights reserved.
//

#import "WHUBorderMaker.h"

#pragma mark - 被添加的圆角覆盖物标识

@interface WHUBorderLayer:CAShapeLayer

@end

@implementation WHUBorderLayer

@end


#pragma mark 提供调用接口

@implementation WHUBorderMaker

+ (void) borderView:( UIView * _Nonnull ) view withCornerRadius:(CGFloat) radius width:(CGFloat)borderWidth color:(UIColor * _Nonnull)borderColor {
    [self borderView:view withCornerRadius:radius width:borderWidth color:borderColor byRoundingCorners:UIRectCornerAllCorners];

}

+ (void) borderView:( UIView * _Nonnull ) view withCornerRadius:(CGFloat) radius width:(CGFloat)borderWidth color:(UIColor * _Nonnull)borderColor byRoundingCorners:(UIRectCorner)corners {
    NSMutableArray<CALayer *> * layers = [[view.layer sublayers] mutableCopy];
    [layers enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[WHUBorderLayer class]]) {
            [obj removeFromSuperlayer];
        }
    }];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    WHUBorderLayer *borderLayer = [WHUBorderLayer layer];
    borderLayer.path = path.CGPath;
    borderLayer.lineWidth = borderWidth;
    borderLayer.strokeColor = borderColor.CGColor;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.frame = view.bounds;
    [view.layer addSublayer:borderLayer];
}



@end
