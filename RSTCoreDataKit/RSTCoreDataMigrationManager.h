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
@import UIKit;
@import CoreData;

@class RSTCoreDataMigrationManager;
@class RSTCoreDataModel;


@protocol RSTCoreDataMigrationManagerDelegate <NSObject>

- (void)migrationManager:(RSTCoreDataMigrationManager *)migrationManager
              didSucceed:(BOOL)didSucceed
               withError:(NSError *)error;

@end


@interface RSTCoreDataMigrationManager : NSObject

@property (weak, nonatomic) id<RSTCoreDataMigrationManagerDelegate> delegate;

- (BOOL)migrateModel:(RSTCoreDataModel *)model;

- (BOOL)migrateModel:(RSTCoreDataModel *)model withStoreType:(NSString *)storeType;

@end
