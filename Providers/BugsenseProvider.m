//
//  BugsenseProvider.m
//  Pods
//
//  Created by Idrish Sorathiya on 19/08/14.
//
//

#import "BugsenseProvider.h"
#import <BugSense-iOS/BugSenseController.h>

@implementation BugsenseProvider
#ifdef AR_BUGSENSE_EXISTS

- (id)initWithIdentifier:(NSString *)identifier
{
    NSAssert([BugSenseController class], @"Bugsense is not included");
    [BugSenseController sharedControllerWithBugSenseAPIKey:identifier];
    
    return [super init];
}

- (void)identifyUserWithID:(NSString *)userID andEmailAddress:(NSString *)email {
    
    //No way to pass both so, I have appended userID and email by '-'
    [BugSenseController setUserIdentifier:[userID stringByAppendingPathComponent:[NSString stringWithFormat:@"-%@",email]]];
}

- (void)didShowNewPageView:(NSString *)pageTitle {
    
    NSString *string = [NSString stringWithFormat:@"Opened %@", pageTitle];
    [BugSenseController leaveBreadcrumb:string];
}

- (void)event:(NSString *)event withProperties:(NSDictionary *)properties {
    NSString *checkpoint;
    
    if (properties) {
        checkpoint = [NSString stringWithFormat:@"%@%@", event, properties];
    } else {
        checkpoint = event;
    }
    
    //Please note that only premium account supports breadcrumbs.
    
    [BugSenseController sendCustomEventWithTag:checkpoint];
    
    [BugSenseController leaveBreadcrumb:checkpoint];
}

- (void)remoteLog:(NSString *)parsedString {
    [BugSenseController leaveBreadcrumb:parsedString];
}

#endif
@end
