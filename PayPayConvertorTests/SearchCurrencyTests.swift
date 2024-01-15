//
//  SearchCurrencyTests.swift
//  PayPayConvertorTests
//
//  Created by Yuvaraj Selvam on 15/01/24.
//

import XCTest
import Alamofire
@testable import PayPayConvertor

/**
 Unit tests for the `CurrencySearchPresenter` class.
 */
final class CurrencySearchPresenterTests: XCTestCase {
    
    var presenter: CurrencySearchPresenter!
    var mockInteractor: MockCurrencySearchInteractor!
    var mockRouter: MockCurrencySearchRouter!
    var mockView: MockCurrencySearchView!
    
    override func setUp() {
        super.setUp()
        
        mockInteractor = MockCurrencySearchInteractor()
        mockRouter = MockCurrencySearchRouter()
        mockView = MockCurrencySearchView()
        
        presenter = CurrencySearchPresenter()
        presenter.interactor = mockInteractor
        presenter.router = mockRouter
        presenter.view = mockView
    }
    
    override func tearDown() {
        mockInteractor = nil
        mockRouter = nil
        mockView = nil
        presenter = nil
        super.tearDown()
    }

    func testGetAvailableCurrencies() {
        presenter.getAvailableCurrencies()
        XCTAssertTrue(mockInteractor.fetchAvailableCurrenciesCalled)
    }

    func testDidFetchCurrencies() {
        let availableCurrencies = AvailableCurrencies.create()
        availableCurrencies.currencies = []
        availableCurrencies.lastSyncedDate = Date()
        presenter.didFetchCurrencies(with: availableCurrencies)
        XCTAssertTrue(mockView.dataDidLoadCalled)
    }

    func testDidFetchCurrenciesFailed() {
        let mockError = AFError.sessionInvalidated(error: nil)
        presenter.didFetchCurrenciesFailed(with: mockError)
        XCTAssertTrue(mockView.dataDidFailCalled)
        XCTAssertTrue((mockView.passedError != nil))
    }
}

//MARK: Mock Classes
class MockCurrencySearchInteractor: CurrencySearchInteractorProtocol {
    var presenter: CurrencySearchInteractorOutputProtocol?
    var fetchAvailableCurrenciesCalled = false

    func fetchAvailableCurrencies() {
        fetchAvailableCurrenciesCalled = true
    }
}

class MockCurrencySearchRouter: CurrencySearchRouterProtocol {
    static func createModule() -> UIViewController {
        return UIViewController()
    }
}

class MockCurrencySearchView: CurrencySearchViewProtocol, CurrencyChooserDelegate {
    var dataDidLoadCalled = false
    var dataDidFailCalled = false
    var passedError: Error?

    func dataDidLoad() {
        dataDidLoadCalled = true
    }

    func dataDidFail(with error: AFError) {
        dataDidFailCalled = true
        passedError = error
    }
    
    func didChooseCurrency() { }
}
