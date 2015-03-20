//
//  AppDelegate.m
//  Calendar
//
//  Created by Divyahans Gupta on 1/21/15.
//  Copyright (c) 2015 divyahansg. All rights reserved.
//

#import "AppDelegate.h"

#import "MSCalendarViewController.h"
#import "AnnounceViewController.h"
#import "FAQViewController.h"
#import "ReportViewController.h"
#import "MapViewController.h"

#import "MSEvent.h"
#import "ColorScheme.h"
#import <Parse/Parse.h>


@interface AppDelegate ()

@property (strong, nonatomic)UITabBarController * tabBarController;

@property (strong, nonatomic) MSCalendarViewController *calendarViewController;

@property (strong, nonatomic) AnnounceViewController *annouceViewController;

@property (strong, nonatomic) FAQViewController *faqViewController;

@property (strong, nonatomic) ReportViewController *reportViewController;

@property (strong, nonatomic) MapViewController *mapViewController;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [Parse enableLocalDatastore];
        
    [Parse setApplicationId:@"" clientKey:@""];
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
    
    /*
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    */
    
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [ColorScheme redColor]} forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"AvenirNext-DemiBold" size:10.0f], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    

    self.calendarViewController = [[MSCalendarViewController alloc] init];
    self.calendarViewController.title = @"Schedule";
    
    
    self.annouceViewController = [[AnnounceViewController alloc] init];
    self.annouceViewController.title = @"Notifications";

    
    self.faqViewController = [[FAQViewController alloc] init];
    self.faqViewController.title = @"FAQ";

    self.mapViewController = [[MapViewController alloc] init];
    self.mapViewController.title = @"Maps";
    
    self.reportViewController = [[ReportViewController alloc] init];
    self.reportViewController.title = @"Report";
    
    
    self.tabBarController = [[UITabBarController alloc] init];
    UINavigationController* nav1 = [[UINavigationController alloc]
                                             initWithRootViewController:self.calendarViewController];
    UINavigationController* nav2 = [[UINavigationController alloc]
                                    initWithRootViewController:self.annouceViewController];
    UINavigationController* nav3 = [[UINavigationController alloc]
                                    initWithRootViewController:self.faqViewController];
    
    UINavigationController* nav4 = [[UINavigationController alloc]
                                    initWithRootViewController:self.mapViewController];
    
    UINavigationController* nav5 = [[UINavigationController alloc]
                                    initWithRootViewController:self.reportViewController];
    
    NSArray* controllers = [NSArray arrayWithObjects:nav1, nav2, nav3, nav4, nav5, nil];
    self.tabBarController.viewControllers = controllers;
    
    
    UIImage *schedule_selectedImage = [UIImage imageNamed:@"tabbar-schedule-active"];
    UIImage *schedule_unselectedImage = [UIImage imageNamed:@"tabbar-schedule"];
    UITabBarItem *item0 = [self.tabBarController.tabBar.items objectAtIndex:0];
    [item0 setFinishedSelectedImage:schedule_selectedImage withFinishedUnselectedImage:schedule_unselectedImage];
    
    
    UIImage *notif_selectedImage = [UIImage imageNamed:@"tabbar-hacks-active"];
    UIImage *notif_unselectedImage = [UIImage imageNamed:@"tabbar-hacks"];
    UITabBarItem *item1 = [self.tabBarController.tabBar.items objectAtIndex:1];
    [item1 setFinishedSelectedImage:notif_selectedImage withFinishedUnselectedImage:notif_unselectedImage];
    
    UIImage *faq_selectedImage = [UIImage imageNamed:@"tabbar-faq-active"];
    UIImage *faq_unselectedImage = [UIImage imageNamed:@"tabbar-faq"];
    UITabBarItem *item2 = [self.tabBarController.tabBar.items objectAtIndex:2];
    [item2 setFinishedSelectedImage:faq_selectedImage withFinishedUnselectedImage:faq_unselectedImage];

    
    UIImage *map_selectedImage = [UIImage imageNamed:@"tabbar-map-active"];
    UIImage *map_unselectedImage = [UIImage imageNamed:@"tabbar-map"];
    UITabBarItem *item3 = [self.tabBarController.tabBar.items objectAtIndex:3];
    [item3 setFinishedSelectedImage:map_selectedImage withFinishedUnselectedImage:map_unselectedImage];
    
    UIImage *report_selectedImage = [UIImage imageNamed:@"tabbar-report-active"];
    UIImage *report_unselectedImage = [UIImage imageNamed:@"tabbar-report"];
    UITabBarItem *item4 = [self.tabBarController.tabBar.items objectAtIndex:4];
    [item4 setFinishedSelectedImage:report_selectedImage withFinishedUnselectedImage:report_unselectedImage];
    

    NSDictionary *notificationPayload = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    if(notificationPayload != nil) {
        self.tabBarController.selectedIndex = 1;
    }
    
    NSInteger i = [[UIApplication sharedApplication] applicationIconBadgeNumber];
    NSString *badgeString = [NSString stringWithFormat:@"%ld", (long)i];
    if(i == 0) {
        [[self.tabBarController.tabBar.items objectAtIndex:1] setBadgeValue:nil];
    } else {
        [[self.tabBarController.tabBar.items objectAtIndex:1] setBadgeValue:badgeString];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.tabBarController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[ @"global" ];
    currentInstallation.badge = 0;
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {

    NSString *badgeString = [[self.tabBarController.tabBar.items objectAtIndex:1] badgeValue];
    NSInteger i;
    if(badgeString != nil) {
        i = [badgeString integerValue];
    } else {
        i = 0;
    }
    i += 1;
    badgeString = [NSString stringWithFormat:@"%ld", (long)i];
    [[self.tabBarController.tabBar.items objectAtIndex:1] setBadgeValue:badgeString];

    if (application.applicationState != UIApplicationStateActive) {
        self.tabBarController.selectedIndex = 1;
        [self.annouceViewController refresh:nil];
    } else {
        [PFPush handlePush:userInfo];        
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
