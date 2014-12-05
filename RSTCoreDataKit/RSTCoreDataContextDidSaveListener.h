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
 *  A completion block to be called when receiving `NSManagedObjectContextDidSaveNotification`.
 *
 *  @param notification The notification that was posted.
 */
typedef void(^RSTCoreDataContextSaveHandler)(NSNotification *notification);

/**
 *  An instance of `RSTCoreDataContextDidSaveListener` is a single-purpose object intended to simplify
 *  listening for the `NSManagedObjectContextDidSaveNotification` notification.
 *
 *  It listens for `NSManagedObjectContextDidSaveNotification`, and calls its handler block upon receiving the notification.
 *  Upon deallocation, this object will stop listening for notifications.
 */
@interface RSTCoreDataContextDidSaveListener : NSObject

/**
 *  Initializes a new `RSTCoreDataContextDidSaveListener` with the specified handler and begins 
 *  listening for notifications from the specified managedObjectContext.
 *
 *  @param handler              The handler block to be called each time the notification is received. This value may not be `nil`.
 *  @param managedObjectContext The managed object context to be observed. This value may be `nil`.
 *
 *  @return An initialized `RSTCoreDataContextDidSaveListener` if successful, `nil` otherwise.
 */
- (instancetype)initWithHandler:(RSTCoreDataContextSaveHandler)handler
        forManagedObjectContext:(NSManagedObjectContext *)managedObjectContext NS_DESIGNATED_INITIALIZER;

/**
 *  Not a valid initializer for this class.
 */
- (id)init NS_UNAVAILABLE;

@end
