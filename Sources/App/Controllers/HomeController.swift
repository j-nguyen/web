//
//  HomeController.swift
//  App
//
//  Created by Johnny Nguyen on 2017-12-04.
//

import Vapor
import HTTP

/**
 * This home controller should entail the basic details of what route it should provide
 *
**/
public final class HomeController {
  private let view: ViewRenderer
  
  public init(_ view: ViewRenderer) {
    self.view = view
  }
  
  public func index(_ req: Request) throws -> ResponseRepresentable {
    // we're gonna create a limit of 1 events and 1 news
    let events = try Event.makeQuery().sort("createdAt", .ascending).filter("eventTypeId", EventType.Category.event.id()).limit(3).all()
    let news = try Event.makeQuery().sort("createdAt", .ascending).filter("eventTypeId", EventType.Category.news.id()).limit(3).all()
    return try view.make("index", ["events": events.makeJSON(), "news": news.makeJSON()])
  }
}
