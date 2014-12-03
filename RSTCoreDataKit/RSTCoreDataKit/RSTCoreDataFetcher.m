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

#pragma mark - Init

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSParameterAssert(managedObjectContext != nil);

    self = [super init];
    if (self) {
        _managedObjectContext = managedObjectContext;
    }
    return self;
}

#pragma mark - NSObject

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: managedObjectContext=%@>", [self class], self.managedObjectContext];
}

#pragma mark - Fetching

- (NSManagedObject *)objectForObjectID:(NSManagedObjectID *)objectID
{
    NSParameterAssert(objectID != nil);
    
    NSManagedObject *object = [self.managedObjectContext objectWithID:objectID];
    if (![object isFault]) {
        return object;
    }

    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = objectID.entity;
    request.predicate = [NSPredicate predicateWithFormat:@"SELF = %@", object];
    
    NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (results == nil) {
        NSLog(@"*** %s Error: %@", __PRETTY_FUNCTION__, error);
    }

    return results.firstObject;
}

- (id)firstObjectFromExecutingFetchRequest:(NSFetchRequest *)fetchRequest
{
    NSParameterAssert(fetchRequest != nil);

    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    return fetchedObjects.firstObject;
}

@end
