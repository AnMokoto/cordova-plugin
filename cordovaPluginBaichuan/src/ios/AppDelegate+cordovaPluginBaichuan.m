//
//  AppDelegate_cordovaPluginBaichuan.m
//  Baichuan
//
//  Created by Moo on 2019/10/19.
//
#import "AppDelegate.h"
#import "AppDelegate+cordovaPluginBaichuan.h"
#import <AlibcTradeSDK/AlibcTradeSDK.h>

@implementation AppDelegate (cordovaPluginBaichuan)

-(BOOL)application:(UIApplication *)app
           openURL:(NSURL *)url
           options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    if(@available(iOS 9.0,*)){
        __unused BOOL isHandledByALBBSDK = [[AlibcTradeSDK sharedInstance] application:app
                                                                               openURL:url
                                                                               options:options];
    }else{
    }
    return YES;

}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation{
    if(![[AlibcTradeSDK sharedInstance] application:application
                                            openURL:url
                                  sourceApplication:sourceApplication
                                         annotation:annotation]){
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:CDVPluginHandleOpenURLNotification
                                                                                             object:url]];
    }
    return YES;
}

@end
