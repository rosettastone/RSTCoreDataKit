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

@import CoreData;

@interface NSManagedObject (RSTCoreDataKit)

/**
 *  @return The entity name of the receiver.
 */
+ (NSString *)rst_entityName;

/**
 *  Creates, configures, and returns an instance of the class for the entity with a given name.
 *
 *  @param managedObjectContext The managed object context in which the entity should be inserted.
 *
 *  @return A new, fully configured instance of the class for the entity. 
 *  The instance has its entity description set and is inserted it into context.
 */
+ (instancetype)rst_insertNewObjectInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

/**
 *  @return A fetch request configured to fetch using the entity name of the receiver.
 */
+ (NSFetchRequest *)rst_fetchRequest;

@end
