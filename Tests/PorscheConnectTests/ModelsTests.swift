import XCTest
@testable import PorscheConnect

final class ModelsTests: XCTestCase {
  let porscheAuth = PorscheAuth(accessToken: "zVb3smCN32iOslsoXa7XIYPrenGz",
                                idToken: "yJhbGciOiJSUzI1NiIsImtpZCI6IjE1bF9LeldTV08tQ1ZNdXdlTmQyMnMifQ.eyJzdWIiOiI4N3VnOGJobXZydnF5bTFrIiwiYXVkIjoiVFo0VmY1d25LZWlwSnh2YXRKNjBsUEhZRXpxWjRXTnAiLCJqdGkiOiI5NWhPT0ZlSDdzZW9yaVZ2bUNhTWdWIiwiaXNzIjoiaHR0cHM6XC9cL2xvZ2luLnBvcnNjaGUuY29tIiwiaWF0IjoxNjEyNzQwOTE2LCJleHAiOjE2MTI3NDEyMTYsInBpLnNyaSI6IkVYYjZSSlFpRWZLazNRZWk0Y1dyTWlwSmgxSSJ9.bVzapayesKjA85pRwVBZN_TfKzPNFTOb6nszPSWElMU2-MOzmJjy6dWHTjN3jCCx3Ui20XDwHkkDOdIUZqIQq6nve5ihbRlNi1ywrNiKKLOL7nmfzmM7yBPMZfwxtCP_-imypF_n19i1rZDkatIkW0Ejs7lcc0xRD9JewGMhfALqpFuOciIX3SIInHE56WSmTNyEB1LTNNLXiwaBWygPVbYDAYYc4u-w3V_GPZR3kTSTJjwnfXM9Qke6wBcoXDaON4_NfNcTQf0vXYwhC749dJd8Z2eDcRTl-Yl06BTHHTIL-yInfk8yjCO1iaCv01ROjK_nGAyPsOvUKtVgsaXxnw",
                                tokenType: "Bearer",
                                expiresIn: 7199)!
  
  func testPorscheAuthConstruction() {
    XCTAssertNotNil(porscheAuth)
  }
  
  func testDecodingJsonIntoModel() {
    let json =  "{\"access_token\":\"jycHMMWhUjsEVNUxzLgM92XGIN17\",\"id_token\":\"eyJhbGciOiJSUzI1NiIsImtpZCI6IjE1bF9LeldTV08tQ1ZNdXdlTmQyMnMifQ\",\"token_type\":\"Bearer\",\"expires_in\":7199}\r\n".data(using: .utf8)!
    
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    
    let porscheAuth = try! decoder.decode(PorscheAuth.self, from: json)
    XCTAssertNotNil(porscheAuth)
    XCTAssertEqual("jycHMMWhUjsEVNUxzLgM92XGIN17", porscheAuth.accessToken)
    XCTAssertEqual("eyJhbGciOiJSUzI1NiIsImtpZCI6IjE1bF9LeldTV08tQ1ZNdXdlTmQyMnMifQ", porscheAuth.idToken)
    XCTAssertEqual("Bearer", porscheAuth.tokenType)
    XCTAssertEqual(7199, porscheAuth.expiresIn)
  }
  
  func testDecodedJwtToken() {
    XCTAssertNotNil(porscheAuth)
    XCTAssertEqual("TZ4Vf5wnKeipJxvatJ60lPHYEzqZ4WNp", porscheAuth.apiKey)
  }
}
