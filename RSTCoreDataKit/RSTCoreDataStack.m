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

#import "RSTCoreDataStack.h"

@interface RSTCoreDataStack ()

@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong, readonly) NSURL *storeURL;
@property (nonatomic, strong, readonly) NSURL *modelURL;

@end


@implementation RSTCoreDataStack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

#pragma mark - Init

+ (instancetype)defaultStackWithStoreURL:(NSURL *)storeURL modelURL:(NSURL *)modelURL
{
    return [[RSTCoreDataStack alloc] initWithStoreURL:storeURL
                                             modelURL:modelURL
                                              options:@{ NSMigratePersistentStoresAutomaticallyOption : @(YES),
                                                         NSInferMappingModelAutomaticallyOption : @(YES) }
                                      concurrencyType:NSMainQueueConcurrencyType];
}

+ (instancetype)privateStackWithStoreURL:(NSURL *)storeURL modelURL:(NSURL *)modelURL
{
    return [[RSTCoreDataStack alloc] initWithStoreURL:storeURL
                                             modelURL:modelURL
                                              options:@{ NSMigratePersistentStoresAutomaticallyOption : @(YES),
                                                         NSInferMappingModelAutomaticallyOption : @(YES) }
                                      concurrencyType:NSPrivateQueueConcurrencyType];
}

+ (instancetype)stackWithInMemoryStoreWithModelURL:(NSURL *)modelURL
{
    return [[RSTCoreDataStack alloc] initWithStoreURL:nil
                                             modelURL:modelURL
                                              options:nil
                                      concurrencyType:NSMainQueueConcurrencyType];
}

- (instancetype)initWithStoreURL:(NSURL *)storeURL
                        modelURL:(NSURL *)modelURL
                         options:(NSDictionary *)options
                 concurrencyType:(NSManagedObjectContextConcurrencyType)concurrencyType
{
    NSParameterAssert(modelURL != nil);

    self = [super init];
    if (self) {
        _storeURL = [storeURL copy];
        _modelURL = [modelURL copy];

        NSString *storeType = (storeURL == nil) ? NSInMemoryStoreType : NSSQLiteStoreType;

        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:_modelURL];

        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];

        NSError *error = nil;
        [_persistentStoreCoordinator addPersistentStoreWithType:storeType
                                                  configuration:nil
                                                            URL:storeURL
                                                        options:options
                                                          error:&error];

        if (error) {
            NSLog(@"*** %s Error adding persistent store: %@", __PRETTY_FUNCTION__, error);
            return nil;
        }

        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:concurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:_persistentStoreCoordinator];
    }
    return self;
}

#pragma mark - NSObject

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: storeURL=%@, modelURL=%@>", [self class], self.storeURL, self.modelURL];
}

#pragma mark - Creating child contexts

- (NSManagedObjectContext *)newDefaultPrivateChildContext
{
    return [self newChildContextWithConcurrencyType:NSPrivateQueueConcurrencyType
                                    mergePolicyType:NSMergeByPropertyObjectTrumpMergePolicyType];
}

- (NSManagedObjectContext *)newDefaultMainChildContext
{
    return [self newChildContextWithConcurrencyType:NSMainQueueConcurrencyType
                                    mergePolicyType:NSMergeByPropertyObjectTrumpMergePolicyType];
}

- (NSManagedObjectContext *)newChildContextWithConcurrencyType:(NSManagedObjectContextConcurrencyType)concurrencyType
                                               mergePolicyType:(NSMergePolicyType)mergePolicyType
{
    NSManagedObjectContext *privateChildContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:concurrencyType];
    privateChildContext.parentContext = self.managedObjectContext;
    privateChildContext.mergePolicy = [[NSMergePolicy alloc] initWithMergeType:mergePolicyType];
    return privateChildContext;
}

@end
