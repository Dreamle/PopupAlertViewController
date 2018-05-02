//
//  HCBottomPopupAction.h
//  Test2
//
//  Created by hehaichi on 2017/12/15.
//  Copyright © 2017年 hehaichi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PopupActionSelectItemType) {
     PopupActionSelectItemTypeDefault = 1,
     PopupActionSelectItemTypeCancel = 2,
     PopupActionSelectItemTypeDestructive = 3, //红色字体
     PopupActionSelectItemTypeSystem = 4, //系统蓝
   
};
typedef void(^PopupActionSelectItemBlock)(void);

@interface PopupAction : NSObject

@property(nonatomic,strong) NSString * title;
@property(nonatomic,assign) PopupActionSelectItemType type;
@property(nonatomic,copy)   PopupActionSelectItemBlock selectBlock;

+ (instancetype)actionWithTitle:(NSString *)title style:(PopupActionSelectItemType)style handler:(PopupActionSelectItemBlock)selectBlock;

@end
