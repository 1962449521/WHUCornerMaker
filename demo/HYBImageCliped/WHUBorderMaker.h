//
//  WHUBorderMaker.h
//  CornerViewDemo
//
//  Created by 胡 帅 on 16/4/8.
//  Copyright © 2016年 Disney. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHUBorderMaker : NSObject

+ (void) borderView:( UIView * _Nonnull ) view withCornerRadius:(CGFloat) radius width:(CGFloat)borderWidth color:(UIColor * _Nonnull)borderColor;


+ (void) borderView:( UIView * _Nonnull ) view withCornerRadius:(CGFloat) radius width:(CGFloat)borderWidth color:(UIColor * _Nonnull)borderColor byRoundingCorners:(UIRectCorner)corners;

@end
