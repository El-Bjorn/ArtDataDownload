//
//  NetworkImporter.m
//  Palette_Data_Importer
//
//  Created by BjornC on 8/5/15.
//  Copyright (c) 2015 Builtlight. All rights reserved.
//

#import "NetworkImporter.h"
#import "Artwork.h"
#import "DataStorage.h"
#import "NSObject+Blocks.h"


extern DataStorage *ds;
extern dispatch_semaphore_t done_sema;

@implementation NetworkImporter

-(instancetype) init {
    self = [super init];
    if (self) {
        self.urlsession = [NSURLSession sharedSession];
        self.authenticated = NO;
    }
    return self;
}

int num_artworks = 0;

-(void) authenticate {
    NSURL *url = [NSURL URLWithString:@"http://palette-dev.pacegallery.com/palette/j_spring_security_check"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *postString = @"j_username=charnden&j_password=Palette3";
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    NSURLSessionTask *task = [self.urlsession dataTaskWithRequest:request
                                                completionHandler:^(NSData *data,
                                                                    NSURLResponse *response,
                                                                    NSError *error)
    {
        // we're authenticated
        //NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        //NSLog(@"cookies: %@",cookieJar.cookies);
        
#define FRAME_SIZE 100
       
        //[self downloadImageForPgid:@"01648" withWidth:50];
        int num_frames = 510;
        //int num_frames = 5;
        int i;
        for (i=0; i< num_frames ; i++ ) {
            //[self performBlock:^{
                printf("making call for frame: %d\n",i);
                [self artArrayForIndex:i withCompBlock:^(NSArray *artDicts, NSError *err) {
                    NSLog(@"Frame: %d got artwork array of size: %ld",i,artDicts.count);
                    for (NSDictionary *d in artDicts) {
                        Artwork *a = [self createArtworkFromArtDict:d];
                        if (a != nil) {
                            //NSLog(@"created artwork: %@",a);
                        }
                        //printf("number of artworks imported: %d\n",++num_artworks);
                        num_artworks++;
                        if (num_artworks == num_frames*FRAME_SIZE) {
                            NSLog(@"done importing");
                            dispatch_semaphore_signal(done_sema);
                        }
                    }
                }];

            //} afterDelay:5];
            
            NSLog(@"sleeping....");
            sleep(1);
        }
    }];
    [task resume];
}

#define ACQ_URL @"http://palette-dev.pacegallery.com/palette/search/acquisitions?count="

// retrieves array of 10 art piece dictionaries
-(void) artArrayForIndex:(int)index withCompBlock:(void (^)(NSArray *artDict, NSError *err))compBlk {
    //NSURL *url = [NSURL URLWithString:@"http://palette-dev.pacegallery.com/palette/search/filter/ajax/get"];
    NSString *urlstr = [NSString stringWithFormat:@"%@%d",ACQ_URL,FRAME_SIZE];
    //NSURL *url = [NSURL URLWithString:@"http://palette-dev.pacegallery.com/palette/search/acquisitions?count=100"];
    NSURL *url = [NSURL URLWithString:urlstr];
    //NSLog(@"url= %@",url);

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *postString = [NSString stringWithFormat:@"index=%d&sortType=SORT_TYPE_RELEVANCY_DESC",index];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    NSURLSessionTask *task = [self.urlsession dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    if (error){
                        NSLog(@"error = %@",error);
                    }
                    NSLog(@"response= %@",response);
                    NSError *err = nil;
                    NSMutableArray *pgidList = [[NSMutableArray alloc] init];
                    NSDictionary *ajaxResults = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
                    //NSLog(@"ajaxResults = %@",ajaxResults);
                    NSArray *results = ajaxResults[@"data"][@"results"];
                    //NSLog(@"results= %@",results);
                    for (NSDictionary *d in results) {
                        [pgidList addObject:d];
                    }
                    compBlk(pgidList,error);
    }];
    [task resume];
}

#define WIDTH_KEY @"artworkImageWidth"
#define HEIGHT_KEY @"artworkImageHeight"

-(Artwork*) createArtworkFromArtDict:(NSDictionary*)dict {
    // check if we gots an image
    NSString *acquisStatus = dict[@"acquisitionStatus"];
    //NSLog(@"acquisStatus= %@ -----------------------------------------",acquisStatus);

    if ([dict[WIDTH_KEY] isKindOfClass:[NSNull class]]) {
        NSLog(@"no image");
        //return nil;
    }
    NSArray *flagArray = @[ @{ @"flag":@"acquisitionOnConsignmentFlag", @"label":@"Consignment"},
                            @{ @"flag":@"acquisitionOnLoanFlag", @"label":@"Loan"},
                            @{ @"flag":@"acquisitionOnApprovalFlag", @"label":@"Approval"},
                            @{ @"flag":@"acquisitionReservedFlag", @"label":@"Reserved"},
                            @{ @"flag":@"acquisitionAboFlag", @"label":@"ABO"},
                            @{ @"flag":@"acquisitionNfsFlag", @"label":@"NFS"},
                            @{ @"flag":@"acquisitionRedFlag", @"label":@"Red Flag"} ];
    
    //NSLog(@"creating artwork....");
    // check if we have it already
    NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:@"Artwork"];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"paceID=%@",dict[@"artworkPgNumber"]];
    req.predicate = pred;
    NSError *err = nil;
    NSArray *results = [ds.context executeFetchRequest:req error:&err];
    if (results.count > 0){
        NSLog(@"got pgid: %@ already",dict[@"artworkPgNumber"]);
        return nil;
    }
    
    
    Artwork *newArt = [NSEntityDescription insertNewObjectForEntityForName:@"Artwork" inManagedObjectContext:ds.context];
    newArt.artworkID = dict[@"artworkId"];
    newArt.paceID = dict[@"artworkPgNumber"];
    newArt.artistNames = dict[@"artistName"];
    newArt.title = dict[@"artworkTitle"];
    newArt.searchResultOrder = @(-1);
    if (dict[@"artworkDate"] != [NSNull null]) {
        newArt.creationDate =  dict[@"artworkDate"];
    }
    
    //newArt.statusLabel = dict[@"acquisitionStatusLabel"]; // TDB
    // Cracked-out status logic
    if ([acquisStatus isEqualToString:@"GIFTED"] || [acquisStatus isEqualToString:@"RETURNED"] ||[acquisStatus isEqualToString:@"SOLD"]) {
        newArt.statusColorName = @"red";
        newArt.statusLabel = acquisStatus;
    } else if ([acquisStatus isEqualToString:@"ACTIVE"]){
        NSString *statusLabel = @"";
        //newArt.statusLabel = @"";
        for (NSDictionary *f in flagArray) {
            if ([dict[ f[@"flag"]] boolValue]==YES) {
                [statusLabel stringByAppendingString:[NSString stringWithFormat:@"%@ ",f[@"label"]]];
                newArt.statusColorName = @"orange";
            }
        }
        if (newArt.statusColorName != nil) {
            newArt.statusLabel = statusLabel;
        } else {
            newArt.statusLabel = @"Available";
            newArt.statusColorName = @"green";
        }
    } else {
        NSLog(@"problem doing status. No logic for %@",acquisStatus);
    }
    
    if (dict[@"artworkClassificationName"]==[NSNull null]){
        newArt.classificationName = @"NONE";
    } else {
        newArt.classificationName = dict[@"artworkClassificationName"];
    }
    newArt.mediumName = dict[@"artworkMediumName"]; // @"NONE"
    newArt.dimensions = dict[@"artworkDimensions"]; // @"NONE"
    if (dict[@"artworkEditionInfo"] == [NSNull null]) {
        newArt.artworkEditionInfo = nil;
    } else {
        newArt.artworkEditionInfo = dict[@"artworkEditionInfo"];
    }
    newArt.regionName = dict[@"acquisitionRegionNames"][0];
    newArt.regionID = dict[@"acquisitinRegionIds"][0];
    newArt.locationName = dict[@"acquisitionLocationName"];
    if (dict[@"acquisitionLocationDate"]==[NSNull null]){
        //acq_loc_date = 0;
        newArt.locationDate = nil;
    } else {
        time_t acq_loc_date;
        acq_loc_date = [dict[@"acquisitionLocationDate"] integerValue]/1000;
        newArt.locationDate = [NSDate dateWithTimeIntervalSince1970:acq_loc_date];
    }
    // parse acquisitionPrice
    NSString *priceStr = dict[@"acquisitionPrice"];
    if ((id)priceStr == [NSNull null]) {
        newArt.price = nil;
        newArt.priceCurrency = nil;
    } else {
        NSArray *priceParts = [priceStr componentsSeparatedByString:@","];
        newArt.price = [NSDecimalNumber decimalNumberWithString:priceParts[0]];
        newArt.priceCurrency = priceParts[1];
    }
    
    if (dict[@"acquisitionPriceDealer"]==[NSNull null]) {
        newArt.priceDealer = @"";
    } else {
        newArt.priceDealer = dict[@"acquisitionPriceDealer"];
    }
    if (dict[@"acquisitionPriceEffectiveDate"]==[NSNull null]){
        newArt.priceEffectiveDate = nil;
    } else {
        time_t price_effect_date;
        price_effect_date = [dict[@"acquisitionPriceEffectiveDate"] integerValue]/1000;
        newArt.priceEffectiveDate = [NSDate dateWithTimeIntervalSince1970:price_effect_date];
    }
    
    
    // artwork image size
    if ([dict[WIDTH_KEY] isKindOfClass:[NSNull class]] || dict[WIDTH_KEY]==nil) {
        newArt.artworkImageWidth = @0;
    } else {
        newArt.artworkImageWidth = dict[WIDTH_KEY];
    }
    if ([dict[HEIGHT_KEY] isKindOfClass:[NSNull class]] || dict[HEIGHT_KEY]==nil) {
        newArt.artworkImageHeight = @0;
    } else {
        newArt.artworkImageHeight = dict[HEIGHT_KEY];
    }
    NSError *savErr = nil;
    [ds.context save:&savErr];
    if (savErr) {
        NSLog(@"Error saving artwork to context: %@",savErr);
    }
    return newArt;
}

-(void) downloadInfoForPGid:(int)pgid
        withCompBlock:(void (^)(NSDictionary*dict, NSError *err))compBlk
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://palette-dev.pacegallery.com/palette/artwork/infofragment?pgNumber=%d",pgid]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //NSLog(@"url = %@",url);
    NSURLSessionTask *task = [self.urlsession dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                        //NSLog(@"response= %@, err= %@",response,error);
                        NSError *err = nil;
                        NSDictionary *artInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
                        //NSLog(@"art info= %@",artInfo);
                                                    
                        compBlk(artInfo,error);
    }];
    [task resume];
}

#define IMAGE_DOWNLOAD_URL @"http://palette-dev.pacegallery.com/palette/artwork/image/id"

// testing
-(void) downloadImageForPgid:(NSString *)pgid withWidth:(double)width {
    NSString *urlString = [NSString stringWithFormat:@"%@?pgNumber=%@&width=%d",
                           IMAGE_DOWNLOAD_URL,pgid,(int)width];
    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"url= %@",url);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLSessionTask *task = [self.urlsession dataTaskWithRequest:request
                                              completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                  NSLog(@"response= %@",response);
                                                  NSLog(@"err = %@",error);
                                                  //NSImage *img = [[NSImage alloc] initWithData:data];
                                                  //UIImage *img = [UIImage imageWithData:data];
                                                  NSLog(@"downloaded image= %@",data);
                                              }];
    [task resume];
}

@end
