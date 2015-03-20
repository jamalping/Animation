//
//  JamalViewController.m
//  Animation
//
//  Created by jamalping on 15-3-19.
//  Copyright (c) 2015年 jamalping. All rights reserved.
//
/**
 *  @brief  CAAnimation：核心动画的基础类，不能直接使用，负责动画运行时间、速度的控制，本身实现了CAMediaTiming协议。
 
 CAPropertyAnimation：属性动画的基类（通过属性进行动画设置，注意是可动画属性），不能直接使用。
 
 CAAnimationGroup：动画组，动画组是一种组合模式设计，可以通过动画组来进行所有动画行为的统一控制，组中所有动画效果可以并发执行。
 
 CATransition：转场动画，主要通过滤镜进行动画效果设置。
 
 CABasicAnimation：基础动画，通过属性修改进行动画参数控制，只有初始状态和结束状态。
 
 CAKeyframeAnimation：关键帧动画，同样是通过属性进行动画参数控制，但是同基础动画不同的是它可以有多个状态控制。
 */

#import "JamalViewController.h"
#import "jamalView.h"

#define PHOTO_HEIGHT  150

@interface JamalViewController ()
{
    CALayer *_layer;
}
@end

@implementation JamalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"dismiss" style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
    
    // 自定义Calayer
//    [self customLayer];
    
//    [self CustonJamalView];
    // UIView基本动画
//    [self myAnimation];
    
#warning 动画创建一般分为以下几步
    /*
    1.初始化动画并设置动画属性
    2.设置动画属性初始值（可以省略）、结束值以及其他动画属性
    3.给图层添加动画
     */
    [self customAnimation];
}
//--------------------------------111--------------------------------
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

//--------------------------------222--------------------------------
#pragma mark --- 使用自定义图层绘图
- (void)CustonJamalView {
    jamalView *jView = [[jamalView alloc] initWithFrame:CGRectMake(100, 350, 200, 200)];
    jView.backgroundColor=[UIColor redColor];
    
    [self.view addSubview:jView];
}

/**
 *  @brief  一般动画
 */
- (void)myAnimation {
    UIImage *image=[UIImage imageNamed:@"111.jpg"];
    UIImageView *imageView=[[UIImageView alloc]init];
    imageView.image=image;
    imageView.frame=CGRectMake(120, 140, 80, 80);
    [self.view addSubview:imageView];
    
    //两秒后开始一个持续一分钟的动画
    [UIView animateWithDuration:1 delay:2 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        imageView.frame=CGRectMake(80, 100, 160, 160);
    } completion:nil];
}

//--------------------------------333--------------------------------
/**
 *  @brief  自定义动画
 */
- (void)customAnimation {
    //设置背景(注意这个图片其实在根图层)
    UIImage *backgroundImage=[UIImage imageNamed:@"111.jpg"];
    self.view.backgroundColor=[UIColor colorWithPatternImage:backgroundImage];
    
    // 自定义一个图层
    _layer = [[CALayer alloc] init];
    _layer.bounds=CGRectMake(0, 0, 10, 20);
    _layer.position=CGPointMake(50, 150);
    _layer.contents=(id)[UIImage imageNamed:@"flower.png"].CGImage;
    [self.view.layer addSublayer:_layer];
}

- (void)translationAnimation:(CGPoint)location {
    //1.创建动画，并指定动画属性
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    //2.设置动画属性初始值和结束值
//    basicAnimation.fromValue = [NSNumber numberWithInteger:50];// 可以不设置，默认为图层出事状态
    basicAnimation.toValue = [NSValue valueWithCGPoint:location];
    // 动画时间5秒
    basicAnimation.duration = 5;
    // 动画重复次数，HUGE_VAL可以看作无穷大，起到循环动画的效果。
//    basicAnimation.repeatCount = HUGE_VAL;
    // 运行一次是否移除动画，默认为yes
//    basicAnimation.removedOnCompletion = NO;
    // 添加动画到图层，注意key相当与给动画命名以后获得该动画可以通过该名称获取
    
    // 设置动画代理
    basicAnimation.delegate = self;
    //存储当前位置在动画结束后使用
    [basicAnimation setValue:[NSValue valueWithCGPoint:location] forKey:@"JamalBasicAnimation_EndLocation"];
    
    [_layer addAnimation:basicAnimation forKey:@"JamalBasicAnimation_Translation"];
}

// touch事件
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.view];
    [self translationAnimation:location];
}

#pragma mark --- 动画开始的代理
#pragma mark --- 动画结束的代理

- (void)animationDidStart:(CAAnimation *)anim {
    NSLog(@"animation(%@) start.\r_layer.frame=%@",anim,NSStringFromCGRect(_layer.frame));
    NSLog(@"%@",[_layer animationForKey:@"JamalBasicAnimation_Translation"]);//通过前面的设置的key获得动画
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSLog(@"animation(%@) stop.\r_layer.frame=%@",anim,NSStringFromCGRect(_layer.frame));
    /*那就是动画运行完成后会重新从起始点运动到终点。这个问题产生的原因就是前面提到的，对于非根图层，设置图层的可动画属性（在动画结束后重新设置了position，而position是可动画属性）会产生动画效果。解决这个问题有两种办法：关闭图层隐式动画、设置动画图层为根图层。显然这里不能采取后者，因为根图层当前已经作为动画的背景。
     */
    // 开启事物
    [CATransaction begin];
    // 禁用隐式动画
    [CATransaction setDisableActions:YES];
    
    _layer.position=[[anim valueForKey:@"JamalBasicAnimation_EndLocation"] CGPointValue];
    // 提交事务
    [CATransaction commit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
