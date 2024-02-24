# Summary
A small category of UIApplication in Objective C to present alerts to the user from every class of an iOS / iPadOS application.
The presenting view controller is (recursively) determined, so no view controller needs to be specified to present an alert. Therefore it can be used even from background classes like storage providers, app store singletons etc.
Different invocations supported, passing (1.) only an NSError object, (2.) an NSError object and a specific title, or (3.) individual title and message.
# Usage:
```
#import "UIApplication-Addons.h"

[UIApplication.sharedApplication showAlertWithTitle:@"Title" message:@"Message" completion:^
{
  NSLog(@"Completed");
}];

[UIApplication.sharedApplication showAlertWithError:error completion:nil];
```
