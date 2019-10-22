#import "AppDelegate.h"
#import "AppDelegate+BK.h"
#import "JDKeplerSDK.framework/Headers/KeplerApiManager.h"
#import <AlibcTradeSDK/AlibcTradeSDK.h>

@implementation AppDelegate (BK)

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    BOOL result = [[KeplerApiManager sharedKPService] handleOpenURL:url];

    if(!result){
        return [[AlibcTradeSDK sharedInstance] application:app
                                                   openURL:url
                                                   options:options];
    }

    return result;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    BOOL result = [[KeplerApiManager sharedKPService] handleOpenURL:url];

    if(!result){
        return [[AlibcTradeSDK sharedInstance] application:application
                                                   openURL:url
                                         sourceApplication:sourceApplication
                                                annotation:annotation];
    }

    return result;
}


@end
