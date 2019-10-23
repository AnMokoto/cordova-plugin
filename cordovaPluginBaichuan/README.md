### 阿里百川SDK

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
