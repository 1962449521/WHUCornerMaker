//
//  ViewController.m
//  CornerViewDemo
//
//  Created by Mitty on 16/4/7.
//  Copyright © 2016年 Mitty. All rights reserved.
//

#import "ViewController.h"
#import "WHUCornerMaker.h"


@interface MyCell : UITableViewCell

@property (nonatomic, strong) UIImageView * imageView_0;
@property (nonatomic, strong) UIImageView * imageView_1;
@property (nonatomic, strong) UIImageView * imageView_2;
@property (nonatomic, strong) UIImageView * imageView_3;
@property (nonatomic, strong) UIImageView * imageView_4;
@property (nonatomic, strong) UIView * cornerView_0;

@end

@implementation MyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self customInit];
    }
    return self;

}

- (void) customInit {
    _imageView_0 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    _imageView_1 = [[UIImageView alloc] initWithFrame:CGRectMake(50, 0, 50, 50)];
    _imageView_2 = [[UIImageView alloc] initWithFrame:CGRectMake(100, 0, 50, 50)];
    _imageView_3 = [[UIImageView alloc] initWithFrame:CGRectMake(150, 0, 50, 50)];
    _imageView_4 = [[UIImageView alloc] initWithFrame:CGRectMake(200, 0, 50, 50)];
    _cornerView_0 = [[UIView alloc] initWithFrame:CGRectMake(250, 0, 50, 50)];
    
    [self.contentView addSubview:_imageView_0];
    [self.contentView addSubview:_imageView_1];
    [self.contentView addSubview:_imageView_2];
    [self.contentView addSubview:_imageView_3];
    [self.contentView addSubview:_imageView_4];
    [self.contentView addSubview:_cornerView_0];
    


}

+ (NSString *) identifier {
    return @"MyCell";
}

@end

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

unsigned long _objc_rootRetainCount(id);

@implementation ViewController {
    WHUCornerMaker *_masker;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[MyCell class] forCellReuseIdentifier:[MyCell identifier]];
    self.tableView.rowHeight = 50;
    _masker = [WHUCornerMaker new];

    self.automaticallyAdjustsScrollViewInsets = NO;

}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 400;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyCell *cell = [tableView dequeueReusableCellWithIdentifier:[MyCell identifier]];
    
    NSArray *colorlists = @[[UIColor redColor], [UIColor yellowColor], [UIColor greenColor], [UIColor purpleColor]];
    NSUInteger index = arc4random() % 4;
    UIColor *color = colorlists[index];
    cell.backgroundColor = color;
    
    [cell.imageView_0 setImage:[UIImage imageNamed:@"icon"]];
    [cell.imageView_1 setImage:[UIImage imageNamed:@"icon"]];
    [cell.imageView_2 setImage:[UIImage imageNamed:@"icon"]];
    [cell.imageView_3 setImage:[UIImage imageNamed:@"icon"]];
    [cell.imageView_4 setImage:[UIImage imageNamed:@"icon"]];
    
    [_masker roundViews:@[cell.imageView_0, cell.imageView_1, cell.imageView_2, cell.imageView_3, cell.imageView_4] withCornerRadius:25 defaultColor:nil];

    return cell;
}

@end
