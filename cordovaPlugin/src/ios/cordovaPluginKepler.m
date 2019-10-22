/********* cordovaPluginBaichuan.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import "JDKeplerSDK.framework/Headers/KeplerApiManager.h"
#import <Toast/UIView+Toast.h>

typedef void (^Callback)(void);

@interface cordovaPluginKepler : CDVPlugin
    // Member variables go here.
@property (atomic,assign) BOOL isInitial;
- (void)keplerLogin:(CDVInvokedUrlCommand*)command;
- (void)keplerLogout:(CDVInvokedUrlCommand*)command;
- (void)keplerIsLogin:(CDVInvokedUrlCommand*)command;
@end


@implementation cordovaPluginKepler
#pragma mark "API"
- (void)pluginInitialize{
    NSString *APPKEY = [[self.commandDelegate settings] objectForKey:@"kepler_appkey"];
    NSString *APPSECRET = [[self.commandDelegate settings] objectForKey:@"kepler_appsecret"];
    [[KeplerApiManager sharedKPService] asyncInitSdk:APPKEY
                                           secretKey:APPSECRET
                                      sucessCallback:^{
                                      [self setIsInitial:YES];
                                          NSLog(@"Kepler init success");
                                      }
                                      failedCallback:^(NSError *error) {
                                      [self setIsInitial:NO];
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                  [self.viewController.view makeToast:[[NSString alloc] initWithFormat:@"京东开普勒初始化失败%ld",error.code]
                                                                             duration:2.0
                                                                             position:CSToastPositionCenter];
                                              });
                                          NSLog(@"Kepler init failed 京东开普勒初始化失败--> %@",error);
                                      }];
}

- (void)keplerLogin:(CDVInvokedUrlCommand*)command
{

    [self IsLogin:^{
        // 已登录
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
    } failure:^{
        // 未登录
        [[KeplerApiManager sharedKPService]
         keplerLoginWithViewController:self.viewController
         success:^{
             // 登录成功
             [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
         } failure:^(NSError* error){
             // 登录失败
             [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error.description] callbackId:command.callbackId];
         }];
    }];
    [self.commandDelegate sendPluginResult:nil callbackId:command.callbackId];
}

- (void)keplerLogout:(CDVInvokedUrlCommand*)command
{
    [[KeplerApiManager sharedKPService] cancelAuth ];
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
}

- (void)keplerIsLogin:(CDVInvokedUrlCommand*)command
{
    [self IsLogin:^{
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
    } failure:^{

        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
    }];
}

- (void)IsLogin:(Callback)call failure:(Callback)fail
{
    [[KeplerApiManager sharedKPService] keplerLoginWithSuccess:call failure:fail];
}

@end
