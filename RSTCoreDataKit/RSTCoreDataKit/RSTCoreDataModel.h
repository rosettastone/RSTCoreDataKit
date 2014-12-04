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
 *  The `RSTCoreDataModel` class represents a Core Data model.
 *  It provides the model and store URLs as well as convenience methods for interacting with the store.
 */
@interface RSTCoreDataModel : NSObject

/**
 *  Returns the model name of the Core Data model resource.
 */
@property (nonatomic, readonly) NSString *modelName;

/**
 *  Returns the database file name for the store.
 */
@property (nonatomic, readonly) NSString *databaseFilename;

/**
 *  Returns the file URL specifying the model file.
 */
@property (nonatomic, readonly) NSURL *modelURL;

/**
 *  Returns the file URL specifying the store.
 */
@property (nonatomic, readonly) NSURL *storeURL;

/**
 *  The bundle in which the model is located.
 */
@property (nonatomic, readonly) NSBundle *bundle;

/**
 *  Returns the managed object model for the model specified by modelName.
 */
@property (nonatomic, readonly) NSManagedObjectModel *managedObjectModel;

#pragma mark - Init

/**
 *  Initializes and returns a new `RSTCoreDataModel` object for the specified modelName and bundle.
 *
 *  @param modelName The name of the Core Data model. This value must not be `nil`.
 *  @param bundle    The bundle in which the Core Data model is located. This value must not be `nil`.
 *
 *  @return An initialized `RSTCoreDataModel` if successful, `nil` otherwise.
 */
- (instancetype)initWithName:(NSString *)modelName bundle:(NSBundle *)bundle NS_DESIGNATED_INITIALIZER;

/**
 *  Initializes and returns a new `RSTCoreDataModel` object for the specified modelName for 
 *  a model that is located in the Application's main bundle.
 *
 *  @param modelName The name of the Core Data model. This value must not be `nil`.
 *
 *  @return An initialized `RSTCoreDataModel` if successful, `nil` otherwise.
 */
- (instancetype)initWithName:(NSString *)modelName;

/**
 *  Not a valid initializer for this class.
 */
- (id)init NS_UNAVAILABLE;

#pragma mark - Model

/**
 *  Queries the meta data for the persistent store specified by the receiver and returns whether
 *  or not a migration is needed.
 *
 *  @return `YES` if the store requires a migration, `NO` otherwise.
 */
- (BOOL)modelStoreNeedsMigration;

/**
 *  Removes the existing model store specfied by the receiver.
 */
- (void)removeExistingModelStore;

@end
