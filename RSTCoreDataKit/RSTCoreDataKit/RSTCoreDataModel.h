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

@interface RSTCoreDataModel : NSObject

@property (nonatomic, readonly) NSString *modelName;
@property (nonatomic, readonly) NSString *databaseFilename;
@property (nonatomic, readonly) NSURL *modelURL;
@property (nonatomic, readonly) NSURL *storeURL;

#pragma mark - Init

- (instancetype)initWithName:(NSString *)modelName;

#pragma mark - Model

- (BOOL)modelStoreNeedsMigration;

- (void)removeExistingModelStore;

@end
