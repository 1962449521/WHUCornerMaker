//
//  WHUCornerMasker.m
//  CornerViewDemo
//
//  Created by Mitty on 16/4/7.
//  Copyright © 2016年 Mitty. All rights reserved.
//

#import "WHUCornerMaker.h"

#pragma mark - 重用池的键值标识自定义对象

@interface WHUCornerKey : NSObject<NSCopying>

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) CGFloat radius;

@end

@implementation WHUCornerKey

- (instancetype) initWithColor:(UIColor *)color radius:(CGFloat) radius {
    self = [super init];
    if (self) {
        _color = color;
        _radius = radius;
    }
    return self;
}

- (BOOL) isEqual:(WHUCornerKey *)other {
    if (other == self) {
        return YES;
    } else if (![other isKindOfClass:[self class]]) {
        return NO;
    } else {
        return CGColorEqualToColor(_color.CGColor, other.color.CGColor) &&  fabs(_radius - other.radius) < 0.1;
    }
}

- (NSUInteger) hash {
    
    const CGFloat *colors = CGColorGetComponents(_color.CGColor);
    NSUInteger count = CGColorGetNumberOfComponents(_color.CGColor);
    
    NSMutableString *mStr = [NSMutableString string];
    for (NSUInteger index = 0; index < count; index ++) {
        [mStr appendString:[NSString stringWithFormat:@"%@", @(colors[index])]];
    }
    [mStr appendString:[NSString stringWithFormat:@"%@", @(_radius)]];
    
    return [mStr hash];
}

- (id) copyWithZone:(NSZone *)zone {
    WHUCornerKey *instance =  [[[self class] allocWithZone:zone] init];
    if (instance) {
        instance.color = _color;
        instance.radius = _radius;
    }
    return instance;
}

@end

#pragma mark - 被添加的圆角覆盖物标识

@interface WHUCornerImageView:UIImageView

@end

@implementation WHUCornerImageView

@end

#pragma mark - 主功能实现

@interface WHUCornerMaker ()

#pragma mark 实现享元模式所需的重用池
@property (nonatomic, strong) NSCache<WHUCornerKey *, UIImage *> *cornerPool;
@property (nonatomic, strong) NSCache<WHUCornerKey *, NSArray<UIImage *> *> *cornerRectPool;

#pragma mark 创建或获取可重用的圆角图片
- (UIImage *) p_cornerWithColor:(UIColor *)color radius:(CGFloat) radius;
- (NSArray<UIImage *> *) p_cornersWithColor:(UIColor *)color radius:(CGFloat) radius;

@end

@implementation WHUCornerMaker {
    dispatch_semaphore_t _semaphore_cornerPool;
    dispatch_semaphore_t _semaphore_cornerRectPool;
}

- (instancetype) init {
    if (self = [super init]) {
        _cornerPool = [NSCache new];
        _semaphore_cornerPool = dispatch_semaphore_create(1);
        _cornerRectPool = [NSCache new];
        _semaphore_cornerRectPool = dispatch_semaphore_create(1);
    }
    return self;
}

#pragma mark 提供调用接口
+ (BOOL) isCorneredAtView:(UIView *)view {
    __block BOOL isCornered = NO;
    NSMutableArray<UIView *> *curArr = [view.subviews mutableCopy];
    [curArr enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[WHUCornerImageView class]]) {
            isCornered = YES;
            *stop = YES;
        }
    }];
    return isCornered;
}

- (void) roundView:(UIView *) view withCornerRadius:(CGFloat) radius defaultColor:( UIColor * _Nullable)defaultcolor byRoundingCorners:(UIRectCorner)corners {
    NSMutableArray<UIView *>  *curArr = [view.subviews mutableCopy];
    [curArr enumerateObjectsUsingBlock:^( UIView *  obj, NSUInteger idx, BOOL *  stop) {
        if ( [obj isKindOfClass:[WHUCornerImageView class]]) {
            [obj removeFromSuperview];
        }
    }];
    
    UIView *superview = view.superview;
    while (superview.backgroundColor == nil || CGColorGetAlpha(superview.backgroundColor.CGColor) == 0 || superview.alpha == 0 || superview.opaque == 0 ) {
        if (!superview) {
            break;
        }
        superview = [superview superview];
    }
    
    UIColor *color = superview.backgroundColor;
    if (!color) {
        color = defaultcolor;
    }
    
    NSArray *arr = [self p_cornersWithColor:color radius:radius];
    if ([arr count] < 4) {
        return;
    }
    
    if (corners & UIRectCornerTopLeft) {
        WHUCornerImageView *leftUpImageView = [[WHUCornerImageView alloc]initWithImage:arr[0]];
        [view addSubview:leftUpImageView];
        leftUpImageView.translatesAutoresizingMaskIntoConstraints = NO;
        
        // align leftUpImageView from the left
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[leftUpImageView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(leftUpImageView)]];
        
        // align leftUpImageView from the top
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[leftUpImageView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(leftUpImageView)]];
        
        // width constraint
        NSString *vflStr = [NSString stringWithFormat:@"H:[leftUpImageView(==%@)]", @(radius)];
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vflStr options:0 metrics:nil views:NSDictionaryOfVariableBindings(leftUpImageView)]];
        
        // height constraint
        vflStr = [NSString stringWithFormat:@"V:[leftUpImageView(==%@)]", @(radius)];
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vflStr options:0 metrics:nil views:NSDictionaryOfVariableBindings(leftUpImageView)]];
    }
    
    if (corners & UIRectCornerTopRight) {
        WHUCornerImageView *rightUpImageView = [[WHUCornerImageView alloc]initWithImage:arr[1]];
        [view addSubview:rightUpImageView];
        rightUpImageView.translatesAutoresizingMaskIntoConstraints = NO;
        
        // align rightUpImageView from the right
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[rightUpImageView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(rightUpImageView)]];
        
        // align rightUpImageView from the top
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[rightUpImageView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(rightUpImageView)]];
        
        // width constraint
        NSString *vflStr = [NSString stringWithFormat:@"H:[rightUpImageView(==%@)]", @(radius)];
        
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vflStr options:0 metrics:nil views:NSDictionaryOfVariableBindings(rightUpImageView)]];
        
        // height constraint
        vflStr = [NSString stringWithFormat:@"V:[rightUpImageView(==%@)]", @(radius)];
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vflStr options:0 metrics:nil views:NSDictionaryOfVariableBindings(rightUpImageView)]];
        
    }
    
    if (corners & UIRectCornerBottomRight) {
        WHUCornerImageView *rightDownImageView = [[WHUCornerImageView alloc]initWithImage:arr[2]];
        [view addSubview:rightDownImageView];
        rightDownImageView.translatesAutoresizingMaskIntoConstraints = NO;
        
        // align rightDownImageView from the right
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[rightDownImageView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(rightDownImageView)]];
        
        // align rightDownImageView from the bottom
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[rightDownImageView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(rightDownImageView)]];
        
        // width constraint
        NSString *vflStr = [NSString stringWithFormat:@"H:[rightDownImageView(==%@)]", @(radius)];
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vflStr options:0 metrics:nil views:NSDictionaryOfVariableBindings(rightDownImageView)]];
        
        // height constraint
        vflStr = [NSString stringWithFormat:@"V:[rightDownImageView(==%@)]", @(radius)];
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vflStr options:0 metrics:nil views:NSDictionaryOfVariableBindings(rightDownImageView)]];
        
        
    }
    
    if (corners & UIRectCornerBottomLeft) {
        WHUCornerImageView *leftDownImageView = [[WHUCornerImageView alloc]initWithImage:arr[3]];
        [view addSubview:leftDownImageView];
        leftDownImageView.translatesAutoresizingMaskIntoConstraints = NO;
        // align leftDownImageView from the left
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[leftDownImageView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(leftDownImageView)]];
        
        // align leftDownImageView from the bottom
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[leftDownImageView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(leftDownImageView)]];
        
        // width constraint
        NSString *vflStr = [NSString stringWithFormat:@"H:[leftDownImageView(==%@)]", @(radius)];
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vflStr options:0 metrics:nil views:NSDictionaryOfVariableBindings(leftDownImageView)]];
        
        // height constraint
        vflStr = [NSString stringWithFormat:@"V:[leftDownImageView(==%@)]", @(radius)];
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vflStr options:0 metrics:nil views:NSDictionaryOfVariableBindings(leftDownImageView)]];
    }
}

- (void) roundViews:(NSArray<UIView *> *) views withCornerRadius:(CGFloat) radius defaultColor:(UIColor * _Nullable)color  byRoundingCorners:(UIRectCorner)corners {
    [views enumerateObjectsUsingBlock:^(UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
        [self roundView:view withCornerRadius:radius defaultColor:color byRoundingCorners:corners];
    }];
}

- (void) roundView:(UIView *) view withCornerRadius:(CGFloat) radius defaultColor:(UIColor * _Nullable)color{
    [self roundView:view withCornerRadius:radius defaultColor:color byRoundingCorners:UIRectCornerAllCorners];
}

- (void) roundViews:(NSArray<UIView *> *) views withCornerRadius:(CGFloat) radius defaultColor:(UIColor * _Nullable)color {
    [views enumerateObjectsUsingBlock:^(UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
        [self roundView:view withCornerRadius:radius defaultColor:color];
    }];
}

- (void) clearRecreatableCache {
    dispatch_semaphore_wait(_semaphore_cornerPool, DISPATCH_TIME_FOREVER);
    [self.cornerRectPool removeAllObjects];
    dispatch_semaphore_signal(_semaphore_cornerPool);
}

- (void) clearAllCache {
    dispatch_semaphore_wait(_semaphore_cornerPool, DISPATCH_TIME_FOREVER);
    [self clearRecreatableCache];
    dispatch_semaphore_signal(_semaphore_cornerPool);
    dispatch_semaphore_wait(_semaphore_cornerRectPool, DISPATCH_TIME_FOREVER);
    [self.cornerPool removeAllObjects];
    dispatch_semaphore_signal(_semaphore_cornerRectPool);
}

#pragma mark 私有方法
FOUNDATION_STATIC_INLINE NSUInteger p_cacheCostForImage(UIImage *image) {
    return image.size.height * image.size.width * image.scale * image.scale;
}

- (UIImage *) p_cornerWithColor:(UIColor *)color radius:(CGFloat) radius {
    WHUCornerKey *key = [[WHUCornerKey alloc] initWithColor:color radius:radius];
    UIImage *corner_check = [self.cornerPool objectForKey:key];
    
    if (!corner_check) {
        dispatch_semaphore_wait(_semaphore_cornerPool, DISPATCH_TIME_FOREVER);
        UIImage *corner_reCheck = [self.cornerPool objectForKey:key];
        
        if (!corner_reCheck) {
            UIImage *img;
            radius *= [UIScreen mainScreen].scale ;
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGContextRef contextRef = CGBitmapContextCreate(NULL, radius, radius, 8, 0, colorSpace, kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
            
            CGContextSetFillColorWithColor(contextRef, color.CGColor);
            CGContextMoveToPoint(contextRef, radius, 0);
            CGContextAddLineToPoint(contextRef, 0, 0);
            CGContextAddLineToPoint(contextRef, 0, radius);
            CGContextAddArc(contextRef, radius, radius, radius, 180 * (M_PI / 180.0f), 270 * (M_PI / 180.0f), 0);
            CGContextFillPath(contextRef);
            
            CGImageRef imageCG = CGBitmapContextCreateImage(contextRef);
            img = [UIImage imageWithCGImage:imageCG];
            
            CGContextRelease(contextRef);
            CGColorSpaceRelease(colorSpace);
            CGImageRelease(imageCG);
            if (img) {
                [self.cornerPool setObject:img forKey:key cost:p_cacheCostForImage(img)];
                dispatch_semaphore_signal(_semaphore_cornerPool);
                return img;
            } else {
                dispatch_semaphore_signal(_semaphore_cornerPool);
                return nil;
            }
        } else {
            dispatch_semaphore_signal(_semaphore_cornerPool);
            return corner_reCheck;
        }
    } else {
        return corner_check;
    }
}

- (NSArray<UIImage *> *) p_cornersWithColor:(UIColor *)color radius:(CGFloat) radius {
    WHUCornerKey *key = [[WHUCornerKey alloc] initWithColor:color radius:radius];
    NSArray<UIImage *> *cornerRect_check = (NSArray<UIImage *> *)[self.cornerRectPool objectForKey:key];
    
    if (!cornerRect_check) {
        dispatch_semaphore_wait(_semaphore_cornerRectPool, DISPATCH_TIME_FOREVER);
        NSArray<UIImage *> *cornerRect_reCheck = (NSArray<UIImage *> *)[self.cornerRectPool objectForKey:key];
        
        if (!cornerRect_reCheck) {
            UIImage *cornerImage = [self p_cornerWithColor:color radius:radius];
            CGImageRef imageRef = cornerImage.CGImage;
            
            UIImage *leftUpImage = [[UIImage alloc] initWithCGImage:imageRef scale:[UIScreen mainScreen].scale  orientation:UIImageOrientationRight];
            UIImage *rightUpImage = [[UIImage alloc] initWithCGImage:imageRef scale:[UIScreen mainScreen].scale  orientation:UIImageOrientationLeftMirrored];
            UIImage *rightDownImage = [[UIImage alloc] initWithCGImage:imageRef scale:[UIScreen mainScreen].scale  orientation:UIImageOrientationLeft];
            UIImage *leftDownImage = [[UIImage alloc] initWithCGImage:imageRef scale:[UIScreen mainScreen].scale  orientation:UIImageOrientationUp];;
            
            if (leftUpImage && rightUpImage && rightDownImage && leftDownImage) {
                NSArray *cornerRect = @[leftUpImage, rightUpImage, rightDownImage, leftDownImage];
                [self.cornerRectPool setObject:cornerRect forKey:key cost:p_cacheCostForImage(cornerImage) * 4];
                dispatch_semaphore_signal(_semaphore_cornerRectPool);
                return cornerRect;
            } else {
                dispatch_semaphore_signal(_semaphore_cornerRectPool);
                return nil;
            }
        } else {
            dispatch_semaphore_signal(_semaphore_cornerRectPool);
            return cornerRect_reCheck;
        }
    } else {
        return cornerRect_check;
    }
}


@end
