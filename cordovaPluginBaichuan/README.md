### 阿里百川SDK

#### 插件配置

* android
    放置安全图片到 `drawable` 文件夹内
* ios
    1. 放置安全图片到 项目目录内
    2. 编译增加 `-lstdc++`

#### Auth

```javascript
    // 登录
    BC.Login(v => {
      // 授权成功
    }, le => {
     // 授权失败
    })
    
    // 注销
    BC.Logout(_ => {
      // 注销成功
    })

    // 检测是否登录
    BC.IsLogin(v => {
        // 已登录
    }, e => {
      // 未登录
    })

        
```
