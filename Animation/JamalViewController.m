//
//  JamalViewController.m
//  Animation
//
//  Created by jamalping on 15-3-19.
//  Copyright (c) 2015年 jamalping. All rights reserved.
//

#import "JamalViewController.h"
#import "jamalView.h"

#define PHOTO_HEIGHT  150

@interface JamalViewController ()

@end

@implementation JamalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"dismiss" style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
    
    // 自定义Calayer
    [self customLayer];
    
    [self CustonJamalView];
}

/**
 *  @brief  自定义layer，涉及CATransform3DMakeRotation，layer.contents,layer.delegate
 */
- (void)customLayer {
    CGPoint position = CGPointMake(160, 200);
    CGRect bounds = CGRectMake(0, 0, PHOTO_HEIGHT, PHOTO_HEIGHT);
    CGFloat cornerRadius = PHOTO_HEIGHT/2;
    CGFloat borderWidth = 2;
    
    // 阴影图层
    CALayer *layerShadow = [[CALayer alloc] init];
    layerShadow.position = position;
    layerShadow.bounds = bounds;
    layerShadow.cornerRadius = cornerRadius;
    layerShadow.shadowColor = [UIColor grayColor].CGColor;
    layerShadow.shadowOffset = CGSizeMake(2, 1);
    layerShadow.shadowOpacity = 1;
    layerShadow.borderColor = [UIColor whiteColor].CGColor;
    layerShadow.borderWidth = borderWidth;
    [self.view.layer addSublayer:layerShadow];
    
    // 容器图层
    CALayer *layer=[[CALayer alloc]init];
    layer.backgroundColor=[UIColor redColor].CGColor;
    layer.masksToBounds=YES;
    layer.borderColor=[UIColor whiteColor].CGColor;
    layer.bounds=bounds;
    layer.position=position;
    layer.cornerRadius=cornerRadius;
    layer.borderWidth=borderWidth;
    
    // 直接设置图层内容，
//    [layer setContents:(id)[UIImage imageNamed:@"111.jpg"].CGImage];
    
    // 利用图层形变解决图像倒立的问题
//    layer.transform = CATransform3DMakeRotation(M_PI, 1, 0, 0);
    
    // 通过keypath的方式进行设置，keyPath的值请参考Xcode帮助文档中“CATransform3D Key Paths”一节
    [layer setValue:@M_PI forKeyPath:@"transform.rotation.x"];
    
    //设置图层代理
    layer.delegate=self;
    
    //添加图层到根图层
    [self.view.layer addSublayer:layer];
    
    //调用图层setNeedDisplay,否则代理方法不会被调用
    [layer setNeedsDisplay];
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    //    NSLog(@"%@",layer);//这个图层正是上面定义的图层
    UIImage *image=[UIImage imageNamed:@"111.jpg"];
    //注意这个位置是相对于图层而言的不是屏幕
    CGContextDrawImage(ctx, CGRectMake(0, 0, PHOTO_HEIGHT, PHOTO_HEIGHT), image.CGImage);
}

- (void)dismiss {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

///////////////////////////////////////////////////////////////////////////////////
#pragma mark --- 使用自定义图层绘图
- (void)CustonJamalView {
    jamalView *jView = [[jamalView alloc] initWithFrame:CGRectMake(100, 350, 200, 200)];
    jView.backgroundColor=[UIColor redColor];
    
    [self.view addSubview:jView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
