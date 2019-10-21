#import "AppDelegate.h"
#import "AppDelegate_cordovaPluginKepler.h"
#import "JDKeplerSDK.framework/Headers/KeplerApiManager.h"
@implementation AppDelegate (cordovaPluginKepler)

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [[KeplerApiManager sharedKPService] handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    return [[KeplerApiManager sharedKPService] handleOpenURL:url];
}
@end
