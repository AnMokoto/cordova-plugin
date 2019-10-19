//
//  cordovaPluginBaichuan.h
//  Baichuan
//
//  Created by Moo on 2019/10/19.
//

#import <Cordova/CDV.h>

@interface cordovaPluginBaichuan : CDVPlugin
// Member variables go here.

- (void)pluginInitialize;
/** 登录 */
- (void)Login:(CDVInvokedUrlCommand*)command;
/** 注销 */
- (void)Logout:(CDVInvokedUrlCommand*)command;
/** 获取用户信息 */
- (void)Session:(CDVInvokedUrlCommand*)command;


@end
