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

#pragma mark - Init

- (instancetype)initWithName:(NSString *)modelName
{
    self = [super init];
    if (self) {
        _modelName = [modelName copy];
        _databaseFilename = [NSString stringWithFormat:@"%@.sqlite", _modelName];
        _modelURL = [[NSBundle mainBundle] URLForResource:_modelName withExtension:@"momd"];

        NSError *error = nil;
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
                                                                              inDomain:NSUserDomainMask
                                                                     appropriateForURL:nil
                                                                                create:YES
                                                                                 error:&error];

        if (error) {
            NSLog(@"Error finding documents directory: %@, %@", error, [error userInfo]);
            return nil;
        }

        _storeURL = [documentsDirectoryURL URLByAppendingPathComponent:_databaseFilename];
    }
    return self;
}

#pragma mark - NSObject

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: modelName=%@, needsMigration=%@, databaseFilename=%@, modelURL=%@, storeURL=%@>",
            [self class], self.modelName, @([self modelStoreNeedsMigration]), self.databaseFilename, self.modelURL, self.storeURL];
}

#pragma mark - Model

- (BOOL)modelStoreNeedsMigration
{
    BOOL isCompatible = NO;

    NSManagedObjectModel *destinationModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:self.modelURL];

    NSError *error = nil;
    NSDictionary *sourceMetaData = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:nil
                                                                                              URL:self.storeURL
                                                                                            error:&error];
    if (sourceMetaData) {
        isCompatible = [destinationModel isConfiguration:nil compatibleWithStoreMetadata:sourceMetaData];
    }
    else {
        NSLog(@"Error checking persistent store coordinator meta data: %@, %@", error, [error userInfo]);
    }

    return !isCompatible;
}

- (void)removeExistingModelStore
{
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtURL:self.storeURL error:&error];
    
    if (error) {
        NSLog(@"%s error: Error removing model store: %@", __PRETTY_FUNCTION__, error);
    }
}

@end
