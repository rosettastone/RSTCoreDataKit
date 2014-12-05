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

#import "RSTCoreDataContextDidSaveListener.h"


@interface RSTCoreDataContextDidSaveListener ()

@property (copy, nonatomic) RSTCoreDataContextSaveHandler handler;

@end


@implementation RSTCoreDataContextDidSaveListener

#pragma mark - Init

- (instancetype)initWithHandler:(RSTCoreDataContextSaveHandler)handler forManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSParameterAssert(handler != nil);

    self = [super init];
    if (self) {
        _handler = handler;

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveManagedObjectContextDidSaveNotification:)
                                                     name:NSManagedObjectContextDidSaveNotification
                                                   object:managedObjectContext];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notifications

- (void)didReceiveManagedObjectContextDidSaveNotification:(NSNotification *)notification
{
    self.handler(notification);
}

@end
