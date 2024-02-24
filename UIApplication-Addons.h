@interface UIApplication(Addons)

- (void)showAlertWithError:(NSError *)error completion:(void (^)(void))completion;
- (void)showAlertWithError:(NSError *)error title:(NSString *)title completion:(void (^)(void))completion;
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message completion:(void (^)(void))completion;

@end
