//
//  Rosetta Stone
//  http://product.rosettastone.com/news/
//
//
//  Documentation
//  http://cocoadocs.org/docsets/RSTCoreDataKit
//
//
//  GitHub
//  https://github.com/rosettastone/RSTCoreDataKit
//
//
//  License
//  Copyright (c) 2014 Rosetta Stone
//  Released under a BSD license: http://opensource.org/licenses/BSD-3-Clause
//

#import "RSTCoreDataContextSaver.h"

@implementation RSTCoreDataContextSaver

+ (BOOL)saveAndWait:(NSManagedObjectContext *)context
{
    if (context == nil) {
        NSLog(@"*** %s Error: managed object context is nil", __PRETTY_FUNCTION__);
        return NO;
    }
    
    if (![context hasChanges]) {
        return YES;
    }

    __block BOOL success = NO;

    [context performBlockAndWait:^{
        NSError *error = nil;
        success = [context save:&error];

        if (!success) {
            NSLog(@"*** %s Error saving managed object context: %@", __PRETTY_FUNCTION__, error);
        }
    }];

    return success;
}

+ (void)save:(NSManagedObjectContext *)context
{
    if (context == nil) {
        NSLog(@"*** %s Error: managed object context is nil", __PRETTY_FUNCTION__);
        return;
    }
    
    if (![context hasChanges]) {
        return;
    }
    
    [context performBlock:^{
        NSError *error = nil;
        BOOL success = [context save:&error];

        if (!success) {
            NSLog(@"*** %s Error saving managed object context: %@", __PRETTY_FUNCTION__, error);
        }
    }];
}

@end
