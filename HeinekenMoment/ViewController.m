//
//  ViewController.m
//  HeinekenMoment
//
//  Created by yyq on 15/7/15.
//  Copyright © 2015年 mobilenow. All rights reserved.
//

#import "ViewController.h"
#import "HGRHeinMomtView.h"
@interface ViewController ()
@property (nonatomic, strong) HGRHeinMomtView *heinMomtView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addHMV];
}

- (void)addHMV{
    HGRHeinMomtView *view = [HGRHeinMomtView viewFromNibWithFrame:self.view.bounds timeInterval:20];
    self.heinMomtView = view;
    [self.view addSubview:view];
}
- (IBAction)btnClick:(id)sender {
//    [self.heinMomtView setPercent:30 animated:YES];
}

@end
