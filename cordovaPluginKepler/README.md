### [京东开普勒SDK](./cordovaPluginKepler/README.md) [![npm](https://img.shields.io/npm/v/cordova-plugin-kepler.svg)](https://www.npmjs.com/package/cordova-plugin-kepler) 

`cordova plugin cordova-plugin-kepler --variable KEPLER_APPKEY=APPKEY --variable KEPLER_APPSECRET=APPSECRET`

#### 插件配置

* android
    放置安全图片到 `raw` 文件夹内
* ios
    放置安全图片到 `Kepler.bundle`

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
