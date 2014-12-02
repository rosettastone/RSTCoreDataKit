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
    if (!objectID) {
        return nil;
    }
    
    NSManagedObject *object = [managedObjectContext objectWithID:objectID];
    if (![object isFault]) {
        return object;
    }
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[objectID entity]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF = %@", object];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    if ([results count] > 0 ) {
        return [results objectAtIndex:0];
    }
    
    return nil;
}

@end
