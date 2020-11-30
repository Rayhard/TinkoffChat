//
//  TinkoffChatUITests.swift
//  TinkoffChatUITests
//
//  Created by Никита Пережогин on 27.11.2020.
//  Copyright © 2020 Nikita Perezhogin. All rights reserved.
//

import XCTest

class TinkoffChatUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests
        //before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testProfileView() throws {
        let app = XCUIApplication()
        app.launch()
        
        let profileButton = app.navigationBars.otherElements["OpenProfileButton"].firstMatch
        let profileButtonExistens = profileButton.waitForExistence(timeout: 5.0)
        
        XCTAssertTrue(profileButtonExistens)
        profileButton.tap()
        
        let nameTextField = app.textFields["NameTextField"].firstMatch
        let nameTextFieldExistens = nameTextField.waitForExistence(timeout: 5.0)
        let descriptionTextView = app.textViews["DescriptionTextView"].firstMatch
        let descriptionTextViewExistens = descriptionTextView.waitForExistence(timeout: 5.0)
        
        XCTAssertTrue(nameTextFieldExistens)
        XCTAssertTrue(descriptionTextViewExistens)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
