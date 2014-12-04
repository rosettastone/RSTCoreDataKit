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

#pragma mark - Public

- (BOOL)migrateModel:(RSTCoreDataModel *)model
{
    return [self migrateModel:model withStoreType:NSSQLiteStoreType];
}

- (BOOL)migrateModel:(RSTCoreDataModel *)model withStoreType:(NSString *)storeType
{
    __block UIBackgroundTaskIdentifier backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:backgroundTask];
    }];

    __block NSError *error = nil;
    BOOL success = [self progressivelyMigrateModel:model withStoretype:storeType error:&error];

    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate migrationManager:self didSucceed:success withError:error];
        });
    }
    else {
        [self.delegate migrationManager:self didSucceed:success withError:error];
    }

    [[UIApplication sharedApplication] endBackgroundTask:backgroundTask];
    return success;
}

#pragma mark - Private

- (BOOL)progressivelyMigrateModel:(RSTCoreDataModel *)model
                    withStoretype:(NSString *)storeType
                            error:(NSError **)error
{
    if (![model modelStoreNeedsMigration]) {
        return YES;
    }

    if (![[NSFileManager defaultManager] fileExistsAtPath:model.storeURL.path]) {
        //  there is no file, so one will be created
        return YES;
    }

    NSDictionary *sourceMetadata = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:storeType URL:model.storeURL error:error];
    if (sourceMetadata == nil) {
        return NO;
    }

    NSManagedObjectModel *sourceModel = [NSManagedObjectModel mergedModelFromBundles:nil forStoreMetadata:sourceMetadata];
    NSArray *modelPaths = [self modelPathsInDeploymentDirectory:model.modelURL.path];
    if (modelPaths == nil) {
        return NO;
    }

    NSMappingModel *mappingModel = nil;
    NSManagedObjectModel *targetModel = nil;
    NSString *modelPath = nil;

    for (NSString *path in modelPaths) {
        targetModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path]];

        if (![targetModel isEqual:sourceModel] && ![[targetModel entityVersionHashesByName] isEqual:[sourceModel entityVersionHashesByName]]) {
            mappingModel = [NSMappingModel mappingModelFromBundles:nil
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

    [self performCheckpointStoreWithSourceModel:sourceModel sourceStoreURL:model.storeURL];

    NSString *storePath = [NSString stringWithFormat:@"%@.%@.%@",
                           [model.storeURL.path stringByDeletingPathExtension], [[NSProcessInfo processInfo] globallyUniqueString], model.storeURL.path.pathExtension];

    NSURL *destinationStoreURL = [NSURL fileURLWithPath:storePath];

    NSMigrationManager *manager = [[NSMigrationManager alloc] initWithSourceModel:sourceModel destinationModel:targetModel];
    BOOL success = [manager migrateStoreFromURL:model.storeURL
                                           type:storeType
                                        options:nil
                               withMappingModel:mappingModel
                               toDestinationURL:destinationStoreURL
                                destinationType:storeType
                             destinationOptions:nil
                                          error:error];

    if (!success) {
        return NO;
    }

    [self backupAndReplaceStoreAtURL:model.storeURL withStoreAtURL:destinationStoreURL error:error];

    return [self progressivelyMigrateModel:model withStoretype:storeType error:error];
}

- (void)performCheckpointStoreWithSourceModel:(NSManagedObjectModel *)sourceModel sourceStoreURL:(NSURL *)sourceStoreURL
{
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:sourceModel];
    
    [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                             configuration:nil
                                                       URL:sourceStoreURL
                                                   options:@{ NSSQLitePragmasOption: @{ @"journal_mode": @"DELETE"} }
                                                     error:nil];

    [persistentStoreCoordinator removePersistentStore:[persistentStoreCoordinator persistentStoreForURL:sourceStoreURL] error:nil];
}

- (NSArray *)modelPathsInDeploymentDirectory:(NSString *)momdPath
{
    NSString *resourceSubpath = [momdPath lastPathComponent];
    NSArray *array = [[NSBundle mainBundle] pathsForResourcesOfType:@"mom" inDirectory:resourceSubpath];
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
