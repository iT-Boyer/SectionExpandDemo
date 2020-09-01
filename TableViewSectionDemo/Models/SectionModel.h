//
//  SectionModel.h
//  TableViewSectionDemo
//
//  Created by jhmac on 2020/9/1.
//  Copyright © 2020 iTBoyer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SectionModel : NSObject
@property (nonatomic,assign) BOOL isExpand;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSArray *cellArray;
@end

@interface CellModel : NSObject
@property (nonatomic,strong) NSString *title;
@end

NS_ASSUME_NONNULL_END
