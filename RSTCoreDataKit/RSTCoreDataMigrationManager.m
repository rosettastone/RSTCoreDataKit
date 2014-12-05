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

#import "RSTCoreDataMigrationManager.h"

#import "RSTCoreDataModel.h"


@implementation RSTCoreDataMigrationManager

#pragma mark - Init

- (instancetype)initWithModel:(RSTCoreDataModel *)model storeType:(NSString *)storeType
{
    NSParameterAssert(model != nil);
    NSParameterAssert(storeType != nil);
    
    self = [super init];
    if (self) {
        _model = model;
        _storeType = [storeType copy];
    }
    return self;
}

#pragma mark - NSObject

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: model=%@, storeType=%@>", [self class], self.model, self.storeType];
}

#pragma mark - Public

- (void)beginMigratingModel
{
    __block UIBackgroundTaskIdentifier backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:backgroundTask];
    }];
    
    __block NSError *error = nil;
    BOOL success = [self progressivelyMigrateModelError:&error];
    
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate migrationManager:self didSucceed:success withError:error];
        });
    }
    else {
        [self.delegate migrationManager:self didSucceed:success withError:error];
    }
    
    [[UIApplication sharedApplication] endBackgroundTask:backgroundTask];
}

#pragma mark - Private

- (BOOL)progressivelyMigrateModelError:(NSError **)error
{
    if (![self.model modelStoreNeedsMigration]) {
        return YES;
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:self.model.storeURL.path]) {
        //  there is no file, so one will be created
        return YES;
    }
    
    NSDictionary *sourceMetadata = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:self.storeType URL:self.model.storeURL error:error];
    if (sourceMetadata == nil) {
        return NO;
    }
    
    NSManagedObjectModel *sourceModel = [NSManagedObjectModel mergedModelFromBundles:@[ self.model.bundle ] forStoreMetadata:sourceMetadata];
    NSArray *modelPaths = [self modelPathsForAllModelVersions];
    if (modelPaths == nil) {
        return NO;
    }
    
    NSMappingModel *mappingModel = nil;
    NSManagedObjectModel *targetModel = nil;
    NSString *modelPath = nil;
    
    for (NSString *path in modelPaths) {
        targetModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path]];
        
        if (![targetModel isEqual:sourceModel] && ![[targetModel entityVersionHashesByName] isEqual:[sourceModel entityVersionHashesByName]]) {
            
            mappingModel = [NSMappingModel mappingModelFromBundles:@[ self.model.bundle ]
                                                    forSourceModel:sourceModel
                                                  destinationModel:targetModel];
            
            if (mappingModel != nil) {
                modelPath = path;
                break;
            }
        }
    }
    
    if (mappingModel == nil) {
        return NO;
    }
    
    [self performCheckpointStoreWithSourceModel:sourceModel sourceStoreURL:self.model.storeURL];
    
    NSString *storePath = [NSString stringWithFormat:@"%@.%@.%@",
                           [self.model.storeURL.path stringByDeletingPathExtension], [[NSProcessInfo processInfo] globallyUniqueString], self.model.storeURL.path.pathExtension];
    
    NSURL *destinationStoreURL = [NSURL fileURLWithPath:storePath];
    
    NSMigrationManager *manager = [[NSMigrationManager alloc] initWithSourceModel:sourceModel destinationModel:targetModel];
    BOOL success = [manager migrateStoreFromURL:self.model.storeURL
                                           type:self.storeType
                                        options:nil
                               withMappingModel:mappingModel
                               toDestinationURL:destinationStoreURL
                                destinationType:self.storeType
                             destinationOptions:nil
                                          error:error];
    
    if (!success) {
        return NO;
    }
    
    [self backupAndReplaceStoreAtURL:self.model.storeURL withStoreAtURL:destinationStoreURL error:error];
    
    return [self progressivelyMigrateModelError:error];
}

- (void)performCheckpointStoreWithSourceModel:(NSManagedObjectModel *)sourceModel sourceStoreURL:(NSURL *)sourceStoreURL
{
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:sourceModel];
    
    NSDictionary *options = [self.storeType isEqualToString:NSSQLiteStoreType] ? @{ NSSQLitePragmasOption: @{ @"journal_mode": @"DELETE"} } : nil;
    
    [persistentStoreCoordinator addPersistentStoreWithType:self.storeType
                                             configuration:nil
                                                       URL:sourceStoreURL
                                                   options:options
                                                     error:nil];
    
    [persistentStoreCoordinator removePersistentStore:[persistentStoreCoordinator persistentStoreForURL:sourceStoreURL] error:nil];
}

- (NSArray *)modelPathsForAllModelVersions
{
    NSString *resourceSubpath = [self.model.modelURL.path lastPathComponent];
    NSArray *array = [self.model.bundle pathsForResourcesOfType:@"mom" inDirectory:resourceSubpath];
    if (array.count == 0) {
        return nil;
    }
    
    return array;
}

- (BOOL)backupAndReplaceStoreAtURL:(NSURL *)sourceURL withStoreAtURL:(NSURL *)destinationURL error:(NSError **)error
{
    NSString *guid = [[NSProcessInfo processInfo] globallyUniqueString];
    NSString *backupPath = [NSTemporaryDirectory() stringByAppendingPathComponent:guid];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager moveItemAtPath:sourceURL.path toPath:backupPath error:error]) {
        return NO;
    }
    
    if (![fileManager moveItemAtPath:destinationURL.path toPath:sourceURL.path error:error]) {
        [fileManager moveItemAtPath:backupPath
                             toPath:sourceURL.path
                              error:nil];
        return NO;
    }
    
    return YES;
}

@end
