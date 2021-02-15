//
//  FileHelper.swift
//  Workouts
//
//  Created by Emily Cheroske on 7/10/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import Foundation

var documentsDirectoryURL: URL {
    FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
}

func removeOldFiles() {

    let oneMonthAgo = Calendar.current.date(byAdding: .month, value: -1, to: Date())

    let filePaths = try? FileManager.default.contentsOfDirectory(atPath: documentsDirectoryURL.path)

    if let paths = filePaths {

        for filePath in paths {

            do {
                let fileAttributes = try FileManager.default.attributesOfItem(atPath: documentsDirectoryURL.path + "/" + filePath) as [FileAttributeKey:Any]
                let creationDate = fileAttributes[FileAttributeKey.creationDate] as! Date
                
                if let oneMonthAgo = oneMonthAgo, creationDate < oneMonthAgo {
                    try FileManager.default.removeItem(atPath: documentsDirectoryURL.path + "/" + filePath)
                }

            } catch {

                print("err+ \(error.localizedDescription)")

            }
           
        }
    }
}
