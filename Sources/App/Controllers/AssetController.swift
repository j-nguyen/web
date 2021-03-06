//
//  AssetController.swift
//  App
//
//  Created by Johnny Nguyen on 2017-12-19.
//

import Foundation
import Vapor
import HTTP

public final class AssetController {
  /**
    Retrieves all the assets found
  **/
  public func index(_ req: Request) throws -> ResponseRepresentable {
    return try Asset.all().makeJSON()
  }
  
  /**
    Creates an asset, through a file storage api
  **/
  public func store(_ req: Request) throws -> ResponseRepresentable {
    guard let config = drop?.config, let kloudlessConfig: Config = try config.get("kloudless") else { throw Abort.serverError }
    
    let kloudless = try KloudlessService(config: kloudlessConfig)
    
    guard
      let fileName = req.formData?["file"]?.filename,
      let file = req.formData?["file"]?.part.body else {
        throw Abort.badRequest
    }
    
    guard let type = req.formData?["fileType"]?.string, let fileType = KloudlessService.FileType(rawValue: type) else {
        throw Abort(.conflict, reason: "Could not get file type!")
    }
    
    let results: Asset
    
    switch fileType {
    case .images:
      results = try kloudless.uploadImage(fileName: fileName, file: file)
    case .documents:
      results = try kloudless.uploadDocument(fileName: fileName, file: file)
    case .videos:
      results = try kloudless.uploadVideo(fileName: fileName, file: file)
    }

    return try results.makeJSON()
  }
  /**
    Destroys the asset, along with the file storage API too
  **/
  public func destroy(_ req: Request) throws -> ResponseRepresentable {
    if let id = req.query?["id"]?.int, let asset = try Asset.find(id) {
      if try req.getUserData().admin {        
        try asset.events.all().forEach { try $0.galleries.remove(asset) }
        try asset.delete()
      }
    }
    
    return Response(redirect: "/events")
  }
}
