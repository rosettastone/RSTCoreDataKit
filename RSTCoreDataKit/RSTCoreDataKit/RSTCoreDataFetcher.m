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

#import "RSTCoreDataFetcher.h"

@implementation RSTCoreDataFetcher

+ (NSManagedObject *)objectForObjectID:(NSManagedObjectID *)objectID
                             inContext:(NSManagedObjectContext *)managedObjectContext
{
    NSParameterAssert(objectID != nil);
    NSParameterAssert(managedObjectContext != nil);
    
    NSManagedObject *object = [managedObjectContext objectWithID:objectID];
    if (![object isFault]) {
        return object;
    }

    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = objectID.entity;
    request.predicate = [NSPredicate predicateWithFormat:@"SELF = %@", object];
    
    NSError *error = nil;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    if (results == nil) {
        NSLog(@"*** %s Error: %@", __PRETTY_FUNCTION__, error);
    }

    return results.firstObject;
}

@end
