//
//  ViewController.m
//  Animation
//
//  Created by jamalping on 15-3-16.
//  Copyright (c) 2015年 jamalping. All rights reserved.
//
#define layerWidth 50
#import "ViewController.h"
#import "JamalViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    view = [[UIView alloc] initWithFrame:CGRectMake(10, 20, 100, 100)];
    view.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:view];
    
    UIButton *push = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    push.frame = CGRectMake(100, 300, 100, 100);
//    push.titleLabel.text = @"push";
    [push setTitle:@"push" forState:UIControlStateNormal];
    push.backgroundColor = [UIColor redColor];
    [push addTarget:self action:@selector(pushClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:push];
    
    // eg：1
//    [self drawMylayer];
    
    // eg：2
    [self cusTomLayer];
}

/**
 *  @brief  画layer（学习layer的各个属性）
 */
- (void)drawMylayer {
    CGSize size = view.frame.size;
    CALayer *layer = [[CALayer alloc] init];
    // anchorPoint 默认：（0.5，0.5） 移动layer的位置，使得中心点的位置等于anchorPoint
//    layer.anchorPoint = CGPointMake(0.1, 1);
//    layer.anchorPoint = CGPointMake(1, 1);
    layer.backgroundColor = [UIColor redColor].CGColor;
    // 设置中心点(默认0，0)
    layer.position = CGPointMake(size.width/2, size.height/2);
    // 设置大小为
    layer.bounds = CGRectMake(0, 0, layerWidth, layerWidth);
    // 设置圆角，当圆角的半径等于矩形的一半的时候看起来就是个圆形
    layer.cornerRadius = layerWidth/2;
    // 设置阴影
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOffset = CGSizeMake(3, 3);
    // 设置不透明度
    layer.shadowOpacity = 100;
    
    [view.layer addSublayer:layer];
}

// 点击放大的方法
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CALayer *layer = view.layer.sublayers[0];
    CGFloat width = layer.bounds.size.width;
    if (width == layerWidth) {
        layer.opacity = .5;
        width = 4*layerWidth;
    } else {
        layer.opacity = 1;
        width = layerWidth;
    }
    layer.bounds = CGRectMake(0, 0, width, width);
    layer.position = [touch locationInView:view];
    layer.cornerRadius = width/2;
}

/**
 *  @brief  画layer
 */
- (void)cusTomLayer {
    
    CGRect bounds = CGRectMake(0, 0, 150, 150);
    CGPoint position = CGPointMake(200, 100);
    CGFloat Radius = 150/2;
    
    // 阴影图层
    CALayer *shadowLayer = [[CALayer alloc] init];
    shadowLayer.bounds = bounds;
    shadowLayer.position = position;
    shadowLayer.cornerRadius = Radius;
    shadowLayer.shadowColor = [UIColor redColor].CGColor;
    shadowLayer.shadowOffset = CGSizeMake(1, 1);
    shadowLayer.shadowOpacity = 1;
//    shadowLayer.delegate = self;
    shadowLayer.borderColor = [UIColor whiteColor].CGColor;
    shadowLayer.borderWidth = 3;
    [view.layer addSublayer:shadowLayer];
    
    
    CALayer *layer = [[CALayer alloc] init];
    layer.bounds = bounds;
    layer.position = position;
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    layer.cornerRadius = Radius;
    layer.masksToBounds = YES;
//    layer.borderWidth = 3;
//    layer.borderColor = [UIColor whiteColor].CGColor;
    layer.delegate = self;
    [view.layer addSublayer:layer];
    // 重绘
    [layer setNeedsDisplay];
}

#pragma mark --- 绘制图形，图像到图层，注意参数ctx是图层的图形上下文，其中绘图位置也是相对图层而言的
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    CGContextSaveGState(ctx);
    //图形上下文形变，解决图片倒立的问题
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -150);
    
    UIImage *img = [UIImage imageNamed:@"111.jpg"];
    // 注意这个位置是相对图层而不是屏幕
    CGContextDrawImage(ctx, CGRectMake(0, 0, 150, 150), img.CGImage);
    CGContextRestoreGState(ctx);
}

- (void)pushClick {
    JamalViewController *jamalVc = [[JamalViewController alloc] init];
    UINavigationController *nvg = [[UINavigationController alloc] initWithRootViewController:jamalVc];
    [self presentViewController:nvg animated:YES completion:nil];
}

@end
