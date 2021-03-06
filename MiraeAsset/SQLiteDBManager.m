//
//  SQLiteDBManager.m
//  iTender
//
//  Created by HyeongJun Park on 13. 2. 20..
//  Copyright (c) 2013년 BENCHBEE. All rights reserved.
//
//
/*
 Rev. 13. 11. 06
 * sqlite3_exec / sqlite3_prepare 관련 코드 정리
 * 참고 : http://stackoverflow.com/questions/1711631/how-do-i-improve-the-performance-of-sqlite
 * 참고2 : http://soooprmx.com/wp/archives/4656
 
 */
#import "SQLiteDBManager.h"
#import <sqlite3.h>

#import "AESExtention.h"

#define DBFILENAME @"MiraeAssetSqlite.sqlite"
//#define FREEMEM(ptr) { if(ptr) { free(ptr); ptr = NULL; } }

@implementation SQLiteDBManager

+ (void)initDB
{
	SQLiteDBManager *dbManager = [[SQLiteDBManager alloc] init];
	NSString *dbFilePath = [dbManager getDBFile];
	
	// Check if the database has already been created in the users filesystem
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	// Get the path to the database in the application package
	if(![fileManager fileExistsAtPath:dbFilePath]) {
		// Copy the database from the package to the users filesystem
		NSString *filePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DBFILENAME];
		
//		NSError *error;
		[fileManager copyItemAtPath:filePathFromApp toPath:dbFilePath error:nil];
		NSLog(@"Database file copied from bundle to %@",dbFilePath);
//		if (error) {
//			NSLog(@"DB File Copy Err %@",[error localizedDescription]);
//		}
	}
//	[dbManager release];
}

- (NSString*)getDBFile
{
	NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
	if (![documentsDirectory hasSuffix:@"/"]) {
		documentsDirectory = [documentsDirectory stringByAppendingString:@"/"];
	}
	NSString *dbFilePath = [documentsDirectory stringByAppendingPathComponent:DBFILENAME];
	
	return dbFilePath;
}

#pragma mark - check column



+ (BOOL)checkColumnAdds{
    
    BOOL columnExists = NO;
    
    
    SQLiteDBManager *dbManager = [[SQLiteDBManager alloc] init];
    NSString *dbfilePath = [dbManager getDBFile];
    sqlite3 *database;
    
    if (sqlite3_open([dbfilePath UTF8String], &database) == SQLITE_OK) {
        sqlite3_stmt *statement;
        const char *sql = "select newfield10 from CONTACT";
        
        if(sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK){
            columnExists = YES;
        }
    }
    
    
    //    sqlite3_stmt *selectStmt;
    //
    //    const char *sqlStatement = "select calduration from recentCall";
    //    if(sqlite3_prepare_v2(database, sqlStatement, -1, &selectStmt, NULL) == SQLITE_OK)
    //        columnExists = YES;
    //
    
    sqlite3_close(database);
//    [dbManager release];
    
    NSLog(@"columnExist %@",columnExists?@"YES":@"NO");
    return columnExists;
}

#pragma mark - Encryption/Decryption

//- (char *)encryptString:(NSString *)plainString
//{
//    /****************************************************************
//     작업자 : 김혜민
//     작업일자 : 2012/06/04
//     작업내용 : 받은 스트링을 암호화해 char *형으로 돌려준다.
//     param  - plainString(NSString *) : 스트링
//     연관화면 : 없음
//     ****************************************************************/
//    
//    
//    char *enc_data;
//    enc_data = (char *)malloc(3000);
//    memset (enc_data, '\0', 3000);
//    const char *src_data = [plainString UTF8String]; // NSString -> char *
//    int src_data_len = (int)strlen(src_data);
//    BenEncryption(src_data_len, (char *)src_data, enc_data + sizeof(short)); // 워닝뜨는건 header를 변경하도록 하겠음
//    memcpy(enc_data, &src_data_len, sizeof(short));
//    return enc_data;
//}
//
//- (NSString *)decryptString:(char *)enc_data
//{
//    /****************************************************************
//     작업자 : 김혜민
//     작업일자 : 2012/06/04
//     작업내용 : 암호화되어있는 데이터를 복호화해서 NSString *형으로 돌려준다.
//     param  - enc_data(char *) : 암호화되어있는 데이터
//     연관화면 : 없음
//     ****************************************************************/
//    
//    
//    if(enc_data == NULL) return @""; // 널이나 공백문자가 들어오면 BenDecryption 하다가 메모리 오류로 죽음...
//    
//    char dec_data[3000];
//    short dec_data_len = 0;
//    memset(dec_data, '\0', 3000);
//    memcpy(&dec_data_len, enc_data, sizeof(short));
//    BenDecryption(dec_data_len, (char *)(enc_data + sizeof(short)), dec_data);
//    
//    NSString *plainString = [NSString stringWithUTF8String:dec_data]; // char * -> NSString
//    //		NSLog(@"DEC(%d) %@",[plainString length], plainString);
//    return plainString;
//}

#pragma mark - CALLLOG

+ (void)AddListWithTalkdate:(NSString *)Talkdate FromName:(NSString *)FromName ToName:(NSString *)ToName Talktime:(NSString *)Talktime Num:(NSString *)Num
{
    /****************************************************************
     작업자 : 김혜민 > 박형준
     작업일자 : 2012/06/04 > 2013/11/06
     작업내용 : CALLLOG DB에 최근통화를 추가한다.
     param  - Talkdate(NSString *) : 통화 날짜
     - FromName(NSString *) : 발신자 이름
     - ToName(NSString *) : 수신자 이름
     - Talktime(NSString *) : 통화 시간
     - Num(NSString *) : 상대방 번호
     연관화면 : 최근통화
     ****************************************************************/
    
    
    
    SQLiteDBManager *dbManager = [[SQLiteDBManager alloc] init];
    NSString *dbfilePath = [dbManager getDBFile];
    sqlite3 *database;
    
    if (sqlite3_open([dbfilePath UTF8String], &database) == SQLITE_OK) {
        sqlite3_stmt *statement;
        const char *sql="INSERT INTO CALLLOG (talkdate, fromname, toname, talktime, num) values (?,?,?,?,?)";
        
        if(sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK){
            sqlite3_bind_text(statement, 1, [Talkdate!=nil?Talkdate:@"" UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 2, [FromName!=nil?FromName:@"" UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 3, [ToName!=nil?ToName:@"" UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 4, [Talktime!=nil?Talktime:@"" UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 5, [Num!=nil?Num:@"" UTF8String], -1, SQLITE_TRANSIENT);
            
            if(sqlite3_step(statement) != SQLITE_DONE) {
                NSLog(@"step != done error message : %s",sqlite3_errmsg(database));
            }
        } else {
            NSLog(@"prepare != ok error message : %s",sqlite3_errmsg(database));
        }
        sqlite3_finalize(statement);
    } else {
        NSLog(@"SQL OPEN FAILED code %s",sqlite3_errmsg(database));
    }
    //	[dbManager release];
    sqlite3_close(database);
    
}

+ (void)removeCallLogRecordWithId:(int)Id all:(BOOL)all
{
    /****************************************************************
     작업자 : 김혜민 > 박형준
     작업일자 : 2012/06/04 > 2013/11/06
     작업내용 : CALLLOG DB에서 해당 인덱스의 최근통화를 지운다.
     param  - Id(int) : DB의 인덱스
     연관화면 : 없음
     ****************************************************************/
    
    SQLiteDBManager *dbManager = [[SQLiteDBManager alloc] init];
    NSString *dbfilePath = [dbManager getDBFile];
    sqlite3 *database;
    
    if (sqlite3_open([dbfilePath UTF8String], &database) == SQLITE_OK) {
        sqlite3_stmt *statement;
        const char *sql;
        
        BOOL deleteAll = (Id == 0 && all == YES);
        if(deleteAll) 	{
            sql = "DELETE FROM CALLLOG";
        }
        else {
            sql = "DELETE FROM CALLLOG WHERE id=?";
        }
        
        if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
            if (!deleteAll) {
                sqlite3_bind_int(statement, 1, Id);
            }
            if (sqlite3_step(statement) != SQLITE_DONE) {
                NSLog(@"step != done error message : %s",sqlite3_errmsg(database));
            }
        } else {
            NSLog(@"prepare != ok error message : %s",sqlite3_errmsg(database));
        }
        sqlite3_finalize(statement);
    } else {
        NSLog(@"SQL OPEN FAILED code %s",sqlite3_errmsg(database));
    }
    //	[dbManager release];
    sqlite3_close(database);
}

+ (void)removeCallLogRecords:(NSArray*)array
{
    
    SQLiteDBManager *dbManager = [[SQLiteDBManager alloc] init];
    NSString *dbfilePath = [dbManager getDBFile];
    sqlite3 *database;
    
    if (sqlite3_open([dbfilePath UTF8String], &database) == SQLITE_OK) {
        sqlite3_stmt *statement;
        const char *sql = "DELETE FROM CALLLOG WHERE id=?";
        
        if(sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_exec(database, "BEGIN", 0, 0, 0);
            
            for(NSNumber *idNumber in array) {
                sqlite3_bind_int(statement, 1, [idNumber intValue]);
                
                if(sqlite3_step(statement) != SQLITE_DONE) {
                    NSLog(@"step != done error message : %s",sqlite3_errmsg(database));
                }
                sqlite3_clear_bindings(statement);
                sqlite3_reset(statement);
            }
            sqlite3_exec(database, "COMMIT", 0, 0, 0);
            
        } else {
            NSLog(@"prepare != ok error message : %s",sqlite3_errmsg(database));
        }
        sqlite3_finalize(statement);
        
    } else {
        NSLog(@"SQL OPEN FAILED code %s",sqlite3_errmsg(database));
    }
    sqlite3_close(database);
    //    [dbManager release];
}

+ (NSArray *)getLog
{
    /****************************************************************
     작업자 : 김혜민 > 박형준
     작업일자 : 2012/06/04 > 2013/11/06
     작업내용 : CALLLOG DB에서 최근통화를 가져온다.
     연관화면 : 없음
     ****************************************************************/
    
    NSLog(@"getlog");
    SQLiteDBManager *dbManager = [[SQLiteDBManager alloc] init];
    NSString *dbfilePath = [dbManager getDBFile];
    sqlite3 *database;
    
    // select한 값을 배열로 저장
    NSMutableArray *resultArray = [NSMutableArray array];
    
    if (sqlite3_open([dbfilePath UTF8String], &database) == SQLITE_OK) {
        
        sqlite3_stmt *statement;
        const char *sql = "SELECT id, talkdate, fromname, toname, talktime, num FROM CALLLOG order by id desc limit 100";
        
        if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithInt:sqlite3_column_int(statement, 0)],@"id",
                                     [NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 1)!=nil?(char *)sqlite3_column_text(statement, 1):"")],@"talkdate",
                                     [NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 2)!=nil?(char *)sqlite3_column_text(statement, 2):"")],@"fromname",
                                     [NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 3)!=nil?(char *)sqlite3_column_text(statement, 3):"")],@"toname",
                                     [NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 4)!=nil?(char *)sqlite3_column_text(statement, 4):"")],@"talktime",
                                     [NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 5)!=nil?(char *)sqlite3_column_text(statement, 5):"")],@"num",
//                                     [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)],@"talkdate",
//                                     [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)],@"fromname",
//                                     [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)],@"toname",
//                                     [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)],@"talktime",
//                                     [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)],@"num",
                                     nil];
                
                
                [resultArray addObject:dic];
            }
        } else {
            NSLog(@"prepare != ok error message : %s",sqlite3_errmsg(database));
        }
        sqlite3_finalize(statement);
    } else {
        NSLog(@"SQL OPEN FAILED code %s",sqlite3_errmsg(database));
    }
    //	[dbManager release];
    sqlite3_close(database);
    return resultArray;
    
}


#pragma mark - Contact / Organize / Favorite

+ (NSMutableArray *)getOrganizing
{
    /****************************************************************
     작업자 : 김혜민 > 박형준
     작업일자 : 2012/06/04 > 2013/11/05
     작업내용 : ORGANIZE DB에서 조직도를 가져온다.
     연관화면 : 조직도
     ****************************************************************/

	SQLiteDBManager *dbManager = [[SQLiteDBManager alloc] init];
	NSString *dbfilePath = [dbManager getDBFile];
	sqlite3 *database;
	NSMutableArray *resultArray = [NSMutableArray array];
	
	if (sqlite3_open([dbfilePath UTF8String], &database) == SQLITE_OK) {
        const char *sql = "SELECT id, mycode, parentcode, shortname, newfield1 FROM ORGANIZE group by mycode";
		sqlite3_stmt *statement;
		
		if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithInt:sqlite3_column_int(statement, 0)],@"id",
                                     [NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 1)!=nil?(char *)sqlite3_column_text(statement, 1):"")],@"mycode",
                                     [NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 2)!=nil?(char *)sqlite3_column_text(statement, 2):"")],@"parentcode",
//                                     [dbManager decryptString:((char *)sqlite3_column_text(statement, 3)!=nil?(char *)sqlite3_column_text(statement, 3):"")],@"shortname",
                                     [AESExtention aesDecryptString:[NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 3)!=nil?(char *)sqlite3_column_text(statement, 3):"")]],@"shortname",
                                     [NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 4)!=nil?(char *)sqlite3_column_text(statement, 4):"")],@"newfield1",
                                     nil];
                
                [resultArray addObject:dic];
            }
        } else {
			NSLog(@"prepare != ok error message : %s",sqlite3_errmsg(database));
		}
		sqlite3_finalize(statement);

    } else {
		NSLog(@"SQL OPEN FAILED code %s",sqlite3_errmsg(database));
	}
	sqlite3_close(database);
//    [dbManager release];
	return resultArray;
}


+ (void)addColumns{
    
    SQLiteDBManager *dbManager = [[SQLiteDBManager alloc] init];
    NSString *dbfilePath = [dbManager getDBFile];
    sqlite3 *database;
//    NSMutableArray *resultArray = [NSMutableArray array];
    
    if (sqlite3_open([dbfilePath UTF8String], &database) == SQLITE_OK) {
        
        sqlite3_stmt *statement;
        
        BOOL checkColumn = [self checkColumnAdds];
        if (checkColumn==YES) {
            
            NSLog(@"Column alredy added");
            
        }
        else
        {
            NSString *updateSQL = [NSString stringWithFormat: @"ALTER TABLE CONTACT ADD COLUMN newfield4 TEXT"];
            const char *update_stmt = [updateSQL UTF8String];
            sqlite3_prepare_v2(database, update_stmt, -1, &statement, NULL);
            if(sqlite3_step(statement)==SQLITE_DONE)
            {
                NSLog(@"Column added");
                
            }
            else
            {
                NSLog(@"Column not added");
                NSLog(@"Error %s while preparing statement", sqlite3_errmsg(database));
                
            }
            
            updateSQL = [NSString stringWithFormat: @"ALTER TABLE CONTACT ADD COLUMN newfield5 TEXT"];
            update_stmt = [updateSQL UTF8String];
            sqlite3_prepare_v2(database, update_stmt, -1, &statement, NULL);
            if(sqlite3_step(statement)==SQLITE_DONE)
            {
                NSLog(@"Column added");
                
            }
            else
            {
                NSLog(@"Column not added");
                NSLog(@"Error %s while preparing statement", sqlite3_errmsg(database));
                
            }
            
            updateSQL = [NSString stringWithFormat: @"ALTER TABLE CONTACT ADD COLUMN newfield6 TEXT"];
            update_stmt = [updateSQL UTF8String];
            sqlite3_prepare_v2(database, update_stmt, -1, &statement, NULL);
            if(sqlite3_step(statement)==SQLITE_DONE)
            {
                NSLog(@"Column added");
                
            }
            else
            {
                NSLog(@"Column not added");
                NSLog(@"Error %s while preparing statement", sqlite3_errmsg(database));
                
            }
            
            updateSQL = [NSString stringWithFormat: @"ALTER TABLE CONTACT ADD COLUMN newfield7 TEXT"];
            update_stmt = [updateSQL UTF8String];
            sqlite3_prepare_v2(database, update_stmt, -1, &statement, NULL);
            if(sqlite3_step(statement)==SQLITE_DONE)
            {
                NSLog(@"Column added");
                
            }
            else
            {
                NSLog(@"Column not added");
                NSLog(@"Error %s while preparing statement", sqlite3_errmsg(database));
                
            }
            
            updateSQL = [NSString stringWithFormat: @"ALTER TABLE CONTACT ADD COLUMN newfield8 TEXT"];
            update_stmt = [updateSQL UTF8String];
            sqlite3_prepare_v2(database, update_stmt, -1, &statement, NULL);
            if(sqlite3_step(statement)==SQLITE_DONE)
            {
                NSLog(@"Column added");
                
            }
            else
            {
                NSLog(@"Column not added");
                NSLog(@"Error %s while preparing statement", sqlite3_errmsg(database));
                
            }
            
            updateSQL = [NSString stringWithFormat: @"ALTER TABLE CONTACT ADD COLUMN newfield9 TEXT"];
            update_stmt = [updateSQL UTF8String];
            sqlite3_prepare_v2(database, update_stmt, -1, &statement, NULL);
            if(sqlite3_step(statement)==SQLITE_DONE)
            {
                NSLog(@"Column added");
                
            }
            else
            {
                NSLog(@"Column not added");
                NSLog(@"Error %s while preparing statement", sqlite3_errmsg(database));
                
            }
            
            updateSQL = [NSString stringWithFormat: @"ALTER TABLE CONTACT ADD COLUMN newfield10 TEXT"];
            update_stmt = [updateSQL UTF8String];
            sqlite3_prepare_v2(database, update_stmt, -1, &statement, NULL);
            if(sqlite3_step(statement)==SQLITE_DONE)
            {
                NSLog(@"Column added");
                
            }
            else
            {
                NSLog(@"Column not added");
                NSLog(@"Error %s while preparing statement", sqlite3_errmsg(database));
                
            }
            
            
        }
        
        
        
        
    } else {
        NSLog(@"SQL OPEN FAILED code %s",sqlite3_errmsg(database));
    }
    sqlite3_close(database);
}

+ (NSMutableArray *)getList
{
    
    SQLiteDBManager *dbManager = [[SQLiteDBManager alloc] init];
	NSString *dbfilePath = [dbManager getDBFile];
	sqlite3 *database;
	NSMutableArray *resultArray = [NSMutableArray array];

    if (sqlite3_open([dbfilePath UTF8String], &database) == SQLITE_OK) {
        
        sqlite3_stmt *statement;
        
        BOOL checkColumn = [self checkColumnAdds];
        if (checkColumn==YES) {
            
            NSLog(@"Column alredy added");
            
        }
        else
        {
            NSString *updateSQL = [NSString stringWithFormat: @"ALTER TABLE CONTACT ADD COLUMN newfield4 TEXT"];
            const char *update_stmt = [updateSQL UTF8String];
            sqlite3_prepare_v2(database, update_stmt, -1, &statement, NULL);
            if(sqlite3_step(statement)==SQLITE_DONE)
            {
                NSLog(@"Column added");
                
            }
            else
            {
                NSLog(@"Column not added");
                NSLog(@"Error %s while preparing statement", sqlite3_errmsg(database));
                
            }
            
            updateSQL = [NSString stringWithFormat: @"ALTER TABLE CONTACT ADD COLUMN newfield5 TEXT"];
            update_stmt = [updateSQL UTF8String];
            sqlite3_prepare_v2(database, update_stmt, -1, &statement, NULL);
            if(sqlite3_step(statement)==SQLITE_DONE)
            {
                NSLog(@"Column added");
                
            }
            else
            {
                NSLog(@"Column not added");
                NSLog(@"Error %s while preparing statement", sqlite3_errmsg(database));
                
            }
            
            updateSQL = [NSString stringWithFormat: @"ALTER TABLE CONTACT ADD COLUMN newfield6 TEXT"];
            update_stmt = [updateSQL UTF8String];
            sqlite3_prepare_v2(database, update_stmt, -1, &statement, NULL);
            if(sqlite3_step(statement)==SQLITE_DONE)
            {
                NSLog(@"Column added");
                
            }
            else
            {
                NSLog(@"Column not added");
                NSLog(@"Error %s while preparing statement", sqlite3_errmsg(database));
                
            }
            
            updateSQL = [NSString stringWithFormat: @"ALTER TABLE CONTACT ADD COLUMN newfield7 TEXT"];
            update_stmt = [updateSQL UTF8String];
            sqlite3_prepare_v2(database, update_stmt, -1, &statement, NULL);
            if(sqlite3_step(statement)==SQLITE_DONE)
            {
                NSLog(@"Column added");
                
            }
            else
            {
                NSLog(@"Column not added");
                NSLog(@"Error %s while preparing statement", sqlite3_errmsg(database));
                
            }
            
            updateSQL = [NSString stringWithFormat: @"ALTER TABLE CONTACT ADD COLUMN newfield8 TEXT"];
            update_stmt = [updateSQL UTF8String];
            sqlite3_prepare_v2(database, update_stmt, -1, &statement, NULL);
            if(sqlite3_step(statement)==SQLITE_DONE)
            {
                NSLog(@"Column added");
                
            }
            else
            {
                NSLog(@"Column not added");
                NSLog(@"Error %s while preparing statement", sqlite3_errmsg(database));
                
            }
            
            updateSQL = [NSString stringWithFormat: @"ALTER TABLE CONTACT ADD COLUMN newfield9 TEXT"];
            update_stmt = [updateSQL UTF8String];
            sqlite3_prepare_v2(database, update_stmt, -1, &statement, NULL);
            if(sqlite3_step(statement)==SQLITE_DONE)
            {
                NSLog(@"Column added");
                
            }
            else
            {
                NSLog(@"Column not added");
                NSLog(@"Error %s while preparing statement", sqlite3_errmsg(database));
                
            }
            
            updateSQL = [NSString stringWithFormat: @"ALTER TABLE CONTACT ADD COLUMN newfield10 TEXT"];
            update_stmt = [updateSQL UTF8String];
            sqlite3_prepare_v2(database, update_stmt, -1, &statement, NULL);
            if(sqlite3_step(statement)==SQLITE_DONE)
            {
                NSLog(@"Column added");
                
            }
            else
            {
                NSLog(@"Column not added");
                NSLog(@"Error %s while preparing statement", sqlite3_errmsg(database));
                
            }
            
            
        }
    
        
		const char *sql = "SELECT id,name,email,cellphone,companyphone,deptcode,team,position,grade2,uniqueid,profileimage,available,favorite,newfield1,newfield2,newfield3,newfield4 FROM CONTACT group by uniqueid";
        
        if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithInt:sqlite3_column_int(statement, 0)],@"id",
//                                     [dbManager decryptString:((char *)sqlite3_column_text(statement, 1)!=nil?(char *)sqlite3_column_text(statement, 1):"")],@"name",
//                                     [dbManager decryptString:((char *)sqlite3_column_text(statement, 2)!=nil?(char *)sqlite3_column_text(statement, 2):"")],@"email",
//                                     [dbManager decryptString:((char *)sqlite3_column_text(statement, 3)!=nil?(char *)sqlite3_column_text(statement, 3):"")],@"cellphone",
//                                     [dbManager decryptString:((char *)sqlite3_column_text(statement, 4)!=nil?(char *)sqlite3_column_text(statement, 4):"")],@"companyphone",
                                     
                                     [AESExtention aesDecryptString:[NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 1)!=nil?(char *)sqlite3_column_text(statement, 1):"")]],@"name",
                                     [AESExtention aesDecryptString:[NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 2)!=nil?(char *)sqlite3_column_text(statement, 2):"")]],@"email",
                                     [AESExtention aesDecryptString:[NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 3)!=nil?(char *)sqlite3_column_text(statement, 3):"")]],@"cellphone",
                                     [AESExtention aesDecryptString:[NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 4)!=nil?(char *)sqlite3_column_text(statement, 4):"")]],@"companyphone",
                                     [NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 5)!=nil?(char *)sqlite3_column_text(statement, 5):"")],@"deptcode",
                                     [NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 6)!=nil?(char *)sqlite3_column_text(statement, 6):"")],@"team",
                                     [NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 7)!=nil?(char *)sqlite3_column_text(statement, 7):"")],@"position",
                                     [NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 8)!=nil?(char *)sqlite3_column_text(statement, 8):"")],@"grade2",
                                     [NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 9)!=nil?(char *)sqlite3_column_text(statement, 9):"")],@"uniqueid",
                                     [NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 10)!=nil?(char *)sqlite3_column_text(statement, 10):"")],@"profileimage",
                                     [NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 11)!=nil?(char *)sqlite3_column_text(statement, 11):"")],@"available",
                                     [NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 12)!=nil?(char *)sqlite3_column_text(statement, 12):"")],@"favorite",
                                     [NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 13)!=nil?(char *)sqlite3_column_text(statement, 13):"")],@"newfield1",
                                     [NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 14)!=nil?(char *)sqlite3_column_text(statement, 14):"")],@"newfield2",
                                     [NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 15)!=nil?(char *)sqlite3_column_text(statement, 15):"")],@"newfield3",
                                     [NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 16)!=nil?(char *)sqlite3_column_text(statement, 16):"")],@"newfield4",
                                     nil];

                [resultArray addObject:dic];
            }
        } else {
			NSLog(@"prepare != ok error message : %s",sqlite3_errmsg(database));
		}
		sqlite3_finalize(statement);
		
    } else {
		NSLog(@"SQL OPEN FAILED code %s",sqlite3_errmsg(database));
	}
	sqlite3_close(database);
//    [dbManager release];
	return resultArray;
}

+ (BOOL)addDept:(NSMutableArray *)array
{
    /****************************************************************
     작업자 : 김혜민 > 박형준
     작업일자 : 2012/06/04 > 2013/11/06
     작업내용 : 조직 배열을 ORGANIZE DB에 추가
     param  - array(NSMutableArray *) : 조직 배열
     연관화면 : 조직도
     ****************************************************************/
	BOOL success = NO;
    SQLiteDBManager *dbManager = [[SQLiteDBManager alloc] init];
	NSString *dbfilePath = [dbManager getDBFile];
	sqlite3 *database;
    
    if (sqlite3_open([dbfilePath UTF8String], &database) == SQLITE_OK) {
		sqlite3_stmt *statement;
		const char *sql = "INSERT INTO ORGANIZE (mycode, parentcode, shortname, newfield1) values (?,?,?,?)";

		if(sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK){
			sqlite3_exec(database, "BEGIN", 0, 0, 0);

			for(NSDictionary *forDic in array) {
				if([forDic[@"close"] isEqualToString:@"N"]) {
					NSString *MyCd = forDic[@"deptcode"];
					NSString *PaCd = forDic[@"parentdeptcode"];
					NSString *Sname = forDic[@"deptname"];
//                    char *encSname = [dbManager encryptString:Sname!=nil&&![Sname isKindOfClass:[NSNull class]]?Sname:@""];
					NSString *sequence = forDic[@"sequence"];
					
					sqlite3_bind_text(statement, 1, [MyCd!=nil&&![MyCd isKindOfClass:[NSNull class]]?MyCd:@"" UTF8String], -1, SQLITE_TRANSIENT);
					sqlite3_bind_text(statement, 2, [PaCd!=nil&&![PaCd isKindOfClass:[NSNull class]]?PaCd:@"" UTF8String], -1, SQLITE_TRANSIENT);
//					sqlite3_bind_blob(statement, 3, (void*)encSname, -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 3, [Sname!=nil&&![Sname isKindOfClass:[NSNull class]]?[AESExtention aesEncryptString:Sname]:@"" UTF8String], -1, SQLITE_TRANSIENT);
					sqlite3_bind_text(statement, 4, [sequence!=nil&&![sequence isKindOfClass:[NSNull class]]?sequence:@"" UTF8String], -1, SQLITE_TRANSIENT);

					if(sqlite3_step(statement) != SQLITE_DONE) {
						NSLog(@"step != done error message : %s",sqlite3_errmsg(database));
					}
					sqlite3_clear_bindings(statement);
					sqlite3_reset(statement);

//					FREEMEM(encSname);
				}
			}
			
			if(sqlite3_exec(database, "COMMIT", 0, 0, 0) == SQLITE_OK) {
				success = YES;
			}
		} else {
			NSLog(@"prepare != ok error message : %s",sqlite3_errmsg(database));
		}
		sqlite3_finalize(statement);

    } else {
		NSLog(@"SQL OPEN FAILED code %s",sqlite3_errmsg(database));
	}
	sqlite3_close(database);	
//    [dbManager release];
    
    
	return success;
}



+ (void)addDeptDic:(NSDictionary *)dic
{
    
    /****************************************************************
     작업자 : 김혜민 > 박형준
     작업일자 : 2012/06/04 > 2013/11/06
     작업내용 : 조직 배열을 ORGANIZE DB에 추가
     param  - array(NSMutableArray *) : 조직 배열
     연관화면 : 없음
     ****************************************************************/
	
	if([dic[@"close"] isEqualToString:@"N"]) {
		SQLiteDBManager *dbManager = [[SQLiteDBManager alloc] init];
		NSString *dbfilePath = [dbManager getDBFile];
		sqlite3 *database;
	
		if (sqlite3_open([dbfilePath UTF8String], &database) == SQLITE_OK) {
			sqlite3_stmt *statement;
			const char *sql = "INSERT INTO ORGANIZE (mycode, parentcode, shortname,newfield1) values (?,?,?,?)";
			
			if(sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
				NSString *MyCd = dic[@"deptcode"];
				NSString *PaCd = dic[@"parentdeptcode"];
				NSString *Sname = dic[@"deptname"];
//				char *encSname = [dbManager encryptString:Sname!=nil&&![Sname isKindOfClass:[NSNull class]]?Sname:@""];
				NSString *sequence = dic[@"sequence"];
				
				sqlite3_bind_text(statement, 1, [MyCd!=nil&&![MyCd isKindOfClass:[NSNull class]]?MyCd:@"" UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_text(statement, 2, [PaCd!=nil&&![PaCd isKindOfClass:[NSNull class]]?PaCd:@"" UTF8String], -1, SQLITE_TRANSIENT);
//				sqlite3_bind_blob(statement, 3, (void*)encSname, -1, SQLITE_TRANSIENT);
                	sqlite3_bind_text(statement, 3, [Sname!=nil&&![Sname isKindOfClass:[NSNull class]]?[AESExtention aesEncryptString:Sname]:@"" UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_text(statement, 4, [sequence!=nil&&![sequence isKindOfClass:[NSNull class]]?sequence:@"" UTF8String], -1, SQLITE_TRANSIENT);
				
				if(sqlite3_step(statement) != SQLITE_DONE) {
					NSLog(@"step != done error message : %s",sqlite3_errmsg(database));
				}
//				FREEMEM(encSname);
			} else {
				NSLog(@"prepare != ok error message : %s",sqlite3_errmsg(database));
			}
			sqlite3_finalize(statement);
		} else {
			NSLog(@"SQL OPEN FAILED code %s",sqlite3_errmsg(database));
		}
		sqlite3_close(database);
//		[dbManager release];
	}
}


+ (BOOL)addContact:(NSMutableArray *)array init:(BOOL)init
{
    NSLog(@"addcontact %d",[array count]);
    if(init == NO)
        NSLog(@"array %@",array);
    /****************************************************************
     작업자 : 김혜민 > 박형준
     작업일자 : 2012/06/04 > 2013/11/06
     작업내용 : 주소록 배열을 CONTACT DB에 추가
     param  - array(NSMutableArray *) : 주소록 배열
     연관화면 : 없음
     ****************************************************************/
    BOOL success = NO;
    SQLiteDBManager *dbManager = [[SQLiteDBManager alloc] init];
	NSString *dbfilePath = [dbManager getDBFile];
	sqlite3 *database;
    
    if (sqlite3_open([dbfilePath UTF8String], &database) == SQLITE_OK) {
		sqlite3_stmt *statement;
		const char *sql = "INSERT INTO CONTACT (name,email,cellphone,companyphone,deptcode,team,position,uniqueid,profileimage,available,favorite,grade2,newfield1,newfield2,newfield3,newfield4) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		
		NSMutableArray *profileCacheArray = [NSMutableArray array];
		
		if(sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK){
			sqlite3_exec(database, "BEGIN", 0, 0, 0);
			
			NSDictionary *mydic = [SharedAppDelegate readPlist:@"myinfo"];
			
			for(NSDictionary *forDic in array) {
				if([forDic[@"retirement"]isEqualToString:@"N"]) {
					
					NSString *Name = forDic[@"name"];
					NSString *Email = forDic[@"email"];
					NSString *Cellphone = forDic[@"cellphone"];
					NSString *Companyphone = forDic[@"officephone"];
					NSString *Position = forDic[@"duty"];
					NSString *Department = forDic[@"deptcode"];
					NSString *Team = [[ResourceLoader sharedInstance] searchCode:Department];
					NSString *Uniqueid = forDic[@"uid"];
					NSString *ProfileImage = forDic[@"profileimage"];
					NSString *Available = forDic[@"available"];
					if([Available length] < 1 || Available == nil)
						Available = @"0";
					
					NSString *Favorite = @"0";
					NSString *Grade2 = forDic[@"position"];
					NSString *Info = [forDic[@"employeinfo"]objectFromJSONString][@"msg"];
					NSString *sequence = forDic[@"sequence"];
                    NSString *userlevel = [forDic[@"userlevel"]length]>0?forDic[@"userlevel"]:@"";
                    NSString *app_no = [forDic[@"app_no"]length]>1?forDic[@"app_no"]:@"";
					
//					char *encName = [dbManager encryptString:Name!=nil&&![Name isKindOfClass:[NSNull class]]?Name:@""];
//					char *encEmail = [dbManager encryptString:Email!=nil&&![Email isKindOfClass:[NSNull class]]?Email:@""];
//					char *encCellphone = [dbManager encryptString:Cellphone!=nil&&![Cellphone isKindOfClass:[NSNull class]]?Cellphone:@""];
//					char *encCompanyphone = [dbManager encryptString:Companyphone!=nil&&![Companyphone isKindOfClass:[NSNull class]]?Companyphone:@""];
					
					if([Uniqueid isEqualToString:mydic[@"uid"]]){
						NSLog(@"forDic %@",forDic);
						NSMutableDictionary *newMyinfo = [NSMutableDictionary dictionary];
                        [newMyinfo setObject:Name!=nil&&![Name isKindOfClass:[NSNull class]]?Name:@"" forKey:@"name"];
                        [newMyinfo setObject:Email!=nil&&![Email isKindOfClass:[NSNull class]]?Email:@"" forKey:@"email"];
						[newMyinfo setObject:Cellphone!=nil&&![Cellphone isKindOfClass:[NSNull class]]?Cellphone:@"" forKey:@"cellphone"];
						[newMyinfo setObject:Companyphone!=nil&&![Companyphone isKindOfClass:[NSNull class]]?Companyphone:@"" forKey:@"officephone"];
                        [newMyinfo setObject:Grade2!=nil&&![Grade2 isKindOfClass:[NSNull class]]?Grade2:@"" forKey:@"position"];
                        [newMyinfo setObject:Department!=nil&&![Department isKindOfClass:[NSNull class]]?Department:@"" forKey:@"deptcode"];
                        [newMyinfo setObject:Team!=nil&&![Team isKindOfClass:[NSNull class]]?Team:@"" forKey:@"team"];
						[newMyinfo setObject:mydic[@"uid"]!=nil&&![mydic[@"uid"] isKindOfClass:[NSNull class]]?mydic[@"uid"]:@"" forKey:@"uid"];
						[newMyinfo setObject:mydic[@"sessionkey"]!=nil&&![mydic[@"sessionkey"] isKindOfClass:[NSNull class]]?mydic[@"sessionkey"]:@"" forKey:@"sessionkey"];
                        [newMyinfo setObject:ProfileImage!=nil&&![ProfileImage isKindOfClass:[NSNull class]]?ProfileImage:@"" forKey:@"profileimage"];
                        [newMyinfo setObject:userlevel!=nil&&![userlevel isKindOfClass:[NSNull class]]?userlevel:@"" forKey:@"userlevel"];
                        [newMyinfo setObject:app_no!=nil&&![app_no isKindOfClass:[NSNull class]]?app_no:@"" forKey:@"newfield4"];

                        
						NSLog(@"newMyInfo %@",newMyinfo);
						[SharedAppDelegate writeToPlist:@"myinfo" value:newMyinfo];
					}
					
//					sqlite3_bind_blob(statement, 1, (void*)encName, -1, SQLITE_TRANSIENT);
//					sqlite3_bind_blob(statement, 2, (void*)encEmail, -1, SQLITE_TRANSIENT);
//					sqlite3_bind_blob(statement, 3, (void*)encCellphone, -1, SQLITE_TRANSIENT);
//					sqlite3_bind_blob(statement, 4, (void*)encCompanyphone, -1, SQLITE_TRANSIENT);
                    
                    sqlite3_bind_text(statement, 1, [Name!=nil&&![Name isKindOfClass:[NSNull class]]?[AESExtention aesEncryptString:Name]:@"" UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 2, [Email!=nil&&![Email isKindOfClass:[NSNull class]]?[AESExtention aesEncryptString:Email]:@"" UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 3, [Cellphone!=nil&&![Cellphone isKindOfClass:[NSNull class]]?[AESExtention aesEncryptString:Cellphone]:@"" UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 4, [Companyphone!=nil&&![Companyphone isKindOfClass:[NSNull class]]?[AESExtention aesEncryptString:Companyphone]:@"" UTF8String], -1, SQLITE_TRANSIENT);
					sqlite3_bind_text(statement, 5, [Department!=nil&&![Department isKindOfClass:[NSNull class]]?Department:@"" UTF8String], -1, SQLITE_TRANSIENT);
					sqlite3_bind_text(statement, 6, [Team!=nil&&![Team isKindOfClass:[NSNull class]]?Team:@"" UTF8String], -1, SQLITE_TRANSIENT);
					sqlite3_bind_text(statement, 7, [Position!=nil&&![Position isKindOfClass:[NSNull class]]?Position:@"" UTF8String], -1, SQLITE_TRANSIENT);
					sqlite3_bind_text(statement, 8, [Uniqueid!=nil&&![Uniqueid isKindOfClass:[NSNull class]]?Uniqueid:@"" UTF8String], -1, SQLITE_TRANSIENT);
					sqlite3_bind_text(statement, 9, [ProfileImage!=nil&&![ProfileImage isKindOfClass:[NSNull class]]?ProfileImage:@"" UTF8String], -1, SQLITE_TRANSIENT);
					sqlite3_bind_text(statement, 10, [Available!=nil&&![Available isKindOfClass:[NSNull class]]?Available:@"" UTF8String], -1, SQLITE_TRANSIENT);
					sqlite3_bind_text(statement, 11, [Favorite!=nil&&![Favorite isKindOfClass:[NSNull class]]?Favorite:@"" UTF8String], -1, SQLITE_TRANSIENT);
					sqlite3_bind_text(statement, 12, [Grade2!=nil&&![Grade2 isKindOfClass:[NSNull class]]?Grade2:@"" UTF8String], -1, SQLITE_TRANSIENT);
					sqlite3_bind_text(statement, 13, [Info!=nil&&![Info isKindOfClass:[NSNull class]]?Info:@"" UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 14, [sequence!=nil&&![sequence isKindOfClass:[NSNull class]]?sequence:@"" UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 15, [userlevel!=nil&&![userlevel isKindOfClass:[NSNull class]]?userlevel:@"" UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 16, [app_no!=nil&&![app_no isKindOfClass:[NSNull class]]?app_no:@"" UTF8String], -1, SQLITE_TRANSIENT);
					
					if(sqlite3_step(statement) != SQLITE_DONE) {
						NSLog(@"step != done error message : %s",sqlite3_errmsg(database));
					}
					sqlite3_clear_bindings(statement);
					sqlite3_reset(statement);
					
//					FREEMEM(encName);
//					FREEMEM(encEmail);
//					FREEMEM(encCellphone);
//					FREEMEM(encCompanyphone);
					
					[profileCacheArray addObject:@{@"uid": Uniqueid, @"profileimage": ProfileImage}];
				}
			}
			
			if(sqlite3_exec(database, "COMMIT", 0, 0, 0) == SQLITE_OK) {
				success = YES;
			}
			if (YES == init) {
				[[ResourceLoader sharedInstance] setCache_profileImageDirectory:profileCacheArray];
			} else {
				[[ResourceLoader sharedInstance].cache_profileImageDirectory addObjectsFromArray:profileCacheArray];
			}
			[[NSNotificationCenter defaultCenter] postNotificationName:@"refreshProfiles" object:nil];
		} else {
			NSLog(@"prepare != ok error message : %s",sqlite3_errmsg(database));
		}
		sqlite3_finalize(statement);
	} else {
		NSLog(@"SQL OPEN FAILED code %s",sqlite3_errmsg(database));
	}
	sqlite3_close(database);
//    [dbManager release];
    
    
	return success;
}

+ (void)addContactDic:(NSDictionary *)dic
{
    /****************************************************************
     작업자 : 김혜민 > 박형준
     작업일자 : 2012/06/04 > 2013/11/06
     작업내용 : 주소록 배열을 CONTACT DB에 추가
     param  - array(NSMutableArray *) : 주소록 배열
     연관화면 : 없음
     ****************************************************************/
	if([dic[@"retirement"] isEqualToString:@"N"]) {
		
		SQLiteDBManager *dbManager = [[SQLiteDBManager alloc] init];
		NSString *dbfilePath = [dbManager getDBFile];
		sqlite3 *database;
		
		if (sqlite3_open([dbfilePath UTF8String], &database) == SQLITE_OK) {
			sqlite3_stmt *statement;
			const char *sql = "INSERT INTO CONTACT (name,email,cellphone,companyphone,deptcode,team,position,uniqueid,profileimage,available,favorite,grade2,newfield1,newfield2,newfield3,newfield4) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
			
			NSString *Name = dic[@"name"];
			NSString *Email = dic[@"email"];
			NSString *Cellphone = dic[@"cellphone"];
			NSString *Companyphone = dic[@"officephone"];
			NSString *Position = dic[@"duty"];
			NSString *Department = dic[@"deptcode"];
			NSString *Team = [[ResourceLoader sharedInstance] searchCode:Department];
			NSString *Uniqueid = dic[@"uid"];
			NSString *ProfileImage = dic[@"profileimage"];
			NSString *Available = dic[@"available"];
			if([Available length] < 1 || Available == nil)
				Available = @"0";
			
			NSString *Info = [dic[@"employeinfo"]objectFromJSONString][@"msg"];
			NSString *Favorite = @"0";
			NSString *Grade2 = dic[@"position"];
			NSString *sequence = dic[@"sequence"];
            NSString *userlevel = [dic[@"userlevel"]length]>0?dic[@"userlevel"]:@"";
            NSString *app_no = [dic[@"app_no"]length]>1?dic[@"app_no"]:@"";
			
//			char *encName = [dbManager encryptString:Name!=nil&&![Name isKindOfClass:[NSNull class]]?Name:@""];
//			char *encEmail = [dbManager encryptString:Email!=nil&&![Email isKindOfClass:[NSNull class]]?Email:@""];
//			char *encCellphone = [dbManager encryptString:Cellphone!=nil&&![Cellphone isKindOfClass:[NSNull class]]?Cellphone:@""];
//			char *encCompanyphone = [dbManager encryptString:Companyphone!=nil&&![Companyphone isKindOfClass:[NSNull class]]?Companyphone:@""];
			
			if(sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK){
//				sqlite3_bind_blob(statement, 1, (void*)encName, -1, SQLITE_TRANSIENT);
//				sqlite3_bind_blob(statement, 2, (void*)encEmail, -1, SQLITE_TRANSIENT);
//				sqlite3_bind_blob(statement, 3, (void*)encCellphone, -1, SQLITE_TRANSIENT);
//				sqlite3_bind_blob(statement, 4, (void*)encCompanyphone, -1, SQLITE_TRANSIENT);
//                
                sqlite3_bind_text(statement, 1, [Name!=nil&&![Name isKindOfClass:[NSNull class]]?[AESExtention aesEncryptString:Name]:@"" UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 2, [Email!=nil&&![Email isKindOfClass:[NSNull class]]?[AESExtention aesEncryptString:Email]:@"" UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 3, [Cellphone!=nil&&![Cellphone isKindOfClass:[NSNull class]]?[AESExtention aesEncryptString:Cellphone]:@"" UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 4, [Companyphone!=nil&&![Companyphone isKindOfClass:[NSNull class]]?[AESExtention aesEncryptString:Companyphone]:@"" UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_text(statement, 5, [Department!=nil&&![Department isKindOfClass:[NSNull class]]?Department:@"" UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_text(statement, 6, [Team!=nil&&![Team isKindOfClass:[NSNull class]]?Team:@"" UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_text(statement, 7, [Position!=nil&&![Position isKindOfClass:[NSNull class]]?Position:@"" UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_text(statement, 8, [Uniqueid!=nil&&![Uniqueid isKindOfClass:[NSNull class]]?Uniqueid:@"" UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_text(statement, 9, [ProfileImage!=nil&&![ProfileImage isKindOfClass:[NSNull class]]?ProfileImage:@"" UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_text(statement, 10, [Available!=nil&&![Available isKindOfClass:[NSNull class]]?Available:@"" UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_text(statement, 11, [Favorite!=nil&&![Favorite isKindOfClass:[NSNull class]]?Favorite:@"" UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_text(statement, 12, [Grade2!=nil&&![Grade2 isKindOfClass:[NSNull class]]?Grade2:@"" UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_text(statement, 13, [Info!=nil&&![Info isKindOfClass:[NSNull class]]?Info:@"" UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 14, [sequence!=nil&&![sequence isKindOfClass:[NSNull class]]?sequence:@"" UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 15, [userlevel!=nil&&![userlevel isKindOfClass:[NSNull class]]?userlevel:@"" UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 16, [app_no!=nil&&![app_no isKindOfClass:[NSNull class]]?app_no:@"" UTF8String], -1, SQLITE_TRANSIENT);
                
				
				if(sqlite3_step(statement) != SQLITE_DONE) {
					NSLog(@"step != done error message : %s",sqlite3_errmsg(database));
				}
			} else {
				NSLog(@"prepare != ok error message : %s",sqlite3_errmsg(database));
			}
			sqlite3_finalize(statement);

//			FREEMEM(encName);
//			FREEMEM(encEmail);
//			FREEMEM(encCellphone);
//			FREEMEM(encCompanyphone);
			
			[[[ResourceLoader sharedInstance] cache_profileImageDirectory] addObject:@{@"uid": Uniqueid, @"profileimage": ProfileImage}];
			[[NSNotificationCenter defaultCenter] postNotificationName:@"refreshProfiles" object:nil];
		} else {
			NSLog(@"SQL OPEN FAILED code %s",sqlite3_errmsg(database));
		}
		sqlite3_close(database);
//		[dbManager release];
	}

}


+ (void)removeContactWithUid:(NSString *)uid all:(BOOL)all {

    /****************************************************************
     작업자 : 김혜민 > 박형준
     작업일자 : 2012/06/04 > 2013/11/06
     작업내용 : CONTACT DB에서 사번에 맞춰 삭제
     param  - uid(NSString *) : 사번
     연관화면 : 없음
     ****************************************************************/
    
    SQLiteDBManager *dbManager = [[SQLiteDBManager alloc] init];
	NSString *dbfilePath = [dbManager getDBFile];
	sqlite3 *database;
	
    if (sqlite3_open([dbfilePath UTF8String], &database) == SQLITE_OK) {
		sqlite3_stmt *statement;
		const char *sql;
	
		BOOL deleteAll = ([uid isEqualToString:@"0"] && all == YES);
		if(deleteAll) {
			sql = "DELETE FROM CONTACT";
			[[[ResourceLoader sharedInstance] cache_profileImageDirectory] removeAllObjects];
			[[NSNotificationCenter defaultCenter] postNotificationName:@"refreshProfiles" object:nil];
		} else {
			sql = "DELETE FROM CONTACT WHERE uniqueid=?";
			[[ResourceLoader sharedInstance] cache_profileImageDirectoryDeleteObjectAtUID:uid];
		}
		
		if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
			if (!deleteAll) {
				sqlite3_bind_text(statement, 1, [uid UTF8String], -1, SQLITE_TRANSIENT);
			}
			
			if (sqlite3_step(statement) != SQLITE_DONE) {
				NSLog(@"step != done error message : %s",sqlite3_errmsg(database));
			}
		} else {
			NSLog(@"prepare != ok error message : %s",sqlite3_errmsg(database));
		}
		sqlite3_finalize(statement);
	} else {
		NSLog(@"SQL OPEN FAILED code %s",sqlite3_errmsg(database));
	}
	sqlite3_close(database);
//	[dbManager release];
}

+ (BOOL)removeContact:(NSArray*)array {
	BOOL success = NO;
	SQLiteDBManager *dbManager = [[SQLiteDBManager alloc] init];
	NSString *dbfilePath = [dbManager getDBFile];
	sqlite3 *database;
    
    if (sqlite3_open([dbfilePath UTF8String], &database) == SQLITE_OK) {
		sqlite3_stmt *statement;
		const char *sql = "DELETE FROM CONTACT WHERE uniqueid=?";
		
		if(sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK){
			sqlite3_exec(database, "BEGIN", 0, 0, 0);
			
			for(NSString *uid in array) {
				if ([uid length] < 1) {
					continue;
				}
				sqlite3_bind_text(statement, 1, [uid UTF8String], -1, SQLITE_TRANSIENT);
				
				if(sqlite3_step(statement) != SQLITE_DONE) {
					NSLog(@"step != done error message : %s",sqlite3_errmsg(database));
				}
				sqlite3_clear_bindings(statement);
				sqlite3_reset(statement);
			}
			if (sqlite3_exec(database, "COMMIT", 0, 0, 0) == SQLITE_OK) {
				success = YES;
			}
			
		} else {
			NSLog(@"prepare != ok error message : %s",sqlite3_errmsg(database));
		}
		sqlite3_finalize(statement);
		
    } else {
		NSLog(@"SQL OPEN FAILED code %s",sqlite3_errmsg(database));
	}
	sqlite3_close(database);
//    [dbManager release];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"refreshProfiles" object:nil];
	return success;
}

+ (void)removeDeptWithCode:(NSString *)code all:(BOOL)all {
    
    /****************************************************************
     작업자 : 김혜민 > 박형준
     작업일자 : 2012/06/04 > 2013/11/06
     작업내용 : ORGANIZE DB에서 코드에 맞춰 삭제
     param  - code(NSString *) : 조직코드
     연관화면 : 없음
     ****************************************************************/
    
    SQLiteDBManager *dbManager = [[SQLiteDBManager alloc] init];
	NSString *dbfilePath = [dbManager getDBFile];
	sqlite3 *database;
    
    if (sqlite3_open([dbfilePath UTF8String], &database) == SQLITE_OK) {
		sqlite3_stmt *statement;
		const char *sql;
		
		BOOL deleteAll = ([code isEqualToString:@"0"] && all == YES);

		if(deleteAll) {
			sql = "DELETE FROM ORGANIZE";
		} else {
			sql = "DELETE FROM ORGANIZE WHERE mycode=?";
		}
		
		if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
			if (!deleteAll) {
				sqlite3_bind_text(statement, 1, [code UTF8String], -1, SQLITE_TRANSIENT);
			}

			if (sqlite3_step(statement) != SQLITE_DONE) {
				NSLog(@"step != done error message : %s",sqlite3_errmsg(database));
			}
		} else {
			NSLog(@"prepare != ok error message : %s",sqlite3_errmsg(database));
		}
		sqlite3_finalize(statement);
	} else {
		NSLog(@"SQL OPEN FAILED code %s",sqlite3_errmsg(database));
	}
	sqlite3_close(database);
//	[dbManager release];
}

+ (BOOL)removeDept:(NSArray*)array {
	BOOL success = NO;
	SQLiteDBManager *dbManager = [[SQLiteDBManager alloc] init];
	NSString *dbfilePath = [dbManager getDBFile];
	sqlite3 *database;
    
    if (sqlite3_open([dbfilePath UTF8String], &database) == SQLITE_OK) {
		sqlite3_stmt *statement;
		const char *sql = "DELETE FROM ORGANIZE WHERE mycode=?";
		
		if(sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK){
			sqlite3_exec(database, "BEGIN", 0, 0, 0);
			
			for(NSString *code in array) {
				if ([code length] < 1) {
					continue;
				}
				sqlite3_bind_text(statement, 1, [code UTF8String], -1, SQLITE_TRANSIENT);
				
				if(sqlite3_step(statement) != SQLITE_DONE) {
					NSLog(@"step != done error message : %s",sqlite3_errmsg(database));
				}
				sqlite3_clear_bindings(statement);
				sqlite3_reset(statement);
			}
			if (sqlite3_exec(database, "COMMIT", 0, 0, 0) == SQLITE_OK) {
				success = YES;
			}
			
		} else {
			NSLog(@"prepare != ok error message : %s",sqlite3_errmsg(database));
		}
		sqlite3_finalize(statement);
		
    } else {
		NSLog(@"SQL OPEN FAILED code %s",sqlite3_errmsg(database));
	}
	sqlite3_close(database);
//    [dbManager release];
	return success;
}


+ (void)updateFavorite:(NSString *)fav uniqueid:(NSString *)uid
{
    
    /****************************************************************
     작업자 : 김혜민 > 박형준
     작업일자 : 2012/06/04 > 2013/11/06
     작업내용 : 즐겨찾기를 추가/삭제 했을 때 DB에서도 사번에 맞춰 업데이트
     param  - fav(NSString *) : 즐겨찾기 정보
     - uid(NSString *) : 사번
     연관화면 : 상세정보
     ****************************************************************/
    SQLiteDBManager *dbManager = [[SQLiteDBManager alloc] init];
	NSString *dbfilePath = [dbManager getDBFile];
	sqlite3 *database;
	
    if (sqlite3_open([dbfilePath UTF8String], &database) == SQLITE_OK) {
		sqlite3_stmt *statement;
		const char *sql = "UPDATE CONTACT set favorite=? where uniqueid=?";
		
		if(sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
			sqlite3_bind_text(statement, 1, [fav!=nil?fav:@"" UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(statement, 2, [uid!=nil?uid:@"" UTF8String], -1, SQLITE_TRANSIENT);
			
			if(sqlite3_step(statement) != SQLITE_DONE) {
				NSLog(@"step != done error message : %s",sqlite3_errmsg(database));
			}
		} else {
			NSLog(@"prepare != ok error message : %s",sqlite3_errmsg(database));
		}
		sqlite3_finalize(statement);
	} else {
		NSLog(@"SQL OPEN FAILED code %s",sqlite3_errmsg(database));
	}
	sqlite3_close(database);
//	[dbManager release];
		
    BOOL alreadyFavorite = NO;
    
    for(int i = 0; i < [[ResourceLoader sharedInstance].favoriteList count];i++){
        if([[ResourceLoader sharedInstance].favoriteList[i] isEqualToString:uid])
            alreadyFavorite = YES;
    }
    
    if(alreadyFavorite)
        [[ResourceLoader sharedInstance].favoriteList removeObject:uid];
    else
        [[ResourceLoader sharedInstance].favoriteList addObject:uid];

    
    for(int i = 0; i < [[ResourceLoader sharedInstance].allContactList count]; i++)
    {
        if([[ResourceLoader sharedInstance].allContactList[i][@"uniqueid"]isEqualToString:uid])
        {
            NSLog(@"allContactList objectAtIndex %d uid %@ updatefavorite %@",i,uid,fav);
            [[ResourceLoader sharedInstance].allContactList replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:[ResourceLoader sharedInstance].allContactList[i] object:fav key:@"favorite"]];
        }
    }
    for(int i = 0; i < [[ResourceLoader sharedInstance].contactList count]; i++)
    {
        if([[ResourceLoader sharedInstance].contactList[i][@"uniqueid"]isEqualToString:uid])
        {
            NSLog(@"contactList objectAtIndex %d uid %@ updatefavorite %@",i,uid,fav);
            [[ResourceLoader sharedInstance].contactList replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:[ResourceLoader sharedInstance].contactList[i] object:fav key:@"favorite"]];
        }
    }
    
    [SharedAppDelegate.root.allcontact setFavoriteList];
}



+ (void)updateAllFavorite:(NSString *)fav uniqueid:(NSString *)uid
{
    
    /****************************************************************
     작업자 : 김혜민 > 박형준
     작업일자 : 2012/06/04 > 2013/11/06
     작업내용 : 즐겨찾기를 추가/삭제 했을 때 DB에서도 사번에 맞춰 업데이트
     param  - fav(NSString *) : 즐겨찾기 정보
     - uid(NSString *) : 사번
     연관화면 : 상세정보
     ****************************************************************/
    SQLiteDBManager *dbManager = [[SQLiteDBManager alloc] init];
	NSString *dbfilePath = [dbManager getDBFile];
	sqlite3 *database;
	
    if (sqlite3_open([dbfilePath UTF8String], &database) == SQLITE_OK) {
		sqlite3_stmt *statement;
		const char *sql="UPDATE CONTACT set favorite=? where uniqueid=?";
		
		if(sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK){
			
			sqlite3_bind_text(statement, 1, [fav!=nil?fav:@"" UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(statement, 2, [uid!=nil?uid:@"" UTF8String], -1, SQLITE_TRANSIENT);
			
			if(sqlite3_step(statement) != SQLITE_DONE) {
				NSLog(@"step != done error message : %s",sqlite3_errmsg(database));
			}
		} else {
			NSLog(@"prepare != ok error message : %s",sqlite3_errmsg(database));
		}
		sqlite3_finalize(statement);
	} else {
		NSLog(@"SQL OPEN FAILED code %s",sqlite3_errmsg(database));
	}
	sqlite3_close(database);
//	[dbManager release];
    
}

+ (void)updateContact:(NSDictionary *)dic
{
    /****************************************************************
     작업자 : 김혜민 > 박형준
     작업일자 : 2012/06/04 > 2013/11/06
     작업내용 : 들어온 배열의 사번과 CONTACT DB의 사번을 비교해 같은 것을 업데이트
     param  - array(NSMutableArray *) : 주소록 배열
     연관화면 : 없음
     ****************************************************************/

    SQLiteDBManager *dbManager = [[SQLiteDBManager alloc] init];
	NSString *dbfilePath = [dbManager getDBFile];
	sqlite3 *database;
	
    if (sqlite3_open([dbfilePath UTF8String], &database) == SQLITE_OK) {
		
		sqlite3_stmt *statement;
    
		NSString *Name = dic[@"name"];
		NSString *Email = dic[@"email"];
		NSString *Cellphone = dic[@"cellphone"];
		NSString *Companyphone = dic[@"officephone"];
		NSString *Position = dic[@"duty"];
		NSString *Deptcode = dic[@"deptcode"];
		NSString *Team = [[ResourceLoader sharedInstance] searchCode:Deptcode];
		NSString *Uniqueid = dic[@"uid"];
		NSString *ProfileImage = dic[@"profileimage"];
		NSString *Available = dic[@"available"];
		NSString *Info = [dic[@"employeinfo"]objectFromJSONString][@"msg"];
		
		if([Available length] < 1 || Available == nil)
			Available = @"0";
		
		NSString *Grade2 = dic[@"position"];
        NSString *sequence = dic[@"sequence"];
        NSString *userlevel = [dic[@"userlevel"]length]>0?dic[@"userlevel"]:@"";
        NSString *app_no = [dic[@"app_no"]length]>1?dic[@"app_no"]:@"";

	
//		char *encName = [dbManager encryptString:Name!=nil&&![Name isKindOfClass:[NSNull class]]?Name:@""];
//		char *encEmail = [dbManager encryptString:Email!=nil&&![Email isKindOfClass:[NSNull class]]?Email:@""];
//		char *encCellphone = [dbManager encryptString:Cellphone!=nil&&![Cellphone isKindOfClass:[NSNull class]]?Cellphone:@""];
//		char *encCompanyphone = [dbManager encryptString:Companyphone!=nil&&![Companyphone isKindOfClass:[NSNull class]]?Companyphone:@""];
		
		NSString *sqlString = [NSString stringWithFormat:@"UPDATE CONTACT set name=?,email=?,cellphone=?,companyphone=?,deptcode=?,team=?,position=?,profileimage=?,available=?,grade2=?,newfield1=?,newfield2=?,newfield3=?,newfield4=? where uniqueid='%@'",Uniqueid];
		
		NSLog(@"sqlString %@",sqlString);
		
		if(sqlite3_prepare_v2(database, [sqlString UTF8String], -1, &statement, NULL) == SQLITE_OK) {
			
//			sqlite3_bind_blob(statement, 1, (void*)encName, -1, SQLITE_TRANSIENT);
//			sqlite3_bind_blob(statement, 2, (void*)encEmail, -1, SQLITE_TRANSIENT);
//			sqlite3_bind_blob(statement, 3, (void*)encCellphone, -1, SQLITE_TRANSIENT);
//			sqlite3_bind_blob(statement, 4, (void*)encCompanyphone, -1, SQLITE_TRANSIENT);
            
            sqlite3_bind_text(statement, 1, [Name!=nil&&![Name isKindOfClass:[NSNull class]]?[AESExtention aesEncryptString:Name]:@"" UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 2, [Email!=nil&&![Email isKindOfClass:[NSNull class]]?[AESExtention aesEncryptString:Email]:@"" UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 3, [Cellphone!=nil&&![Cellphone isKindOfClass:[NSNull class]]?[AESExtention aesEncryptString:Cellphone]:@"" UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 4, [Companyphone!=nil&&![Companyphone isKindOfClass:[NSNull class]]?[AESExtention aesEncryptString:Companyphone]:@"" UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(statement, 5, [Deptcode!=nil&&![Deptcode isKindOfClass:[NSNull class]]?Deptcode:@"" UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(statement, 6, [Team!=nil&&![Team isKindOfClass:[NSNull class]]?Team:@"" UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(statement, 7, [Position!=nil&&![Position isKindOfClass:[NSNull class]]?Position:@"" UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(statement, 8, [ProfileImage!=nil&&![ProfileImage isKindOfClass:[NSNull class]]?ProfileImage:@"" UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(statement, 9, [Available!=nil&&![Available isKindOfClass:[NSNull class]]?Available:@"" UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(statement, 10, [Grade2!=nil&&![Grade2 isKindOfClass:[NSNull class]]?Grade2:@"" UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(statement, 11, [Info!=nil&&![Info isKindOfClass:[NSNull class]]?Info:@"" UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 12, [sequence!=nil&&![sequence isKindOfClass:[NSNull class]]?sequence:@"" UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 13, [userlevel!=nil&&![userlevel isKindOfClass:[NSNull class]]?userlevel:@"" UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 14, [app_no!=nil&&![app_no isKindOfClass:[NSNull class]]?app_no:@"" UTF8String], -1, SQLITE_TRANSIENT);
		
			if(sqlite3_step(statement) != SQLITE_DONE) {
				NSLog(@"step != done error message : %s",sqlite3_errmsg(database));
			}
		} else {
			NSLog(@"prepare != ok error message : %s",sqlite3_errmsg(database));
		}
		sqlite3_finalize(statement);

//		FREEMEM(encName);
//		FREEMEM(encEmail);
//		FREEMEM(encCellphone);
//		FREEMEM(encCompanyphone);
		
		[[ResourceLoader sharedInstance] cache_profileImageDirectoryUpdateObjectAtUID:Uniqueid andProfileImage:ProfileImage];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"refreshProfiles" object:nil];
	} else {
		NSLog(@"SQL OPEN FAILED code %s",sqlite3_errmsg(database));
	}
	sqlite3_close(database);
//	[dbManager release];

}

+ (BOOL)updateContactArray:(NSMutableArray *)array
{
    /****************************************************************
     작업자 : 김혜민 > 박형준
     작업일자 : 2012/06/04 > 2013/11/27
     작업내용 : 들어온 배열의 사번과 CONTACT DB의 사번을 비교해 같은 것을 업데이트
     param  - array(NSMutableArray *) : 주소록 배열
     연관화면 : 없음
     ****************************************************************/
	BOOL success = NO;
    SQLiteDBManager *dbManager = [[SQLiteDBManager alloc] init];
	NSString *dbfilePath = [dbManager getDBFile];
	sqlite3 *database;
	
	if (sqlite3_open([dbfilePath UTF8String], &database) == SQLITE_OK) {
		sqlite3_stmt *statement;
		const char *sql = "UPDATE CONTACT set name=?,email=?,cellphone=?,companyphone=?,deptcode=?,team=?,position=?,profileimage=?,available=?,grade2=?,newfield1=?,newfield2=?,newfield3=?,newfield4=? where uniqueid=?";
		
		if(sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK){
			sqlite3_exec(database, "BEGIN", 0, 0, 0);
			
            for(NSDictionary *dic in array) {
				NSString *Name = dic[@"name"];
				NSString *Email = dic[@"email"];
				NSString *Cellphone = dic[@"cellphone"];
                NSString *Companyphone = dic[@"officephone"];
                NSString *Deptcode = dic[@"deptcode"];
                NSString *Team = [[ResourceLoader sharedInstance] searchCode:Deptcode];//objectForKey:@"team"];
				NSString *Position = dic[@"duty"];
				NSString *ProfileImage = dic[@"profileimage"];
                NSString *Available = dic[@"available"];
                if([Available length] < 1 || Available == nil)
                    Available = @"0";
                
                NSString *Grade2 = dic[@"position"];
                
                NSString *Info = [dic[@"employeinfo"]objectFromJSONString][@"msg"];
                NSString *sequence = dic[@"sequence"];
                NSString *userlevel = [dic[@"userlevel"]length]>0?dic[@"userlevel"]:@"";
                NSString *app_no = [dic[@"app_no"]length]>1?dic[@"app_no"]:@"";
                
                NSString *Uniqueid = dic[@"uid"];
                
                if([Uniqueid isEqualToString:[ResourceLoader sharedInstance].myUID]){
                  
                    
                    NSMutableDictionary *newMyinfo = [NSMutableDictionary dictionary];
                    [newMyinfo setObject:Cellphone!=nil&&![Cellphone isKindOfClass:[NSNull class]]?Cellphone:@"" forKey:@"cellphone"];
                    [newMyinfo setObject:Name!=nil&&![Name isKindOfClass:[NSNull class]]?Name:@"" forKey:@"name"];
                    [newMyinfo setObject:ProfileImage!=nil&&![ProfileImage isKindOfClass:[NSNull class]]?ProfileImage:@"" forKey:@"profileimage"];
                    [newMyinfo setObject:Companyphone!=nil&&![Companyphone isKindOfClass:[NSNull class]]?Companyphone:@"" forKey:@"officephone"];
                    [newMyinfo setObject:[ResourceLoader sharedInstance].myUID forKey:@"uid"];
                    [newMyinfo setObject:[ResourceLoader sharedInstance].mySessionkey forKey:@"sessionkey"];
                    [newMyinfo setObject:Grade2!=nil&&![Grade2 isKindOfClass:[NSNull class]]?Grade2:@"" forKey:@"position"];
                    [newMyinfo setObject:app_no!=nil&&![app_no isKindOfClass:[NSNull class]]?app_no:@"" forKey:@"newfield4"];
                    [newMyinfo setObject:userlevel!=nil&&![userlevel isKindOfClass:[NSNull class]]?userlevel:@"" forKey:@"newfield3"];
                    [newMyinfo setObject:sequence!=nil&&![sequence isKindOfClass:[NSNull class]]?sequence:@"" forKey:@"newfield2"];
                    [newMyinfo setObject:Email!=nil&&![Email isKindOfClass:[NSNull class]]?Email:@"" forKey:@"email"];
                    [newMyinfo setObject:Deptcode!=nil&&![Deptcode isKindOfClass:[NSNull class]]?Deptcode:@"" forKey:@"deptcode"];
                    [newMyinfo setObject:Team!=nil&&![Team isKindOfClass:[NSNull class]]?Team:@"" forKey:@"team"];
                    [SharedAppDelegate writeToPlist:@"myinfo" value:newMyinfo];
                    
                    
                }
//				char *encName = [dbManager encryptString:Name!=nil&&![Name isKindOfClass:[NSNull class]]?Name:@""];
//				char *encEmail = [dbManager encryptString:Email!=nil&&![Email isKindOfClass:[NSNull class]]?Email:@""];
//				char *encCellphone = [dbManager encryptString:Cellphone!=nil&&![Cellphone isKindOfClass:[NSNull class]]?Cellphone:@""];
//				char *encCompanyphone = [dbManager encryptString:Companyphone!=nil&&![Companyphone isKindOfClass:[NSNull class]]?Companyphone:@""];
				
//				sqlite3_bind_blob(statement, 1, (void*)encName, -1, SQLITE_TRANSIENT);
//				sqlite3_bind_blob(statement, 2, (void*)encEmail, -1, SQLITE_TRANSIENT);
//				sqlite3_bind_blob(statement, 3, (void*)encCellphone, -1, SQLITE_TRANSIENT);
//				sqlite3_bind_blob(statement, 4, (void*)encCompanyphone, -1, SQLITE_TRANSIENT);
                
                sqlite3_bind_text(statement, 1, [Name!=nil&&![Name isKindOfClass:[NSNull class]]?[AESExtention aesEncryptString:Name]:@"" UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 2, [Email!=nil&&![Email isKindOfClass:[NSNull class]]?[AESExtention aesEncryptString:Email]:@"" UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 3, [Cellphone!=nil&&![Cellphone isKindOfClass:[NSNull class]]?[AESExtention aesEncryptString:Cellphone]:@"" UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 4, [Companyphone!=nil&&![Companyphone isKindOfClass:[NSNull class]]?[AESExtention aesEncryptString:Companyphone]:@"" UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_text(statement, 5, [Deptcode!=nil&&![Deptcode isKindOfClass:[NSNull class]]?Deptcode:@"" UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_text(statement, 6, [Team!=nil&&![Team isKindOfClass:[NSNull class]]?Team:@"" UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_text(statement, 7, [Position!=nil&&![Position isKindOfClass:[NSNull class]]?Position:@"" UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_text(statement, 8, [ProfileImage!=nil&&![ProfileImage isKindOfClass:[NSNull class]]?ProfileImage:@"" UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_text(statement, 9, [Available!=nil&&![Available isKindOfClass:[NSNull class]]?Available:@"" UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_text(statement, 10, [Grade2!=nil&&![Grade2 isKindOfClass:[NSNull class]]?Grade2:@"" UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_text(statement, 11, [Info!=nil&&![Info isKindOfClass:[NSNull class]]?Info:@"" UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 12, [sequence!=nil&&![sequence isKindOfClass:[NSNull class]]?sequence:@"" UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 13, [userlevel!=nil&&![userlevel isKindOfClass:[NSNull class]]?userlevel:@"" UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 14, [app_no!=nil&&![app_no isKindOfClass:[NSNull class]]?app_no:@"" UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 15, [Uniqueid!=nil&&![Uniqueid isKindOfClass:[NSNull class]]?Uniqueid:@"" UTF8String], -1, SQLITE_TRANSIENT);

				if(sqlite3_step(statement) != SQLITE_DONE) {
					NSLog(@"step != done error message : %s",sqlite3_errmsg(database));
				}
				sqlite3_clear_bindings(statement);
				sqlite3_reset(statement);
				
//				FREEMEM(encName);
//				FREEMEM(encEmail);
//				FREEMEM(encCellphone);
//				FREEMEM(encCompanyphone);
				
                [[ResourceLoader sharedInstance] cache_profileImageDirectoryUpdateObjectAtUID:Uniqueid andProfileImage:ProfileImage];
              
                
			}
			
			if (sqlite3_exec(database, "COMMIT", 0, 0, 0) == SQLITE_OK) {
				success = YES;
			}
			
		} else {
			NSLog(@"prepare != ok error message : %s",sqlite3_errmsg(database));
		}
		sqlite3_finalize(statement);
		
    } else {
		NSLog(@"SQL OPEN FAILED code %s",sqlite3_errmsg(database));
	}
	sqlite3_close(database);
//    [dbManager release];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"refreshProfiles" object:nil];
	return success;
}


+ (void)updateMyProfileImage:(NSString*)fileName
{
    SQLiteDBManager *dbManager = [[SQLiteDBManager alloc] init];
	NSString *dbfilePath = [dbManager getDBFile];
	sqlite3 *database;
    
    if (sqlite3_open([dbfilePath UTF8String], &database) == SQLITE_OK) {
		sqlite3_stmt *statement;
		NSString *sqlString = [NSString stringWithFormat:@"UPDATE CONTACT set profileimage=? where uniqueid='%@'",[SharedAppDelegate readPlist:@"myinfo"][@"uid"]];
		
		if(sqlite3_prepare_v2(database, [sqlString UTF8String], -1, &statement, NULL) == SQLITE_OK){
			
			sqlite3_bind_text(statement, 1, [fileName UTF8String], -1, SQLITE_TRANSIENT);
			if(sqlite3_step(statement) != SQLITE_DONE) {
				NSLog(@"step != done error message : %s",sqlite3_errmsg(database));
			}
		} else {
			NSLog(@"prepare != ok error message : %s",sqlite3_errmsg(database));
		}
		sqlite3_finalize(statement);
		
//		[[ResourceLoader sharedInstance] cache_profileImageDirectoryUpdateObjectAtUID:[SharedAppDelegate readPlist:@"myinfo"][@"uid"] andProfileImage:fileName];
        if ([fileName length] < 1 || [fileName isEqualToString:@""]) {
            [[ResourceLoader sharedInstance] cache_profileImageDirectoryDeleteObjectAtUID:[SharedAppDelegate readPlist:@"myinfo"][@"uid"]];
        } else {
            [[ResourceLoader sharedInstance] cache_profileImageDirectoryUpdateObjectAtUID:[SharedAppDelegate readPlist:@"myinfo"][@"uid"] andProfileImage:fileName];
        }

        
		[[NSNotificationCenter defaultCenter] postNotificationName:@"refreshProfiles" object:nil];
	} else {
		NSLog(@"SQL OPEN FAILED code %s",sqlite3_errmsg(database));
	}
	sqlite3_close(database);
//	[dbManager release];
}


+ (void)updateDept:(NSDictionary *)dic
{
    /****************************************************************
     작업자 : 김혜민 > 박형준
     작업일자 : 2012/06/04 > 2013/11/06
     작업내용 : 들어온 배열의 코드와 ORGANIZE DB의 mycode를 비교해 같은 것을 업데이트
     param  - array(NSMutableArray *) : 조직 배열
     연관화면 : 없음
     ****************************************************************/
    
    SQLiteDBManager *dbManager = [[SQLiteDBManager alloc] init];
	NSString *dbfilePath = [dbManager getDBFile];
	sqlite3 *database;
	
    if (sqlite3_open([dbfilePath UTF8String], &database) == SQLITE_OK) {
		sqlite3_stmt *statement;
		NSString *sql = [NSString stringWithFormat:@"UPDATE ORGANIZE set parentcode=?, shortname=?, newfield1=? where mycode='%@'",dic[@"mycode"]];
		if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK){
			
			NSString *PaCd = dic[@"parentdeptcode"];
			NSString *Sname = dic[@"shortname"];
			NSString *sequence = dic[@"sequence"];
//			char *encSname = [dbManager encryptString:Sname!=nil&&![Sname isKindOfClass:[NSNull class]]?Sname:@""];
			
			sqlite3_bind_text(statement, 1, [PaCd!=nil&&![PaCd isKindOfClass:[NSNull class]]?PaCd:@"" UTF8String], -1, SQLITE_TRANSIENT);
//			sqlite3_bind_blob(statement, 2, (void*)encSname, -1, SQLITE_TRANSIENT);
              sqlite3_bind_text(statement, 2, [Sname!=nil&&![Sname isKindOfClass:[NSNull class]]?[AESExtention aesEncryptString:Sname]:@"" UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(statement, 3, [sequence!=nil&&![sequence isKindOfClass:[NSNull class]]?sequence:@"" UTF8String], -1, SQLITE_TRANSIENT);
			
			if(sqlite3_step(statement) != SQLITE_DONE)	{
				NSLog(@"step != done error message : %s",sqlite3_errmsg(database));
			}
//			FREEMEM(encSname);
		} else {
			NSLog(@"prepare != ok error message : %s",sqlite3_errmsg(database));
		}
		sqlite3_finalize(statement);
	} else {
		NSLog(@"SQL OPEN FAILED code %s",sqlite3_errmsg(database));
	}
	sqlite3_close(database);
//	[dbManager release];
}

+ (BOOL)updateDeptArray:(NSMutableArray *)array
{
    /****************************************************************
     작업자 : 김혜민 > 박형준
     작업일자 : 2012/06/04 > 2013/11/27
     작업내용 : 들어온 배열의 사번과 CONTACT DB의 사번을 비교해 같은 것을 업데이트
     param  - array(NSMutableArray *) : 주소록 배열
     연관화면 : 없음
     ****************************************************************/
	BOOL success = NO;
    SQLiteDBManager *dbManager = [[SQLiteDBManager alloc] init];
	NSString *dbfilePath = [dbManager getDBFile];
	sqlite3 *database;
	
	if (sqlite3_open([dbfilePath UTF8String], &database) == SQLITE_OK) {
		sqlite3_stmt *statement;
		const char *sql = "UPDATE ORGANIZE set parentcode=?, shortname=?, newfield1=? where mycode=?";
		
		if(sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK){
			sqlite3_exec(database, "BEGIN", 0, 0, 0);
			
			for(NSDictionary *dic in array) {
				NSString *PaCd = dic[@"parentdeptcode"];
				NSString *Sname = dic[@"deptname"];
				NSString *sequence = dic[@"sequence"];
				NSString *deptCode = dic[@"deptcode"];
//				char *encSname = [dbManager encryptString:Sname!=nil&&![Sname isKindOfClass:[NSNull class]]?Sname:@""];
				
				sqlite3_bind_text(statement, 1, [PaCd!=nil&&![PaCd isKindOfClass:[NSNull class]]?PaCd:@"" UTF8String], -1, SQLITE_TRANSIENT);
//				sqlite3_bind_blob(statement, 2, (void*)encSname, -1, SQLITE_TRANSIENT);
                  sqlite3_bind_text(statement, 2, [Sname!=nil&&![Sname isKindOfClass:[NSNull class]]?[AESExtention aesEncryptString:Sname]:@"" UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_text(statement, 3, [sequence!=nil&&![sequence isKindOfClass:[NSNull class]]?sequence:@"" UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_text(statement, 4, [deptCode!=nil&&![deptCode isKindOfClass:[NSNull class]]?deptCode:@"" UTF8String], -1, SQLITE_TRANSIENT);
				
				if(sqlite3_step(statement) != SQLITE_DONE) {
					NSLog(@"step != done error message : %s",sqlite3_errmsg(database));
				}
				sqlite3_clear_bindings(statement);
				sqlite3_reset(statement);
				
//				FREEMEM(encSname);
			}
			
			if (sqlite3_exec(database, "COMMIT", 0, 0, 0) == SQLITE_OK) {
				success = YES;
			}
			
		} else {
			NSLog(@"prepare != ok error message : %s",sqlite3_errmsg(database));
		}
		sqlite3_finalize(statement);
		
    } else {
		NSLog(@"SQL OPEN FAILED code %s",sqlite3_errmsg(database));
	}
	sqlite3_close(database);
//    [dbManager release];
	return success;
}


+ (NSDictionary *)searchContactDictionaryLight:(NSString *)uid
{
    if([uid isEqualToString:@""]) {
        return nil;
    } else {
        uid = [[SharedFunctions minusMe:uid] componentsSeparatedByString:@","][0];
	}
	
    SQLiteDBManager *dbManager = [[SQLiteDBManager alloc] init];
	NSString *dbfilePath = [dbManager getDBFile];
	sqlite3 *database;
    
	NSDictionary *dic = [NSDictionary dictionary];
	
    if (sqlite3_open([dbfilePath UTF8String], &database) == SQLITE_OK) {
		sqlite3_stmt *statement;
		NSString *sql = [NSString stringWithFormat:@"SELECT name,team,position,grade2 FROM CONTACT where uniqueid='%@'",uid];
		
		if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
			while (sqlite3_step(statement) == SQLITE_ROW) {
				dic = [NSDictionary dictionaryWithObjectsAndKeys:
//                       [dbManager decryptString:((char *)sqlite3_column_text(statement, 0)!=nil?(char *)sqlite3_column_text(statement, 0):"")],@"name",
                       
                       [AESExtention aesDecryptString:[NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 0)!=nil?(char *)sqlite3_column_text(statement, 0):"")]],@"name",
					   [NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 1)!=nil?(char *)sqlite3_column_text(statement, 1):"")],@"team",
					   [NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 2)!=nil?(char *)sqlite3_column_text(statement, 2):"")],@"position",
					   [NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 3)!=nil?(char *)sqlite3_column_text(statement, 3):"")],@"grade2",
					   nil];
			}
		} else {
			NSLog(@"prepare != ok error message : %s",sqlite3_errmsg(database));
		}
		sqlite3_finalize(statement);
    } else {
		NSLog(@"SQL OPEN FAILED code %s",sqlite3_errmsg(database));
	}
	sqlite3_close(database);
//	[dbManager release];
    return dic;
}

+ (NSArray *)getProfileImageDirectory
{
    SQLiteDBManager *dbManager = [[SQLiteDBManager alloc] init];
	NSString *dbfilePath = [dbManager getDBFile];
	sqlite3 *database;
    
    // select한 값을 배열로 저장
	NSMutableArray *profileImages = [NSMutableArray array];
    
    if (sqlite3_open([dbfilePath UTF8String], &database) == SQLITE_OK) {
        sqlite3_stmt *statement;
        const char *sql = "SELECT uniqueid,profileimage FROM CONTACT";
        
        if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
				NSDictionary *dic = @{@"uid":[NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 0)!=nil?(char *)sqlite3_column_text(statement, 0):"")],
									  @"profileimage":[NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 1)!=nil?(char *)sqlite3_column_text(statement, 1):"")] };
				[profileImages addObject:dic];
            }
			
        } else {
			NSLog(@"prepare != ok error message : %s",sqlite3_errmsg(database));
		}
		sqlite3_finalize(statement);
    } else {
		NSLog(@"SQL OPEN FAILED code %s",sqlite3_errmsg(database));
	}
	sqlite3_close(database);
//	[dbManager release];
    return profileImages;
}

//#pragma mark - ChatList
//
//+ (void)removeRoom:(NSString *)rk all:(BOOL)all
//{
//	SQLiteDBManager *dbManager = [[SQLiteDBManager alloc] init];
//	NSString *dbfilePath = [dbManager getDBFile];
//	sqlite3 *database;
//	
//    if (sqlite3_open([dbfilePath UTF8String], &database) == SQLITE_OK) {
//		sqlite3_stmt *statement;
//		const char *sql;
//		
//		if([rk isEqualToString:@"0"] && all == YES) {
//			sql = "DELETE FROM CHATLIST";
//			if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
//				if (sqlite3_step(statement) != SQLITE_DONE) {
//					NSLog(@"step != done error message : %s",sqlite3_errmsg(database));
//				}
//			} else {
//				NSLog(@"prepare != ok error message : %s",sqlite3_errmsg(database));
//			}
//			
//			sql = "DELETE FROM MSG";
//			if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
//				if (sqlite3_step(statement) != SQLITE_DONE) {
//					NSLog(@"step != done error message : %s",sqlite3_errmsg(database));
//				}
//			} else {
//				NSLog(@"prepare != ok error message : %s",sqlite3_errmsg(database));
//			}
//		} else {
//			sql = "DELETE FROM CHATLIST WHERE roomkey=?";
//			if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
//				sqlite3_bind_text(statement, 1, [rk UTF8String], -1, SQLITE_TRANSIENT);
//				if (sqlite3_step(statement) != SQLITE_DONE) {
//					NSLog(@"step != done error message : %s",sqlite3_errmsg(database));
//				}
//			} else {
//				NSLog(@"prepare != ok error message : %s",sqlite3_errmsg(database));
//			}
//			
//			sql = "DELETE FROM MSG WHERE roomkey=?";
//			if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
//				sqlite3_bind_text(statement, 1, [rk UTF8String], -1, SQLITE_TRANSIENT);
//				if (sqlite3_step(statement) != SQLITE_DONE) {
//					NSLog(@"step != done error message : %s",sqlite3_errmsg(database));
//				}
//			} else {
//				NSLog(@"prepare != ok error message : %s",sqlite3_errmsg(database));
//			}
//		}
//		sqlite3_finalize(statement);
//	} else {
//		NSLog(@"SQL OPEN FAILED code %s",sqlite3_errmsg(database));
//	}
//	sqlite3_close(database);
////	[dbManager release];
//    
//}
//
//+ (void)removeRooms:(NSArray*)array {
//
//	SQLiteDBManager *dbManager = [[SQLiteDBManager alloc] init];
//	NSString *dbfilePath = [dbManager getDBFile];
//	sqlite3 *database;
//    
//    if (sqlite3_open([dbfilePath UTF8String], &database) == SQLITE_OK) {
//		sqlite3_stmt *chatStmt;
//		const char *chatSQL = "DELETE FROM CHATLIST WHERE roomkey=?";
//		if(sqlite3_prepare_v2(database, chatSQL, -1, &chatStmt, NULL) == SQLITE_OK) {
//			sqlite3_exec(database, "BEGIN", 0, 0, 0);
//			
//			for(NSString *roomkey in array) {
//				if ([roomkey length] < 1) {
//					continue;
//				}
//				sqlite3_bind_text(chatStmt, 1, [roomkey UTF8String], -1, SQLITE_TRANSIENT);
//				
//				if(sqlite3_step(chatStmt) != SQLITE_DONE) {
//					NSLog(@"step != done error message : %s",sqlite3_errmsg(database));
//				}
//				sqlite3_clear_bindings(chatStmt);
//				sqlite3_reset(chatStmt);
//			}
//			sqlite3_exec(database, "COMMIT", 0, 0, 0);
//			
//		} else {
//			NSLog(@"prepare != ok error message : %s",sqlite3_errmsg(database));
//		}
//		sqlite3_finalize(chatStmt);
//		
//		
//		sqlite3_stmt *msgStmt;
//		const char *msgSQL = "DELETE FROM MSG WHERE roomkey=?";
//		if(sqlite3_prepare_v2(database, msgSQL, -1, &msgStmt, NULL) == SQLITE_OK) {
//			sqlite3_exec(database, "BEGIN", 0, 0, 0);
//			
//			for(NSString *roomkey in array) {
//				if ([roomkey length] < 1) {
//					continue;
//				}
//				sqlite3_bind_text(msgStmt, 1, [roomkey UTF8String], -1, SQLITE_TRANSIENT);
//				
//				if(sqlite3_step(msgStmt) != SQLITE_DONE) {
//					NSLog(@"step != done error message : %s",sqlite3_errmsg(database));
//				}
//				sqlite3_clear_bindings(msgStmt);
//				sqlite3_reset(msgStmt);
//			}
//			sqlite3_exec(database, "COMMIT", 0, 0, 0);
//			
//		} else {
//			NSLog(@"prepare != ok error message : %s",sqlite3_errmsg(database));
//		}
//		sqlite3_finalize(msgStmt);
//		
//    } else {
//		NSLog(@"SQL OPEN FAILED code %s",sqlite3_errmsg(database));
//	}
//	sqlite3_close(database);
////    [dbManager release];
//}
//
//
//+ (void)removeMessageWithRk:(NSString *)rk index:(NSString *)index
//{
//    SQLiteDBManager *dbManager = [[SQLiteDBManager alloc] init];
//	NSString *dbfilePath = [dbManager getDBFile];
//	sqlite3 *database;
//    
//    if (sqlite3_open([dbfilePath UTF8String], &database) == SQLITE_OK) {
//		sqlite3_stmt *statement;
//		const char *sql = "DELETE FROM MSG WHERE roomkey=? and msgindex=?";
//		
//		if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
//			sqlite3_bind_text(statement, 1, [rk UTF8String], -1, SQLITE_TRANSIENT);
//			sqlite3_bind_text(statement, 2, [index UTF8String], -1, SQLITE_TRANSIENT);
//			
//			if (sqlite3_step(statement) != SQLITE_DONE) {
//				NSLog(@"step != done error message : %s",sqlite3_errmsg(database));
//			}
//		} else {
//			NSLog(@"prepare != ok error message : %s",sqlite3_errmsg(database));
//		}
//		sqlite3_finalize(statement);
//	} else {
//		NSLog(@"SQL OPEN FAILED code %s",sqlite3_errmsg(database));
//	}
//	sqlite3_close(database);
////	[dbManager release];
//}
//
//+ (void)AddChatListWithRk:(NSString *)rk uids:(NSString *)uids names:(NSString *)names lastmsg:(NSString *)lastmsg
//                     date:(NSString *)date time:(NSString *)time msgidx:(NSString *)lastidx type:(NSString *)rtype order:(NSString *)order groupnumber:(NSString *)groupnumber
//{
//    NSLog(@"addchat uids %@ names %@ type %@ rk %@ number %@ last %@ ",uids,names,rtype,rk, groupnumber,lastmsg);
//    
//    NSString *number = groupnumber;
//    if(groupnumber == nil)
//        number = @"";
//    
//    if(names == nil)
//        names = @"";
//    
//    
//    if(rk == nil || [rk isEqualToString:@""] || uids == nil || [uids isEqualToString:@""])
//        return;
//    
//    
//    NSString *lastmessage = lastmsg;
//    if(lastmsg == nil || [lastmsg isKindOfClass:[NSNull class]])
//        lastmessage = @"";
//    
//  
//    
//    
//    NSLog(@"addchat uids %@ names %@ type %@ rk %@ number %@ last %@",uids,names,rtype,rk, number,lastmessage);
//    
//    
//    SQLiteDBManager *dbManager = [[SQLiteDBManager alloc] init];
//	NSString *dbfilePath = [dbManager getDBFile];
//	sqlite3 *database;
//    
//    if (sqlite3_open([dbfilePath UTF8String], &database) == SQLITE_OK) {
//		sqlite3_stmt *statement;
//		const char *sql="INSERT INTO CHATLIST (roomkey, uids, names, lastmsg, lastdate, lasttime, lastindex, rtype, orderindex, newfield) values (?,?,?,?,?,?,?,?,?,?)";
//
//		if(sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK){
//			sqlite3_bind_text(statement, 1, [rk UTF8String], -1, SQLITE_TRANSIENT);
//			sqlite3_bind_text(statement, 2, [uids UTF8String], -1, SQLITE_TRANSIENT);
//			sqlite3_bind_text(statement, 3, [names UTF8String], -1, SQLITE_TRANSIENT);
//			sqlite3_bind_text(statement, 4, [lastmessage UTF8String], -1, SQLITE_TRANSIENT);
//			sqlite3_bind_text(statement, 5, [date UTF8String], -1, SQLITE_TRANSIENT);
//			sqlite3_bind_text(statement, 6, [time UTF8String], -1, SQLITE_TRANSIENT);
//			sqlite3_bind_text(statement, 7, [lastidx UTF8String], -1, SQLITE_TRANSIENT);
//			sqlite3_bind_text(statement, 8, [rtype UTF8String], -1, SQLITE_TRANSIENT);
//            sqlite3_bind_text(statement, 9, [order UTF8String], -1, SQLITE_TRANSIENT);
//            sqlite3_bind_text(statement, 10, [number UTF8String], -1, SQLITE_TRANSIENT);
//			
//			if(sqlite3_step(statement) != SQLITE_DONE) {
//				NSLog(@"step != done error message : %s",sqlite3_errmsg(database));
//			}
//		} else {
//			NSLog(@"prepare != ok error message : %s",sqlite3_errmsg(database));
//		}
//		sqlite3_finalize(statement);
//	} else {
//		NSLog(@"SQL OPEN FAILED code %s",sqlite3_errmsg(database));
//	}
//	sqlite3_close(database);
////    [dbManager release];
//    [SharedAppDelegate.root.chatList performSelector:@selector(refreshContents)];
//}
//
//+ (void)updateLastmessage:(NSString *)msg date:(NSString *)date time:(NSString *)time idx:(NSString *)lastidx rk:(NSString *)rk order:(NSString *)order
//{
//    if([rk length]<1)
//        return;
//    
//    NSString *lastmessage = msg;
//    if(msg == nil || [msg isKindOfClass:[NSNull class]])
//        lastmessage = @"";
//    
//    
//    NSLog(@"updateLastmessage %@ rk %@ order %@",msg,rk,order);
//	SQLiteDBManager *dbManager = [[SQLiteDBManager alloc] init];
//	NSString *dbfilePath = [dbManager getDBFile];
//	sqlite3 *database;
//	
//    if (sqlite3_open([dbfilePath UTF8String], &database) == SQLITE_OK) {
//		sqlite3_stmt *statement;
//		NSString *sql = @"";
//            sql = [NSString stringWithFormat:@"UPDATE CHATLIST set lastmsg=?, lastdate=?, lasttime=?, lastindex=?, orderindex=? where roomkey='%@'",rk];
//            
//		if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
//			sqlite3_bind_text(statement, 1, [lastmessage UTF8String], -1, SQLITE_TRANSIENT);
//			sqlite3_bind_text(statement, 2, [date UTF8String], -1, SQLITE_TRANSIENT);
//			sqlite3_bind_text(statement, 3, [time UTF8String], -1, SQLITE_TRANSIENT);
//			sqlite3_bind_text(statement, 4, [lastidx UTF8String], -1, SQLITE_TRANSIENT);
//            sqlite3_bind_text(statement, 5, [order UTF8String], -1, SQLITE_TRANSIENT);
//			
//			if(sqlite3_step(statement) != SQLITE_DONE) {
//				NSLog(@"step != done error message : %s",sqlite3_errmsg(database));
//			}
//		} else {
//			NSLog(@"prepare != ok error message : %s",sqlite3_errmsg(database));
//		}
//		sqlite3_finalize(statement);
//	} else {
//		NSLog(@"SQL OPEN FAILED code %s",sqlite3_errmsg(database));
//	}
//    sqlite3_close(database);
////	[dbManager release];
//}
//
//
//+ (void)updateRoomkey:(NSString *)rk number:(NSString *)number
//{
//    if([number length]<1)
//        return;
//    if([rk length]<1)
//        return;
//    
//    NSLog(@"updateroomkey %@ number %@",rk,number);
//    SQLiteDBManager *dbManager = [[SQLiteDBManager alloc] init];
//    NSString *dbfilePath = [dbManager getDBFile];
//    sqlite3 *database;
//    
//    if (sqlite3_open([dbfilePath UTF8String], &database) == SQLITE_OK) {
//        sqlite3_stmt *statement;
//        NSString *sql = [NSString stringWithFormat:@"UPDATE CHATLIST set roomkey=? where newfield='%@'",number];
//        
//        if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
//            sqlite3_bind_text(statement, 1, [rk UTF8String], -1, SQLITE_TRANSIENT);
//            
//            if(sqlite3_step(statement) != SQLITE_DONE) {
//                NSLog(@"step != done error message : %s",sqlite3_errmsg(database));
//            }
//        } else {
//            NSLog(@"prepare != ok error message : %s",sqlite3_errmsg(database));
//        }
//        sqlite3_finalize(statement);
//    } else {
//        NSLog(@"SQL OPEN FAILED code %s",sqlite3_errmsg(database));
//    }
//    sqlite3_close(database);
////    [dbManager release];
//}
//
//+ (void)updateRoomName:(NSString *)names rk:(NSString *)rk
//{
//    if([rk length]<1)
//        return;
//    
//    NSLog(@"updateroomname %@ rk %@",names,rk);
//    SQLiteDBManager *dbManager = [[SQLiteDBManager alloc] init];
//    NSString *dbfilePath = [dbManager getDBFile];
//    sqlite3 *database;
//    
//    if (sqlite3_open([dbfilePath UTF8String], &database) == SQLITE_OK) {
//        sqlite3_stmt *statement;
//        NSString *sql = [NSString stringWithFormat:@"UPDATE CHATLIST set names=? where roomkey='%@'",rk];
//        
//        if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK){
//            sqlite3_bind_text(statement, 1, [names UTF8String], -1, SQLITE_TRANSIENT);
//            
//            if(sqlite3_step(statement) != SQLITE_DONE) {
//                NSLog(@"step != done error message : %s",sqlite3_errmsg(database));
//            }
//        } else {
//            NSLog(@"prepare != ok error message : %s",sqlite3_errmsg(database));
//        }
//        sqlite3_finalize(statement);
//    } else {
//        NSLog(@"SQL OPEN FAILED code %s",sqlite3_errmsg(database));
//    }
//    sqlite3_close(database);
////    [dbManager release];
//}
//+ (void)updateRoomMember:(NSString *)uids rk:(NSString *)rk
//{
//    if([rk length]<1)
//        return;
//    
//	SQLiteDBManager *dbManager = [[SQLiteDBManager alloc] init];
//	NSString *dbfilePath = [dbManager getDBFile];
//	sqlite3 *database;
//	
//    if (sqlite3_open([dbfilePath UTF8String], &database) == SQLITE_OK) {
//		sqlite3_stmt *statement;
//		NSString *sql = [NSString stringWithFormat:@"UPDATE CHATLIST set uids=? where roomkey='%@'",rk];
//    
//		if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK){
//			sqlite3_bind_text(statement, 1, [uids UTF8String], -1, SQLITE_TRANSIENT);
//			
//			if(sqlite3_step(statement) != SQLITE_DONE) {
//				NSLog(@"step != done error message : %s",sqlite3_errmsg(database));
//			}
//		} else {
//			NSLog(@"prepare != ok error message : %s",sqlite3_errmsg(database));
//		}
//		sqlite3_finalize(statement);
//	} else {
//		NSLog(@"SQL OPEN FAILED code %s",sqlite3_errmsg(database));
//	}
//    sqlite3_close(database);
////    [dbManager release];
//}
//
////+ (void)updateAlarmIsMute:(BOOL)status roomkey:(NSString*)rk
////{
////	SQLiteDBManager *dbManager = [[SQLiteDBManager alloc] init];
////	NSString *dbfilePath = [dbManager getDBFile];
////	sqlite3 *database;
////	
////    if (sqlite3_open([dbfilePath UTF8String], &database) == SQLITE_OK) {
////		sqlite3_stmt *statement;
////		NSString *sql = [NSString stringWithFormat:@"UPDATE CHATLIST set newfield=? where roomkey='%@'",rk];
////		
////		if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK){
////			sqlite3_bind_text(statement, 1, status==YES?"YES":"NO", -1, SQLITE_TRANSIENT);
////			
////			if(sqlite3_step(statement) != SQLITE_DONE) {
////				NSLog(@"step != done error message : %s",sqlite3_errmsg(database));
////			}
////		} else {
////			NSLog(@"prepare != ok error message : %s",sqlite3_errmsg(database));
////		}
////		sqlite3_finalize(statement);
////	} else {
////		NSLog(@"SQL OPEN FAILED code %s",sqlite3_errmsg(database));
////	}
////    sqlite3_close(database);
////    [dbManager release];
////}
//
//+ (NSArray *)getChatList
//{
//    /****************************************************************
//     작업자 : 김혜민 > 박형준
//     작업일자 : 2012/06/04 > 2013/11/06
//     작업내용 : CHATLIST DB에서 채팅리스트를 가져온다.
//     연관화면 : 없음
//     ****************************************************************/
//    
//	SQLiteDBManager *dbManager = [[SQLiteDBManager alloc] init];
//	NSString *dbfilePath = [dbManager getDBFile];
//	sqlite3 *database;
//	
//	NSMutableArray *resultArray = [NSMutableArray array];
//    if (sqlite3_open([dbfilePath UTF8String], &database) == SQLITE_OK) {
//        sqlite3_stmt *statement;
//        const char *sql = "SELECT id, roomkey, uids, names, lastmsg, lastdate, lasttime, lastindex, rtype, orderindex, newfield FROM CHATLIST group by roomkey";// order by orderindex desc";
//        
//        if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
//            while (sqlite3_step(statement)==SQLITE_ROW) {
//                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
//                                     [NSNumber numberWithInt:sqlite3_column_int(statement, 0)],@"id",
//                                     [NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 1)!=nil?(char *)sqlite3_column_text(statement, 1):"")],@"roomkey",
//                                     [NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 2)!=nil?(char *)sqlite3_column_text(statement, 2):"")],@"uids",
//                                     [NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 3)!=nil?(char *)sqlite3_column_text(statement, 3):"")],@"names",
//                                     [NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 4)!=nil?(char *)sqlite3_column_text(statement, 4):"")],@"lastmsg",
//                                     [NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 5)!=nil?(char *)sqlite3_column_text(statement, 5):"")],@"lastdate",
//                                     [NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 6)!=nil?(char *)sqlite3_column_text(statement, 6):"")],@"lasttime",
//                                     [NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 7)!=nil?(char *)sqlite3_column_text(statement, 7):"")],@"lastindex",
//                                     [NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 8)!=nil?(char *)sqlite3_column_text(statement, 8):"")],@"rtype",
//                                     [NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 9)!=nil?(char *)sqlite3_column_text(statement, 9):"")],@"orderindex",
//                                     [NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 10)!=nil?(char *)sqlite3_column_text(statement, 10):"")],@"newfield",
//                                     nil];
//                NSLog(@"dic %@",dic);
//                [resultArray addObject:dic];
//            }
//        } else {
//			NSLog(@"prepare != ok error message : %s",sqlite3_errmsg(database));
//		}
//        sqlite3_finalize(statement);
//    } else {
//		NSLog(@"SQL OPEN FAILED code %s",sqlite3_errmsg(database));
//	}
//    sqlite3_close(database);
////	[dbManager release];
//	
//    NSSortDescriptor *sort = [[NSSortDescriptor alloc]initWithKey:@"orderindex" ascending:NO comparator:^(id obj1, id obj2){
//        return [obj1 compare:obj2 options:NSNumericSearch];
//    }];
//    [resultArray sortUsingDescriptors:@[sort]];
//    NSLog(@"resultarray count %d",[resultArray count]);
//    return resultArray;
//}
//
//
//+ (NSArray *)getRecentChatList
//{
//	SQLiteDBManager *dbManager = [[SQLiteDBManager alloc] init];
//	NSString *dbfilePath = [dbManager getDBFile];
//	sqlite3 *database;
//	
//	NSMutableArray *resultArray = [NSMutableArray array];
//    if (sqlite3_open([dbfilePath UTF8String], &database) == SQLITE_OK) {
//        sqlite3_stmt *statement;
//
//        NSString *sqlString = [NSString stringWithFormat:@"SELECT id, roomkey, uids, names, lastmsg, lastdate, lasttime, lastindex, rtype, orderindex, newfield FROM CHATLIST group by roomkey order by orderindex desc LIMIT %d",10];
//
//        if (sqlite3_prepare_v2(database, [sqlString UTF8String], -1, &statement, NULL) == SQLITE_OK) {
//            while (sqlite3_step(statement)==SQLITE_ROW) {
//                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
//                                     [NSNumber numberWithInt:sqlite3_column_int(statement, 0)],@"id",
//                                     [NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 1)!=nil?(char *)sqlite3_column_text(statement, 1):"")],@"roomkey",
//                                     [NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 2)!=nil?(char *)sqlite3_column_text(statement, 2):"")],@"uids",
//                                     [NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 3)!=nil?(char *)sqlite3_column_text(statement, 3):"")],@"names",
//                                     [NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 4)!=nil?(char *)sqlite3_column_text(statement, 4):"")],@"lastmsg",
//                                     [NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 5)!=nil?(char *)sqlite3_column_text(statement, 5):"")],@"lastdate",
//                                     [NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 6)!=nil?(char *)sqlite3_column_text(statement, 6):"")],@"lasttime",
//                                     [NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 7)!=nil?(char *)sqlite3_column_text(statement, 7):"")],@"lastindex",
//                                     [NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 8)!=nil?(char *)sqlite3_column_text(statement, 8):"")],@"rtype",
//                                     [NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 9)!=nil?(char *)sqlite3_column_text(statement, 9):"")],@"orderindex",
//                                     [NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 10)!=nil?(char *)sqlite3_column_text(statement, 10):"")],@"newfield",
//                                     nil];
//                
//                [resultArray addObject:dic];
//            }
//        } else {
//			NSLog(@"prepare != ok error message : %s",sqlite3_errmsg(database));
//		}
//        sqlite3_finalize(statement);
//    } else {
//		NSLog(@"SQL OPEN FAILED code %s",sqlite3_errmsg(database));
//	}
//    sqlite3_close(database);
////    [dbManager release];
//    
//    NSSortDescriptor *sort = [[NSSortDescriptor alloc]initWithKey:@"orderindex" ascending:NO comparator:^(id obj1, id obj2){
//        return [obj1 compare:obj2 options:NSNumericSearch];
//    }];
//    
//    [resultArray sortUsingDescriptors:@[sort]];//, nil]];
//    
//    return resultArray;
//}
//
//
////+ (BOOL)getAlarmIsMute:(NSString*)roomkey
////{
////	
////	/****************************************************************
////	 작업자 : 박형준
////	 작업일자 : 2012/07/04 > 2013/11/06
////	 작업내용 : 파일 다운로드 여부를 반환
////	 연관화면 : 없음
////	 ****************************************************************/
////	
////	
////	SQLiteDBManager *dbManager = [[SQLiteDBManager alloc] init];
////	NSString *dbfilePath = [dbManager getDBFile];
////	sqlite3 *database;
////	BOOL status = NO;
////	
////    if (sqlite3_open([dbfilePath UTF8String], &database) == SQLITE_OK) {
////		sqlite3_stmt *statement;
////		NSString *sql = [NSString stringWithFormat:@"SELECT newfield FROM CHATLIST WHERE roomkey='%@'",roomkey];
////		
////		if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
////			if (sqlite3_step(statement) == SQLITE_ROW) {
////				NSString *statusString = [NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 0)!=nil?(char *)sqlite3_column_text(statement, 0):"")];
////				NSLog(@"stat str = %@",statusString);
////				if ([statusString isEqualToString:@"YES"]) {
////					status = YES;
////				}
////			} else {
////				NSLog(@"step != done error message : %s",sqlite3_errmsg(database));
////			}
////		} else {
////			NSLog(@"prepare != ok error message : %s",sqlite3_errmsg(database));
////		}
////		sqlite3_finalize(statement);
////	} else {
////		NSLog(@"SQL OPEN FAILED code %s",sqlite3_errmsg(database));
////	}
////	[dbManager release];
////	sqlite3_close(database);
////	return status;
////}
//
//
//#pragma mark - MSG
//
//+ (void)AddMessageWithRk:(NSString *)rk read:(NSString *)read sid:(NSString *)sid msg:(NSString *)msg date:(NSString *)date time:(NSString *)time
//                  msgidx:(NSString *)msgidx type:(NSString *)type direct:(NSString *)direct name:(NSString *)name //unread:(NSString *)unread
//{
//    NSLog(@"AddMessageWithRk");
//	SQLiteDBManager *dbManager = [[SQLiteDBManager alloc] init];
//	NSString *dbfilePath = [dbManager getDBFile];
//	sqlite3 *database;
//	
//    if (sqlite3_open([dbfilePath UTF8String], &database) == SQLITE_OK) {
//		sqlite3_stmt *statement;
//		const char *sql="INSERT INTO MSG (roomkey, read, senderid, message, date, time, msgindex, type, direction, sendername) values (?,?,?,?,?,?,?,?,?,?)";
//		
//		char *encMsg = [dbManager encryptString:msg];
//		
//		if(sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
//			sqlite3_bind_text(statement, 1, [rk UTF8String], -1, SQLITE_TRANSIENT);
//			sqlite3_bind_text(statement, 2, [read UTF8String], -1, SQLITE_TRANSIENT);
//			sqlite3_bind_text(statement, 3, [sid UTF8String], -1, SQLITE_TRANSIENT);
//			sqlite3_bind_blob(statement, 4, (void*)encMsg, -1, SQLITE_TRANSIENT);
//			sqlite3_bind_text(statement, 5, [date UTF8String], -1, SQLITE_TRANSIENT);
//			sqlite3_bind_text(statement, 6, [time UTF8String], -1, SQLITE_TRANSIENT);
//			sqlite3_bind_text(statement, 7, [msgidx UTF8String], -1, SQLITE_TRANSIENT);
//			sqlite3_bind_text(statement, 8, [type UTF8String], -1, SQLITE_TRANSIENT);
//			sqlite3_bind_text(statement, 9, [direct UTF8String], -1, SQLITE_TRANSIENT);
//			sqlite3_bind_text(statement, 10, [name UTF8String], -1, SQLITE_TRANSIENT);
////			sqlite3_bind_text(statement, 11, [unread UTF8String], -1, SQLITE_TRANSIENT);
//			
//			if(sqlite3_step(statement) != SQLITE_DONE) {
//				NSLog(@"step != done error message : %s",sqlite3_errmsg(database));
//			}
//		} else {
//			NSLog(@"prepare != ok error message : %s",sqlite3_errmsg(database));
//		}
//		FREEMEM(encMsg);
//		sqlite3_finalize(statement);
//	} else {
//		NSLog(@"SQL OPEN FAILED code %s",sqlite3_errmsg(database));
//	}
////	[dbManager release];
//    sqlite3_close(database);
//}
//
//+ (void)updateReadInfo:(NSString *)read changingIdx:(NSString *)cidx idx:(NSString *)idx
//{
//    if([idx length]<1)
//        return;
//    
//    NSLog(@"updateReadInfo %@ %@ %@",read,cidx,idx);
//	SQLiteDBManager *dbManager = [[SQLiteDBManager alloc] init];
//	NSString *dbfilePath = [dbManager getDBFile];
//	sqlite3 *database;
//	
//    if (sqlite3_open([dbfilePath UTF8String], &database) == SQLITE_OK) {
//		sqlite3_stmt *statement;
//		NSString *sql = [NSString stringWithFormat:@"UPDATE MSG set read='%@', msgindex='%@' where msgindex='%@'",read,cidx,idx];
//		
//		if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
//			if(sqlite3_step(statement) != SQLITE_DONE) {
//				NSLog(@"step != done error message : %s",sqlite3_errmsg(database));
//			}
//		} else {
//			NSLog(@"prepare != ok error message : %s",sqlite3_errmsg(database));
//		}
//		
//		
//		sql = [NSString stringWithFormat:@"UPDATE CHATLIST set orderindex='%@',lastindex='%@' where orderindex='%@'",cidx,cidx,idx];
//		
//		if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
//			if(sqlite3_step(statement) != SQLITE_DONE) {
//				NSLog(@"step != done error message : %s",sqlite3_errmsg(database));
//			}
//		} else {
//			NSLog(@"prepare != ok error message : %s",sqlite3_errmsg(database));
//		}
//		sqlite3_finalize(statement);
//	} else {
//		NSLog(@"SQL OPEN FAILED code %s",sqlite3_errmsg(database));
//	}
////	[dbManager release];
//    sqlite3_close(database);
//}
//
//+ (void)updateUnReadInfo:(NSString *)unread atIdx:(NSString *)idx
//{
//	SQLiteDBManager *dbManager = [[SQLiteDBManager alloc] init];
//	NSString *dbfilePath = [dbManager getDBFile];
//	sqlite3 *database;
//	
//    if (sqlite3_open([dbfilePath UTF8String], &database) == SQLITE_OK) {
//		sqlite3_stmt *statement;
//		NSString *sql = [NSString stringWithFormat:@"UPDATE MSG set newfield1='%@' where msgindex='%@'",unread,idx];
//		
//		if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
//			if(sqlite3_step(statement) != SQLITE_DONE) {
//				NSLog(@"step != done error message : %s",sqlite3_errmsg(database));
//			}
//		} else {
//			NSLog(@"prepare != ok error message : %s",sqlite3_errmsg(database));
//		}
//		
//		
//		sqlite3_finalize(statement);
//	} else {
//		NSLog(@"SQL OPEN FAILED code %s",sqlite3_errmsg(database));
//	}
////	[dbManager release];
//    sqlite3_close(database);
//}
//
//+ (void)updateUnreadAtRoom:(NSString *)rk
//{ // 안 보내진 메시지들 '느낌표' 버튼 나오게 하려고
//	SQLiteDBManager *dbManager = [[SQLiteDBManager alloc] init];
//	NSString *dbfilePath = [dbManager getDBFile];
//	sqlite3 *database;
//	
//    if (sqlite3_open([dbfilePath UTF8String], &database) == SQLITE_OK) {
//		sqlite3_stmt *statement;
//		NSString *unreadQuery = [NSString stringWithFormat:@"UPDATE MSG set read='%d' where roomkey='%@' and read='%d' and direction='%d'",3,rk,2,2];
//		
//		if(sqlite3_prepare_v2(database, [unreadQuery UTF8String], -1, &statement, NULL) == SQLITE_OK){
//			if(sqlite3_step(statement) != SQLITE_DONE) {
//				NSLog(@"step != done error message : %s",sqlite3_errmsg(database));
//			}
//		} else {
//			NSLog(@"prepare != ok error message : %s",sqlite3_errmsg(database));
//		}
//		sqlite3_finalize(statement);
//	} else {
//		NSLog(@"SQL OPEN FAILED code %s",sqlite3_errmsg(database));
//	}
////	[dbManager release];
//    sqlite3_close(database);
//}
//
//
//+ (void)updateReadInfoAtRoom:(NSString *)rk
//{
//	SQLiteDBManager *dbManager = [[SQLiteDBManager alloc] init];
//	NSString *dbfilePath = [dbManager getDBFile];
//	sqlite3 *database;
//	
//    if (sqlite3_open([dbfilePath UTF8String], &database) == SQLITE_OK) {
//		sqlite3_stmt *statement;
//		NSString *sql = [NSString stringWithFormat:@"UPDATE MSG set read='%d' where roomkey='%@' and read='%d' and direction='%d'",0,rk,1,2];
//		
//		if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK){
//			if(sqlite3_step(statement) != SQLITE_DONE) {
//				NSLog(@"step != done error message : %s",sqlite3_errmsg(database));
//			}
//		} else {
//			NSLog(@"prepare != ok error message : %s",sqlite3_errmsg(database));
//		}
//		sqlite3_finalize(statement);
//	} else {
//		NSLog(@"SQL OPEN FAILED code %s",sqlite3_errmsg(database));
//	}
////	[dbManager release];
//    sqlite3_close(database);
//}
//
//+ (void)RemoveMessageWithRk:(NSString *)rk index:(NSString *)index all:(BOOL)all
//{
//    /****************************************************************
//     작업자 : 김혜민 > 박형준
//     작업일자 : 2012/06/04 > 2013/11/06
//     작업내용 : MSG DB에서 받은 룸키에서 받은 인덱스에 해당되는 메시지만 지운다.
//     param  - rk(NSString *) : 룸키
//     - index(NSString *) : 인덱스
//     연관화면 : 없음
//     ****************************************************************/
//    
//	SQLiteDBManager *dbManager = [[SQLiteDBManager alloc] init];
//	NSString *dbfilePath = [dbManager getDBFile];
//	sqlite3 *database;
//	
//    if (sqlite3_open([dbfilePath UTF8String], &database) == SQLITE_OK) {
//		sqlite3_stmt *statement;
//		const char *sql;
//		
//		BOOL deleteAll = ([rk isEqualToString:@"0"] && [index isEqualToString:@"0"] && all == YES);
//		if(deleteAll) {
//			sql = "DELETE FROM MSG";
//		} else {
//			sql = "DELETE FROM MSG WHERE roomkey=? and msgindex=?";
//		}
//		
//		if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
//			if (!deleteAll) {
//				sqlite3_bind_text(statement, 1, [rk UTF8String], -1, SQLITE_TRANSIENT);
//				sqlite3_bind_text(statement, 2, [index UTF8String], -1, SQLITE_TRANSIENT);
//			}
//			if (sqlite3_step(statement) != SQLITE_DONE) {
//				NSLog(@"step != done error message : %s",sqlite3_errmsg(database));
//			}
//		} else {
//			NSLog(@"prepare != ok error message : %s",sqlite3_errmsg(database));
//		}
//		sqlite3_finalize(statement);
//	} else {
//		NSLog(@"SQL OPEN FAILED code %s",sqlite3_errmsg(database));
//	}
////	[dbManager release];
//    sqlite3_close(database);
//    
//}
//
//+ (NSMutableArray *)getMessageFromDB:(NSString *)rk type:(NSString *)type number:(int)num
//{
//    /****************************************************************
//     작업자 : 김혜민 > 박형준
//     작업일자 : 2012/06/04 > 2013/11/06
//     작업내용 : MSG DB에서 해당하는 룸키의 num만큼의 메시지를 가져온다. 타입이 0일 땐 모든 타입의 메시지를 가져오고, 0이 아닐 때는 히스토리를 세팅할 때 쓰인다.
//     param  - rk(NSString *) : 룸키
//     - type(NSString *) : 타입
//     - num(int) : 갯수
//     연관화면 : 없음
//     ****************************************************************/
//    
//    NSLog(@"get %@ %@ %d",rk,type,num);
//	SQLiteDBManager *dbManager = [[SQLiteDBManager alloc] init];
//	NSString *dbfilePath = [dbManager getDBFile];
//	sqlite3 *database;
//	
//	NSMutableArray *resultArray = [NSMutableArray array];
//    if (sqlite3_open([dbfilePath UTF8String], &database) == SQLITE_OK) {
//        sqlite3_stmt *statement;
//        NSString *sql;
//        
//        if([type isEqualToString:@"0"]) {
//            sql = [NSString stringWithFormat:@"SELECT id,read,senderid,message,date,time,msgindex,type,direction,sendername,roomkey,newfield1 FROM MSG WHERE roomkey='%@' group by msgindex order by id DESC LIMIT %d",rk,num];
//        } else {
//            if([rk isEqualToString:@"0"]) {
//				sql = [NSString stringWithFormat:@"SELECT id,read,senderid,message,date,time,msgindex,type,direction,sendername,roomkey,newfield1 FROM MSG WHERE type='%@' group by msgindex order by id DESC",type];
//            } else {
//                sql = [NSString stringWithFormat:@"SELECT id,read,senderid,message,date,time,msgindex,type,direction,sendername,roomkey,newfield1 FROM MSG WHERE type='%@' and roomkey='%@' group by msgindex order by id DESC",type,rk];
//			}
//        }
//        NSLog(@"getMessage query %@",sql);
//        
//        if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
//            while (sqlite3_step(statement)==SQLITE_ROW) {
//                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
//                                     [NSNumber numberWithInt:sqlite3_column_int(statement, 0)],@"id",
//                                     [NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 1)!=nil?(char *)sqlite3_column_text(statement, 1):"")],@"read",
//                                     [NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 2)!=nil?(char *)sqlite3_column_text(statement, 2):"")],@"senderid",
//                                     [dbManager decryptString:(char*)sqlite3_column_blob(statement, 3)],@"message",
//                                     [NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 4)!=nil?(char *)sqlite3_column_text(statement, 4):"")],@"date",
//                                     [NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 5)!=nil?(char *)sqlite3_column_text(statement, 5):"")],@"time",
//                                     [NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 6)!=nil?(char *)sqlite3_column_text(statement, 6):"")],@"msgindex",
//                                     [NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 7)!=nil?(char *)sqlite3_column_text(statement, 7):"")],@"type",
//                                     [NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 8)!=nil?(char *)sqlite3_column_text(statement, 8):"")],@"direction",
//                                     [NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 9)!=nil?(char *)sqlite3_column_text(statement, 9):"")],@"sendername",
//                                     [NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 10)!=nil?(char *)sqlite3_column_text(statement, 10):"")],@"roomkey",
//                                     [NSString stringWithUTF8String:((char *)sqlite3_column_text(statement, 11)!=nil?(char *)sqlite3_column_text(statement, 11):"")],@"newfield1",
//                                     nil];
//                
//                [resultArray addObject:dic];
//            }
//        } else {
//			NSLog(@"prepare != ok error message : %s",sqlite3_errmsg(database));
//		}
//        sqlite3_finalize(statement);
//    } else {
//		NSLog(@"SQL OPEN FAILED code %s",sqlite3_errmsg(database));
//	}
////	[dbManager release];
//    sqlite3_close(database);
//    
//    return resultArray;
//}
//
//
//+ (NSString*)getFileStatus:(NSString*)idx
//{
//	
//	/****************************************************************
//	 작업자 : 박형준
//	 작업일자 : 2012/07/04 > 2013/11/06
//	 작업내용 : 파일 다운로드 여부를 반환
//	 연관화면 : 없음
//	 ****************************************************************/
//	
//	
//	SQLiteDBManager *dbManager = [[SQLiteDBManager alloc] init];
//	NSString *dbfilePath = [dbManager getDBFile];
//	sqlite3 *database;
//	NSString *fileStatus = @"";
//	
//    if (sqlite3_open([dbfilePath UTF8String], &database) == SQLITE_OK) {
//		sqlite3_stmt *statement;
//		NSString *sql = [NSString stringWithFormat:@"SELECT read FROM MSG WHERE msgindex='%@'",idx];
//		
//		if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
//			if (sqlite3_step(statement) == SQLITE_ROW) {
//				fileStatus = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//			} else {
//				NSLog(@"step != done error message : %s",sqlite3_errmsg(database));
//			}
//		} else {
//			NSLog(@"prepare != ok error message : %s",sqlite3_errmsg(database));
//		}
//		sqlite3_finalize(statement);
//	} else {
//		NSLog(@"SQL OPEN FAILED code %s",sqlite3_errmsg(database));
//	}
////	[dbManager release];
//	sqlite3_close(database);
//	NSLog(@"/////////////// %@",fileStatus);
//	return fileStatus;
//}
//
//
@end
