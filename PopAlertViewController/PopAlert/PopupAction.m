//
//  HCBottomPopupAction.m
//  Test2
//
//  Created by hehaichi on 2017/12/15.
//  Copyright © 2017年 hehaichi. All rights reserved.
//

#import "PopupAction.h"

@interface PopupAction()
@end

@implementation PopupAction


+ (instancetype)actionWithTitle:(NSString *)title style:(PopupActionSelectItemType)style handler:(PopupActionSelectItemBlock)selectBlock {
    
    PopupAction * action =  [PopupAction new];
    action.type = style;
    action.selectBlock = selectBlock;
    action.title = title;
    return action;
}
@end
