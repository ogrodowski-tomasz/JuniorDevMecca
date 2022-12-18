//
//  PublicApisTests.swift
//  PublicApisTests
//
//  Created by Tomasz Ogrodowski on 18/12/2022.
//

import XCTest

@testable import PublicApis

final class PublicApisTests: XCTestCase {

    var vc: HomeViewController!
    
    override func setUp() {
        super.setUp()
        vc = HomeViewController()
    }
    
    override func tearDown() {
        vc = nil
    }

    func test_HomeViewController_fetchingData() {
        // Starting as empty
        XCTAssertTrue(vc.entries.isEmpty)
        XCTAssertTrue(vc.viewModels.isEmpty)
        
        // Loading data
        fetchDataExpectation()
        
        XCTAssertFalse(vc.entries.isEmpty)
        XCTAssertFalse(vc.viewModels.isEmpty)
    }
    
    func test_HomeViewController_filteringFetchedData() {
        fetchDataExpectation()
        
        let filterPredicate = "Animals"
        vc.selectedCategory = filterPredicate
        let filteredEntries = vc.filterEntries(vc.entries)
        
        for entry in filteredEntries {
            XCTAssertEqual(entry.category, filterPredicate, "Category should be \(filterPredicate)")
        }
    }
    
    private func fetchDataExpectation() {
        vc.viewDidLoad()
        let expectation = XCTestExpectation(description: "fetching Data")
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
}
