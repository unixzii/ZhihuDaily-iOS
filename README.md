# ZhihuDaily-iOS
A minimal Zhihu daily app for iOS without any 3rd-party frameworks.

## Features
* Splash screen updating
* Image disk cache and cache cleaner
* UI Night mode
* Built-in full-featured WebView

## Screenshots

## Project Structure
* Extensions (系统类扩展)
* Services (应用依赖的全局服务、例如缓存、主题管理等)
* Operations (一些 `NSOperation` 子类，实现了一些粒度较小的异步操作)
* Models (数据模型)
* Data Sources (数据源，用于将数据模型映射到视图，减少 VC 负荷)
* Views (一些视图类)
* View Controllers (视图控制器)
* Supporting Files (应用依赖的支持文件)

## Build
本项目无任何依赖库。
```
git clone https://github.com/unixzii/ZhihuDaily-iOS.git
cd ./ZhihuDaily-iOS
open ./ZhihuDaily.xcodeproj
```
在 Xcode 中直接编译调试即可。

## Author
**Cyandev**, an UC student majored in Software Engineering.
* Weibo: [@unixzii](http://weibo.com/2834711045/profile?topnav=1&wvr=6&is_all=1)
* Email: <unixzii@gmail.com>, <unixzii@163.com> (alternative)

## License
ZhihuDaily-iOS is available under the MIT license. See the LICENSE file for more info.
