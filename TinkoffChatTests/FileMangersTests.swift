//
//  TinkoffChatTests.swift
//  TinkoffChatTests
//
//  Created by Никита Пережогин on 28.11.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

@testable import TinkoffChat
import XCTest

class FileMangersTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSaveGCD() throws {
        
        // Arrange
        let fileManagerMock = FileManagerMock()
        let gcdDataManager = GCDDataManager(fileCore: fileManagerMock)
        let profileInfo = ProfileInfo(name: "Name", description: "Description", photo: nil)
        
        // Act
        gcdDataManager.saveData(profileInfo) {
            
            // Assert
            XCTAssertEqual(fileManagerMock.saveCallsCount, 3)
        }
        
    }
    
    func testReadGCD() throws {
        
        // Arrange
        let fileManagerMock = FileManagerMock()
        let gcdDataManager = GCDDataManager(fileCore: fileManagerMock)
        let profileInfo = ProfileInfo(name: "Some text", description: "Some text", photo: nil)
        
        // Act
        let profile = gcdDataManager.fetchData {}
        
        // Assert
        XCTAssertEqual(profileInfo.name, profile.name)
        XCTAssertEqual(profileInfo.description, profile.description)
        XCTAssertEqual(profileInfo.photo, profile.photo)
        XCTAssertEqual(fileManagerMock.readCallsCount, 3)
        
    }
    
    func testSaveOperation() throws {
        
        // Arrange
        let fileManagerMock = FileManagerMock()
        let gcdDataManager = OperationDataManager(fileCore: fileManagerMock)
        let profileInfo = ProfileInfo(name: "Name", description: "Description", photo: nil)
        
        // Act
        gcdDataManager.saveData(profileInfo) {
            
            // Assert
            XCTAssertEqual(fileManagerMock.saveCallsCount, 3)
        }
        
    }
    
    func testReadOperation() throws {
        
        // Arrange
        let fileManagerMock = FileManagerMock()
        let gcdDataManager = OperationDataManager(fileCore: fileManagerMock)
        let profileInfo = ProfileInfo(name: "Some text", description: "Some text", photo: nil)
        
        // Act
        let profile = gcdDataManager.fetchData {}
        
        // Assert
        XCTAssertEqual(profileInfo.name, profile.name)
        XCTAssertEqual(profileInfo.description, profile.description)
        XCTAssertEqual(profileInfo.photo, profile.photo)
        XCTAssertEqual(fileManagerMock.readCallsCount, 3)
        
    }

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
