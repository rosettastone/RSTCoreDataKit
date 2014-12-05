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

#import "RSTCoreDataModel.h"

@implementation RSTCoreDataModel

@synthesize managedObjectModel = _managedObjectModel;

#pragma mark - Init

- (instancetype)initWithName:(NSString *)modelName bundle:(NSBundle *)bundle
{
    NSParameterAssert(modelName != nil);
    NSParameterAssert(bundle != nil);
    
    self = [super init];
    if (self) {
        _modelName = [modelName copy];
        _bundle = bundle;
        
        _databaseFilename = [NSString stringWithFormat:@"%@.sqlite", _modelName];
        _modelURL = [bundle URLForResource:_modelName withExtension:@"momd"];

        NSError *error = nil;
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
                                                                              inDomain:NSUserDomainMask
                                                                     appropriateForURL:nil
                                                                                create:YES
                                                                                 error:&error];

        if (error) {
            NSLog(@"*** %s Error finding documents directory: %@", __PRETTY_FUNCTION__, error);
            return nil;
        }

        _storeURL = [documentsDirectoryURL URLByAppendingPathComponent:_databaseFilename];
    }
    return self;
}

- (instancetype)initWithName:(NSString *)modelName
{
    return [self initWithName:modelName bundle:[NSBundle mainBundle]];
}

#pragma mark - NSObject

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: modelName=%@, needsMigration=%@, databaseFilename=%@, modelURL=%@, storeURL=%@>",
            [self class], self.modelName, @([self modelStoreNeedsMigration]), self.databaseFilename, self.modelURL, self.storeURL];
}

#pragma mark - Getters

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel == nil) {
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:self.modelURL];
    }
    return _managedObjectModel;
}

#pragma mark - Model

- (BOOL)modelStoreNeedsMigration
{
    NSManagedObjectModel *destinationModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:self.modelURL];

    NSError *error = nil;
    NSDictionary *sourceMetaData = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:nil
                                                                                              URL:self.storeURL
                                                                                            error:&error];
    if (sourceMetaData != nil) {
        return ![destinationModel isConfiguration:nil compatibleWithStoreMetadata:sourceMetaData];
    }
    else {
        NSLog(@"*** %s Error checking persistent store coordinator meta data: %@", __PRETTY_FUNCTION__, error);
    }

    return NO;
}

- (void)removeExistingModelStore
{
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];

    if ([fileManager fileExistsAtPath:self.storeURL.path]) {
        BOOL success = [fileManager removeItemAtURL:self.storeURL error:&error];

        if (!success) {
            NSLog(@"*** %s Error removing model store: %@", __PRETTY_FUNCTION__, error);
        }
    }
}

@end
