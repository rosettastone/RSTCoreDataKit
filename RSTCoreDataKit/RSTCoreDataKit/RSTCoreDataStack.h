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

@interface RSTCoreDataStack : NSObject

@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;

#pragma mark - Init

+ (instancetype)defaultStackWithStoreURL:(NSURL *)storeURL modelURL:(NSURL *)modelURL;

+ (instancetype)privateStackWithStoreURL:(NSURL *)storeURL modelURL:(NSURL *)modelURL;

+ (instancetype)stackWithInMemoryStoreWithModelURL:(NSURL *)modelURL;

- (instancetype)initWithStoreURL:(NSURL *)storeURL
                        modelURL:(NSURL *)modelURL
                         options:(NSDictionary *)options
                 concurrencyType:(NSManagedObjectContextConcurrencyType)concurrencyType;

- (NSManagedObjectContext *)newDefaultPrivateChildContext;

- (NSManagedObjectContext *)newDefaultMainChildContext;

- (NSManagedObjectContext *)newChildContextWithConcurrencyType:(NSManagedObjectContextConcurrencyType)concurrencyType;

- (NSManagedObjectContext *)newChildContextWithConcurrencyType:(NSManagedObjectContextConcurrencyType)concurrencyType
                                               mergePolicyType:(NSMergePolicyType)mergePolicyType;

@end
