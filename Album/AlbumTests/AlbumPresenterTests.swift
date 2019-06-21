//
//  AppInteractorTests.swift
//  AlbumTests
//
//  Created by Mithilesh Singh on 21/06/19.
//  Copyright © 2019 Mithilesh Kumar Singh. All rights reserved.
//

import XCTest
@testable import Album

class AlbumPresenterTests: XCTestCase {
    
    private var presenter: AlbumPresenterInterface!
    private var expectation: XCTestExpectation!
    
    private var result:AlbumPresenterResultType?

    override func setUp() {
        let networkTask = NetworkTask()
        let interactor = AppInteractor(networkTask: networkTask)
        let router = AppRouter()
        presenter = AlbumPresenter(interactor: interactor, router: router)
        presenter.delegate = self
        
        expectation = XCTestExpectation(description: "Waiting for photos to be downloaded.")
    }

    override func tearDown() {
        presenter = nil
    }

    func testExample() {
        presenter.fetchPhotos()
        
        wait(for: [expectation], timeout: 30)
        
        let success = AlbumPresenterResultType.success()
        XCTAssertTrue(result == success)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}

extension AlbumPresenterTests: AlbumPresenterDelegate {
    func fetchPhotosRequestCompleted(result: AlbumPresenterResultType) {
        self.result = result
        expectation.fulfill()
    }
}

extension AlbumPresenterResultType: Equatable {
    public static func == (lhs: AlbumPresenterResultType, rhs: AlbumPresenterResultType) -> Bool {
        switch (lhs, rhs) {
        case (.success, .success):
            return true
        case (.success, .failure(error: _)), (.failure(error: _), .success):
            return false
        case (.failure(error: let errorL), .failure(error: let errorR)):
            return errorL?.localizedDescription == errorR?.localizedDescription
        }
    }
}
