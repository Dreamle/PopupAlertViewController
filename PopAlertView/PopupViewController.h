//
//  HCBottomPopupViewController.h
//  Test2
//
//  Created by hehaichi on 2017/12/15.
//  Copyright © 2017年 hehaichi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasePopupViewController.h"
#import "PopupAction.h"

@interface PopupViewController : BasePopupViewController

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message;
+ (instancetype)initWithTitle:(NSString *)title message:(NSString *)message;

- (void)addAction:(PopupAction *)action;
@end
