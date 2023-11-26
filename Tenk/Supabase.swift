//
//  Supabase.swift
//  Tenk
//
//  Created by Charel Felten on 26/11/2023.
//

import Foundation
import Supabase

let supabase = SupabaseClient(
    supabaseURL: URL(string: "https://rtbdzflkfveoqjujqwhf.supabase.co")!,
    supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ0YmR6ZmxrZnZlb3FqdWpxd2hmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDA3Njc2NTgsImV4cCI6MjAxNjM0MzY1OH0.tilSElyuv8bC3Z6Ki_Apysu2CK-b6ayUavP1blg2jTY"
)
