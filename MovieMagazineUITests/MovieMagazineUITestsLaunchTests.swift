//
//  MovieMagazineUITestsLaunchTests.swift
//  MovieMagazineUITests
//
//  Created by Шаповалов Илья on 02.11.2023.
//

import XCTest

final class MovieMagazineUITestsLaunchTests: XCTestCase {

//    @available(macOS 11.0, *)
//    func testLaunch1() throws {
//        let options = XCTMeasureOptions()
//        options.iterationCount = 100
//        let application = XCUIApplication(bundleIdentifier: Bundle.main.bundlePath)
//        let launchMetric = XCTApplicationLaunchMetric(waitUntilResponsive: true)
//        
//        measure(
//            metrics: [launchMetric],
//            options: options
//        ) {
//            application.launch()
//        }
//    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
