import XCTest
@testable import PorscheConnect

final class PorscheConnectAuthTests: BaseMockNetworkTestCase {
  
  // MARK: - Properties
  
  var connect: PorscheConnect!
  let mockNetworkRoutes = MockNetworkRoutes()
  
  // MARK: - Setup
  
  override func setUp() {
    super.setUp()
    self.connect = PorscheConnect(username: "homer.simpson@icloud.example", password: "Duh!", environment: .Test)
  }
  
  // MARK: - Tests
  
  func testRequestTokenSuccessful() async {
    let application: Application = .Portal
    let expectation = self.expectation(description: "Network Expectation")
    mockNetworkRoutes.mockPostLoginAuthSuccessful(router: MockServer.shared.router)
    mockNetworkRoutes.mockGetApiAuthSuccessful(router: MockServer.shared.router)
    mockNetworkRoutes.mockPostApiTokenSuccessful(router: MockServer.shared.router)
    
    XCTAssertFalse(self.connect.authorized(application: application))
    let porscheAuth = try! await connect.auth(application: application)
    expectation.fulfill()
    
    XCTAssert(self.connect.authorized(application: application))
    self.assertCookiesPresent()
    
    XCTAssertNotNil(porscheAuth)
    XCTAssertEqual("Kpjg2m1ZXd8GM0pvNIB3jogWd0o6", porscheAuth.accessToken)
    XCTAssertEqual("eyJhbGciOiJSUzI1NiIsImtpZCI6IjE1bF9LeldTV08tQ1ZNdXdlTmQyMnMifQ.eyJzdWIiOiI4N3VnOGJobXZydnF5bTFrIiwiYXVkIjoiVFo0VmY1d25LZWlwSnh2YXRKNjBsUEhZRXpxWjRXTnAiLCJqdGkiOiJmTldhWEE4RTBXUzNmVzVZU0VmNFRDIiwiaXNzIjoiaHR0cHM6XC9cL2xvZ2luLnBvcnNjaGUuY29tIiwiaWF0IjoxNjEyNzQxNDA4LCJleHAiOjE2MTI3NDE3MDgsInBpLnNyaSI6InNoeTN3aDN4RFVWSFlwd0pPYmpQdHJ5Y2FpOCJ9.EsgxbnDCdEC0O8b05B_VJoe09etxcQOqhj4bRkR-AOwZrFV0Ba5LGkUFD_8GxksWuCn9W_bG_vHNOxpcum-avI7r2qY3N2iMJHZaOc0Y-NqBPCu5kUN3F5oh8e7aDbBKQI_ZWTxRdMvcTC8zKJRZf0Ud2YFQSk6caGwmqJ5OE_OB38_ovbAiVRgV_beHePWpEkdADKKtlF5bmSViHOoUOs8x6j21mCXDiuMPf62oRxU4yPN-AS4wICtz22dabFgdjIwOAFm651098z2zwEUEAPAGkcRKuvSHlZ8OAvi4IXSFPXBdCfcfXRk5KdCXxP1xaZW0ItbrQZORdI12hVFoUQ", porscheAuth.idToken)
    XCTAssertEqual("Bearer", porscheAuth.tokenType)
    XCTAssertEqual(7199, porscheAuth.expiresIn)
    
    let portalAuth = self.connect.auths[application]!
    XCTAssertNotNil(portalAuth)
    
    XCTAssertEqual("Kpjg2m1ZXd8GM0pvNIB3jogWd0o6", portalAuth.accessToken)
    XCTAssertEqual("eyJhbGciOiJSUzI1NiIsImtpZCI6IjE1bF9LeldTV08tQ1ZNdXdlTmQyMnMifQ.eyJzdWIiOiI4N3VnOGJobXZydnF5bTFrIiwiYXVkIjoiVFo0VmY1d25LZWlwSnh2YXRKNjBsUEhZRXpxWjRXTnAiLCJqdGkiOiJmTldhWEE4RTBXUzNmVzVZU0VmNFRDIiwiaXNzIjoiaHR0cHM6XC9cL2xvZ2luLnBvcnNjaGUuY29tIiwiaWF0IjoxNjEyNzQxNDA4LCJleHAiOjE2MTI3NDE3MDgsInBpLnNyaSI6InNoeTN3aDN4RFVWSFlwd0pPYmpQdHJ5Y2FpOCJ9.EsgxbnDCdEC0O8b05B_VJoe09etxcQOqhj4bRkR-AOwZrFV0Ba5LGkUFD_8GxksWuCn9W_bG_vHNOxpcum-avI7r2qY3N2iMJHZaOc0Y-NqBPCu5kUN3F5oh8e7aDbBKQI_ZWTxRdMvcTC8zKJRZf0Ud2YFQSk6caGwmqJ5OE_OB38_ovbAiVRgV_beHePWpEkdADKKtlF5bmSViHOoUOs8x6j21mCXDiuMPf62oRxU4yPN-AS4wICtz22dabFgdjIwOAFm651098z2zwEUEAPAGkcRKuvSHlZ8OAvi4IXSFPXBdCfcfXRk5KdCXxP1xaZW0ItbrQZORdI12hVFoUQ", portalAuth.idToken)
    XCTAssertEqual("Bearer", portalAuth.tokenType)
    XCTAssertEqual(7199, portalAuth.expiresIn)
    
    await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }
  
  func testRequestTokenFailureAtLoginToRetrieveCookies() async {
    let application: Application = .Portal
    let expectation = self.expectation(description: "Network Expectation")
    mockNetworkRoutes.mockPostLoginAuthFailure(router: MockServer.shared.router)
    
    XCTAssertFalse(self.connect.authorized(application: application))
    
    do {
      let _ = try await connect.auth(application: application)
    } catch {
      expectation.fulfill()
  
      XCTAssertFalse(self.connect.authorized(application: application))
      self.assertCookiesNotPresent()
    }
    
    await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }

  func testRequestTokenFailureAtGetApiAuthCode() async {
    let application: Application = .Portal
    let expectation = self.expectation(description: "Network Expectation")
    mockNetworkRoutes.mockPostLoginAuthSuccessful(router: MockServer.shared.router)
    mockNetworkRoutes.mockGetApiAuthFailure(router: MockServer.shared.router)
    
    XCTAssertFalse(self.connect.authorized(application: application))
    
    do {
      let _ = try await connect.auth(application: application)
    } catch {
      expectation.fulfill()
      XCTAssertFalse(self.connect.authorized(application: application))
      self.assertCookiesPresent()
    }

    await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }

  func testRequestTokenFailureAtGetApiAuthToken() async {
    let application: Application = .Portal
    let expectation = self.expectation(description: "Network Expectation")
    mockNetworkRoutes.mockPostLoginAuthSuccessful(router: MockServer.shared.router)
    mockNetworkRoutes.mockGetApiAuthSuccessful(router: MockServer.shared.router)
    mockNetworkRoutes.mockPostApiTokenFailure(router: MockServer.shared.router)

    XCTAssertFalse(self.connect.authorized(application: application))
    
    do {
      let _ = try await connect.auth(application: application)
    } catch {
      expectation.fulfill()
      XCTAssertFalse(self.connect.authorized(application: application))
      self.assertCookiesPresent()
    }

    await waitForExpectations(timeout: kDefaultTestTimeout, handler: nil)
  }

  // MARK: - Private functions
  
  private func assertCookiesNotPresent() {
    let cookies = HTTPCookieStorage.shared.cookies!
    XCTAssertEqual(0, cookies.count)
  }
  
  private func assertCookiesPresent() {
    let cookies = HTTPCookieStorage.shared.cookies!
    XCTAssertEqual(1, cookies.count)
    
    let cookie = cookies.first!
    XCTAssertEqual("CIAM.status", cookie.name)
    XCTAssertEqual("mockValue", cookie.value)
  }
}
