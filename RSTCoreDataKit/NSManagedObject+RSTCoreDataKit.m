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

#import "NSManagedObject+RSTCoreDataKit.h"

@implementation NSManagedObject (RSTCoreDataKit)

+ (NSString *)rst_entityName
{
    return NSStringFromClass([self class]);
}

+ (instancetype)rst_insertNewObjectInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    return [NSEntityDescription insertNewObjectForEntityForName:[self rst_entityName]
                                         inManagedObjectContext:managedObjectContext];
}

+ (NSFetchRequest *)rst_fetchRequest
{
    return [NSFetchRequest fetchRequestWithEntityName:[self rst_entityName]];
}

@end
