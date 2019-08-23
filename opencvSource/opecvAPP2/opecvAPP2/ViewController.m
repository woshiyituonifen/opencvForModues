//
//  ViewController.m
//  opecvAPP2
//
//  Created by linkface on 2019/8/23.
//  Copyright © 2019 linkface. All rights reserved.
//

#import "ViewController.h"
#import <opencvSource/opencvSource.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    opencvManger *manger = [[opencvManger alloc] init];
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"0011"]];
    imageV.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 300);
    [self.view addSubview:imageV];
    UIImage *imgae = [UIImage imageNamed:@"0011"];
//    UIImage *image2 =  [manger getImageOpencv:imgae];
    UIImage *image2 = [manger getWarpOpencv:imgae];
    
    UIImageView *imagev2 = [[UIImageView alloc] initWithImage:image2];
    imagev2.frame = CGRectMake(0, imageV.frame.size.height + 10 + 64, [UIScreen mainScreen].bounds.size.width/2, 200);
    [self.view addSubview:imagev2];
    
}


@end
