//
//  AYAnimation.h
//  AYAnimation
//
//  Created by Alan Yeh on 16/8/1.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
 *  简单封装[UIView animation...]系列动画
 */
@interface AYAnimation : NSObject
+ (AYAnimation *(^)(void (^action)()))before; /**< 动画准备动作(创建一个新的动作) */
+ (AYAnimation *(^)(NSTimeInterval duration, void (^action)()))begin; /**< 开始动画动作(创建一个新的动作) */

@property (nonatomic, readonly) AYAnimation *(^before)(void (^action)()); /**< 添加动画准备动作 */
@property (nonatomic, readonly) AYAnimation *(^begin)(NSTimeInterval duration, void (^action)()); /**< 添加开始动作 */
@property (nonatomic, readonly) AYAnimation *(^delay)(NSTimeInterval delay); /**< 添加等待时间 */
@property (nonatomic, readonly) AYAnimation *(^then)(NSTimeInterval duration, void (^action)()); /**< 添加继续动作 */
@property (nonatomic, readonly) AYAnimation *(^final)(void (^action)()); /**< 动画完成后执行的动作 */

- (void)action;/**< 开始执行动画 */
@end
NS_ASSUME_NONNULL_END