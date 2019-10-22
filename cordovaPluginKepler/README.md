### 京东开普勒SDK

#### Auth

```javascript
    // 登录
    Kepler.Login(v => {
      // 授权成功
    }, le => {
     // 授权失败
    })
    
    // 注销
    Kepler.Logout(_ => {
      // 注销成功
    })

    // 检测是否登录
    Kepler.IsLogin(v => {
        // 已登录
    }, e => {
      // 未登录
    })

        
```
