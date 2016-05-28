//
//  WHUCornerMasker.h
//  CornerViewDemo
//
//  Created by Mitty on 16/4/7.
//  Copyright © 2016年 Mitty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHUCornerMaker : NSObject

+ (BOOL) isCorneredAtView:(UIView * _Nonnull)view;

// 优先选取view 沿superview上的父类容器的背景色， 如果一直为nil, 则取defaultColor 作为圆角颜色

- (void) roundView:( UIView * _Nonnull ) view withCornerRadius:(CGFloat) radius defaultColor:( UIColor * _Nullable)color;

- (void) roundViews:(NSArray<UIView *> * _Nonnull) views withCornerRadius:(CGFloat) radius  defaultColor:( UIColor * _Nullable)color;

- (void) roundView:(UIView * _Nonnull) view withCornerRadius:(CGFloat) radius defaultColor:( UIColor * _Nullable)color byRoundingCorners:(UIRectCorner)corners;

- (void) roundViews:(NSArray<UIView *> * _Nonnull) views withCornerRadius:(CGFloat) radius  defaultColor:( UIColor * _Nullable)color  byRoundingCorners:(UIRectCorner)corners;


@end
