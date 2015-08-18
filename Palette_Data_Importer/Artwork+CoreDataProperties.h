//
//  Artwork+CoreDataProperties.h
//  Palette_Data_Importer
//
//  Created by BjornC on 8/18/15.
//  Copyright © 2015 Builtlight. All rights reserved.
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

#import "Artwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface Artwork (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *artistNames;
@property (nullable, nonatomic, retain) NSNumber *artworkImageHeight;
@property (nullable, nonatomic, retain) NSNumber *artworkImageWidth;
@property (nullable, nonatomic, retain) NSString *creationDate;
@property (nullable, nonatomic, retain) NSString *paceID;
@property (nullable, nonatomic, retain) NSString *statusColorName;
@property (nullable, nonatomic, retain) NSString *statusLabel;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSNumber *artworkID;
@property (nullable, nonatomic, retain) NSManagedObject *imageData;

@end

NS_ASSUME_NONNULL_END
