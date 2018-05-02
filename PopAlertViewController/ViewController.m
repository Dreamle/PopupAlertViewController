//
//  ViewController.m
//  PopAlertViewController
//
//  Created by admin on 2018/5/2.
//  Copyright © 2018年 dreamLee. All rights reserved.
//

#import "ViewController.h"

#import "PopupViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self popView];
}

- (void)popView {
    
    PopupViewController *popVC = [PopupViewController initWithTitle:@"中华人民共和国" message:@"八万ding"];
    PopupAction *action1 = [PopupAction actionWithTitle:@"title1" style:PopupActionSelectItemTypeDefault handler:^{
        NSLog(@"+++++++ 你点了title1");
    }];
    PopupAction *action2 = [PopupAction actionWithTitle:@"title2" style:PopupActionSelectItemTypeSystem handler:nil];
    PopupAction *action3 = [PopupAction actionWithTitle:@"title3" style:PopupActionSelectItemTypeDestructive handler:nil];
    PopupAction *action4 = [PopupAction actionWithTitle:@"title4" style:PopupActionSelectItemTypeCancel handler:nil];
    
    [popVC addAction:action1];
    [popVC addAction:action2];
    [popVC addAction:action3];
    [popVC addAction:action4];
    [self presentViewController:popVC animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
