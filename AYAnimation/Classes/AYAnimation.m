//
//  AYAnimation.m
//  AYAnimation
//
//  Created by Alan Yeh on 16/8/1.
//
//

#import "AYAnimation.h"

@interface AYAnimateAction : NSObject
@property (nonatomic, copy) void (^action)();
@property (nonatomic, assign) NSTimeInterval duration;
@end

@interface AYAnimation ()
@property (nonatomic, copy) void(^beforeAction)();
@property (nonatomic, copy) void(^finalAction)();
@property (nonatomic, strong, readonly) NSMutableArray<AYAnimateAction *> *actions;

@end

@implementation AYAnimation

- (NSMutableSet<AYAnimation*> *)holder{
    static NSMutableSet<AYAnimation*> *holder;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        holder = [NSMutableSet new];
    });
    return holder;
}

- (instancetype)init{
    if (self = [super init]) {
        _actions = [NSMutableArray new];
    }
    return self;
}

+ (AYAnimation *(^)(void (^)()))before{
    return ^(void(^action)()){
        AYAnimation *animation = [AYAnimation new];
        animation.beforeAction = action;
        return animation;
    };
}

+ (AYAnimation *(^)(NSTimeInterval, void (^)()))begin{
    return ^(NSTimeInterval duration, void(^action)()){
        AYAnimateAction *animateAction = [AYAnimateAction new];
        animateAction.action = action;
        animateAction.duration = duration;
        
        AYAnimation *animation = [AYAnimation new];
        [animation.actions addObject:animateAction];
        return animation;
    };
}

- (AYAnimation *(^)(void (^)()))before{
    return ^(void(^action)()){
        self.beforeAction = action;
        return self;
    };
}

- (AYAnimation *(^)(NSTimeInterval, void (^)()))begin{
    return ^(NSTimeInterval duration, void(^action)()){
        AYAnimateAction *animateAction = [AYAnimateAction new];
        animateAction.action = action;
        animateAction.duration = duration;
        
        [self.actions addObject:animateAction];
        return self;
    };
}

- (AYAnimation *(^)(NSTimeInterval))delay{
    return ^(NSTimeInterval delay){
        AYAnimateAction *animateAction = [AYAnimateAction new];
        animateAction.action = nil;
        animateAction.duration = delay;
        [_actions addObject:animateAction];
        return self;
    };
}

- (AYAnimation *(^)(NSTimeInterval, void (^)()))then{
    return ^(NSTimeInterval duration, void(^action)()){
        AYAnimateAction *animateAction = [AYAnimateAction new];
        animateAction.action = action;
        animateAction.duration = duration;
        [_actions addObject:animateAction];
        return self;
    };
}

- (AYAnimation *(^)(void (^)()))final{
    return ^(void(^action)()){
        self.finalAction = action;
        return self;
    };
}

- (void)action{
    if (self.beforeAction) {
        self.beforeAction();
    }
    [self.holder addObject:self];
    [self actWithActions:_actions];
}

- (void)actWithActions:(NSMutableArray<AYAnimateAction *> *)actions{
    AYAnimateAction *action = [actions objectAtIndex:0];
    [actions removeObject:action];
    
    if (!action) {
        if (self.finalAction) {
            self.finalAction();
        }
        [self.holder removeObject:self];
        return;
    }
    
    if (action.action) {
        [UIView animateWithDuration:action.duration
                         animations:^{
                             action.action();
                         } completion:^(BOOL finished) {
                             [self actWithActions:actions];
                         }];
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(action.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self actWithActions:actions];
        });
    }
    
}
@end

@implementation AYAnimateAction

@end