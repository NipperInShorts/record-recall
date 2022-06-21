//
//  RecentRecords.swift
//  Record Recall
//
//  Created by Justin Nipper on 6/13/22.
//

import SwiftUI

struct RecentRecords: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Latest Records")
                .foregroundColor(.darkBlue)
                .font(
                    .system(size: 20, weight: .semibold))
                .padding(.leading)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    VStack(alignment: .leading, spacing: 24) {
                        HStack {
                            Text("Back Squat")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.primaryBlue)
                            Spacer()
                            Text(Helper.getFriendlyDateString(from: Date()))
                                .font(.system(size: 12, weight: .medium)).foregroundColor(.secondaryBlue)
                        }
                        HStack(alignment: .top) {
                            VStack(spacing: 4) {
                                Text("Weight")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.secondaryBlue)
                                    .textCase(.uppercase)
                                HStack(spacing: 2) {
                                    Text("183")
                                        .font(.system(size: 24, weight: .semibold))
                                        .foregroundColor(.primaryBlue)
                                    Text("kg")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.secondaryBlue)
                                }
                            }
                            Spacer()
                            HStack {
                                VStack(spacing: 4) {
                                    Text("Reps")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.secondaryBlue)
                                        .textCase(.uppercase)
                                    ForEach((1...3), id: \.self) { _ in
                                        HStack(spacing: 8) {
                                            HStack(spacing: 2) {
                                                Text("183")
                                                    .font(.system(size: 18, weight: .semibold))
                                                    .foregroundColor(.primaryBlue)
                                                Text("kg")
                                                    .font(.system(size: 12, weight: .medium))
                                                    .foregroundColor(.secondaryBlue)
                                            }
                                            
                                            Text("x")
                                                .font(.system(size: 12, weight: .semibold))
                                                .foregroundColor(.primaryBlue)
                                            Text("5")
                                                .font(.system(size: 18, weight: .semibold))
                                                .foregroundColor(.primaryBlue)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: 264)
                    .background(.white)
                    .cornerRadius(8)
                    
                    VStack(alignment: .leading, spacing: 24) {
                        HStack {
                            Text("Back Squat")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.primaryBlue)
                            Spacer()
                            Text(Helper.getFriendlyDateString(from: Date.now))
                                .font(.system(size: 12, weight: .medium)).foregroundColor(.secondaryBlue)
                        }
                        HStack(alignment: .top) {
                            VStack(spacing: 4) {
                                Text("Weight")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.secondaryBlue)
                                    .textCase(.uppercase)
                                HStack(spacing: 2) {
                                    Text("183")
                                        .font(.system(size: 24, weight: .semibold))
                                        .foregroundColor(.primaryBlue)
                                    Text("kg")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.secondaryBlue)
                                }
                            }
                            Spacer()
                            HStack {
                                VStack(spacing: 4) {
                                    Text("Reps")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.secondaryBlue)
                                        .textCase(.uppercase)
                                    ForEach((1...3), id: \.self) { _ in
                                        HStack(spacing: 8) {
                                            HStack(spacing: 2) {
                                                Text("183")
                                                    .font(.system(size: 18, weight: .semibold))
                                                    .foregroundColor(.primaryBlue)
                                                Text("kg")
                                                    .font(.system(size: 12, weight: .medium))
                                                    .foregroundColor(.secondaryBlue)
                                            }
                                            
                                            Text("x")
                                                .font(.system(size: 12, weight: .semibold))
                                                .foregroundColor(.primaryBlue)
                                            Text("5")
                                                .font(.system(size: 18, weight: .semibold))
                                                .foregroundColor(.primaryBlue)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: 264)
                    .background(.white)
                    .cornerRadius(8)
                }
                .padding(.horizontal)
            }
        }
    }
}

struct RecentRecords_Previews: PreviewProvider {
    static var previews: some View {
        RecentRecords()
    }
}
