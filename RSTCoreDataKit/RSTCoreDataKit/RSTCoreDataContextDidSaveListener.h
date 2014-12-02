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


typedef void(^RSTCoreDataContextSaveHandler)(void);


@interface RSTCoreDataContextDidSaveListener : NSObject

- (instancetype)initWithHandler:(RSTCoreDataContextSaveHandler)handler
        forManagedObjectContext:(NSManagedObjectContext *)managedObjectContext NS_DESIGNATED_INITIALIZER;

- (id)init NS_UNAVAILABLE;

@end
