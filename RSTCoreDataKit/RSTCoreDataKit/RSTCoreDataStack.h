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
 *  The `RSTCoreDataStack` class encapsulates the entire Core Data stack for a SQLite store type.
 *  It manages the managed object model, the persistent store coordinator, and the main managed object context. 
 *  It provides convenience methods for initializing your stack for common use-cases as well as creating child contexts.
 */
@interface RSTCoreDataStack : NSObject

/**
 *  Returns the main managed object context for the Core Data stack.
 */
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;

#pragma mark - Init

/**
 *  Initializes and returns a new `RSTCoreDataStack` instance having the specified storeURL and modelURL.
 *  This stack is initialized with the `NSMainQueueConcurrencyType` concurrency type and default options that specify that
 *  the persistent store coordinator should automatically attempt to migrate versioned stores and 
 *  should attempt to create the mapping model automatically.
 *
 *  @param storeURL The file URL specifying the store. If `nil`, an in-memory store type will be used instead.
 *  @param modelURL The file URL specifying the model file. This value must not be `nil`.
 *
 *  @return An initialized `RSTCoreDataStack` if successful, `nil` otherwise.
 */
+ (instancetype)defaultStackWithStoreURL:(NSURL *)storeURL modelURL:(NSURL *)modelURL;

/**
 *  Initializes and returns a new `RSTCoreDataStack` instance having the specified storeURL and modelURL.
 *  This stack is initialized with the `NSPrivateQueueConcurrencyType` concurrency type and default options that specify that
 *  the persistent store coordinator should automatically attempt to migrate versioned stores and
 *  should attempt to create the mapping model automatically.
 *
 *  @param storeURL The file URL specifying the store. If `nil`, an in-memory store type will be used instead.
 *  @param modelURL The file URL specifying the model file. This value must not be `nil`.
 *
 *  @return An initialized `RSTCoreDataStack` if successful, `nil` otherwise.
 */
+ (instancetype)privateStackWithStoreURL:(NSURL *)storeURL modelURL:(NSURL *)modelURL;

/**
 *  Initializes and returns a new in-memory `RSTCoreDataStack` instance for the specified modelURL.
 *
 *  @param modelURL The file URL specifying the model file. This value must not be `nil`.
 *
 *  @return An initialized `RSTCoreDataStack` if successful, `nil` otherwise.
 */
+ (instancetype)stackWithInMemoryStoreWithModelURL:(NSURL *)modelURL;

/**
 *  Initializes and returns an `RSTCoreDataStack` having the specified storeURL, modelURL, options, and concurrencyType
 *  for a SQLite store type.
 *
 *  @param storeURL        The file URL specifying the store. If `nil`, an in-memory store type will be used instead.
 *  @param modelURL        The file URL specifying the model file. This value must not be `nil`.
 *  @param options         A dictionary containing key-value pairs that specify options for the store. This value may be nil.
 *  @param concurrencyType The concurrency pattern with which the managed object context will be used.
 *
 *  @return An initialized `RSTCoreDataStack` if successful, `nil` otherwise.
 */
- (instancetype)initWithStoreURL:(NSURL *)storeURL
                        modelURL:(NSURL *)modelURL
                         options:(NSDictionary *)options
                 concurrencyType:(NSManagedObjectContextConcurrencyType)concurrencyType NS_DESIGNATED_INITIALIZER;

/**
 *  Not a valid initializer for this class.
 */
- (id)init NS_UNAVAILABLE;

#pragma mark - Creating child contexts

/**
 *  Creates and returns a new child managed object context with an `NSPrivateQueueConcurrencyType`
 *  and `NSMergeByPropertyObjectTrumpMergePolicyType`.
 *
 *  @return An initialized child context.
 */
- (NSManagedObjectContext *)newDefaultPrivateChildContext;

/**
 *  Creates and returns a new child managed object context with an `NSMainQueueConcurrencyType`
 *  and `NSMergeByPropertyObjectTrumpMergePolicyType`.
 *
 *  @return An initialized child context.
 */
- (NSManagedObjectContext *)newDefaultMainChildContext;

/**
 *  Creates and returns a new child managed object context with the specified concurrencyType and mergePolicyType.
 *
 *  @param concurrencyType The concurrency pattern with which the managed object context will be used.
 *  @param mergePolicyType The merge policy with which the manged object context will be used.
 *
 *  @return A child context initialized to use the given concurrency type and merge policy type.
 */
- (NSManagedObjectContext *)newChildContextWithConcurrencyType:(NSManagedObjectContextConcurrencyType)concurrencyType
                                               mergePolicyType:(NSMergePolicyType)mergePolicyType;

@end
