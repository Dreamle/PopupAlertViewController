//
//  HCBottomPopupViewController.m
//  Test2
//
//  Created by hehaichi on 2017/12/15.
//  Copyright © 2017年 hehaichi. All rights reserved.
//


#import "PopupViewController.h"
#import "PopupCommon.h"

#define PopupSelectItemHeight 50

@interface PopViewSelectedItemView:UIButton
@property(nonatomic,strong) UIView * bottomLine;
@property(nonatomic,strong) NSString * title;
@property(nonatomic,copy)   dispatch_block_t clickBlock;
@property(nonatomic,assign) PopupActionSelectItemType type;

@end


@implementation PopViewSelectedItemView

- (instancetype)initWithFrame:(CGRect)frame withType:(PopupActionSelectItemType)type  bottomLineIsHiddern:(BOOL)hidden {
    if(self = [super initWithFrame:frame]){
        _type = type;
        
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.backgroundColor = [UIColor whiteColor];
        [self addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        self.bottomLine.hidden = hidden;
    }
    
    return self;
}
- (void)setTitle:(NSString *)title{
    _title = title;
    [self setTitle:_title forState:UIControlStateNormal];
    
    switch (self.type) {
        case PopupActionSelectItemTypeDestructive:
            {
             [self setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
            break;
        case PopupActionSelectItemTypeSystem:
        {
            [self setTitleColor:CWIPColorFromHex(0x1E90FF) forState:UIControlStateNormal];
        }
            break;

        default:
             [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            break;
    }
   
}

- (UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc]init];
        _bottomLine.frame = CGRectMake(0, CGRectGetHeight(self.frame)-1, CGRectGetWidth(self.frame), 1);
        _bottomLine.backgroundColor = [UIColor blackColor];
        _bottomLine.alpha = 0.1;
        [self addSubview:_bottomLine];
    }
    return _bottomLine;
}

- (void)action:(UIButton *)sender{
    if (self.clickBlock) {
        self.clickBlock();
    }
}
@end







@interface PopupViewController ()
<UIViewControllerTransitioningDelegate,
UIViewControllerAnimatedTransitioning,
BasePopupViewControllerDelegate>
{
    PopupAnimatingType animatingType;
}
@property(nonatomic,strong) NSMutableArray <PopupAction *>* actionArray;
@property(nonatomic,assign) BOOL isContainCancel;

@property (nonatomic, strong) NSString *popTitle;
@property (nonatomic, strong) NSString *popMessage;
@end

@implementation PopupViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _actionArray = @[].mutableCopy;
        self.popupViewCornerRadius = 0;
        self.tapMaskDissmiss = YES;
        self.popupDelegate = self;
   
    }
    return self;
}

+ (instancetype)initWithTitle:(NSString *)title message:(NSString *)message {
    return [[self alloc] initWithTitle:title message:message];
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message {
    if (self = [self init]) {
        _popTitle = title;
        _popMessage = message;
    }
    return self;
}

- (void)viewDidLoad {

    CGFloat height =  self.actionArray.count * PopupSelectItemHeight;
    if (self.isContainCancel) {
        height += 20;
    }
    [self setupPopViewSizeWithHeight:height];
    
    [super viewDidLoad];
}




#pragma mark - public method
- (void)addAction:(PopupAction *)action{
    
    if (![self.actionArray containsObject:action]) {
        
        //如果已经有了取消，则再次添加无效
        if (self.isContainCancel == YES && action.type == PopupActionSelectItemTypeCancel) {
            return;
        }
        if (action.type == PopupActionSelectItemTypeCancel && self.isContainCancel == NO) {
            self.isContainCancel = YES;
        }
        [self.actionArray addObject:action];
    }
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return self.animatedTimeInterval>0?self.animatedTimeInterval:0.4;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    if (animatingType == PopupAnimatingTypePresent) {
        UIView *popedView = [toVC.view viewWithTag:1000];
        [containerView addSubview:toVC.view];
        popedView.alpha = 0;
        CGRect frame = popedView.frame;
        frame.origin = CGPointMake(0, CGRectGetHeight(self.view.frame));
        popedView.frame = frame;
        
        NSTimeInterval duration = 0.4;
        [UIView animateWithDuration:duration / 2.0 animations:^{
            popedView.alpha = 1.0;
        }];
        
        [UIView animateWithDuration:duration / 2.0 animations:^{
            popedView.transform = CGAffineTransformMakeTranslation(0, -CGRectGetHeight(popedView.frame));
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
        
    } else {
        UIView *popedView = [fromVC.view viewWithTag:1000];
        NSTimeInterval duration = 0.25;

        [UIView animateWithDuration:duration animations:^{
            popedView.transform = CGAffineTransformMakeTranslation(0,CGRectGetHeight(popedView.frame));
            popedView.alpha = 0;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
}

#pragma mark - UIViewControllerTransitioningDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    animatingType = PopupAnimatingTypePresent;
    return self;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    animatingType = PopupAnimatingTypeDismiss;
    return self;
}


- (CGFloat)setPopTitle:(NSString *)popTitle message:(NSString *)popMessage inView:(UIView *)popupView {
    
    UILabel *titleLab = nil;
    CGFloat currentTop = 0;
    if (popTitle.length <= 0 && popMessage.length <= 0) {
        return currentTop;
    }
    
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(popupView.frame), currentTop)];
    topView.backgroundColor = [UIColor whiteColor];
    [popupView addSubview:topView];
    
    NSString *titleStr = self.popTitle;
    BOOL isHaveMessage = NO;
    //只有message
    if (self.popTitle.length<= 0 && self.popMessage.length) {
        titleStr = self.popMessage;
    } else if(self.popTitle.length > 0 && self.popMessage.length <= 0) {
        titleStr = self.popTitle;
    } else {
        isHaveMessage = YES;
    }
    
    
    titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 18, CGRectGetWidth(popupView.frame) - 15 *2, 15)];
    titleLab.attributedText = [self getAttributedWithString:titleStr WithLineSpace:2 font:[UIFont systemFontOfSize:14]];
    titleLab.numberOfLines = 0;
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = CWIPColorFromHex(0x535353);
    titleLab.backgroundColor = [UIColor whiteColor];
    [topView addSubview:titleLab];
    
    CGSize size = [titleLab sizeThatFits:titleLab.frame.size];
    CGRect titleLabRect = titleLab.frame;
    titleLabRect.size.height = size.height;
    titleLab.frame = titleLabRect;
    
    currentTop = 18 + size.height;

    UILabel *messageLab = nil;
    if (isHaveMessage) {
        messageLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(titleLab.frame), currentTop + 5, CGRectGetWidth(titleLab.frame), 15)];
        messageLab.attributedText = [self getAttributedWithString:self.popMessage WithLineSpace:2 font:[UIFont systemFontOfSize:12]];
        messageLab.numberOfLines = 0;
        messageLab.textColor = CWIPColorFromHex(0x2A2A2A);
        messageLab.textAlignment = NSTextAlignmentCenter;
        [topView addSubview:messageLab];
        
        CGSize size = [messageLab sizeThatFits:messageLab.frame.size];
        CGRect messageLabRect = messageLab.frame;
        messageLabRect.size.height = size.height;
        messageLab.frame = messageLabRect;
        currentTop = currentTop + size.height;
    }
    
    currentTop = currentTop + 18;
    topView.frame = CGRectMake(0, 0, CGRectGetWidth(popupView.frame), currentTop);
    
    UIView *bottomLine = [UIView new];
    bottomLine.frame = CGRectMake(0, CGRectGetHeight(topView.frame)-1, CGRectGetWidth(topView.frame), 1);
    bottomLine.backgroundColor = [UIColor blackColor];
    bottomLine.alpha = 0.1;
    [topView addSubview:bottomLine];
    
    
    return currentTop;
}


#pragma mark - BasePopupViewControllerDelegate
- (void)PopViewController:(UIViewController *)controller setupSubViewWithPopupView:(UIView *)popupView{

    popupView.backgroundColor = [UIColor clearColor];
    
    //0.设置title和message
    CGFloat currentTop = [self setPopTitle:self.popTitle message:self.popMessage inView:popupView];
    
    
    //1.取出cancelAction的位置
     __block  NSInteger index = 0;
    [self.actionArray enumerateObjectsUsingBlock:^(PopupAction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.type == PopupActionSelectItemTypeCancel) {
            index = idx;
            *stop = YES;
        }
    }];
    
    //2.将cancelAction移动到最后一个位置
    if (self.isContainCancel) {
        PopupAction *cancelAction = [self.actionArray objectAtIndex:index];
        [self.actionArray removeObjectAtIndex:index];
        [self.actionArray addObject:cancelAction];
    }
    
    
    for (int i = 0; i < self.actionArray.count; i++) {
        spweakify(self);
        PopupAction * action = self.actionArray[i];
        PopViewSelectedItemView * sv;
        if (action.type ==  PopupActionSelectItemTypeCancel) {
           sv = [[PopViewSelectedItemView alloc]initWithFrame:CGRectMake(0, currentTop + i*PopupSelectItemHeight+10, CGRectGetWidth(popupView.frame), PopupSelectItemHeight) withType:action.type bottomLineIsHiddern:YES];
            
            sv.clickBlock = ^{
                spstrongify(self);
                if (action.selectBlock) {
                    action.selectBlock();
                }
                [self dismiss];
            };
        }else{
            
            
            BOOL ishidderBottomLine = NO;
            if (self.isContainCancel) {
                ishidderBottomLine = (i == self.actionArray.count - 2);
            } else {
                ishidderBottomLine = (i == self.actionArray.count - 1);
            }
            
            sv = [[PopViewSelectedItemView alloc]initWithFrame:CGRectMake(0, currentTop + i*PopupSelectItemHeight, CGRectGetWidth(popupView.frame), PopupSelectItemHeight) withType:action.type bottomLineIsHiddern:ishidderBottomLine];
            sv.clickBlock = ^{
                spstrongify(self);
                [self dismiss];
                if (action.selectBlock) {
                    action.selectBlock();
                }
            };
        }
        [popupView addSubview:sv];
        sv.title = action.title;
        
       
        self.popupViewSize = CGSizeMake(CGRectGetWidth(self.view.frame),currentTop + self.actionArray.count * PopupSelectItemHeight + 20);
    }
}

- (NSMutableAttributedString *)getAttributedWithString:(NSString *)string WithLineSpace:(CGFloat)lineSpace font:(UIFont *)font {
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    //调整行间距
    paragraphStyle.lineSpacing = lineSpace;
    NSDictionary *attriDict = @{NSParagraphStyleAttributeName:paragraphStyle,
                                NSFontAttributeName:font};
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:string attributes:attriDict];
    return attributedString;
}

#pragma mark -  private method
- (void)setupPopViewSizeWithHeight:(CGFloat)height {
    self.popupViewSize = CGSizeMake(CGRectGetWidth(self.view.frame),height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
