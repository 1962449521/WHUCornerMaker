//
//  Demo1Controller.m
//  HYBImageCliped
//
//  Created by huangyibiao on 16/3/31.
//  Copyright © 2016年 huangyibiao. All rights reserved.
//

#import "Demo1Controller.h"
#import "Masonry.h"
#import "HYBImageCliped.h"
#import "WHUCornerMaker.h"
#import "WHUBorderMaker.h"

@implementation Demo1Controller {
    WHUCornerMaker *cornerMaker;
}

- (void)viewDidLoad {
  [super viewDidLoad];
    cornerMaker = [[WHUCornerMaker alloc] init];
  self.view.backgroundColor = [UIColor lightGrayColor];
  
  // 可以直接使用UIView来显示图片，不要求必须使用UIImageView
  UIView *cornerView1 = [[UIView alloc] init];
  cornerView1.frame = CGRectMake(10, 10, 80, 80);
  [self.view addSubview:cornerView1];
  
  cornerView1.backgroundColor = [UIColor redColor];
 UIImage *image = [UIImage imageNamed:@"bimg1.jpg"];
// [cornerView1 hyb_setCircleImage:image size:CGSizeMake(80, 80) isEqualScale:YES backgrounColor:[UIColor lightGrayColor] onCliped:^(UIImage *clipedImage) {
//   
// }];
    cornerView1.layer.contents = (id)image.CGImage;
    [cornerMaker roundView:cornerView1 withCornerRadius:40.0 defaultColor:nil];
  // 当图片的宽高比，与控件的宽高比不相等时，裁剪图片圆角会显示不好或者不显示出来。这是因为压缩后
  // 的图片是等比例压缩的。如果不是等比例压缩，图片就会不清楚。
  UIImageView *cornerView2 = [[UIImageView alloc] init];
  cornerView2.frame = CGRectMake(100, 10, 80, 80);
  [self.view addSubview:cornerView2];
  cornerView2.backgroundColor = [UIColor redColor];
//  [cornerView2 hyb_setImage:@"bimg5.jpg" cornerRadius:10 rectCorner:UIRectCornerTopLeft | UIRectCornerTopRight onCliped:^(UIImage *clipedImage) {
//    // You can cache the cliped image when the control is use in cell that can be reused.
//  }];
    cornerView2.image = [UIImage imageNamed:@"bimg5.jpg"];
    [cornerMaker roundView:cornerView2 withCornerRadius:10.0 defaultColor:nil  byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight];

  
  // 当图片的宽高比，与控件的宽高比不相等时，裁剪图片圆角会显示不好或者不显示出来。这是因为压缩后
  // 的图片是等比例压缩的。如果不是等比例压缩，图片就会不清楚。
  UIImageView *cornerView3 = [[UIImageView alloc] init];
  cornerView3.frame = CGRectMake(200, 10, 80, 80);
  [self.view addSubview:cornerView3];
  cornerView3.backgroundColor = [UIColor redColor];
//  [cornerView3 hyb_setImage:@"bimg8.jpg" cornerRadius:10 rectCorner:UIRectCornerTopLeft];
  
  // 由于图片宽远大于高，因此若什么等比例压缩，会看不见大部分图片内容
//  [cornerView3 hyb_setImage:@"bimg8.jpg" cornerRadius:10 rectCorner:UIRectCornerTopLeft |UIRectCornerBottomRight isEqualScale:NO onCliped:^(UIImage *clipedImage) {
//    
//  }];
    cornerView3.image = [UIImage imageNamed:@"bimg8.jpg"];
    [cornerMaker roundView:cornerView3 withCornerRadius:10.0  defaultColor:nil byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomRight];
  
  UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(10, 100, 80, 80)];
  view1.backgroundColor = [UIColor greenColor];
//  [view1 hyb_addCorner:UIRectCornerTopLeft cornerRadius:10];
  [self.view addSubview:view1];
    [cornerMaker roundView:view1 withCornerRadius:40.0 defaultColor:nil byRoundingCorners:UIRectCornerTopLeft];

  
  UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 80, 80)];
  view2.backgroundColor = [UIColor greenColor];
//  [view2 hyb_addCorner:UIRectCornerTopRight cornerRadius:10];
  [self.view addSubview:view2];
    [cornerMaker roundView:view2 withCornerRadius:10.0 defaultColor:nil byRoundingCorners:UIRectCornerTopRight];


  UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(200, 100, 80, 80)];
  view3.backgroundColor = [UIColor greenColor];
//  [view3 hyb_addCorner:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadius:10];
  [self.view addSubview:view3];
    [cornerMaker roundView:view3 withCornerRadius:10.0 defaultColor:nil  byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight];


  UIImageView *imgView = [[UIImageView alloc] init];
  imgView.frame = CGRectMake(10, 200, 80, 80);
  [self.view addSubview:imgView];
  
//   也可以直接使用UIView的扩展API哦。对于直接加载本地的图片，直接使用UIView的扩展API就只可以了。
//  [imgView hyb_setCircleImage:@"img1.jpeg" size:CGSizeMake(80, 80) isEqualScale:YES backgrounColor:[UIColor lightGrayColor] onCliped:^(UIImage *clipedImage) {
//    
//  }];
    imgView.image = [UIImage imageNamed:@"img1.jpeg"];
    [cornerMaker roundView:imgView withCornerRadius:40.0 defaultColor:nil];
  
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  button.frame = CGRectMake(100, 200, 80, 80);
  // 先设置背景色，就可以生成与背景一样颜色的图片
  button.backgroundColor = [UIColor lightGrayColor];
  [self.view addSubview:button];
//  [button hyb_setImage:@"img1.jpeg" forState:UIControlStateNormal cornerRadius:40 isEqualScale:YES];
//  [button hyb_setImage:@"bimg5.jpg" forState:UIControlStateHighlighted cornerRadius:40 isEqualScale:NO];
    [button setImage:[UIImage imageNamed:@"img1.jpeg"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"bimg5.jpg"] forState:UIControlStateHighlighted];
    [cornerMaker roundView:button withCornerRadius:40.0 defaultColor:nil];


  UIImageView *colorImageView = [[UIImageView alloc] init];
  colorImageView.frame = CGRectMake(200, 200, 80, 100);
  [self.view addSubview:colorImageView];
//  colorImageView.image = [UIImage hyb_imageWithColor:[UIColor greenColor] toSize:CGSizeMake(80, 100) cornerRadius:20 backgroundColor:[UIColor lightGrayColor]];
    colorImageView.backgroundColor = [UIColor greenColor];
    [cornerMaker roundView:colorImageView withCornerRadius:20.0 defaultColor:nil];

  
  UIImageView *bimgView = [[UIImageView alloc] init];
  bimgView.frame = CGRectMake(10, 300, 80, 80);
  [self.view addSubview:bimgView];
  UIImage *bimg = [UIImage imageNamed:@"bimg4.jpg"];
//  bimg.hyb_pathWidth = 3;
//  bimg.hyb_borderColor = [UIColor redColor];
//  bimg.hyb_borderWidth = 0.5;
//  bimgView.image = [bimg hyb_clipToSize:bimgView.bounds.size cornerRadius:0 corners:UIRectCornerAllCorners backgroundColor:[UIColor lightGrayColor] isEqualScale:NO isCircle:YES];
    bimgView.image = bimg;
    [cornerMaker roundView:bimgView withCornerRadius:40.0 defaultColor:nil];
    [WHUBorderMaker borderView:bimgView  withCornerRadius:40.0 width:3 color:[UIColor redColor]];
  
  UIImageView *bimgView1 = [[UIImageView alloc] init];
  bimgView1.frame = CGRectMake(100, 300, 80, 80);
  [self.view addSubview:bimgView1];
  UIImage *bimg1 = [UIImage imageNamed:@"bimg4.jpg"];

//  bimg1.hyb_pathWidth = 5;
//  bimg1.hyb_pathColor = [UIColor redColor];
//  bimg1.hyb_borderColor = [UIColor yellowColor];
//  bimg1.hyb_borderWidth = 1;
//  bimgView1.image = [bimg1 hyb_clipToSize:bimgView1.bounds.size cornerRadius:10 corners:UIRectCornerAllCorners backgroundColor:[UIColor lightGrayColor] isEqualScale:NO isCircle:NO];
    bimgView1.image = bimg1;
    [cornerMaker roundView:bimgView1 withCornerRadius:10.0 defaultColor:nil];
    [WHUBorderMaker borderView:bimgView1  withCornerRadius:10.0 width:5 color:[UIColor redColor]];
  
  UIImageView *bimgView3 = [[UIImageView alloc] init];
  bimgView3.frame = CGRectMake(200, 300, 80, 80);
  [self.view addSubview:bimgView3];
  UIImage *bimg3 = [UIImage imageNamed:@"bimg4.jpg"];
//  bimg3.hyb_pathWidth = 5;
//    bimg.hyb_pathColor = [UIColor yellowColor];
//  bimg3.hyb_borderWidth = 1;
//  bimgView3.image = [bimg hyb_clipCircleToSize:CGSizeMake(80, 80) backgroundColor:[UIColor lightGrayColor] isEqualScale:YES];
    bimgView3.image = bimg3;

    [cornerMaker roundView:bimgView3 withCornerRadius:40.0 defaultColor:nil];
    [WHUBorderMaker borderView:bimgView3  withCornerRadius:40.0 width:5 color:[UIColor redColor]];
  
}

@end
