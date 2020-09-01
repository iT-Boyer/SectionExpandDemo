//
//  SectionView.h
//  TableViewSectionDemo
//
//  Created by jhmac on 2020/9/1.
//  Copyright © 2020 iTBoyer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionModel.h"

NS_ASSUME_NONNULL_BEGIN

@class SectionModel;
typedef void(^CallBackBlock)(BOOL);
@interface SectionView : UITableViewHeaderFooterView
@property (nonatomic,strong) SectionModel *model;
@property (nonatomic,strong) CallBackBlock block;
@end

NS_ASSUME_NONNULL_END
