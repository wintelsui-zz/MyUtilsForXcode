//
//  ResourcesBuilderViewModel.h
//  testResourcs
//
//  Created by wintel on 2019/11/19.
//  Copyright © 2019 wintel. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ReactiveObjC.h"

typedef enum : NSUInteger {
    ResourcesSizeType1,
    ResourcesSizeType2,
    ResourcesSizeType3,
    ResourcesSizeTypeNone,
} ResourcesSizeType;

NS_ASSUME_NONNULL_BEGIN

@interface ResourcesBuilderViewModel : NSObject

@property (nonatomic, copy) NSString *inputFolder;
@property (nonatomic, copy) NSString *outputFolder;

@property (nonatomic, assign) ResourcesSizeType inputType;
@property (nonatomic, assign) ResourcesSizeType inputTypeTemp;

@property (nonatomic, assign) BOOL createImage1;
@property (nonatomic, assign) BOOL createImage2;
@property (nonatomic, assign) BOOL createImage3;


- (void)startCompletion:(void (^)(BOOL succeed))completion;



@property (nonatomic, readonly, strong) RACSignal *segmentedControlSignal;
@property (nonatomic, readonly, strong) RACSignal *validStartSignal;

@end

NS_ASSUME_NONNULL_END
