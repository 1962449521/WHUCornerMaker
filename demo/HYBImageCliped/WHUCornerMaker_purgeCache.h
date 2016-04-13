//
//  WHUCornerMaker_purgeCache.h
//  WHUKitDemo
//
//  Created by 胡 帅 on 16/4/9.
//  Copyright © 2016年 Disney. All rights reserved.
//

#import "WHUCornerMaker.h"

@interface WHUCornerMaker ()

// 清除所有圆角集,圆角集与圆角元是四对一的关系，由圆角元旋转形成四个角
- (void) clearRecreatableCache;

// 清除所有圆角集和圆角元 
- (void) clearAllCache;

@end
