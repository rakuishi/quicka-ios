// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to BrowserHistory.h instead.

#import <CoreData/CoreData.h>


extern const struct BrowserHistoryAttributes {
	__unsafe_unretained NSString *title;
	__unsafe_unretained NSString *updated;
	__unsafe_unretained NSString *url;
} BrowserHistoryAttributes;

extern const struct BrowserHistoryRelationships {
} BrowserHistoryRelationships;

extern const struct BrowserHistoryFetchedProperties {
} BrowserHistoryFetchedProperties;






@interface BrowserHistoryID : NSManagedObjectID {}
@end

@interface _BrowserHistory : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (BrowserHistoryID*)objectID;





@property (nonatomic, strong) NSString* title;



//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* updated;



//- (BOOL)validateUpdated:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* url;



//- (BOOL)validateUrl:(id*)value_ error:(NSError**)error_;






@end

@interface _BrowserHistory (CoreDataGeneratedAccessors)

@end

@interface _BrowserHistory (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;




- (NSDate*)primitiveUpdated;
- (void)setPrimitiveUpdated:(NSDate*)value;




- (NSString*)primitiveUrl;
- (void)setPrimitiveUrl:(NSString*)value;




@end
