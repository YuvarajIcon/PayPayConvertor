//
//  CurrencyConversionTests.swift
//  PayPayConvertorTests
//
//  Created by Yuvaraj Selvam on 13/01/24.
//

import XCTest
import Alamofire
@testable import PayPayConvertor

/**
 Unit tests for the `CurrencyConversionPresenter` class.
 */
final class CurrencyConversionPresenterTests: XCTestCase {
    
    var presenter: CurrencyConversionPresenter!
    var mockInteractor: MockCurrencyConversionInteractor!
    var mockRouter: MockCurrencyConversionRouter!
    var mockView: MockCurrencyConversionView!
    
    override func setUp() {
        super.setUp()
        
        mockInteractor = MockCurrencyConversionInteractor()
        mockRouter = MockCurrencyConversionRouter()
        mockView = MockCurrencyConversionView()
        
        presenter = CurrencyConversionPresenter()
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

    func testGetRates() {
        presenter.getRates(for: 1.0)
        XCTAssertTrue(mockInteractor.fetchRatesCalled)
    }

    func testMoveToSearch() {
        let mockNavigationController = MockNavigationController()
        presenter.moveToSearch(with: mockNavigationController, delegate: mockView)
        XCTAssertTrue(mockRouter.navigateToSearchCalled)
        XCTAssertTrue(mockRouter.passedNavigationController === mockNavigationController)
        XCTAssertTrue(mockRouter.passedDelegate === mockView)
    }

    func testDidFetchRates() {
        let exchangeRates = ExchangeRates.create()
        exchangeRates.disclaimer = "A disclaimer"
        exchangeRates.base = "USD"
        exchangeRates.license = "A licence"
        exchangeRates.rates = [DynamicKeyMap(key: "INR", value: AnyCodable(value: 100))]
        exchangeRates.timestamp = 12345
        exchangeRates.lastSyncedDate = Date()
        presenter.didFetchRates(with: exchangeRates)
        XCTAssertTrue(mockView.dataDidLoadCalled)
    }

    func testDidFetchRatesFailed() {
        let mockError = AFError.sessionInvalidated(error: nil)
        presenter.didFetchRatesFailed(with: mockError)
        XCTAssertTrue(mockView.dataDidFailCalled)
        XCTAssertTrue((mockView.passedError != nil))
    }
}

//MARK: Mock Classes
class MockCurrencyConversionInteractor: CurrencyConversionInteractorProtocol {
    var presenter: CurrencyConversionInteractorOutputProtocol?
    var fetchRatesCalled = false
    func fetchRates() {
        fetchRatesCalled = true
    }
}

class MockCurrencyConversionRouter: CurrencyConversionRouterProtocol {
    static func createModule() -> UIViewController {
        return UIViewController()
    }

    var navigateToSearchCalled = false
    var passedNavigationController: UINavigationController?
    var passedDelegate: CurrencyChooserDelegate?

    func navigateToSearch(with navigationController: UINavigationController, delegate: CurrencyChooserDelegate) {
        navigateToSearchCalled = true
        passedNavigationController = navigationController
        passedDelegate = delegate
    }
}

class MockCurrencyConversionView: CurrencyConversionViewProtocol, CurrencyChooserDelegate {
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

class MockNavigationController: UINavigationController {
    var pushViewControllerCalled = false

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushViewControllerCalled = true
    }
}

