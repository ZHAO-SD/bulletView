//
//  ViewController.m
//  Bullet
//
//  Created by xialan on 2019/6/13.
//  Copyright © 2019 xialan. All rights reserved.
//

#import "ViewController.h"
#import "BulletManager.h"
#import "BulletView.h"

@interface ViewController ()

@property (nonatomic, strong) BulletManager *manager;
    
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _manager = [BulletManager bulletManagerInView:self.view dataSource:@[@"1111",@"222222222",@"444444444",@"5555555555555555"]];
    
    UIButton *confirmButton = [[UIButton alloc] init];
    confirmButton.frame = CGRectMake(100, 100, 60, 40);
    [confirmButton setTitle:@"开始" forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [confirmButton addTarget:self action:@selector(confirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:confirmButton];
    
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(250, 100, 60, 40);
    [button setTitle:@"停止" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    
}

-(void)confirmButtonClick{
        
        [self.manager start];
        
}
    
-(void)buttonClick{
        
        [self.manager stop];
        
}

    
@end
