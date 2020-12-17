//
//  UserDefaultsTests.swift
//  TinkoffChatTests
//
//  Created by Никита Пережогин on 30.11.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

@testable import TinkoffChat
import XCTest

class UserDefaultsTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSaveToUserDafaults() throws {
        
        // Arrange
        let userMock = UserDafaultsMock()
        let fileManagerMock = FileManagerMock()
        let fileMock = GCDDataManager(fileCore: fileManagerMock)
        let settings = SettingsService(userDefaults: userMock, fileManager: fileMock)
        
        // Act
        settings.setTheme()
        
        // Assert
        XCTAssertEqual(userMock.readCallsCount, 1)
    }
    
    func testReadFromUserDafaults() throws {
        
        // Arrange
        let userMock = UserDafaultsMock()
        let fileManagerMock = FileManagerMock()
        let fileMock = GCDDataManager(fileCore: fileManagerMock)
        let settings = SettingsService(userDefaults: userMock, fileManager: fileMock)
        
        // Act
        settings.setProfile()
        
        // Assert
        XCTAssertEqual(userMock.readCallsCount, 1)
        XCTAssertEqual(userMock.saveCallsCount, 1)
    }

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
