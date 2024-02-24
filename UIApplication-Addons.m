#import "UIApplication-Addons.h"

@implementation UIApplication(Addons)

- (void)showAlertWithError:(NSError *)error completion:(void (^)(void))completion
{
	NSString *defaultTitle = NSLocalizedStringWithDefaultValue (@"errorAlertTitle", nil, [NSBundle mainBundle], @"Error", @"Title of error alert");
	NSString *title = ([error localizedFailureReason]) ? [error localizedFailureReason] : defaultTitle;

	[self showAlertWithError:error title:title completion:completion];
}

- (void)showAlertWithError:(NSError *)error title:(NSString *)title completion:(void (^)(void))completion
{
	// The displaying (top-most) controller determined recursively, so no controller needs to be passed to this method

	NSLog(@"Handling error: %@", error);

	NSDictionary *userInfo = error.userInfo;
	NSError *underlyingError = [userInfo objectForKey:NSUnderlyingErrorKey];
	if (underlyingError)
	{
		error = underlyingError;
		NSLog(@"Found underlying error: %@", error);
	}

	NSString *message = [error localizedRecoverySuggestion] ? [error localizedRecoverySuggestion] : [error localizedDescription];

	[self showAlertWithTitle:title message:message completion:completion];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message completion:(void (^)(void))completion
{
	// The displaying (top-most) controller determined recursively, so no controller needs to be passed to this method

	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
	NSString *okTitle = NSLocalizedStringWithDefaultValue (@"errorAlertOK", nil, [NSBundle mainBundle], @"Okay", @"Title of error alert button");
	UIAlertAction *okAction = [UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
	{
		[alertController dismissViewControllerAnimated:YES completion:nil];
		if (completion) completion();
	}];
	[alertController addAction:okAction];

	// Although keyWindow is deprecated since iOS 13, the only working solution in iPad's splitview <https://stackoverflow.com/questions/57679284/getting-currently-focused-uiscene-when-multiple-connected-scenes-are-active-in-f>

	UIWindow *window = UIApplication.sharedApplication.keyWindow;
	UIViewController *topViewController = [self topViewControllerWithRootViewController:window.rootViewController];
	[topViewController presentViewController:alertController animated:YES completion:nil];
}

- (UIViewController *)topViewControllerWithRootViewController:(UIViewController *)rootViewController
{
    // Walking recursively through view hierarchie to identify top-most view controller
    
	if (rootViewController == nil) return nil;
	if ([rootViewController isKindOfClass:UITabBarController.class])
	{
		return [self topViewControllerWithRootViewController:((UITabBarController *)rootViewController).selectedViewController];
	}
	else if ([rootViewController isKindOfClass:UINavigationController.class])
	{
		return [self topViewControllerWithRootViewController:((UINavigationController *)rootViewController).topViewController];
	}
	else if ((rootViewController.presentedViewController != nil) && rootViewController.presentedViewController.isBeingDismissed == FALSE)
	{
		return [self topViewControllerWithRootViewController:rootViewController.presentedViewController];
	}

	return rootViewController;
}

@end
