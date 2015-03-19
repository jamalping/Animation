//
//  jamalView.m
//  Animation
//
//  Created by jamalping on 15-3-19.
//  Copyright (c) 2015年 jamalping. All rights reserved.
//

#import "jamalView.h"
#import "JamalCLayer.h"

@implementation jamalView
/*前面的文章中曾经说过，在使用Quartz 2D在UIView中绘制图形的本质也是绘制到图层中，为了说明这个问题下面演示自定义图层绘图时没有直接在视图控制器中调用自定义图层，而是在一个UIView将自定义图层添加到UIView的根图层中（例子中的UIView跟自定义图层绘图没有直接关系）。从下面的代码中可以看到：UIView在显示时其根图层会自动创建一个CGContextRef（CALayer本质使用的是位图上下文），同时调用图层代理（UIView创建图层会自动设置图层代理为其自身）的draw: inContext:方法并将图形上下文作为参数传递给这个方法。而在UIView的draw:inContext:方法中会调用其drawRect:方法，在drawRect:方法中使用UIGraphicsGetCurrentContext()方法得到的上下文正是前面创建的上下文。
*/
// 自己的理解 View在显示的时候会自动创建一个CGContextRef（图文上下文）同时调用图层代理（UIView创建图层会自动设置图层代理为其自身）的draw：inContent方法, 并将CGContextRef作为参数传递给这个方法，再调用drawRect方法，在drawRect方法中使用UIGraphicsGetCurrentContext()得到的图文上下文正是前面创建的上下文
- (instancetype)initWithFrame:(CGRect)frame {
    NSLog(@"initWithFrame");
    self = [super initWithFrame:frame];
    if (self) {
        JamalCLayer *jClayer = [[JamalCLayer alloc] init];
        jClayer.bounds=CGRectMake(0, 0, frame.size.width, frame.size.height);
        jClayer.position=CGPointMake(frame.size.width/2,frame.size.height/2);
        jClayer.backgroundColor=[UIColor colorWithRed:0 green:146/255.0 blue:1.0 alpha:1.0].CGColor;
        
        //显示图层
        [jClayer setNeedsDisplay];
        
        [self.layer addSublayer:jClayer];
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    NSLog(@"2-drawRect:");
    NSLog(@"CGContext:%@",UIGraphicsGetCurrentContext());//得到的当前图形上下文正是drawLayer中传递的
    [super drawRect:rect];
    
}

-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
    NSLog(@"1-drawLayer:inContext:");
    NSLog(@"CGContext:%@",ctx);
    [super drawLayer:layer inContext:ctx];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
