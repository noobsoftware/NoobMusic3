#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import <sqlite3.h>
@class PHPScriptObject;
@class PHPInterpretation;
// database name demo.sqlite

#define DB_NAME @"noobmediacenter.sqlite"//@"Conferencedata//////////////NSLog"

@interface DBConnection : NSObject
/*{
    @private sqlite3 *g_database;
}*/

@property (nonatomic) sqlite3* database; //,assign,readwrite
@property (nonatomic) NSMutableDictionary* tableColumnsValues;
@property (nonatomic) PHPInterpretation* interpretation;

//+ (DBConnection *) sharedConnection;
- (BOOL) executeQuery:(NSString *)query values: (PHPScriptObject*) scriptObject ;
-(NSMutableArray *) fetchResults:(NSString *)query values: (PHPScriptObject*) scriptObject;
//+ (int) rowCountForTable:(NSString *)table where:(NSString *)where;
- (void) errorMessage:(NSString *)msg;
- (void) closeConnection;

//- (id)initConnection;
- (void)close;
- (BOOL)insertData: (NSString*) inserStatement values: (PHPScriptObject*) scriptObject;
- (NSNumber*)lastInsertRowId;
- (NSObject*) initializeDatabase: (NSString*) dbName; //initializeDatabaseWithPath
- (NSObject*) initializeDatabaseWithPath: (NSString*) dbName;
@end
