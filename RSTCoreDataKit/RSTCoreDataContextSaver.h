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
 *  An instance of `RSTCoreDataContextSaver` is responsible for saving a managed object context.
 */
@interface RSTCoreDataContextSaver : NSObject

/**
 *  Attempts to commit unsaved changes to registered objects to the specified context's parent store.
 *  This method is performed *synchronously* in a given block on the context's queue.
 *
 *  @param context The managed object context to save.
 *
 *  @return A boolean value indicating whether the save succeeded. `YES` if successful, `NO` otherwise.
 */
+ (BOOL)saveAndWait:(NSManagedObjectContext *)context;

/**
 *  Attempts to commit unsaved changes to registered objects to the specified context's parent store.
 *  This method is performed *asynchronously* in a given block on the context's queue.
 *
 *  @param context The managed object context to save.
 */
+ (void)save:(NSManagedObjectContext *)context;

@end
