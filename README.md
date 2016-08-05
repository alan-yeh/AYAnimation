# AYAnimation

[![CI Status](http://img.shields.io/travis/alan-yeh/AYAnimation.svg?style=flat)](https://travis-ci.org/alan-yeh/AYAnimation)
[![Version](https://img.shields.io/cocoapods/v/AYAnimation.svg?style=flat)](http://cocoapods.org/pods/AYAnimation)
[![License](https://img.shields.io/cocoapods/l/AYAnimation.svg?style=flat)](http://cocoapods.org/pods/AYAnimation)
[![Platform](https://img.shields.io/cocoapods/p/AYAnimation.svg?style=flat)](http://cocoapods.org/pods/AYAnimation)

## 引用
　　使用[CocoaPods](http://cocoapods.org)可以很方便地引入AYAnimation。Podfile添加AYAnimation的依赖。

```ruby
pod "AYAnimation"
```

## 使用
简单封装UIView和CALayout的动画，方便编写简单动画。before、begin、delay、then、final实质上没有次续之分，可以任意组合，但是最好使用符合语义的顺序，以方便维护。

```objective-c
    [AYAnimation.before(^{
        //准备动作
        //将testView放在屏幕底部外侧（不可见区域）
        [PSLayoutV(self.testView).withSize(20, 20).toParentBottom.alignParentCenterWidth apply];
    }).begin(2, ^{
        //开始第一个动画，动画持续2秒
        //将testView移动到离底部20像素的位置
        [PSLayoutV(self.testView).alignParentBottom.distance(20) apply];
    }).delay(1)//暂停1秒
     .then(3, ^{
        //开始第二个动画，动画持续3秒
        //将testView移动到居中偏右50像素的位置
        [PSLayoutV(self.testView).alignParentCenterWidth.distance(50) apply];
    }).then(0.5, ^{
        //开始第三个动画，动画持续0.5秒
        //将testView的背景颜色改成purple
        self.testView.backgroundColor = [UIColor purpleColor];
    }).final(^{
        //动画完成后执行
        NSLog(@"动画完成了", nil);
    }) action/*开始动画*/];
```

## License

AYAnimation is available under the MIT license. See the LICENSE file for more info.
