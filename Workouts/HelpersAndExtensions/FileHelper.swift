//
//  FileHelper.swift
//  Workouts
//
//  Created by Emily Cheroske on 7/10/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import Foundation

func getDocumentsDirectory() -> URL {
    // find all possible documents directories for this user
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

    // just send back the first one, which ought to be the only one
    return paths[0]
}

func removeOldFiles() {
    let oneMonthAgo = Calendar.current.date(byAdding: .month, value: -1, to: Date())
    let path = getDocumentsDirectory()
    let filePaths = try? FileManager.default.contentsOfDirectory(atPath: path.path)
    if let paths = filePaths {
        for filePath in paths {
            do {
                let fileAttributes = try FileManager.default.attributesOfItem(atPath: path.path + "/" + filePath) as [FileAttributeKey:Any]
                let creationDate = fileAttributes[FileAttributeKey.creationDate] as! Date
                
                if let oneMonthAgo = oneMonthAgo {
                    if creationDate < oneMonthAgo {
                        try FileManager.default.removeItem(atPath: path.path + "/" + filePath)
                    }
                }
            } catch {
                print("err+ \(error.localizedDescription)")
            }
           
        }
    }
}
