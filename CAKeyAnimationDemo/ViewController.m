//
//  ViewController.m
//  CAKeyAnimationDemo
//
//  Created by qzwh on 2018/10/14.
//  Copyright © 2018年 qianjinjia. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) UIView *circleView;

@property (nonatomic, strong) UIView *sinView;
@property (nonatomic, strong) CAShapeLayer *sinLayer;

@property (nonatomic, strong) UIImageView *redView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //关键帧动画
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 110, self.view.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineView];

    self.circleView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, 20, 20)];
    self.circleView.backgroundColor = [UIColor orangeColor];
    self.circleView.layer.cornerRadius = self.circleView.frame.size.width/2;
    self.circleView.layer.masksToBounds = YES;
    [self.view addSubview:self.circleView];

//    [self addLineKeyAnimation];

    [self createPath];
    
    //CA动画基础
//    [self createBasicCA];
    //旋转动画
//    [self transitView];
    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.backgroundColor = [UIColor orangeColor];
//    [btn setTitle:@"视图变大" forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    btn.frame = CGRectMake(30, 100, 100, 30);
//    [btn addTarget:self action:@selector(handleAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn];
//
//    [self.view addSubview:self.redView];
    
    //创建子线程
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(handleChildren) object:nil];
//    NSLog(@"主线程");
//    [queue addOperation:operation];
}

- (void)handleChildren {
    NSLog(@"子线程%@", [NSThread currentThread]);
}

- (void)handleAction:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"视图变大"]) {
        //动画移动放大
        [self translationChangeBig];
        [sender setTitle:@"视图缩小" forState:UIControlStateNormal];
    } else {
        [self translationChangeSmall];
        [sender setTitle:@"视图变大" forState:UIControlStateNormal];
    }
}

- (void)translationChangeBig {
    [UIView animateWithDuration:3.0 animations:^{
        CGRect frame = self.redView.frame;
        frame.origin.x = (self.view.frame.size.width-300)/2;
        frame.origin.y = 500;
        frame.size.width = 300;
        frame.size.height = 300;
        self.redView.frame = frame;
    } completion:^(BOOL finished) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
        label.text = @"你可能是个傻子拉上来看的积分阿斯加德理发卡接收到阿斯兰的积分";
        [self.redView addSubview:label];
    }];
}

- (void)translationChangeSmall {
    [UIView animateWithDuration:3.0 animations:^{
        CGRect frame = self.redView.frame;
        frame.origin.x = 0;
        frame.origin.y = 200;
        frame.size.width = 50;
        frame.size.height = 50;
        self.redView.frame = frame;
    } completion:^(BOOL finished) {
        for (UIView *view in self.redView.subviews) {
            [view removeFromSuperview];
        }
    }];
}

- (void)transitView {
    self.redView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    [UIView animateWithDuration:1.0 animations:^{
        self.redView.transform = CGAffineTransformMakeRotation(M_PI);
    }];
}

- (void)createBasicCA {
    //anchorPoint默认为(0.5,0.5)
    CALayer *mylayer = [CALayer layer];
    //设置层的宽高
    mylayer.bounds = CGRectMake(0, 0, 100, 100);
    //设置层的位置
    mylayer.position = CGPointMake(100, 100);
//    mylayer.anchorPoint = CGPointMake(0, 0);
    mylayer.anchorPoint = CGPointMake(1, 1);
    mylayer.backgroundColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:mylayer];
}

//对视图添加关键帧动画
- (void)addLineKeyAnimation {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    NSArray *values = @[
                        [NSValue valueWithCGPoint:CGPointMake(10, 110)],
                        [NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width-10, 110)],
                        ];
    animation.values = values;
    animation.duration = 3;
    //1.2设置动画执行完毕后，不删除动画
    animation.removedOnCompletion = NO;
    animation.repeatCount = 1000;
    animation.autoreverses = YES;
    animation.calculationMode = kCAAnimationLinear;
    animation.fillMode = kCAFillModeForwards;
    [self.circleView.layer addAnimation:animation forKey:nil];
}

- (void)createPath {
    //创建一个路径
    UIBezierPath *path = [UIBezierPath new];
    CGFloat y = 7;
    //将点移动到 x=0,y=currentK的位置
    [path moveToPoint:CGPointMake(0, 500)];
    for (NSInteger x = 0.0f; x<= self.view.frame.size.width; x++) {
        //正玄波浪公式
        y = 100 * sin(M_PI/50 * x) + 500;
        //将点连成线
        [path addLineToPoint:CGPointMake(x, y)];
    }
//    [path addLineToPoint:CGPointMake(self.view.frame.size.width, 1)];
//    [path addLineToPoint:CGPointMake(0, 1)];
    self.sinLayer.path = path.CGPath;
    [self.view.layer addSublayer:self.sinLayer];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.path = path.CGPath;
    animation.duration = 10;
    //1.2设置动画执行完毕后，不删除动画
    animation.removedOnCompletion = NO;
    animation.repeatCount = 1000;
    animation.autoreverses = NO;
    animation.calculationMode = kCAAnimationLinear;
    animation.fillMode = kCAFillModeForwards;
    [self.circleView.layer addAnimation:animation forKey:nil];
}

- (CAShapeLayer *)sinLayer {
    if (!_sinLayer) {
        _sinLayer = [CAShapeLayer layer];
        _sinLayer.strokeColor = [UIColor redColor].CGColor;
        _sinLayer.fillColor = [UIColor clearColor].CGColor;
        _sinView.frame = CGRectMake(0, 0, self.view.frame.size.height, 1);
        _sinLayer.lineWidth = 1;
//        _sinLayer. = [UIColor redColor].CGColor;
    }
    return _sinLayer;
}

- (UIView *)sinView {
    if (!_sinView) {
//        _sinView = [UIView alloc] initWithFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>);
    }
    return _sinView;
}

- (UIImageView *)redView {
    if (!_redView) {
        _redView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 200, 50, 50)];
//        _redView.backgroundColor = [UIColor redColor];
        _redView.image = [UIImage imageNamed:@"Image"];
    }
    return _redView;
}

@end
