//
//  LandmarkList.swift
//  Landmarks
//
//  Created by koki isshiki on 09.11.20.
//  Copyright © 2020 Apple. All rights reserved.
//

import SwiftUI

struct LandmarkList: View {
    var body: some View {
        NavigationView{
            List(landmarkData){ landmark in
                NavigationLink(destination: LandmarkDetail(landmark: landmark)){
                    LandmarkRow(landmark:landmark)
                }

            }
            .navigationBarTitle(Text("Landmarks"))
        }

    }
}

struct LandmarkList_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkList()
            .previewDevice(PreviewDevice(rawValue:"iPhone SE"))
    }
}
