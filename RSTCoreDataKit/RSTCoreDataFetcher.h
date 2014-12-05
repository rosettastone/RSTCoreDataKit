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

@import Foundation;
@import CoreData;

/**
 *  The `RSTCoreDataFetcher` class provides convenience methods for common Core Data fetching operations.
 */
@interface RSTCoreDataFetcher : NSObject

/**
 *  Returns the managed object context from which managed objects are fetched.
 */
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;

#pragma mark - Init

/**
 *  Initializes and returns an `RSTCoreDataFetcher` having the specified managedObjectContext.
 *
 *  @param managedObjectContext The managed object context from which to fetch managed objects. This value must not be `nil`.
 *
 *  @return An initialized `RSTCoreDataFetcher` if successful, `nil` otherwise.
 */
- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext NS_DESIGNATED_INITIALIZER;

/**
 *  Not a valid initializer for this class.
 */
- (id)init NS_UNAVAILABLE;

#pragma mark - Fetching

/**
 *  Fetches and returns the managed object with the specified objectID from the receiver's managedObjectContext.
 *
 *  @param objectID The object ID of the object to fetch. This value must not be `nil`.
 *
 *  @return The managed object having the specified objectID if it exists, `nil` otherwise.
 */
- (NSManagedObject *)objectForObjectID:(NSManagedObjectID *)objectID;

/**
 *  Fetches and returns the first object found by executing the specified fetchRequest on the receiver's managedObjectContext.
 *
 *  @param fetchRequest A fetch request that specifies the search criteria for the fetch.
 *
 *  @return The first object found that meets the criteria specified by fetchRequest that is fetched
 *  from the the receiver's managedObjectContext.
 */
- (id)firstObjectFromExecutingFetchRequest:(NSFetchRequest *)fetchRequest;

@end
