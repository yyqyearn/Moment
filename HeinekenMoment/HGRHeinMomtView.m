//
//  HGRHeinMomtView.m
//  OSE
//
//  Created by Yongqi on 15/7/15.
//  Copyright © 2015年 MobileNow. All rights reserved.
//

#define degreesToRadians(x) (M_PI*(x)/180.0) //把角度转换成PI的方式
#define kCircleRadius 120 //圆直径
#define kCircleLineWidth 10 //弧线的宽度
#define yyqColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#import "HGRHeinMomtView.h"

@interface HGRHeinMomtView ()

@property (weak, nonatomic) IBOutlet UIView *activeView;
@property (nonatomic, strong) CAShapeLayer *contentLayer;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (nonatomic,assign)NSInteger timeInterval;

@property (nonatomic, strong) NSTimer *timer;


@end

@implementation HGRHeinMomtView

+ (instancetype)viewFromNibWithFrame:(CGRect)frame timeInterval:(NSInteger)timeInterval{
    HGRHeinMomtView * view = [[[NSBundle mainBundle]loadNibNamed:@"HGRHeinMomtView" owner:nil options:nil]firstObject];
    view.frame = frame;
    view.timeInterval = timeInterval;
    [view setupTimeCount];
    [view setupActiveView];
    return view;
}
- (void)setupTimeCount{
    self.timeLB.text = [NSString stringWithFormat:@"%li",self.timeInterval];
    self.timeLB.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
            self.timeLB.alpha = 1;
    }];
}
- (void)setupActiveView{
    
    //创建绘图层
    CAShapeLayer *contentLayer = [CAShapeLayer layer];
    contentLayer.frame = self.activeView.bounds;
    self.contentLayer = contentLayer;
    //    [self.activeView.layer addSublayer:contentLayer];
    
    //设置图层
    contentLayer.fillColor = [UIColor clearColor].CGColor;
    contentLayer.strokeColor = [UIColor greenColor].CGColor;
    contentLayer.lineCap = kCALineCapRound;
    contentLayer.lineWidth = kCircleLineWidth;
    
    //绘制渲染路径
    CGPoint center = CGPointMake(self.activeView.bounds.size.width*0.5, self.activeView.bounds.size.height*0.5);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:kCircleRadius startAngle:degreesToRadians(-85) endAngle:degreesToRadians(275) clockwise:YES];
    contentLayer.path = path.CGPath;
    
    //设置渐变色
    CALayer *colorLayer = [CALayer layer];
    //左侧渐变
    CAGradientLayer *gradientLayer1 = [CAGradientLayer layer];
    gradientLayer1.frame = CGRectMake(0, 0, self.activeView.bounds.size.width*0.5, self.activeView.bounds.size.height);
    
    NSArray *colorArray1 = [NSArray arrayWithObjects:(id)yyqColor(162, 253, 167, 1).CGColor,(id)yyqColor(32, 175, 80, 1).CGColor, nil];
    gradientLayer1.colors = colorArray1;
    gradientLayer1.locations = @[@0.2,@0.7,@1];
    gradientLayer1.startPoint = CGPointMake(0, 0);
    gradientLayer1.endPoint = CGPointMake(0, 1);
    [colorLayer addSublayer:gradientLayer1];
    
    //右侧渐变
    CAGradientLayer *gradientLayer2 = [CAGradientLayer layer];
    gradientLayer2.frame = CGRectMake(self.activeView.bounds.size.width*0.5,0,self.activeView.bounds.size.width*0.5, self.activeView.bounds.size.height);
    NSArray *colorArray2 = [NSArray arrayWithObjects:(id)yyqColor(40, 182 , 87, 1).CGColor,[colorArray1 lastObject], nil];
    gradientLayer2.colors = colorArray2;
    gradientLayer2.locations = @[@0.2,@0.7,@1];
    gradientLayer2.startPoint = CGPointMake(0, 0);
    gradientLayer2.endPoint = CGPointMake(0, 1);
    [colorLayer addSublayer:gradientLayer2];
    [colorLayer setMask:contentLayer];
    [self.activeView.layer addSublayer:colorLayer];
    [self setPercent:0 animated:NO];
}



-(void)setPercent:(NSInteger)percent animated:(BOOL)animated
{
    [CATransaction begin];
    [CATransaction setDisableActions:!animated];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [CATransaction setAnimationDuration:self.timeInterval];
    self.contentLayer.strokeEnd = percent/100.0;
    [CATransaction commit];
    
    if (animated) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimeCountWithAnimated:) userInfo:nil repeats:YES];
    }
}


#pragma mark - 点击事件
- (IBAction)btnClick:(id)sender {
    self.timeInterval = 20;
    self.activeView.alpha = 1;
    self.activeView.transform = self.timeLB.transform = CGAffineTransformIdentity;

    [self setPercent:100 animated:YES];
}
- (IBAction)stopBtnClick:(UIButton *)sender {
    [self stopShining];
}


- (void)updateTimeCountWithAnimated:(BOOL)animated{
    if (self.timeInterval==1) {
        [self.timer invalidate];
        self.timer = nil;
        [UIView animateWithDuration:0.38 animations:^{
            self.activeView.transform = self.timeLB.transform = CGAffineTransformMakeScale(1.5, 1.5);
            self.activeView.alpha = self.timeLB.alpha = 0;
        } completion:^(BOOL finished) {
            [self startShining];
        }];
        return;
    }
    
    self.timeInterval--;
    if (self.timeInterval>9) {
        [UIView animateWithDuration:0.2 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.timeLB.alpha = 0;
        } completion:^(BOOL finished) {
            self.timeLB.text = [NSString stringWithFormat:@"%li",self.timeInterval];
            [UIView animateWithDuration:0.2 animations:^{
                self.timeLB.alpha = 1;
            } completion:^(BOOL finished) {
            
            }];
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            self.timeLB.transform = CGAffineTransformMakeScale(1.5, 1.5);
            self.timeLB.alpha = 0;
        } completion:^(BOOL finished) {
            self.timeLB.text = [NSString stringWithFormat:@"%li",self.timeInterval];
            self.timeLB.transform = CGAffineTransformMakeScale(0.1, 0.1);
            
            [UIView animateWithDuration:0.15 animations:^{
                self.timeLB.transform = CGAffineTransformMakeScale(0.85, 0.85);
                self.timeLB.alpha = 1;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    self.timeLB.transform = CGAffineTransformIdentity;
                } completion:^(BOOL finished) {
                }];
                
            }];
        }];
    }
}


- (void)startShining{
    self.backgroundColor = [UIColor greenColor];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(updateShining) userInfo:nil repeats:YES];
}
- (void)updateShining{
    if ([self.backgroundColor isEqual:[UIColor greenColor]]) {
        self.backgroundColor = [UIColor blackColor];
    }else{
        self.backgroundColor = [UIColor greenColor];
    }
}
- (void)stopShining{
    [self.timer invalidate];
    self.timer = nil;
    
}


@end
