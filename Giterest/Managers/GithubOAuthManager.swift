//
//  GithubOAuthManager.swift
//  Giterest
//
//  Created by Louis Tur on 11/17/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation
import UIKit

enum GithubScope: String {
  case user, public_repo
}

class GithubOAuthManager {
  static let authorizationURL: URL = URL(string: "https://github.com/login/oauth/authorize")!
  static let redirectURL: URL = URL(string: "giterest://auth.url")!
  
  private var clientID: String?
  private var clientSecret: String?
  
  static let shared: GithubOAuthManager = GithubOAuthManager()
  private init () {}
  
  // Class function to set up our manager (code design purely)
  class func configure(clientID: String, clientSecret: String) {
    shared.clientID = clientID
    shared.clientSecret = clientSecret
  }
  
  func requestAuthorization(scopes: [GithubScope]) throws {
    guard
      let clientID = self.clientID,
      let clientSecret = self.clientSecret
    else {
        throw NSError(domain: "Client ID/Client Secret not set", code: 1, userInfo: nil)
    }
    
    let clientIDQuery = URLQueryItem(name: "client_id", value: clientID)
    let redirectURLQuery = URLQueryItem(name: "redirect_uri", value: GithubOAuthManager.redirectURL.absoluteString)
    let scopeQuery: URLQueryItem = URLQueryItem(name: "scope", value: scopes.flatMap { $0.rawValue }.joined(separator: " ") )
    
    
    var components = URLComponents(url: GithubOAuthManager.authorizationURL, resolvingAgainstBaseURL: true)
    components?.queryItems = [clientIDQuery, redirectURLQuery, scopeQuery]
    
    UIApplication.shared.open(components!.url!, options: [:], completionHandler: nil)
  }
  
}
