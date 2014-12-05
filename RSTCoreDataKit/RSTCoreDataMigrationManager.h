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
@import UIKit;
@import CoreData;

@class RSTCoreDataMigrationManager;
@class RSTCoreDataModel;

/**
 *  The `RSTCoreDataMigrationManagerDelegate` protocol defines methods that
 *  allow you to respond to events from an `RSTCoreDataMigrationManager`.
 */
@protocol RSTCoreDataMigrationManagerDelegate <NSObject>

@required

/**
 *  Tells the delegate that the specified migration manager has completed its migration.
 *
 *  @param migrationManager The migration manager responsible for migrating a model.
 *  @param didSucceed       A boolean value that indicates whether or not the migration succeeded.
 *  @param error            An error object if the migration did not succeed.
 */
- (void)migrationManager:(RSTCoreDataMigrationManager *)migrationManager
              didSucceed:(BOOL)didSucceed
               withError:(NSError *)error;

@end

/**
 *  An instance of `RSTCoreDataMigrationManager` is responsible for assisting in migrating
 *  Core Data models from a previous version to a new version.
 */
@interface RSTCoreDataMigrationManager : NSObject

/**
 *  Returns the core data model.
 */
@property (nonatomic, readonly) RSTCoreDataModel *model;

/**
 *  Returns the store type of the persistent store backing the model.
 */
@property (nonatomic, readonly) NSString *storeType;

/**
 *  The object that acts as the delegate for the migration manager.
 */
@property (weak, nonatomic) id<RSTCoreDataMigrationManagerDelegate> delegate;

/**
 *  Initializes a new migration manager for the specified model and storeType.
 *
 *  @param model     The model that requires migration to a new version. This value must not be `nil`.
 *  @param storeType The store type for the persistent store backing the model. This value must not be `nil`.
 *
 *  @return An initialized `RSTCoreDataMigrationManager` if successful, `nil` otherwise.
 */
- (instancetype)initWithModel:(RSTCoreDataModel *)model storeType:(NSString *)storeType NS_DESIGNATED_INITIALIZER;

/**
 *  Not a valid initializer for this class.
 */
- (id)init NS_UNAVAILABLE;

/**
 *  Begins migrating the model. This migration happens in a background task. 
 *  The manager notifies its delegate upon completion, whether successful or not.
 */
- (void)beginMigratingModel;

@end
